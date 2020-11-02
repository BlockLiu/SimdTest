#include "param.h"
#include <stdio.h>

ClockUpdateThreadParam::ClockUpdateThreadParam(): tid(0), haveJob(false), begin(0), width(0), lastUpdateIdx(0), updateLen(0){
    pthread_cond_init(&cond, NULL);
    pthread_mutex_init(&mutex_cond, NULL);
}
ClockUpdateThreadParam::~ClockUpdateThreadParam(){
    pthread_mutex_destroy(&mutex_cond);
    pthread_cond_destroy(&cond);
}
void ClockUpdateThreadParam::setParams(int _begin, int _width, int _updateLen){
    printf("beg=%d, width=%d, end=%d\n", _begin, _width, _begin + _width);
    begin = _begin;     
    width = _width;     
    updateLen = _updateLen;
}
