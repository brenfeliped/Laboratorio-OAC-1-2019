
.include "macros2.s"

.data
C: .word 10,10,10,20,5,30 # array de tuplas onde cada tupla representa uma posição na tela
N: .word 6 #tamanho do array

.text

M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC

TEST: #teste de verificação do plot na tela
  la a0, N #carrega o endereço de N em a0
  la a1, C #carrega o endereço de C em a1

DESENHA:
  lw s0, 0(a0) # salvando os valores de N(a0) e C(a1)
  addi s1, a1, 0
  jal PLOTFRAME #constroi o plano de fundo
  li a4, 0 # a4 
  li a3, 0x2000 # 0x20 = cor verde do quadrado 0x00 = cor preta da letra
  li a0, 0 #limpa os registradores a0 e a1
  li a1, 0
  li a7, 111 #mostra na tela o frame com o vertice inserido
  addi a0, zero, 64 # carregando 64 em a0
  
  jal PLOTPOINT
  jal FIM
  
  
PLOTPOINT:
  addi a0, a0, 1 # incrementando n+64
  
  lw a1, 0(s1) # posicao x de onde o char vai ser mostrado
  lw a2, 4(s1) # posicao y de onde o char vai ser mostrado
  
  M_Ecall #chamada para o plot do vértice
  
  addi s0, s0, -2 # para cada iteração decrementa-se -2 das s0(N) tuplas
  addi s1, s1, 8 #incrementa a posicao da proxima tupla, palavra(word) de s1
  bne zero, s0, PLOTPOINT #condicao de parada quando s0 for 0, ou seja, quando todos os vertices estiverem plotados
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
