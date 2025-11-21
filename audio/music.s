#########################################################
# MUSIC.S - Sistema de Música do Jogo
# 
# Este arquivo gerencia a reprodução de música de fundo.
# A música toca em loop contínuo durante o jogo.
#
# FUNCIONAMENTO:
# - Array de notas com: [nota MIDI, duração, instrumento]
# - Sistema non-blocking: verifica se é hora de tocar próxima nota
# - Loop automático quando chega ao fim da música
#########################################################

.data

# ============ DADOS DA MÚSICA ============

# Estrutura: [total_notas, nota_atual, timestamp_ultima_nota, notas...]
# Cada nota: [midi_pitch, duração_ms, instrumento]

MUSIC_DATA:
.word 140, 0, 0  # Total de notas, índice atual, timestamp

# ===== Seção 1 - Introdução =====
.word 60, 800, 4    # Dó 
.word 62, 700, 4    # Ré
.word 64, 800, 4    # Mi
.word 62, 600, 4    # Ré
.word 60, 900, 4    # Dó
.word 57, 700, 4    # Lá 

# ===== Seção 2 - Tema Principal =====
.word 64, 700, 4    # Mi
.word 65, 600, 4    # Fá
.word 67, 800, 4    # Sol
.word 65, 600, 4    # Fá
.word 64, 700, 4    # Mi
.word 62, 900, 4    # Ré

# ===== Seção 3 - Desenvolvimento =====
.word 60, 800, 4    # Dó
.word 62, 600, 4    # Ré
.word 64, 700, 4    # Mi
.word 67, 800, 4    # Sol
.word 65, 700, 4    # Fá
.word 64, 900, 4    # Mi

# ===== Seção 4 - Arpejo Descendente =====
.word 69, 900, 89   # Lá
.word 67, 700, 89   # Sol
.word 65, 800, 89   # Fá
.word 64, 700, 89   # Mi
.word 62, 900, 89   # Ré
.word 60, 800, 89   # Dó

# ===== Seção 5 - Variação Rápida =====
.word 64, 700, 25   # Mi
.word 67, 600, 25   # Sol
.word 69, 800, 25   # Lá
.word 67, 600, 25   # Sol
.word 65, 700, 25   # Fá
.word 64, 900, 25   # Mi

# ===== Seção 6 - Sequência Central =====
.word 67, 800, 4    # Sol
.word 69, 700, 4    # Lá
.word 67, 800, 4    # Sol
.word 65, 600, 4    # Fá
.word 64, 700, 4    # Mi
.word 62, 900, 4    # Ré

# ===== Seção 7 - Clímax =====
.word 72, 900, 80   # Dó alto
.word 71, 700, 80   # Si
.word 69, 800, 80   # Lá
.word 67, 700, 80   # Sol
.word 69, 900, 80   # Lá
.word 67, 800, 80   # Sol

# ===== Seção 8 - Transição =====
.word 65, 700, 4    # Fá
.word 67, 600, 4    # Sol
.word 69, 800, 4    # Lá
.word 71, 700, 4    # Si
.word 69, 600, 4    # Lá
.word 67, 900, 4    # Sol

# ===== Seção 9 - Melodia Ascendente =====
.word 64, 900, 89   # Mi
.word 65, 800, 89   # Fá
.word 67, 900, 89   # Sol
.word 69, 800, 89   # Lá
.word 67, 700, 89   # Sol
.word 65, 1000, 89  # Fá

# ===== Seção 10 - Ponte =====
.word 62, 700, 4    # Ré 
.word 64, 600, 25   # Mi 
.word 65, 800, 4    # Fá 
.word 67, 700, 25   # Sol 
.word 65, 600, 4    # Fá 
.word 64, 900, 25   # Mi 

# ===== Seção 11 - Sequência Alta =====
.word 74, 900, 80   # Ré alto
.word 72, 700, 80   # Dó
.word 71, 800, 80   # Si
.word 69, 700, 80   # Lá
.word 71, 900, 80   # Si
.word 69, 800, 80   # Lá

# ===== Seção 12 - Descida =====
.word 67, 700, 4    # Sol
.word 65, 600, 4    # Fá
.word 64, 800, 4    # Mi
.word 65, 700, 4    # Fá
.word 67, 600, 4    # Sol
.word 69, 900, 4    # Lá

