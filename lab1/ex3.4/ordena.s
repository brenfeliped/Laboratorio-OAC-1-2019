
.include "macros2.s"
##############################
#Metodo DESENHA
#Dado um vetor de words contendo coordenadas(x,y) em C(a1) e o tamanho do vetor em N(a0)
#Ser� printado um grafo no BitmapDisplay com as Coordenadas em C
##############################
.data
N: .word 3
# Número de Casas/Clientes
C: .space 160
D: .space 1600
space: .string " "
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
la a0,N
la a1,C
jal ra,ROTAS
la a0,N
la a1,D
jal ra,MATRIZ
la a0,N
la a1,C
la a2,D
jal ra,ORDENA
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
  addi sp, sp, -12
  sw a0, 0(sp) # salvando os valores de N(a0) e C(a1) na pilha
  sw a1, 4(sp)
  sw ra  8(sp)
  jal PLOTFRAME #constroi o plano de fundo
  
  jal PLOTPOINT #desenha os v�rtices
  
  lw ra, 8(sp)
  addi sp,sp,12
  ret  #encerra o programa
  
  
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


PLOTFRAME:
  li a0,0xFF000000  # endereco inicial da Memoria VGA
  li a1,0xFF012C00  # endereco final
  li a2,0xFFFFFFFF  #cor do plano de fundo
PLOT:    
  sw a2, 0(a0) #escreve a cor na mem�ria
  addi a0, a0, 4 #incrementa 4 ao endere�o
  bne a0,a1,PLOT #Se n�o for o �ltimo endere�o ent�o continua o loop
  ret #caso contr�rio retorna para o chamador
  
ROTAS: # a0=N a1=c[]
  li s5,0 # contador i
  mv tp,a1 # tp = C[]
  lw a0, 0(a0)
  addi sp,sp,-4
  la s7,D
  sw  ra,0(sp)
  for1:  beq s5,a0,exitfor1
    # abaixo codigo da matriz
    mul s8,s5,a0 # s8= i*N (inicio do calculo da  posicao da matriz)
    add s8,s5,s8 # s8= j +(i*N)
    slli s8,s8,2 # s8 = (j +(i*N))*4 (fim do calculo da posicao da matriz)
    add s8,s8,s7 # s8 = *D[i][i]
    fcvt.s.w ft0,zero  # ft0 = float(0)
    fsw ft0, 0(s8) # carrega 0 na D[i][i], ou seja a distancia de  D[i][i] para D[i][i] = 0 
    # fim codigo da matriz
    lw s1, 0(tp) # s1 = x1
    lw s2, 4(tp) # s2 = y1
    addi tp,tp,8 # posina tp no inicio da proxima coordenada(x,y)
    addi sp,sp,-4
    sw tp,0(sp)
    addi s6,s5,1 # contador j = i+1
    for2:  beq s6,a0,exitfor2
      lw s3, 0(tp) # s3= x2
      lw s4, 4(tp) # s4 = y2
      # abaixo codigo da matriz
      mul s8,s5,a0 # s8= i*N (inicio do calculo da  posicao da matriz)
      add s8,s6,s8 # s8= j +(i*N)
      slli s8,s8,2 # s8 = (j +(i*N))*4) (fim do calculo da posicao da matriz)
      add s8,s8,s7 # s8 = *D[i][j]
      sub s9,s3,s1 # s9 = x2-x1 (calculo distancia euclidiana)
      mul s9,s9,s9 # s9 = (x2-x1)**2
      sub s10,s4,s2 # s10 = y2 - y1
      mul s10,s10,s10 # s10= (y2- y1)**2
      add s11,s9,s10 # s10 = (x2-x1)**2 + (y2- y1)**2
      fcvt.s.w ft0,s11 # ft0 = float(s10)
      fsqrt.s fa0,ft0 #  ft0 = sqrt((x2-x1)**2 + (y2- y1)**2)
      fsw fa0,0(s8)
      mul s8,s6,a0 # s8= j*N (inicio do calculo da  posicao da matriz)
      add s8,s5,s8 # s8= i +(j*N)
      slli s8,s8,2 # s8 = (j +(i*N))*4) (fim do calculo da posicao da matriz)
      add s8,s8,s7 # s8 = *D[i][j]
      fsw fa0, 0(s8)
      # fim codigo da matriz
      addi sp,sp,-4
      sw a0,0(sp)
      mv a0,s1   # carregando paramentros para BRESENHAM
      mv a1,s2
      mv a2,s3
      mv a3,s4
      li a4,0x0000 # cor preta
      li a5,0 # seleciona a frame 0
      jal BRESENHAM
      lw a0,0(sp)
      addi sp,sp,4
      addi s6,s6,1 # j++
      addi tp,tp,8 # direciona para proxima coordenada (x,y)
      j for2
    exitfor2:
      lw tp, 0(sp) # recupera tp
      addi sp,sp,4
      addi s5,s5,1 #  i++
      j for1
  exitfor1:
    lw ra, 0(sp)
    addi sp,sp,4
    ret
MATRIZ: # a0=N e a1=D
  lw a0,0(a0)
  mul a0,a0,a0 # a0 = N*N
  li t0,0
  forM: beq t0,a0,exitforM
    flw fa0,0(a1)
    li a7,2
    ecall
    addi sp,sp,-4
    sw a0,0(sp)
    la a0,space
    li a7,4
    ecall
    lw a0,0(sp)
    addi sp,sp,4
    addi a1,a1,4
    addi t0,t0,1
    j forM
  exitforM:
    ret
    
ORDENA:
  lw t0, 0(a0)
  lw t1, 0(a1)
  lw t2, 0(a2)
  addi sp, sp, -4
  sw ra, 0(sp)
  jal PERMUTATION
  lw ra, 0(sp)
  addi sp, sp,4
  
  ret

PERMUTATION: #recebe um vetor a0, o tamanho a1, a2, e retorna um vetor a0 ordenado
  li s0,1
  beq a1, s0, PRINTARRAY
  add s2, a1, zero #i=tamanho
LOOPPERMUT:
  addi s1, a1, -1
  jal PERMUTATION
  addi t1, zero, 2
  rem t1,s1,t1
  add t2, a0, zero
  lw a0, 0(t2)
  beq t1, s0, SWAP
  jal SWAP
  addi s2, s2, -1
  bne s2, zero, LOOPPERMUT
  ret
  
PRINTARRAY:
  add t0, zero, a0
  add t1, zero, a1
PRTLOOP:
  addi a0, 0(t0)
  addi t0, t0, 4
  addi t1, t1, -1
  bne t1,zero,PRINTLOOP
  ret

SWAP:

FIM:
  li a7, 10 #encerra a execu��o do algoritmo
  M_Ecall
  
.include "SYSTEMv13.s"
