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

#########################################################
# SOM DE "FALHA" / GAME OVER
# Efeito: Sequência rápida descendente (Power Down)
#########################################################
SOM_EFEITO_FALHA:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a7, 31       # Syscall MIDI (Async)
    li a2, 0        # Instrumento 0: Acoustic Grand Piano
    li a3, 127      # Volume Máximo

    # --- Parte 1: A Queda (Notas descendo) ---
    
    # Nota 1: Sol (G3)
    li a0, 55       
    li a1, 150      # Duração curta
    ecall
    
    # Pequeno delay
    li a7, 32
    li a0, 120
    ecall

    # Nota 2: Mi bemol (Eb3) - Tom menor (triste)
    li a7, 31
    li a0, 51       
    li a1, 150
    ecall

    li a7, 32
    li a0, 120
    ecall

    # Nota 3: Dó (C3)
    li a7, 31
    li a0, 48       
    li a1, 150
    ecall

    li a7, 32
    li a0, 200      # Pausa dramática antes do impacto final
    ecall

    # --- Parte 2: O "Slam" (Acorde de Erro) ---
    # Tocamos 3 notas graves e vizinhas AO MESMO TEMPO.
    # Isso cria o som de "Bater no piano".
    
    li a7, 31       # MIDI Async
    li a1, 1000     # Duração longa (sustain do piano)

    # Nota Grave 1: Si (B2)
    li a0, 47       
    ecall

    # Nota Grave 2: Dó (C3) - (B e C juntos criam dissonância forte)
    li a0, 48       
    ecall
    
    # Nota Grave 3: Fá Sustenido (F#2) - (O intervalo do "trítono", som de perigo)
    li a0, 42       
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

SOM_DANO:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a7, 31       
    li a2, 81       # Instrumento: Lead 2 (Sawtooth) - Som eletrônico
    li a3, 127
    li a1, 60       # Muito rápido

    # Faz uma descida rápida de tom (Pitch slide fake)
    li a0, 65       # Começa agudo
    ecall
    
    li a0, 55       # Termina grave
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

    #########################################################
# SOM DE PASSOS REALISTA ("TUMP" SECO)
#########################################################
TOCAR_SOM_PASSO:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # 1. Controle de Tempo (A cada 15 frames)
    la t0, PASSO_TIMER
    lw t1, 0(t0)
    addi t1, t1, 1      
    li t2, 5           
    blt t1, t2, SAI_SOM_PASSO  
    
    sw zero, 0(t0)      # Reseta timer
    
    # 2. Configuração do Som
    li a7, 31           # Syscall MIDI
    
    # O TRUQUE ESTÁ AQUI:
    li a2, 117          # Instrumento: Melodic Tom (Soa como um "tump" abafado)
                        # Alternativa se não gostar: 118 (Synth Drum)
    
    li a3, 50          # Volume Máximo
    li a1, 40           # Duração MUITO CURTA (40ms) pra ser seco
    
    li a0, 41           # Nota Grave (Fá grave) - Dá o peso do corpo
    ecall

    SAI_SOM_PASSO:
    sw t1, 0(t0)        
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

    