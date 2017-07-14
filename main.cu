#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void MatAdd (float* A, float* B, float* C, int N){

	int index = threadIdx.x;
	if (index < 5){
		C[index] = A[index] + B[index];
	}
}

int main(void){

	/*Set array size*/
	int N = 5;
	int size = N * sizeof(float);

	/*Define and initialize arrays in HOST*/
	float* h_A = (float *)malloc(size);
	float* h_B = (float *)malloc(size);
	float* h_C = (float *)malloc(size);

	for (int i = 0; i < N; i++){
		h_A[i] = i;
		h_B[i] = i;
		h_C[i] = 0;
	}

	/*Define and allocate arrays in DEVICE*/
	float* d_A;
	float* d_B;
	float* d_C;
	cudaMalloc((void **)&d_A, size);
	cudaMalloc((void **)&d_B, size);
	cudaMalloc((void **)&d_C, size);

	/*Copy arrays from HOST to DEVICE*/
	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_C, h_C, size, cudaMemcpyHostToDevice);

	/*Define level of parallelism*/
	dim3 threadsPerBlock(16, 16);
	dim3 numBlocks(1,1,1);

	/*Launch kernel and synchronize*/
	MatAdd<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_C, N);
	cudaDeviceSynchronize();

	/*Copy output array from DEVICE to HOST*/
	cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

	/*Free device memory*/
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

//	/*Print to console*/
//	cout << "A[] = ";
//	for (int i = 0; i < N; i++){
//		if (i == 0) {cout << "[";}
//		cout << h_A[i];
//		if (i == N-1) {cout << "]" << endl << endl;} else {cout << ", ";}
//	}
//
//	cout << "B[] = ";
//	for (int i = 0; i < N; i++){
//		if (i == 0) {cout << "[";}
//		cout << h_B[i];
//		if (i == N-1) {cout << "]" << endl << endl;} else {cout << ", ";}
//	}
//
//	cout << "C[] = ";
//	for (int i = 0; i < N; i++){
//		if (i == 0) {cout << "[";}
//		cout << h_C[i];
//		if (i == N-1) {cout << "]" << endl;} else {cout << ", ";}
//
//	}

	return 0;
}
