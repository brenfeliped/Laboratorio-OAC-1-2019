#compilação para -O1

.globl main

.data
.LC0: .string "\t"
jl: .string "\n"
v: .word 10,9,8,7,6,5,4,3,2,1

.text
show:
  addi sp,sp,-16
  sw ra,12(sp)
  sw s0,8(sp)
  sw s1,4(sp)
  sw s2,0(sp)
  blez a1,.L2
  mv s0,a0
  slli a1,a1,2
  add s1,a0,a1
  #lui s2,%hi(.LC0)
.L3:
  lw a1,0(s0)	
  mv a0,a1 #move o conteúdo de a1 para a0
  li a7,1 #print Números
  ecall	

  lui s2,%hi(.LC0)
  addi a0,s2,%lo(.LC0)
  
  li,a7,4 #print TAB
  ecall
  
  #call printf
  addi s0,s0,4
  bne s0,s1,.L3
.L2:
  li a0,10
  #call putchar
  
  addi sp,sp,-4#
  sw a0,0(sp)#
  add a0,zero,sp # Tudo aqui é pro '\n'
  li a7,4#
  ecall#
  addi sp,sp,4#
  
  lw ra,12(sp)
  lw s0,8(sp)
  lw s1,4(sp)
  lw s2,0(sp)
  addi sp,sp,16
  jr ra
swap:
  slli a1,a1,2
  add a5,a0,a1
  lw a4,0(a5)
  addi a1,a1,4
  add a0,a0,a1
  lw a3,0(a0)
  sw a3,0(a5)
  sw a4,0(a0)
  ret
sort:
  blez a1,.L15
  addi sp,sp,-32
  sw ra,28(sp)
  sw s0,24(sp)
  sw s1,20(sp)
  sw s2,16(sp)
  sw s3,12(sp)
  sw s4,8(sp)
  sw s5,4(sp)
  sw s6,0(sp)
  mv s2,a0
  mv s4,a0
  addi s6,a1,-1
  li s5,0
  li s3,-1
  j .L9
.L10:
  addi s5,s5,1
  addi s4,s4,4
.L9:
  mv s0,s5
  beq s5,s6,.L18
  bltz s0,.L10
  lw a4,0(s4)
  lw a5,4(s4)
  ble a4,a5,.L10
  mv s1,s4
.L11:
  mv a1,s0
  mv a0,s2
  call swap
  addi s0,s0,-1
  beq s0,s3,.L10
  lw a4,-4(s1)
  addi s1,s1,-4
  lw a5,4(s1)
  bgt a4,a5,.L11
  j .L10
.L18:
  lw ra,28(sp)
  lw s0,24(sp)
  lw s1,20(sp)
  lw s2,16(sp)
  lw s3,12(sp)
  lw s4,8(sp)
  lw s5,4(sp)
  lw s6,0(sp)
  addi sp,sp,32
  jr ra
.L15:
  ret
main:
  addi sp,sp,-16
  sw ra,12(sp)
  sw s0,8(sp)
  lui s0,%hi(v)
  li a1,10
  addi a0,s0,%lo(v)
  call show
  li a1,10
  addi a0,s0,%lo(v)
  call sort
  li a1,10
  addi a0,s0,%lo(v)
  call show
  li a0,0
  lw ra,12(sp)
  lw s0,8(sp)
  addi sp,sp,16
  jr ra
  
  li a7,10
  ecall
 
