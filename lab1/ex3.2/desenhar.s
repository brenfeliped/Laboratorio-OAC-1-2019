
.include "macros2.s"
##############################
#Metodo DESENHA
#Dado um vetor de words contendo coordenadas(x,y) em C(a1) e o tamanho do vetor em N(a0)
#Ser� printado um grafo no BitmapDisplay com as Coordenadas em C
##############################
.data
N: .word 6
# Número de Casas/Clientes
C: .space 160
# Espaço em bytes correspondente a 2 coordenadas x 20 casas (máx) x 4 bytes,
.text
M_SetEcall(exceptionHandling)	# Macro de SetEcall - n�o tem ainda na DE1-SoC
la t0,N
lw a0,0(t0)
la a1,C
jal ra,SORTEIO
la a0,N
la a1,C
jal ra, DESENHA
li a7,10 # chamada de fim de programa 
ecall

SORTEIO:
  li t0,0 # contador t0
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

DESENHA:
  addi sp, sp, -4
  sw a0, 0(sp) # salvando os valores de N(a0) e C(a1) na pilha
  sw a1, 4(sp)
  jal PLOTFRAME #constroi o plano de fundo
  
  jal PLOTPOINT #desenha os v�rtices
  jal PLOTLINES #desenha os arcos
  
  addi sp, sp, 4 #limpa a pilha novamente
  
  jal FIM #encerra o programa
  
  
PLOTPOINT:
  lw s1, 4(sp) #recarregando posi�oes s1(C) e s0(N)
  lw t1, 0(sp)
  lw s0, 0(t1) #recarrega o tamanho do vetor
  li a4, 0 # a4 
  li a3, 0x2000 # 0x20 = cor verde do quadrado 0x00 = cor preta da letra
  li a1, 0 #limpa o registrador a1
  li a7, 111 #mostra na tela o frame com o vertice inserido
  addi a0, zero, 64 # carregando 64 em a0
  
FORPLOTPOINT:
  addi a0, a0, 1 # incrementando n+64
  
  lw a1, 0(s1) # posicao x de onde o char vai ser mostrado
  lw a2, 4(s1) # posicao y de onde o char vai ser mostrado
  
  M_Ecall #chamada para o plot do v�rtice
  
  addi s0, s0, -1 # para cada itera��o decrementa-se -2 das s0(N) tuplas
  addi s1, s1, 8 #incrementa a posicao da proxima tupla, palavra(word) de s1
  bne zero, s0, FORPLOTPOINT #condicao de parada quando s0 for 0, ou seja, quando todos os vertices estiverem plotados
  ret #retorna ao chamador

PLOTLINES:
  lw s1, 4(sp) #recarregando posi�oes s1(C) e s0(N)
  lw t1, 0(sp)
  lw s0, 0(t1) #recarrega o tamanho do vetor
  
PLOTARCO:
  lw a0,0(s1) #carregando parametros
  lw a1,4(s1)
  lw a2,8(s1)
  lw a3,12(s1)
  li a4, 0x0000 #cor do arco preto
  li a5, 0 #frame 0
  
  jal BRESENHAM #chama o m�todo para desenhar arcos
  
  addi s1, s1, 8 #pr�ximas tuplas
  addi s0, s0, -4
  bge s0, zero, PLOTARCO #enquanto s0 >= 0 ent�o volta a plotar arcos
  
  la s1, C #recarregando posi�oes s1(C)
  lw a0,0(s1) #pega a primeira tupla(x,y)=(a0,a1)
  lw a1,4(s1)
  
  jal BRESENHAM #printa um arco do primero ate o ultimo vertice
  
  ret #retorna ao chamador

PLOTFRAME:
  li a0,0xFF000000  # endereco inicial da Memoria VGA
  li a1,0xFF012C00  # endereco final
  li a2,0xFFFFFFFF  #cor do plano de fundo
PLOT:    
  sw a2, 0(a0) #escreve a cor na mem�ria
  addi a0, a0, 4 #incrementa 4 ao endere�o
  bne a0,a1,PLOT #Se n�o for o �ltimo endere�o ent�o continua o loop
  ret #caso contr�rio retorna para o chamador
  
FIM:
  li a7, 10 #encerra a execu��o do algoritmo
  M_Ecall
  
.include "SYSTEMv13.s"
