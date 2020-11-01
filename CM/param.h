#ifndef _PARAM_H_
#define _PARAM_H_

#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>

#define _BIND_THREAD_WITH_CPU_  // if manually bind thread to cpu cores
#define KEY_LENGTH 32
typedef uint16_t Counter_t;     // counter type
typedef uint8_t Clock_t;        // 8-bit
#define ClockSize sizeof(Clock_t)
#define CLOCK_MAX_VAL ((1 << ClockSize) - 1)

#define DEBUG true              // turn on debug

// params for synchronization in thread
class ClockUpdateThreadParam
{
public:
    pthread_t tid;			// thread id
    
    pthread_cond_t cond;
    pthread_mutex_t mutex_cond;
	bool haveJob;			// these are used for wake up thread

    int begin;              
    int width;              // this thread manage [begin, begin + width)
    int lastUpdateIdx;      // in range [0, width)

    int updateLen;          // number of clock/counters will be updated

    ClockUpdateThreadParam();
	~ClockUpdateThreadParam();
    
    void setParams(int _begin, int _width, int _updateLen);
};

#endif //_PARAM_H_