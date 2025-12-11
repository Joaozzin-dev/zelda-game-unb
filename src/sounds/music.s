.data

# Cabeçalho: [0]Total Notas (80), [1]Índice Atual, [2]Timestamp Última Nota
music_state: .word 80, 0, 0 

# Dados: .word NOTA, DURAÇÃO(ms), INSTRUMENTO
# Stride (Tamanho do bloco) = 12 bytes (3 words)
music_notes:
    # === INTRODUÇÃO (Toy Piano - Inst 11) ===
    # Padrão A: Lá-Dó-Si-Sol
    .word 57, 350, 11   # Lá (A3)
    .word 60, 350, 11   # Dó (C4)
    .word 59, 350, 11   # Si (B3)
    .word 55, 350, 11   # Sol (G3)

    .word 57, 350, 11
    .word 60, 350, 11
    .word 59, 350, 11
    .word 55, 350, 11

    # Padrão B: Lá-Dó-Si-Mi (Variação do baixo)
    .word 57, 350, 11
    .word 60, 350, 11
    .word 59, 350, 11
    .word 52, 350, 11   # Mi (E3)

    .word 57, 350, 11
    .word 60, 350, 11
    .word 59, 350, 11
    .word 52, 350, 11

    # === TEMA PRINCIPAL (Acordeão - Inst 21) ===
    # Frase 1
    .word 76, 450, 21   # Mi (E5)
    .word 74, 225, 21   # Ré (D5)
    .word 72, 225, 21   # Dó (C5)
    .word 74, 450, 21   # Ré (D5)

    .word 76, 450, 21   # Mi
    .word 74, 225, 21   # Ré
    .word 72, 225, 21   # Dó
    .word 71, 900, 21   # Si (B4) - Longa

    # Frase 2
    .word 74, 450, 21   # Ré
    .word 72, 225, 21   # Dó
    .word 71, 225, 21   # Si
    .word 72, 450, 21   # Dó

    .word 74, 450, 21   # Ré
    .word 72, 225, 21   # Dó
    .word 71, 225, 21   # Si
    .word 69, 900, 21   # Lá (A4) - Longa

    # === REPETIÇÃO ORQUESTRAL (Violino/Strings - Inst 49) ===
    # A mesma melodia, mas uma oitava acima ou com outro timbre
    
    # Frase 1 (Strings)
    .word 76, 450, 49   # Mi
    .word 74, 225, 49   # Ré
    .word 72, 225, 49   # Dó
    .word 74, 450, 49   # Ré

    .word 76, 450, 49   # Mi
    .word 74, 225, 49   # Ré
    .word 72, 225, 49   # Dó
    .word 71, 900, 49   # Si

    # Frase 2 (Strings)
    .word 74, 450, 49   # Ré
    .word 72, 225, 49   # Dó
    .word 71, 225, 49   # Si
    .word 72, 450, 49   # Dó

    .word 74, 450, 49   # Ré
    .word 72, 225, 49   # Dó
    .word 71, 225, 49   # Si
    .word 69, 900, 49   # Lá

    # === PONTE / TRANSIÇÃO (Piano - Inst 0) ===
    .word 64, 225, 0    # Mi (E4)
    .word 68, 225, 0    # Sol# (G#4)
    .word 71, 225, 0    # Si (B4)
    .word 76, 450, 0    # Mi (E5)
    
    .word 64, 225, 0    # Mi
    .word 68, 225, 0    # Sol#
    .word 71, 225, 0    # Si
    .word 76, 450, 0    # Mi

    .word 62, 225, 0    # Ré (D4)
    .word 65, 225, 0    # Fá (F4)
    .word 69, 225, 0    # Lá (A4)
    .word 74, 450, 0    # Ré (D5)

    .word 62, 225, 0    # Ré
    .word 65, 225, 0    # Fá
    .word 69, 225, 0    # Lá
    .word 74, 450, 0    # Ré
