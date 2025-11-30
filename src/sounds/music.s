.data
# Cabeçalho: [0]Total Notas, [1]Nota Atual, [2]Tempo Última Nota
music_state: .word 80, 0, 0 

# Dados da Música (Nota, Duração, Instrumento)
music_notes:
#seção 1
60, 800, 4,    # Dó 
62, 700, 4,    # Ré
64, 800, 4,    # Mi
62, 600, 4,    # Ré
60, 900, 4,    # Dó
57, 700, 4,    # Lá 

#seção 2
64, 700, 4,    # Mi
65, 600, 4,    # Fá
67, 800, 4,    # Sol
65, 600, 4,    # Fá
64, 700, 4,    # Mi
62, 900, 4,    # Ré

#seção 3
60, 800, 4,    # Dó
62, 600, 4,    # Ré
64, 700, 4,    # Mi
67, 800, 4,    # Sol
65, 700, 4,    # Fá
64, 900, 4,    # Mi

#seção 4
69, 900, 89,   # Lá
67, 700, 89,   # Sol
65, 800, 89,   # Fá
64, 700, 89,   # Mi
62, 900, 89,   # Ré
60, 800, 89,   # Dó

#seção 5
64, 700, 25,   # Mi
67, 600, 25,   # Sol
69, 800, 25,   # Lá
67, 600, 25,   # Sol
65, 700, 25,   # Fá
64, 900, 25,   # Mi

#seção 6
67, 800, 4,    # Sol
69, 700, 4,    # Lá
67, 800, 4,    # Sol
65, 600, 4,    # Fá
64, 700, 4,    # Mi
62, 900, 4,    # Ré

#seção 7
72, 900, 80,   # Dó alto
71, 700, 80,   # Si
69, 800, 80,   # Lá
67, 700, 80,   # Sol
69, 900, 80,   # Lá
67, 800, 80,   # Sol

#seção 8
65, 700, 4,    # Fá
67, 600, 4,    # Sol
69, 800, 4,    # Lá
71, 700, 4,    # Si
69, 600, 4,    # Lá
67, 900, 4,    # Sol

#seção 9
64, 900, 89,   # Mi
65, 800, 89,   # Fá
67, 900, 89,   # Sol
69, 800, 89,   # Lá
67, 700, 89,   # Sol
65, 1000, 89,  # Fá

#seção 10
62, 700, 4,    # Ré 
64, 600, 25,   # Mi 
65, 800, 4,    # Fá 
67, 700, 25,   # Sol 
65, 600, 4,    # Fá 
64, 900, 25,   # Mi 

#seção 11
74, 900, 80,   # Ré 
72, 700, 80,   # Dó
71, 800, 80,   # Si
69, 700, 80,   # Lá
71, 900, 80,   # Si
69, 800, 80,   # Lá

#seção 12
67, 700, 4,    # Sol
65, 600, 4,    # Fá
64, 800, 4,    # Mi
65, 700, 4,    # Fá
67, 600, 4,    # Sol
69, 900, 4,    # Lá

#seção 13
67, 800, 25,   # Sol
69, 700, 25,   # Lá
71, 800, 4,    # Si 
69, 600, 25,   # Lá 
67, 700, 4,    # Sol
65, 900, 25,   # Fá

#seção 14
76, 900, 89,   # Mi 
74, 800, 80,   # Ré 
72, 900, 89,   # Dó 
71, 700, 80,   # Si 
69, 800, 89,   # Lá
67, 1000, 80,  # Sol 

#seção 15
65, 700, 4,    # Fá
64, 800, 4,    # Mi
62, 700, 4,    # Ré
64, 600, 4,    # Mi
62, 800, 4,    # Ré
60, 900, 4,    # Dó

#seção 16
64, 800, 4,    # Mi
65, 700, 89,   # Fá 
67, 900, 4,    # Sol
65, 700, 89,   # Fá 
64, 800, 4,    # Mi
62, 1000, 89,  # Ré 

#seção 17
60, 900, 4,    # Dó
62, 800, 4,    # Ré
64, 900, 4,    # Mi
62, 700, 4,    # Ré
60, 1100, 4,   # Dó 
57, 1300, 4,   # Lá 

.text
# ==========================================
# FUNÇÃO: TOCAR_MUSICA (LOOP INFINITO 102 NOTAS)
# ==========================================
TOCAR_MUSICA:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, music_state
    lw t1, 0(t0)        # t1 = Total de notas (102)
    lw t2, 4(t0)        # t2 = Índice atual
    lw t3, 8(t0)        # t3 = Tempo da última nota tocada

    # 1. Pega Tempo Atual
    li a7, 30
    ecall
    mv t5, a0           # t5 = Tempo Agora

    # Se t3 = 0 (jogo começou agora), toca a primeira nota imediatamente
    beqz t3, TOCAR_AGORA

    # 2. Verifica Duração da nota anterior
    sub t6, t5, t3      # Tempo passado desde a última nota
    
    # Calcula endereço da nota ATUAL para usar sua duração como "delay"
    li t4, 12
    mul t4, t2, t4
    la a1, music_notes
    add a1, a1, t4
    lw t4, 4(a1)        # Carrega a duração da nota atual
    
    # Se ainda não passou o tempo da nota, sai da função
    blt t6, t4, SAIR_MUSICA  

    # 3. Avança para a próxima nota
    addi t2, t2, 1      # Incrementa índice
    
    # 4. Verifica Loop (REINICIO)
    # Se índice >= Total (102), volta para 0
    bge t2, t1, REINICIAR
    
    # Salva o novo índice normal
    sw t2, 4(t0)
    j TOCAR_AGORA

    REINICIAR:
    li t2, 0            # Zera índice
    sw t2, 4(t0)        # Salva 0 na memória
    # Segue direto para tocar a nota 0

    TOCAR_AGORA:
    # Recalcula endereço com o índice novo (ou resetado)
    li t4, 12
    mul t4, t2, t4
    la a1, music_notes
    add a1, a1, t4

    # Toca a nota
    li a7, 31
    lw a0, 0(a1)        # Nota
    lw a1, 4(a1)        # Duração
    lw a2, 8(a1)        # Instrumento
    li a3, 100          # Volume
    ecall

    # Atualiza o tempo "última vez tocada" para AGORA
    li a7, 30
    ecall
    sw a0, 8(t0)

    SAIR_MUSICA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret