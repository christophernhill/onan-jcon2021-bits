//  mpicc -I${CUDA_ROOT}/include -L${CUDA_ROOT}/lib64 -I/home/cnh/projects/cuda-toolkit/NVIDIA_CUDA-11.2_Samples/common/inc cuda_test.cc  -lcudart

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#include <cuda_runtime_api.h>
#include <helper_cuda.h>

#include <time.h>


int main(int argc, char** argv) {
	MPI_Comm comm;
	comm = MPI_COMM_WORLD;
	MPI_Init(NULL, NULL);
	int world_rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	int world_size;
	MPI_Comm_size(MPI_COMM_WORLD, &world_size);
        if ( world_size != 2 ) {
		exit(-1);
        }

	int dev_id;
	dev_id = world_rank;
	cudaSetDevice( dev_id );

	int nbytes = 1000*1000*8;
	int nm     = 10;
	void *sendBuf;
	void *recvBuf;
	cudaMalloc((void **) &sendBuf, nbytes);
	cudaMalloc((void **) &recvBuf, nbytes);

	int recv_from_rank, recv_from_tag;
	int send_to_rank, sender_tag;
        if ( world_rank == 0 ) {
         recv_from_rank = 1;
         recv_from_tag  = 11;
         send_to_rank   = 1;
         sender_tag     = 10;
	}

        if ( world_rank == 1 ) {
         recv_from_rank = 0;
         recv_from_tag  = 10;
         send_to_rank   = 0;
         sender_tag     = 11;
	}

	int rc;
	MPI_Request rreq, sreq;
	int im;
	struct timespec begin, end;
	clock_gettime( CLOCK_REALTIME, &begin );
	for (im=0;im<=nm-1;++im) {
         	rc = MPI_Irecv(  recvBuf, nbytes, MPI_CHAR, recv_from_rank, recv_from_tag, comm, &rreq);
        	rc = MPI_Isend(  sendBuf, nbytes, MPI_CHAR, send_to_rank,   sender_tag,    comm, &sreq);
        	MPI_Request req_arr[2];
        	MPI_Status  stat_arr[2];
        	req_arr[0] = rreq;
        	req_arr[1] = sreq;
        	rc = MPI_Waitall(2,req_arr,stat_arr);
	}
	clock_gettime( CLOCK_REALTIME, &end );
	double time_spent = ( end.tv_sec - begin.tv_sec ) + 
		            (double)( end.tv_nsec - begin.tv_nsec )/double(1.e9);

	printf("The elapsed time is %f seconds\n", time_spent);
	printf("The BW is %f GB/s\n", (double)(nbytes*nm*2)/time_spent/(double)(1.e9) );

	rc = MPI_Barrier( comm );

}

/*
for nmesg = 1:4
 rreq  = MPI.Irecv!(recvArr, recv_from_rank, recv_from_tag, comm)
 sreq  = MPI.Isend( sendArr, send_to_rank  , sender_tag,    comm)
 stats = MPI.Waitall!([rreq, sreq])
 tick();tok()
end

function sr(nm)
 for nmesg = 1:nm
  rreq  = MPI.Irecv!(recvArr, recv_from_rank, recv_from_tag, comm)
  sreq  = MPI.Isend( sendArr, send_to_rank  , sender_tag,    comm)
  stats = MPI.Waitall!([rreq, sreq])
 end
end

sr(1)
sr(1)
sr(1)

tick()
sr(nm)
elap=tok()

println("elap = ",elap, " BW (GB/s) ", 2*nel*nm*8/elap/1e9)

MPI.Barrier(comm)
*/
