#include <random>
#include <iostream>
#include "gpuacc.h"

typedef struct {
    std::mt19937 &gen;
    std::uniform_int_distribution<> &dis;
} context;

int gpu_run(void *arg) {
    context *ctx = (context *)arg;
    double random_number = ctx->dis(ctx->gen);
    std::cout << "Random number: " << random_number << std::endl;
    return 0;
}


int main() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 100);

    context ctx = {gen, dis};

    gpu_run((void *)&ctx, sizeof(context), gpu_run);

    return 0;
}