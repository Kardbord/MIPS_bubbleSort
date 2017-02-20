.data # Data Declaration section:

# Test Cases:
container: .word 40, 90, 73, 23, 567, 5, 50, 62 # container is the address of the beginning of the array
#container: .word 0, 1, 2, 3, 4, 5, 6, 7
#container: .word 7, 6, 5, 4, 3, 2, 1, 0
#container: .word -4, 5, 10, -90, 500, 42, 2, 20
#container: .word 4, -5, 6, -5, 6, 100, -40, 42

# Size of container:
cSize: .word 8

# Output Info:
unsorted: .asciiz "Unsorted Array:\n"
sorted: .asciiz "\n\nSorted Array:\n"

.text # Assembly language instructions go in text segment


# Bubble Sort written in C++:
# void bubbleSort(std::vector<int> &container) {
#     for (int j = (int) container.size() - 1; j >= 0; --j) {
#         for (int i = 0; i < j; ++i) {
#             if (container[i] > container[i + 1]) {
#                 int temp = container[i + 1];
#                 container[i + 1] = container[i];
#                 container[i] = temp;
#             }
#         }
#     }
# }


start:  la $ra, sort        
        la $a0, unsorted    # load address of string to be printed into $a0
        
printfunc:
	li $v0, 4           # load system instruction 4 (print string) into v0 register
	syscall             # call operating system to perform operation 
        la   $a0, cSize     # $a0 is size of array
        la   $a1, container # $a1 is array base address
        addi $t0, $0, 0     # init counter
        lw   $t9, 0($a0)    # put $a0 (size) into t9
  
printloop:            
        sll    $t2, $t0, 2    # mult by 4
        add    $t2, $t2, $a1  # put address plus offset in t2
        lw     $a0, 0($t2)
        li     $v0, 1         # load instruction 1 (print an int)
        syscall
        li     $v0, 11        #load instruction 11 (print char)
        addi   $a0, $0, 32    #load char = 'space'
        syscall
        addi   $t0, $t0, 1    #increment counter
        slt    $t1, $t0, $t9
        bne    $t1, $0, printloop #loop if counter < size
        jr     $ra


sort:	la   $ra, exit      # make ra = exit to exit program after printing after sorting
	la   $s0, container # s0 = base address of container array
	la   $a0, sorted    # change $a0 to print proper method for displaying sorted array
	la   $s1, cSize
	lw   $s1, 0($s1)    # s1 = cSize
	ori  $t0, $s1, 0    # t0 = arraySize = j
loop1:  subi $t0, $t0, 1    # t0 = arraySize - 1 = j; basically --j
	slt  $t1, $t0, $0   # if j < 0, t1 = 1 = true
	bne  $t1, $0, printfunc  # if j < 0, exit
	ori  $t2, $0, 0     # t2 = i = 0
loop2:  sll  $t3, $t2, 2    # t3 = i * 4
	add  $t8, $t3, $s0  # t3 = & container[i]
	lw   $t4, 0($t8)    # t4 = container[i]
	addi $t5, $t3, 4    # t5 = i + 1
	add  $t5, $t5, $s0  # t5 = & container[i+1]
	lw   $t6, 0($t5)    # t6 = container[i+1]
	slt  $t7, $t6, $t4  # if container[i+1] < container[i], then $t7 = 1 = true
	addi $t2, $t2, 1    # t2++ = i++
	bne  $t7, $0, swap  # if (container[i+1] < container[i]), loop
	slt  $t1, $t2, $t0  # i < j, then t1=1=true
	bne  $t1, $0, loop2 # if i < j, go to inner loop
	j    loop1          # if !(i < j) go to outer loop
swap:	sw   $t6, 0($t8)    # container[i] = container[i+1]
	sw   $t4, 0($t5)    # container[i+1] = container[i]
	slt  $t1, $t2, $t0  # i < j, then t1=1=true
	bne  $t1, $0, loop2 # if i < j, go to inner loop
	j    loop1          # if !(i < j) go to outer loop
	
exit:  li $v0, 10         # load system instruction 10 (terminate program) into v0 register
       syscall
