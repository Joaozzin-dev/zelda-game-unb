# ==========================================
# TOCAR SOM DE COLETA (ACORDE MÁGICO)
# ==========================================
TOCAR_SOM_COLETA:
    # Configuração Geral
    li a2, 9        # Instrumento: 9 = Glockenspiel (Mais brilhante que a Celesta)
    li a3, 127      # Volume: Máximo
    li a7, 31       # Syscall MIDI Async

    # Nota 1: Mi (Base)
    li a0, 76       # Pitch: E5
    li a1, 400      # Duração: 400ms
    ecall

    # Nota 2: Sol Sustenido (Dá o tom "Feliz")
    li a0, 80       # Pitch: G#5
    ecall

    # Nota 3: Si (Completa o acorde agudo)
    li a0, 83       # Pitch: B5
    ecall

    ret

# ==========================================
# SOM DE ATAQUE (FLAUTA VARIÁVEL)
# Entrada: a0 = Índice do tiro (0, 1 ou 2)
# ==========================================
TOCAR_SOM_FLAUTA:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # 1. Descobre qual nota tocar baseada no índice
    la t0, NOTAS_FLAUTA
    add t0, t0, a0      # Endereço base + índice (0, 1 ou 2)
    lb a0, 0(t0)        # Carrega a nota (72, 76 ou 79) em a0
    
    # 2. Toca a nota
    li a7, 31       # Syscall MIDI Out
    # a0 já está com a nota correta
    li a1, 150      # Duração (ms)
    li a2, 73       # Instrumento (73 = Flauta)
    li a3, 127      # Volume (Máximo)
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret