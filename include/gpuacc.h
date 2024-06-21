/**
* This is gpu acc interface defination headers
*/
#pragma once

typedef int (*gpu_run_fn)(void *);

/**
* void *arg: the argument pass to the gpu function
* gpu_run_fn fn: the gpu function to run
* return val: the result of gpu run result
* note: if run success return 0, else return -1
* the fn return value must returned by the function itself
*/
int gpu_run(void *arg, int arg_sz, gpu_run_fn fn);
