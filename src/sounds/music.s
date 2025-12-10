.data
# Cabeçalho: [0]Total Notas, [1]Nota Atual, [2]Tempo Última Nota
music_state: .word 80, 0, 0 

# Dados da Música (Nota, Duração, Instrumento)
music_notes:
    # === INTRODUÇÃO (0s - 13s) ===
    # Solo de "Toy Piano" (Instrumento 11)
    # Padrão: Lá - Dó - Si - Sol
    57, 350, 11,   # Lá (A3)
    60, 350, 11,   # Dó (C4)
    59, 350, 11,   # Si (B3)
    55, 350, 11,   # Sol (G3)
    
    57, 350, 11,   # Lá
    60, 350, 11,   # Dó
    59, 350, 11,   # Si
    55, 350, 11,   # Sol
    
    57, 350, 11,   # Lá
    60, 350, 11,   # Dó
    59, 350, 11,   # Si
    55, 350, 11,   # Sol
    
    57, 350, 11,   # Lá
    60, 350, 11,   # Dó
    59, 350, 11,   # Si
    55, 350, 11,   # Sol

    # === TEMA A - A ORQUESTRA ENTRA (13s - 26s) ===
    # Melodia no Acordeão (Instrumento 21)
    76, 450, 21,   # Mi (E5)
    74, 225, 21,   # Ré (D5)
    72, 225, 21,   # Dó (C5)
    74, 450, 21,   # Ré (D5)
    
    76, 450, 21,   # Mi (E5)
    74, 225, 21,   # Ré (D5)
    72, 225, 21,   # Dó (C5)
    71, 900, 21,   # Si (B4) - Nota Longa
    
    74, 450, 21,   # Ré (D5)
    72, 225, 21,   # Dó (C5)
    71, 225, 21,   # Si (B4)
    72, 450, 21,   # Dó (C5)
    
    74, 450, 21,   # Ré (D5)
    72, 225, 21,   # Dó (C5)
    71, 225, 21,   # Si (B4)
    69, 900, 21,   # Lá (A4) - Fim da primeira frase

    # === TEMA A - REPETIÇÃO ENCORPADA (26s - 40s) ===
    # Cordas/Órgão (Instrumento 19 ou 40 para violino)
    76, 450, 19,   # Mi
    74, 225, 19,   # Ré
    72, 225, 19,   # Dó
    74, 450, 19,   # Ré
    
    76, 450, 19,   # Mi
    74, 225, 19,   # Ré
    72, 225, 19,   # Dó
    71, 900, 19,   # Si
    
    74, 450, 19,   # Ré
    72, 225, 19,   # Dó
    71, 225, 19,   # Si
    72, 450, 19,   # Dó
    
    74, 450, 19,   # Ré
    72, 225, 19,   # Dó
    71, 225, 19,   # Si
    69, 900, 19,   # Lá - Final dos 40s
    
    0, 0, 0        # Fim

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