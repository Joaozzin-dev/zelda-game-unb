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