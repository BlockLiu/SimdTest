#include <string.h>
#include <unistd.h>
#include <assert.h>
#include "cm_clock.h"
using std::pair;

#ifdef _BIND_THREAD_WITH_CPU_
#include <sched.h>  
#include <sys/types.h>  
// #include <sys/sysinfo.h> 
#endif

#include <x86intrin.h>
#include <xmmintrin.h> // SSE
#include <emmintrin.h> // SSE2
#include <pmmintrin.h> // SSE3
#include <tmmintrin.h> // SSSE3
#include <immintrin.h> // AVX

/* nA is the number of pairs in A, so is nB
 * A: the range where numbers should sub more
 * B: the range where numbers should sub less */
void splitRange(ClockUpdateThreadParam *param, pair<int,int> *A, int &nA, pair<int,int> *B, int &nB)
{
    int len = param->updateLen % param->width;

    if(len == 0){
        nA = 0;             nB = 1;
        B[0].first = 0;     B[0].second = param->width;
        return;
    }
    
    if(param->lastUpdateIdx + len < param->width){
        nA = 1;             nB = 2;
        A[0].first = param->lastUpdateIdx;  A[0].second = param->lastUpdateIdx + len;
        B[0].first = A[0].second;           B[0].second = param->width;
        B[1].first = 0;                     B[1].second = A[0].first;
    }
    else if(param->lastUpdateIdx + len == param->width){
        nA = 1;             nB = 1;
        A[0].first = param->lastUpdateIdx;  A[0].second = param->width;
        B[0].first = 0;                     B[0].second = A[0].first;
    }
    else{
        nA = 2;             nB = 1;
        A[0].first = param->lastUpdateIdx;  A[0].second = param->width;
        A[1].first = 0;                     A[1].second = param->lastUpdateIdx + len - param->width;
        B[0].first = A[1].second;           B[0].second = A[0].first;
    }

    param->lastUpdateIdx = (param->lastUpdateIdx + len) % param->width;
}

/* substract 'val' from range[beg, end) in clocks
 * if clocks[i] < val, clear counters[i] */
void updateRangeSub_simd(Counter_t *counters, Clock_t *clocks, int beg, int end, int val){
    /* ensure address alignment */
    int alignment = 8 / sizeof(Clock_t);        // aligned by 8byte (64-bit)
    int idx = beg;
    while(idx % alignment){
        if(clocks[idx] < val){
            clocks[idx] = 0;
            counters[idx] = 0;
        }
        else clocks[idx] -= val;
        idx++;
    }

    /* use SIMD */
    __m256i _subVal =  _mm256_set1_epi8(char(val));             // val
    __m256i _subValMinusOne =  _mm256_set1_epi8(char(val - 1)); // val-1
    while(idx +32 <= end){
        __m256i clock1 = _mm256_loadu_si256((__m256i*)(&clocks[idx]));   // load clock contents
        __m256i clock2 = _mm256_subs_epu8(clock1, _subVal);
        _mm256_storeu_si256((__m256i*)(&clocks[idx]), clock2);      // update clock

        __m256i x = _mm256_max_epu8(clock1, _subValMinusOne);   // find out those clock < subVal, and set them to subVal-1
        __m256i eq = _mm256_cmpeq_epi8(x, _subValMinusOne);     // find out those subVal-1

        __m128i low128 = _mm256_extracti128_si256(eq, 0);       // low 128 bit of eq
        __m128i high128 = _mm256_extracti128_si256(eq, 1);       // high 128 bit of eq
        __m256i low = _mm256_cvtepi8_epi16(low128); 
        __m256i high = _mm256_cvtepi8_epi16(high128);             // convert 0xFF to 0xFFFF, and 0x00 to 0x0000

        __m256i counter_low = _mm256_loadu_si256((__m256i*)(&counters[idx]));          
        __m256i counter_high = _mm256_loadu_si256((__m256i*)(&counters[idx + 16]));  // load counters

        __m256i resLow = _mm256_andnot_si256(low, counter_low);
        __m256i resHigh = _mm256_andnot_si256(high, counter_high);  // (!high) bitwise-and counter_high

        _mm256_storeu_si256((__m256i*)(&counters[idx]), resLow);
        _mm256_storeu_si256((__m256i*)(&counters[idx + 16]), resHigh);  // write back to counters
    
        idx += 32;
    }

    /* process the left clocks and counters */
    while(idx < end){
        if(clocks[idx] < val){
            clocks[idx] = 0;
            counters[idx] = 0;
        }
        else clocks[idx] -= val;
        idx++;
    }
}

/* substract 'val' from range[beg, end) in clocks
 * if clocks[i] < val, clear counters[i] */
void updateRangeSub(Counter_t *counters, Clock_t *clocks, int beg, int end, int val){
    // printf("beg=%d, end=%d\n", beg, end);
    for(int i = beg; i < end; ++i)
        if(clocks[i] < val){
            clocks[i] = 0;
            counters[i] = 0;
        }
        else clocks[i] -= val;
}

void* updateClockArray(void* arg){
    void* *args = (void**)arg;
    cm_sketch *sketch = (cm_sketch*)(args[0]);      // pointer to sketch
    int id = int(uintptr_t(args[1]));               // id of thread
    ClockUpdateThreadParam *param = &sketch->threadParams[id];  // get params of this thread

// #ifdef _BIND_THREAD_WITH_CPU_
// 	cpu_set_t mask;
// 	CPU_ZERO(&mask);
// 	CPU_SET(id + 1, &mask);
// 	if(sched_setaffinity(0, sizeof(cpu_set_t), &mask) == -1){
// 		printf("Warning: failed to bind %d-th thread to %d-th CPU core\n", id, id + 1);
// 	}
// #endif
    printf("updateClockArray: successfully create thread-%d\n", id);
    pthread_mutex_lock(&sketch->mutex_updateCond);
    sketch->busyThreadCnt--;
    pthread_cond_signal(&sketch->updateCond);
    pthread_mutex_unlock(&sketch->mutex_updateCond);

    while(true)
    {
        /* wait for main thread signal */
        pthread_mutex_lock(&param->mutex_cond);
        if(!param->haveJob)
            pthread_cond_wait(&param->cond, &param->mutex_cond);
        pthread_mutex_unlock(&param->mutex_cond);

        /* update the clock arrays (no SIMD) */
        // int subA = param->updateLen / param->width + 1, subB = param->updateLen / param->width;
        // pair<int,int> A[2], B[2];
        // int nA, nB;
        // splitRange(param, A, nA, B, nB);
        // if(subB)
        //     for(int i = 0; i < nA; ++i)
        //         updateRangeSub(sketch->counters, sketch->clock, param->begin + A[i].first, param->begin + A[i].second, subA);
        // for(int i = 0; i < nB; ++i)
        //     updateRangeSub(sketch->counters, sketch->clock, param->begin + B[i].first, param->begin + B[i].second, subB);
        int beg = param->lastUpdateIdx;
        int end = std::min(param->width, beg + param->updateLen);
        // updateRangeSub_simd(sketch->counters, sketch->clock, beg, end, 1);
        updateRangeSub(sketch->counters, sketch->clock, beg, end, 1);
        if(end - beg < param->updateLen){
            beg = 0;
            end = param->updateLen - (end - beg);
            // updateRangeSub_simd(sketch->counters, sketch->clock, beg, end, 1);
            updateRangeSub(sketch->counters, sketch->clock, beg, end, 1);
        }
        param->lastUpdateIdx = (param->lastUpdateIdx + param->updateLen) % param->width;
            
        /* notify main thread: update finished */
        pthread_mutex_lock(&sketch->mutex_updateCond);
        sketch->busyThreadCnt--;
        param->haveJob = false;
        pthread_cond_signal(&sketch->updateCond);
        pthread_mutex_unlock(&sketch->mutex_updateCond);
    }
    return NULL;
}

cm_sketch::cm_sketch(int _wSz, int _d, int _width, int _clockUpdateLen, int _threadNum):
            windowSize(_wSz), d(_d), width(_width), clockUpdateLen(_clockUpdateLen), threadNum(_threadNum), W(_width / _d)
{
    assert(clockUpdateLen <= width);
    if(DEBUG){
        printf("cm_sketch::cm_sketch: total counter/clock number: %d, memory-size=%lu KB\n", width, width * (sizeof(Clock_t) + sizeof(Counter_t)) / 1024);
        printf("cm_sketch::cm_sketch: update %d counters for each second\n", clockUpdateLen);
    }

    assert(width % d == 0);
    counters = new Counter_t[width];    memset(counters, 0, sizeof(Counter_t) * width);
    clock = new Clock_t[width];         memset(clock, 0, sizeof(Clock_t) * width);
    hash_func = new BOBHash32*[d];      for(int i = 0; i < d; ++i)  hash_func[i] = new BOBHash32(100 + i);
    if(DEBUG)
        printf("cm_sketch::cm_sketch: successfully allocate memory\n");
   
    /* create one thread for each array */
    // busyThreadCnt = threadNum;
    // pthread_cond_init(&updateCond, NULL);
    // pthread_mutex_init(&mutex_updateCond, NULL);        // this are for thread synchronization

    // assert((width % threadNum == 0) && (clockUpdateLen % threadNum == 0));
    // int __updateLen = clockUpdateLen / threadNum;   
    // int __width = width / threadNum;
    // threadParams = new ClockUpdateThreadParam[threadNum];   // initialize threadParam
    // for(int i = 0; i < threadNum; ++i){
    //     int __begin = __width * i;       
    //     threadParams[i].setParams(__begin, __width, __updateLen);
    // }

    // void* *args = new void*[2 * threadNum];
    // for(int i = 0; i < threadNum; ++i){
    //     args[2 * i] = (void*)this;
    //     args[2 * i + 1] = (void*)(uintptr_t)i;
    //     if(pthread_create(&threadParams[i].tid, NULL, updateClockArray, &args[2*i])){
    //         fprintf(stderr, "cm_sketch::cm_sketch: failed to create thread-%d\n", i);
    //         exit(EXIT_FAILURE);
    //     }
    // }

    /* wait for all thread created */
    // pthread_mutex_lock(&mutex_updateCond);
    // while(busyThreadCnt){
    //     pthread_cond_wait(&updateCond, &mutex_updateCond);
    // }
    // pthread_mutex_unlock(&mutex_updateCond);
    // delete[] args;
    if(DEBUG)
        printf("cm_sketch::cm_sketch: successfully create threads\n");
}

cm_sketch::~cm_sketch()
{
    // for(int i = 0; i < threadNum; ++i)
    //     if(pthread_cancel(threadParams[i].tid)){
    //         fprintf(stderr, "cm_sketch::~cm_sketch: failed to cancel thread-%d\n", i);
    //         exit(EXIT_FAILURE);
    //     }
    // for(int i = 0; i < threadNum; ++i)
    //     if(pthread_join(threadParams[i].tid, NULL)){
    //         fprintf(stderr, "cm_sketch::~cm_sketch: failed to join thread-%d\n", i);
    //         exit(EXIT_FAILURE);
    //     }
    // delete[] threadParams;
    // pthread_cond_destroy(&updateCond);
    // pthread_mutex_destroy(&mutex_updateCond);
    if(DEBUG)
        printf("cm_sketch::~cm_sketch: successfully cancel all threads\n");

    for(int i = 0; i < d; ++i)
        delete hash_func[i];
    delete[] hash_func;
    delete[] clock;
    delete[] counters;
}

int cm_sketch::getWindowSize(){
    return windowSize;
}

void cm_sketch::insert(const char *key, Counter_t f)
{
    for(int i = 0; i < d; ++i){
        int idx = hash_func[i]->run(key, KEY_LENGTH) % W;
        counters[W * i + idx] += f;
        clock[W * i + idx] = CLOCK_MAX_VAL;
    }
}

int cm_sketch::query(const char *key)
{
    Counter_t ret = (1 << sizeof(Counter_t)) - 1;
    for(int i = 0; i < d; ++i){
        int idx = hash_func[i]->run(key, KEY_LENGTH) % W;
        ret = ret > counters[i * W + idx] ? counters[i * W + idx] : ret;
    }
    return ret;
}

void cm_sketch::updateClock()
{
    // busyThreadCnt = threadNum;
    // for(int i = 0; i < threadNum; ++i){
    //     pthread_mutex_lock(&threadParams[i].mutex_cond);
    //     threadParams[i].haveJob = true;
    //     pthread_cond_signal(&threadParams[i].cond);
    //     pthread_mutex_unlock(&threadParams[i].mutex_cond);
    // }

    // pthread_mutex_lock(&mutex_updateCond);
    // while(busyThreadCnt){
    //     pthread_cond_wait(&updateCond, &mutex_updateCond);
    // }
    // pthread_mutex_unlock(&mutex_updateCond);
    static int __lastUpdateIdx = 0;
    int beg = __lastUpdateIdx;
    int end = std::min(beg + clockUpdateLen, width);
    updateRangeSub_simd(counters, clock, beg, end, 1);
    if(clockUpdateLen > end - beg){
        end = clockUpdateLen - (end - beg);
        beg = 0;
        updateRangeSub_simd(counters, clock, beg, end, 1);
    }
    __lastUpdateIdx = end;
}

void cm_sketch::updateClockSlow(){
    static int __lastUpdateIdx = 0;
    for(int i = 0; i < clockUpdateLen; ++i)
    {
        if(clock[__lastUpdateIdx] == 0)
            counters[__lastUpdateIdx] = 0;
        else
            clock[__lastUpdateIdx]--;
        __lastUpdateIdx = (__lastUpdateIdx + 1) % width;
    }
}

double cm_sketch::calARE(const unordered_map<string,int> &RealFreq){
    double RE = 0;
    for(auto it : RealFreq){
        int freq = query(it.first.c_str());
        RE += abs(freq - it.second) * 1.0 / it.second;
    }
    return RE / RealFreq.size();
}
