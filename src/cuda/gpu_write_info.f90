!
!	gpu_info.f90
!	new_quick
!
!	Created by Yipu Miao on 4/20/11.
!	Copyright 2011 University of Florida. All rights reserved.
!

subroutine gpu_write_info(io)
    implicit none
    ! io unit
    integer io
    
    integer gpu_dev_count
    integer gpu_dev_id
    integer gpu_num_proc
    character(len=20) gpu_dev_name
    integer gpu_dev_mem
    double precision gpu_core_freq
    integer name_len
    integer majorv
    integer minorv

    write(io,*)
    write(io,'(a)')   '|------------ CUDA INFORMATION ---------------'
    write(io,'(a)')   '|  CUDA version of Quick in use'
    write(io,'(a)')   '|  Implemented by'
    write(io,'(a)')   '|                      Yipu Miao (Florida)'
    write(io,'(a)')   '|  CAUTION: CUDA Quick is currently experimental'
    write(io,'(a)')   '|           and you may at risk to use it. Be sure'
    write(io,'(a)')   '|           to check result carelly. Advise or '
    write(io,'(a)')   '|           bug report are welcome.'
    write(io,'(a)')   '|---------------------------------------------'
    write(io,*)
    
    call gpu_get_device_info(gpu_dev_count,gpu_dev_id,gpu_dev_mem,gpu_num_proc,gpu_core_freq,gpu_dev_name,name_len,majorv,minorv)
    write(io,'(a)')        '|------------ GPU INFORMATION ---------------'
    write(io,'(a,i8)')     '| CUDA ENABLED DEVICE         : ', gpu_dev_count
    write(io,'(a,i8)')     '| CUDA DEVICE IN USE          : ', gpu_dev_id
    write(io,'(a,a)')        '| CUDA DEVICE NAME            : ', gpu_dev_name(1:name_len)
    write(io,'(a,i8)')     '| CUDA DEVICE PM              : ', gpu_num_proc
    write(io,'(a,f8.2)')   '| CUDA DEVICE CORE FREQ(GHZ)  : ', gpu_core_freq
    write(io,'(a,i8)')     '| CUDA DEVICE MEMORY SIZE (MB): ', gpu_dev_mem
    write(io,'(a,i6,a,i1)')     '| SUPPORTING CUDA VERSION     : ', majorv,'.',minorv
    write(io,'(a)')        '|--------------------------------------------'
    if (majorv <=1 .and. minorv<=2) call prtWrn(io,"Selected GPU does not support double-precision computation.")
    
end subroutine gpu_write_info
    