# ===== Seção 13 - Variação Final =====
.word 67, 800, 25   # Sol
.word 69, 700, 25   # Lá
.word 71, 800, 4    # Si 
.word 69, 600, 25   # Lá 
.word 67, 700, 4    # Sol
.word 65, 900, 25   # Fá

# ===== Seção 14 - Grande Arpejo =====
.word 76, 900, 89   # Mi alto
.word 74, 800, 80   # Ré 
.word 72, 900, 89   # Dó 
.word 71, 700, 80   # Si 
.word 69, 800, 89   # Lá
.word 67, 1000, 80  # Sol 

# ===== Seção 15 - Preparação Final =====
.word 65, 700, 4    # Fá
.word 64, 800, 4    # Mi
.word 62, 700, 4    # Ré
.word 64, 600, 4    # Mi
.word 62, 800, 4    # Ré
.word 60, 900, 4    # Dó

# ===== Seção 16 - Penúltima Frase =====
.word 64, 800, 4    # Mi
.word 65, 700, 89   # Fá 
.word 67, 900, 4    # Sol
.word 65, 700, 89   # Fá 
.word 64, 800, 4    # Mi
.word 62, 1000, 89  # Ré 

# ===== Seção 17 - Resolução Final =====
.word 60, 900, 4    # Dó
.word 62, 800, 4    # Ré
.word 64, 900, 4    # Mi
.word 62, 700, 4    # Ré
.word 60, 1100, 4   # Dó 
.word 57, 1300, 4   # Lá 

.text

#########################################################
# INIT_MUSIC - Inicializa o sistema de música
# 
# Reseta o índice da nota atual e o timestamp.
# Deve ser chamado no SETUP do jogo.
#########################################################
INIT_MUSIC:
    la t0, MUSIC_DATA
    sw zero, 4(t0)     # Reseta índice da nota atual
    sw zero, 8(t0)     # Reseta timestamp
    ret

#########################################################
# UPDATE_MUSIC - Atualiza a música (chamar todo frame)
# 
# FUNCIONAMENTO:
# 1. Verifica quanto tempo passou desde última nota
# 2. Se passou tempo suficiente, toca próxima nota
# 3. Se chegou ao fim, recomeça do início (loop)
# 
# Esta função é non-blocking: executa rapidamente
# e não trava o jogo.
#########################################################
UPDATE_MUSIC:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Carregar dados da música
    la s0, MUSIC_DATA
    lw s1, 0(s0)      # s1 = total de notas
    lw s2, 4(s0)      # s2 = índice da nota atual
    lw s3, 8(s0)      # s3 = timestamp da última nota
    
    # Calcular endereço da nota atual
    # Cada nota ocupa 12 bytes (3 words)
    li t0, 12
    mul s4, t0, s2
    add s4, s4, s0
    
    # Obter tempo atual
    li a7, 30
    ecall
    
    # Calcular tempo decorrido desde última nota
    sub s5, a0, s3
    
    # Obter duração da nota atual
    lw t1, 4(s4)
    
    # Se ainda não passou tempo suficiente, sair
    bgtu t1, s5, END_UPDATE_MUSIC
    
    # ===== Hora de tocar a próxima nota =====
    
    # Verificar se chegou ao fim da música
    bne s2, s1, PLAY_NEXT_NOTE
    
    # Se chegou ao fim, voltar ao início
    li s2, 0
    mv s4, s0
    
    PLAY_NEXT_NOTE:
    # Avançar para próxima nota
    addi s4, s4, 12
    
    # Tocar a nota usando MIDI syscall
    li a7, 31
    lw a0, 0(s4)      # a0 = pitch (nota MIDI)
    lw a1, 4(s4)      # a1 = duração em ms
    lw a2, 8(s4)      # a2 = instrumento
    li a3, 60         # a3 = volume
    ecall
    
    # Atualizar timestamp
    li a7, 30
    ecall
    sw a0, 8(s0)
    
    # Atualizar índice da nota
    addi s2, s2, 1
    sw s2, 4(s0)
    
    END_UPDATE_MUSIC:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# STOP_MUSIC - Para a música (opcional)
# 
# Pode ser usado para silenciar a música em momentos
# específicos (como tela de game over).
#########################################################
STOP_MUSIC:
    # Resetar índice para parar de tocar
    la t0, MUSIC_DATA
    li t1, -1
    sw t1, 4(t0)
    ret