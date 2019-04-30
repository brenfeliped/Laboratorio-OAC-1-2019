
.include "macros2.s"

.data
C: .word 10,10, 10,20, 5,30
N: .word 6

.text

M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC

TEST:
  la a0, C
  la a1, N

DESENHA:
  addi s0, a0, 0 # salvando os valores de N(a0) e C(a1)
  addi s1, a1, 0
  jal PLOTFRAME #constroi o plano de fundo
  li a4, 0
  li a3, 0x20202020 # cor verde do quadrado
  li a0, 0 #limpa os registradores a0 e a1
  li a1, 0
  
  jal LOOP
  jal FIM
  
  
LOOP:
  addi s0, s0, -1 # para cada iteração decrementa-se -1 de s0(N)
  addi a0, s0, 64 # incrementa n+64 no char a ser mostrado
  
  lw a1, 0(s1) # posicao x de onde o char vai ser mostrado
  lw a2, 4(s1) # posicao y de onde o char vai ser mostrado
  
  li a7, 111 #mostra na tela o frame com o vertice inserido
  M_Ecall
  
  addi s1, s1, 8 #incrementa a posicao da proxima palavra(word) de s1
  bne zero, s0, LOOP #condicao de parada quando s0 for 0, ou seja, quando todos os vertices estiverem plotados
  ret #retorna ao chamador
  
PLOTFRAME:
  li a0,0xFF000000  # endereco inicial da Memoria VGA
  li a1,0xFF012C00  # endereco final
  li a2,0xFFFFFFFF  #cor do plano de fundo
PLOT:    
  sw a2, 0(a0) #escreve a cor na memória
  addi a0, a0, 4 #incrementa 4 ao endereço
  bne a0,a1,PLOT #Se não for o último endereço então continua o loop
  ret #caso contrário retorna para o chamador
  
FIM:
  li a7, 10 #encerra a execução do algoritmo
  M_Ecall
  
.include "SYSTEMv13.s"