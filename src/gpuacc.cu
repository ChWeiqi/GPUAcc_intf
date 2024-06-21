#include <cuda_runtime.h>
#include <stdio.h>
#include "gpuacc.h"


__global__ void gpu_run_kernel(void *arg, gpu_run_fn fn) {
    fn(arg);
}

int gpu_run(void *arg, int arg_sz, gpu_run_fn fn) {
    if (fn == NULL) {
        fprintf(stderr, "Function pointer is NULL\n");
        return -1;
    }

    cudaError_t err;

    // allocate memory for parameters
    void *d_arg;
    err = cudaMalloc(&d_arg, arg_sz);
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to allocate device memory for parameters: %s\n", cudaGetErrorString(err));
        return -1;
    }

    // copy parameters to device memory
    err = cudaMemcpy(d_arg, arg, arg_sz, cudaMemcpyHostToDevice);
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to copy parameters to device memory: %s\n", cudaGetErrorString(err));
        return -1;
    }

    // allocate memory for function
    gpu_run_fn d_fn;
    err = cudaMalloc(&d_fn, sizeof(gpu_run_fn));
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to allocate device memory for function: %s\n", cudaGetErrorString(err));
        return -1;
    }

    // copy function to device memory
    err = cudaMemcpy((void*)d_fn, (void*)&fn, sizeof(gpu_run_fn), cudaMemcpyHostToDevice);
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to copy function to device memory: %s\n", cudaGetErrorString(err));
        return -1;
    }

    gpu_run_kernel<<<1, 1>>>(d_arg, d_fn);
    err = cudaGetLastError();
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to launch kernel: %s\n", cudaGetErrorString(err));
        return -1;
    }

    // wait for kernel to finish
    err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to synchronize device: %s\n", cudaGetErrorString(err));
        return -1;
    }

    // free device memory
    cudaFree(d_arg);
    cudaFree((void*)d_fn);

    return 0;
}