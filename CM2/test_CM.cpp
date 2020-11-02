#include <stdio.h>
#include <stdlib.h>
#include <random>
#include <string.h>
#include <string>
#include <chrono>
#include <iostream>
#include <assert.h>
#include "cm_clock.h"
using namespace std;
using namespace std::chrono;

#define test_cycle 10000

int main(int argc, char *argv[])
{
    assert(argc > 1);
    // cm_sketch(int _wSz, int _d, int _width);
    int width = 162000;
    int byteNum = width * (sizeof(Clock_t) + sizeof(Counter_t));
    int wSz = 1 << 14;  // 1024*16
    int d = 8;
    int clockUpdateLen = 80000;
    int threadNum = atoi(argv[1]);
    cm_sketch *cm = new cm_sketch(wSz, d, width, clockUpdateLen, threadNum);

    printf("********************Slow*****************\n");
    for(int iCase = 0; iCase < 3; ++iCase){
        printf("iCase=%d:\n", iCase);
        auto t1 = steady_clock::now();
        for(int i = 0; i < test_cycle; ++i)
            cm->updateClockSlow();
        auto t2 = steady_clock::now();
        auto t3 = duration_cast<microseconds>(t2 - t1).count();
        cout << "(multi-thread): duration: " << 1.0 * t3 / test_cycle << " microseconds per cycle" << endl;
        cout << "(multi-thread): throughput: " << 1 / (1.0 * t3 / test_cycle) << " MIPs\n" << endl;
    }

    printf("********************multi-thread & SIMD*****************\n");
    for(int iCase = 0; iCase < 3; ++iCase){
        printf("iCase=%d:\n", iCase);
        auto t1 = steady_clock::now();
        for(int i = 0; i < test_cycle; ++i)
            cm->updateClock();
        auto t2 = steady_clock::now();
        auto t3 = duration_cast<microseconds>(t2 - t1).count();
        cout << "(multi-thread): duration: " << 1.0 * t3 / test_cycle << " microseconds per cycle" << endl;
        cout << "(multi-thread): throughput: " << 1 / (1.0 * t3 / test_cycle) << " MIPs\n" << endl;
    }

    // auto t4 = steady_clock::now();
    // for(int i = 0; i < test_cycle; ++i)
    //     cm->updateClockSlow();
    
    // auto t5 = steady_clock::now();
    // auto t6 = duration_cast<microseconds>(t5 - t4).count();
    // cout << "(normal): duration: " << 1.0 * t6 / test_cycle << " microseconds per cycle" << endl;
    // cout << "(normal): throughput: " << 1 / (1.0 * t6 / test_cycle) << " MIPs" << endl;

    delete cm;
    return 0;
}
