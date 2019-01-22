! Program to print hello world using MPI

program main
    implicit none
    include 'mpif.h' !defines MPI_COMM_WORLD ie the communicator
    integer :: ierror, rank, size, ilen, i
    character(len=256) :: name
    

    ! initialize MPI
    call MPI_Init(ierror)
    !print*, 'MPI initializion error signal: ',ierror
    
    ! print the rnak of MPI_COMM_WORLD
    call MPI_Comm_RANK(MPI_COMM_WORLD, rank, ierror)
    !print*, 'MPI rank: ', rank, 'error status: ',ierror

    ! print the total number of sizes in the communicator
    call MPI_Comm_Size(MPI_COMM_WORLD, size, ierror)
    !print*, 'MPI size: ', size, 'error status: ',ierror

    ! print the processor name
    call MPI_Get_Processor_Name(name, ilen, ierror) 
    !print*,'MPI processor name', name(1:ilen), 'error status: ',ierror


    do i = 0, size-1
        
          
        if (rank .eq. i) then
            

            ! NOTE: Instead of printing writing to a file gives the correct
            ! order each time. In PRINT the output to the screen is stored in a 
            ! buffer and is printed at will by the processor. 
            ! But by opening and writing, and then quickly closing the file ensures
            ! that the output is written when the statment is encountered.
            !
            ! ALSO NOTE: That printing the file and writing it seems to make
            ! the print statment print in an order.  

            open(10, file='order.dat', position='append')
            !output rank for each processor, rnak and totla number of processors

            write(10,*)'rank: ',rank,', processor name: ', name(1:ilen),', size= ',size
            
            close(10)
             
            
            print*, 'rank: ',rank,', processor name: ', name(1:ilen),', size= ',size

        endif
     
        ! NOTE: A barrier here ensures that all the copies wait here and then
        ! move forward together from this point. 

        call MPI_Barrier(MPI_COMM_WORLD,ierror)
    enddo

    if (rank .eq. 0) then
        print*, 'Hello World! from rank:', rank
    endif

    ! terminate MPI
    call MPI_Finalize(ierror)   
    !print*, 'MPI termination error signal: ',ierror



end program main