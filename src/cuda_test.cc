//  mpicc -I${CUDA_ROOT}/include -L${CUDA_ROOT}/lib64 -I/home/cnh/projects/cuda-toolkit/NVIDIA_CUDA-11.2_Samples/common/inc cuda_test.cc  -lcudart

#include <cuda_runtime_api.h>
#include <helper_cuda.h>

int main()
{
int dev_id;
dev_id=0;

int nbytes;
nbytes=5000;
char buf[nbytes];

void* myBuf;

cudaSetDevice( dev_id );
// Allocate and get IPC handle
cudaMalloc((void **) &myBuf, nbytes);
cudaIpcMemHandle_t myIpc;
checkCudaErrors( cudaIpcGetMemHandle(&myIpc, myBuf) );



}
