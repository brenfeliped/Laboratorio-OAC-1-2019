#compilação para -O0

.globl main
.data #cria um .data
v: .word 10,9,8,7,6,5,4,3,2,1

.LC0: .string "\t" 
jl: .string "\n" #cria uma nova label para o \n
  
.text #cria um .text

show:
  addi sp,sp,-48
  sw ra,44(sp)
  sw s0,40(sp)
  addi s0,sp,48 #?
  sw a0,-36(s0)
  sw a1,-40(s0)
  sw zero,-20(s0)
  
.L3:
  lw a4,-20(s0)
  lw a5,-40(s0)
  bge a4,a5,.L2
  lw a5,-20(s0)
  slli a5,a5,2
  lw a4,-36(s0)
  add a5,a4,a5
  lw a5,0(a5)
  mv a1,a5
  
  mv a0,a1 #move o conteudo de a1 para a0
  
  call printNUM #chama a label para printar os n�meros 
  
  lui a5,%hi(.LC0)
  addi a0,a5,%lo(.LC0)
    
  call printTAB #chama a label para printar a /n
  
  lw a5,-20(s0)
  addi a5,a5,1
  sw a5,-20(s0)
  j .L3
  
.L2:
  li a0,10
  
  addi sp,sp,-4 #aloca 1 espa�o na pilha
  sw a0,0(sp) #carrega de a0 na primeira posi��o da pilha
  add a0,zero,sp #pega o endere�o da primeira posi��o da pilha e joga em a0
  li a7,4 #imprimi o /n
  ecall
  addi sp,sp,4 #desempilha

  nop
  lw ra,44(sp)
  lw s0,40(sp)
  addi sp,sp,48
  jr ra
  ecall
  
swap:
  addi sp,sp,-48
  sw s0,44(sp)
  addi s0,sp,48
  sw a0,-36(s0)
  sw a1,-40(s0)
  lw a5,-40(s0)
  slli a5,a5,2
  lw a4,-36(s0)
  add a5,a4,a5
  lw a5,0(a5)
  sw a5,-20(s0)
  lw a5,-40(s0)
  addi a5,a5,1
  slli a5,a5,2
  lw a4,-36(s0)
  add a4,a4,a5
  lw a5,-40(s0)
  slli a5,a5,2
  lw a3,-36(s0)
  add a5,a3,a5
  lw a4,0(a4)
  sw a4,0(a5)
  lw a5,-40(s0)
  addi a5,a5,1
  slli a5,a5,2
  lw a4,-36(s0)
  add a5,a4,a5
  lw a4,-20(s0)
  sw a4,0(a5)
  nop
  lw s0,44(sp)
  addi sp,sp,48
  jr ra
  
sort:
  addi sp,sp,-48
  sw ra,44(sp)
  sw s0,40(sp)
  addi s0,sp,48
  sw a0,-36(s0)
  sw a1,-40(s0)
  sw zero,-20(s0)
  
.L9:
  lw a4,-20(s0)
  lw a5,-40(s0)
  bge a4,a5,.L10
  lw a5,-20(s0)
  addi a5,a5,-1
  sw a5,-24(s0)
  
.L8:
  lw a5,-24(s0)
  bltz a5,.L7
  lw a5,-24(s0)
  slli a5,a5,2
  lw a4,-36(s0)
  add a5,a4,a5
  lw a4,0(a5)
  lw a5,-24(s0)
  addi a5,a5,1
  slli a5,a5,2
  lw a3,-36(s0)
  add a5,a3,a5
  lw a5,0(a5)
  ble a4,a5,.L7
  lw a1,-24(s0)
  lw a0,-36(s0)
  call swap
  lw a5,-24(s0)
  addi a5,a5,-1
  sw a5,-24(s0)
  j .L8
  
.L7:
  lw a5,-20(s0)
  addi a5,a5,1
  sw a5,-20(s0)
  j .L9
  
.L10:
  nop
  lw ra,44(sp)
  lw s0,40(sp)
  addi sp,sp,48
  jr ra
  
main: 
  addi sp,sp,-16
  sw ra,12(sp)
  sw s0,8(sp)
  addi s0,sp,16 
  li a1,10
  lui a5,%hi(v) 
  addi a0,a5,%lo(v) 
  call show 
  li a1,10 
  lui a5,%hi(v)
  addi a0,a5,%lo(v)
  call sort
  li a1,10
  lui a5,%hi(v)
  addi a0,a5,%lo(v)
  call show
  li a5,0
  mv a0,a5
  lw ra,12(sp)
  lw s0,8(sp)
  addi sp,sp,16
  
  li a7,10
  ecall
  
printTAB: #print o tab
  li a7,4 #printa o /t
  ecall
  jr ra  

printNUM: #printa os n�meros
  li a7,1 #printa um numero
  ecall
  jr ra
  
