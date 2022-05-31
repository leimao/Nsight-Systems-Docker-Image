#include <cuda_runtime.h>
#include <iostream>
#include <vector>

#define CHECK_CUDA_ERROR(val) check((val), #val, __FILE__, __LINE__)
template <typename T>
void check(T err, const char* const func, const char* const file,
           const int line)
{
    if (err != cudaSuccess)
    {
        std::cerr << "CUDA Runtime Error at: " << file << ":" << line
                  << std::endl;
        std::cerr << cudaGetErrorString(err) << " " << func << std::endl;
        std::exit(EXIT_FAILURE);
    }
}

#define CHECK_LAST_CUDA_ERROR() checkLast(__FILE__, __LINE__)
void checkLast(const char* const file, const int line)
{
    cudaError_t err{cudaGetLastError()};
    if (err != cudaSuccess)
    {
        std::cerr << "CUDA Runtime Error at: " << file << ":" << line
                  << std::endl;
        std::cerr << cudaGetErrorString(err) << std::endl;
        std::exit(EXIT_FAILURE);
    }
}

__global__ void kernel(float* a, int offset)
{
    int i = offset + threadIdx.x + blockIdx.x * blockDim.x;
    float x = (float)i;
    float s = sinf(x);
    float c = cosf(x);
    a[i] = a[i] + sqrtf(s * s + c * c);
}

int main(int argc, char** argv)
{
    const int blockSize = 256, numStreams = 4;
    const int n = 4 * 1024 * blockSize * numStreams;
    const int streamSize = n / numStreams;
    const int streamBytes = streamSize * sizeof(float);
    const int bytes = n * sizeof(float);

    // allocate pinned host memory and device memory
    std::vector<float> vec(n, 0);
    float *h_a, *d_a;
    h_a = vec.data();
    CHECK_CUDA_ERROR(cudaMalloc((void**)&d_a, bytes));

    cudaStream_t streams[numStreams];
    for (int i = 0; i < numStreams; ++i)
    {
        CHECK_CUDA_ERROR(cudaStreamCreate(&streams[i]));
    }

    for (int i = 0; i < numStreams; ++i)
    {
        int offset = i * streamSize;
        CHECK_CUDA_ERROR(cudaMemcpyAsync(&d_a[offset], &h_a[offset],
                                         streamBytes, cudaMemcpyHostToDevice,
                                         streams[i]));
        kernel<<<streamSize / blockSize, blockSize, 0, streams[i]>>>(d_a,
                                                                     offset);
        CHECK_LAST_CUDA_ERROR();
        CHECK_CUDA_ERROR(cudaMemcpyAsync(&h_a[offset], &d_a[offset],
                                         streamBytes, cudaMemcpyDeviceToHost,
                                         streams[i]));
    }

    for (int i = 0; i < numStreams; ++i)
    {
        CHECK_CUDA_ERROR(cudaStreamSynchronize(streams[i]));
    }

    for (int i = 0; i < numStreams; ++i)
    {
        CHECK_CUDA_ERROR(cudaStreamDestroy(streams[i]));
    }

    cudaFree(d_a);

    return 0;
}