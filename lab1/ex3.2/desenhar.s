
.include "macros2.s"

##############################
#Metodo DESENHA
#Dado um vetor de words contendo coordenadas(x,y) em C(a1) e o tamanho do vetor em N(a0)
#Será printado um grafo no BitmapDisplay com as Coordenadas em C
##############################

M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC

DESENHA:
  addi sp, sp, -4
  sw a0, 0(sp) # salvando os valores de N(a0) e C(a1) na pilha
  sw a1, 4(sp)
  jal PLOTFRAME #constroi o plano de fundo
  
  jal PLOTPOINT #desenha os vértices
  jal PLOTLINES #desenha os arcos
  
  addi sp, sp, 4 #limpa a pilha novamente
  
  jal FIM #encerra o programa
  
  
PLOTPOINT:
  lw s1, 4(sp) #recarregando posiçoes s1(C) e s0(N)
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
  
  M_Ecall #chamada para o plot do vértice
  
  addi s0, s0, -2 # para cada iteração decrementa-se -2 das s0(N) tuplas
  addi s1, s1, 8 #incrementa a posicao da proxima tupla, palavra(word) de s1
  bne zero, s0, FORPLOTPOINT #condicao de parada quando s0 for 0, ou seja, quando todos os vertices estiverem plotados
  ret #retorna ao chamador

PLOTLINES:
  lw s1, 4(sp) #recarregando posiçoes s1(C) e s0(N)
  lw t1, 0(sp)
  lw s0, 0(t1) #recarrega o tamanho do vetor
  
PLOTARCO:
  lw a0,0(s1) #carregando parametros
  lw a1,4(s1)
  lw a2,8(s1)
  lw a3,12(s1)
  li a4, 0x0000 #cor do arco preto
  li a5, 0 #frame 0
  
  jal BRESENHAM #chama o método para desenhar arcos
  
  addi s1, s1, 8 #próximas tuplas
  addi s0, s0, -4
  bge s0, zero, PLOTARCO #enquanto s0 >= 0 então volta a plotar arcos
  
  la s1, C #recarregando posiçoes s1(C)
  lw a0,0(s1) #pega a primeira tupla(x,y)=(a0,a1)
  lw a1,4(s1)
  
  jal BRESENHAM #printa um arco do primero ate o ultimo vertice
  
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
