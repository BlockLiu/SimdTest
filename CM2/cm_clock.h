#ifndef _CM_SKETCH_CLOCK_H_
#define _CM_SKETCH_CLOCK_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unordered_map>
#include <string>
#include <pthread.h>
#include "BOBHash32.h"
#include "param.h"
using std::unordered_map;
using std::string;

#define _BIND_THREAD_WITH_CPU_

/* update a range in the counter/clock array */
void* updateClockArray(void* arg);


class cm_sketch
{
	int d;			// number of hash functions
	int width;		// width of counter arrays, it is better to set width to 8's and d's multiple times
	int W;			// W = width / d

	Counter_t *counters;	// counter arrays
	Clock_t *clock;			// clocks

	int windowSize;			// window size (only use in updateClock)
	int clockUpdateLen;

	BOBHash32 **hash_func;	// d hash functions

	int threadNum;			// number of threads used
	int busyThreadCnt;
	ClockUpdateThreadParam *threadParams;
	pthread_cond_t updateCond;
	pthread_mutex_t mutex_updateCond;

	friend void* updateClockArray(void* arg);
public:
	cm_sketch(int _wSz, int _d, int _width, int _clockUpdateLen, int _threadNum);
	~cm_sketch();

	void insert(const char *key, Counter_t f=1);
	int query(const char *key);

	void updateClock();
	void updateClockSlow();		// no simd, no multi-thread

	int getWindowSize();
	double calARE(const unordered_map<string,int> &RealFreq);
};

#endif //_CM_SKETCH_CLOCK_H_