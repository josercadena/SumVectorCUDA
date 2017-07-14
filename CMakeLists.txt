cmake_minimum_required(VERSION 2.8.1)

project( SumVectorExample)
find_package( CUDA REQUIRED)

set( CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 -g -pg -gencode arch=compute_20,code=sm_20; --std=c++11 )

cuda_add_executable( SumVectorExample main.cu)
target_link_libraries (	SumVectorExample ${CUDA_LIBRARIES})