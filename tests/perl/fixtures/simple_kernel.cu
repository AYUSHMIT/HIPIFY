#include <cuda_runtime.h>
__global__ void add(int *a) { a[threadIdx.x] += 1; }
int main() { return 0; }
