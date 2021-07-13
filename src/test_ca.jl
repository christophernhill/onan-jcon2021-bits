using MPI
using CUDA
using TickTock

lr=parse(Int64,ENV["OMPI_COMM_WORLD_LOCAL_RANK"])
CUDA.device!(lr)
dev=device()
## pool=CuMemoryPool(dev,alloc_type=CUDA.CU_MEM_ALLOCATION_TYPE_PINNED,handle_type=CUDA.CU_MEM_HANDLE_TYPE_POSIX_FILE_DESCRIPTOR)
pool=CuMemoryPool(dev,alloc_type=CUDA.CU_MEM_ALLOCATION_TYPE_PINNED,handle_type=CUDA.CU_MEM_HANDLE_TYPE_NONE)
memory_pool!(dev,pool)

MPI.Init()

      comm = MPI.COMM_WORLD
local_rank = MPI.Comm_rank(comm)
         R = MPI.Comm_size(comm)

if R != 2
 exit()
end

# See: https://github.com/CliMA/ClimateMachine.jl/blob/2def0d653fcef3d069e816844fa4ec5d745c84d1/src/Driver/Driver.jl#L40-L43
## local_comm = MPI.Comm_split_type(comm, MPI.MPI_COMM_TYPE_SHARED, MPI.Comm_rank(comm))
## CUDA.device!(MPI.Comm_rank(local_comm) % length(devices()))
## dev=device()
## pool=CuMemoryPool(dev,alloc_type=CUDA.CU_MEM_ALLOCATION_TYPE_PINNED,handle_type=CUDA.CU_MEM_HANDLE_TYPE_POSIX_FILE_DESCRIPTOR)
## memory_pool!(dev,pool)


nel=1000000
nm =1

sendArr = CUDA.zeros(Float64, nel)
recvArr = CUDA.zeros(Float64, nel)
fill!(sendArr, local_rank)

if local_rank == 0
 recv_from_rank = 1
 recv_from_tag  = 11
 send_to_rank   = 1
 sender_tag     = 10
end

if local_rank == 1
 recv_from_rank = 0
 recv_from_tag  = 10
 send_to_rank   = 0
 sender_tag     = 11
end

for nmesg = 1:4
 rreq  = MPI.Irecv!(recvArr, recv_from_rank, recv_from_tag, comm)
 sreq  = MPI.Isend( sendArr, send_to_rank  , sender_tag,    comm)
 stats = MPI.Waitall!([rreq, sreq])
 tick();tok()
end

tick()
for nmesg = 1:nm
 rreq  = MPI.Irecv!(recvArr, recv_from_rank, recv_from_tag, comm)
 sreq  = MPI.Isend( sendArr, send_to_rank  , sender_tag,    comm)
 stats = MPI.Waitall!([rreq, sreq])
end
elap=tok()

println("elap = ",elap)

MPI.Barrier(comm)