# === PARTE C: TEMA AGUDO (Glockenspiel/Toy Piano - Inst 11 ou 9) ===
    # Esta é a parte icônica "tlim tlim" que toca uma oitava acima

    # Frase C1
    .word 88, 450, 11    # Mi (E6)
    .word 86, 225, 11    # Ré (D6)
    .word 84, 225, 11    # Dó (C6)
    .word 86, 450, 11    # Ré (D6)

    .word 88, 450, 11    # Mi (E6)
    .word 86, 225, 11    # Ré (D6)
    .word 84, 225, 11    # Dó (C6)
    .word 83, 900, 11    # Si (B5) - Longa

    # Frase C2
    .word 86, 450, 11    # Ré (D6)
    .word 84, 225, 11    # Dó (C6)
    .word 83, 225, 11    # Si (B5)
    .word 84, 450, 11    # Dó (C6)

    .word 86, 450, 11    # Ré (D6)
    .word 84, 225, 11    # Dó (C6)
    .word 83, 225, 11    # Si (B5)
    .word 81, 900, 11    # Lá (A5) - Longa

    # === PARTE D: CLÍMAX (Tutti / Acordeão Forte - Inst 21) ===
    # O ritmo fica mais rápido (colcheias constantes)

    # Subida Rápida 1 (Lá menor)
    .word 69, 225, 21    # Lá (A4)
    .word 71, 225, 21    # Si (B4)
    .word 72, 225, 21    # Dó (C5)
    .word 74, 225, 21    # Ré (D5)
    .word 76, 450, 21    # Mi (E5) Forte
    .word 69, 450, 21    # Lá (A4)

    # Variação Descendente
    .word 76, 225, 21    # Mi (E5)
    .word 74, 225, 21    # Ré (D5)
    .word 72, 225, 21    # Dó (C5)
    .word 71, 225, 21    # Si (B4)
    .word 69, 900, 21    # Lá (A4)

    # Subida Rápida 2 (Fá Maior)
    .word 65, 225, 21    # Fá (F4)
    .word 67, 225, 21    # Sol (G4)
    .word 69, 225, 21    # Lá (A4)
    .word 71, 225, 21    # Si (B4)
    .word 72, 450, 21    # Dó (C5) Forte
    .word 65, 450, 21    # Fá (F4)

    # Finalização da frase
    .word 72, 225, 21    # Dó (C5)
    .word 71, 225, 21    # Si (B4)
    .word 69, 225, 21    # Lá (A4)
    .word 68, 225, 21    # Sol# (G#4)
    .word 69, 900, 21    # Lá (A4) - Resolução

    # === PARTE E: PONTE DESCENDENTE (Piano/Harpsichord - Inst 0 ou 6) ===
    # Uma descida melódica rápida que percorre as harmonias de Am -> G -> F -> E

    # -- Sequência em Lá Menor (Am) --
    .word 76, 200, 0     # Mi (E5)
    .word 74, 200, 0     # Ré (D5)
    .word 72, 200, 0     # Dó (C5)
    .word 71, 200, 0     # Si (B4)
    
    .word 69, 200, 0     # Lá (A4)
    .word 71, 200, 0     # Si (B4)
    .word 72, 200, 0     # Dó (C5)
    .word 76, 400, 0     # Mi (E5) - Pausa breve

    # -- Sequência em Sol Maior (G) --
    .word 74, 200, 0     # Ré (D5)
    .word 72, 200, 0     # Dó (C5)
    .word 71, 200, 0     # Si (B4)
    .word 69, 200, 0     # Lá (A4)

    .word 67, 200, 0     # Sol (G4)
    .word 69, 200, 0     # Lá (A4)
    .word 71, 200, 0     # Si (B4)
    .word 74, 400, 0     # Ré (D5) - Pausa breve

    # -- Sequência em Fá Maior (F) --
    .word 72, 200, 0     # Dó (C5)
    .word 71, 200, 0     # Si (B4)
    .word 69, 200, 0     # Lá (A4)
    .word 67, 200, 0     # Sol (G4)

    .word 65, 200, 0     # Fá (F4)
    .word 67, 200, 0     # Sol (G4)
    .word 69, 200, 0     # Lá (A4)
    .word 72, 400, 0     # Dó (C5) - Pausa breve

    # -- Resolução em Mi Maior (E) - Preparação para o clímax --
    .word 71, 200, 0     # Si (B4)
    .word 69, 200, 0     # Lá (A4)
    .word 68, 200, 0     # Sol# (G#4) - Nota chave da escala harmônica
    .word 65, 200, 0     # Fá (F4)

    .word 64, 200, 0     # Mi (E4)
    .word 68, 200, 0     # Sol# (G#4)
    .word 71, 200, 0     # Si (B4)
    .word 76, 800, 0     #

    # === FINAL (Piano Suave - Inst 0) ===
    # Acorde final arpejado (Lá menor)
    .word 57, 400, 0     # Lá (A3)
    .word 60, 400, 0     # Dó (C4)
    .word 64, 400, 0     # Mi (E4)
    .word 69, 1500, 0    # Lá (A4) - Muito longa para terminar

    # Marcador de fim (como você já usava)
    .word -1, -1, -1
    .text
.text
# ==========================================
# FUNÇÃO: TOCAR_MUSICA (CORRIGIDA - SEM T7)
# ==========================================
TOCAR_MUSICA:
    addi sp, sp, -4
    sw ra, 0(sp)

    # 1. Carrega Estado
    la t0, music_state
    lw t2, 0(t0)        # t2 = Índice atual
    lw t3, 4(t0)        # t3 = Tempo da última nota

    # 2. Pega Tempo Atual
    li a7, 30
    ecall
    mv t5, a0           # t5 = Tempo Agora

    # Se t3 = 0 (primeira vez), toca direto
    beqz t3, VERIFICAR_REINICIO

    # 3. Calcula endereço da nota ATUAL
    la t1, music_notes
    li t4, 12
    mul t4, t2, t4
    add t1, t1, t4      # t1 aponta para a nota atual

    # --- VERIFICAÇÃO DE FIM (CORRIGIDA) ---
    lw t6, 0(t1)        # Carrega o valor da nota
    li a2, -1           # <--- USANDO a2 EM VEZ DE t7
    beq t6, a2, FORCAR_REINICIO_AGORA

    # Lê duração
    lw t6, 4(t1)        
    
    # Verifica tempo
    sub t4, t5, t3      # Delta = Agora - UltimaVez
    blt t4, t6, SAIR_MUSICA 

    # Avança índice
    addi t2, t2, 1      

    VERIFICAR_REINICIO:
    # Calcula endereço da NOVA nota
    la t1, music_notes
    li t4, 12
    mul t4, t2, t4
    add t1, t1, t4      

    # Verifica se a nova nota é o marcador (-1)
    lw a0, 0(t1)        
    li a2, -1           # <--- USANDO a2 EM VEZ DE t7
    bne a0, a2, TOCAR_AGORA 

    FORCAR_REINICIO_AGORA:
    li t2, 0
    la t1, music_notes
    # (Fall-through)

    TOCAR_AGORA:
    # Salva índice
    sw t2, 0(t0)

    # Toca a nota
    li a7, 31
    lw a0, 0(t1)        # Nota
    lw a1, 4(t1)        # Duração
    lw a2, 8(t1)        # Instrumento
    li a3, 100          # Volume
    ecall

    # Atualiza timestamp
    li a7, 30
    ecall
    sw a0, 4(t0)

    SAIR_MUSICA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret