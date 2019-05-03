#######################################
### Metodo SORTEIO recebe em a0  um N e a1 um vetor C, e criar na memoria N coordenadas (x,y)##
### tal que 0 <=x <= 310 e 0 <- y <= 230####
.data
N: .word 6
# Número de Casas/Clientes
C: .space 160
# Espaço em bytes correspondente a 2 coordenadas x 20 casas (máx) x 4 bytes,
.text
la t0,N
lw a0,0(t0)
la a1,C
jal ra,SORTEIO
li a7,10 # chamada de fim de programa 
ecall

SORTEIO:
	li t0,1 # contador t0
FOR:	beq t0,a0,ExitFor # if(t0==a0) : pc=ExitFor ? pc=pc+4
	addi sp,sp,-4  # aloca espaco na pilha para guarda a0
	sw  a0, 0(sp)  # coloca a0 na  pilha
	li a7,41       # chamada rand
	ecall
	li t1,311
	remu t2,a0,t1 # t2 recebe um numero aleatorio entre 0 e 310 (coordenada x)
	ecall
	li t1,231
	remu t3,a0,t1 # t3 recebe um numero aleatorio entre 0 e 230 (coordenada y)
	sw t2,0(a1)    # carrega na memoria t1(coordenada x), no vetor C
	addi a1,a1,4 # incrementa o endereco no vetor C
	sw t3,0(a1)
	addi a1,a1,4 # incrementa o endereco no vetor C
	lw a0,0(sp) # recupera a0(N) da memoria
	addi sp,sp,4 #  deslaca da pilha
	addi t0,t0,1 # incrementa o contador t0
	j FOR
ExitFor:
	jr ra     
	
	
