program intdiff

integer i,j,k,l,m,n,i1,i2,i3,i4,i5,i6,i7,i8
integer j1,j2,j3,j4,j5,j6,j7,j8
double precision d1,d2
logical same
open (unit=2, file="tmp")
open (unit=3, file="tmp2")

read(3,*) k,l,d2

do i = 1, 10000
	same = .false.
	read(2,*) k,l,d1
		if(abs(d1-d2).gt.1e-5) then
				write(*,*) "diff1",k,l,d1,d2,d1-d2
		else
!			write(*,*) "same",j,k,d1,d2,d1-d2
		endif
		read(3,*) k,l,d2
enddo


end program