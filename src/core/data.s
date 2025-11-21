#########################################################
# DATA.S - Dados e Estado do Jogo
# 
# Este arquivo contém todas as variáveis de estado do jogo,
# incluindo posições de entidades, vidas, timers, etc.
#########################################################

.data

# ============ ESTADO GLOBAL DO JOGO ============

# Timer principal do jogo (usado para controle de FPS)
RUN_TIME: .word 0

# Número de vidas restantes do jogador
VIDAS: .word 3

# Contador de frames de invulnerabilidade
# Valor > 0 = jogador está invulnerável
INVULNERAVEL: .word 0

# Velocidade atual do jogador (pode mudar com power-ups)
PLAYER_SPEED: .word 4

# ============ TIMERS DE INIMIGOS ============

# Timer para controlar movimento dos inimigos
# Incrementa a cada frame, reseta quando atinge ENEMY_DELAY
ENEMY_TIMER: .word 0

# Delay entre movimentos (quantos frames esperar)
ENEMY_DELAY: .word 3

# ============ ITENS COLETÁVEIS (BAÚS) ============

# Baú Azul (Power-up de velocidade)
# Formato: X (2 bytes), Y (2 bytes), Disponível (2 bytes)
CHEST_B_DATA: .half 280, 40, 1

# Baú Amarelo (Vida extra)
# Formato: X (2 bytes), Y (2 bytes), Disponível (2 bytes)
CHEST_Y_DATA: .half 32, 200, 1

# ============ ENTIDADES - JOGADOR ============

# Posição atual do jogador
PLYR_POS: .half 160, 120

# Posição anterior no frame 0 (para limpeza)
PLYR_F0: .half 160, 120

# Posição anterior no frame 1 (para limpeza)
PLYR_F1: .half 160, 120

# ============ ENTIDADES - SLIME 1 (Movimento Diagonal) ============

# Posição atual
S1_POS: .half 240, 60

# Histórico de posições para double buffering
S1_F0: .half 240, 60
S1_F1: .half 240, 60

# Velocidade em X e Y (movimento diagonal)
S1_DIR_X: .word -4
S1_DIR_Y: .word 4

# ============ ENTIDADES - SLIME 2 (Movimento Horizontal) ============

# Posição atual
S2_POS: .half 200, 100

# Histórico de posições
S2_F0: .half 200, 100
S2_F1: .half 200, 100

# Direção do movimento (positivo = direita, negativo = esquerda)
S2_DIR: .word 4

# ============ ENTIDADES - SLIME 3 (Movimento em L) ============

# Posição atual
S3_POS: .half 80, 140

# Histórico de posições
S3_F0: .half 80, 140
S3_F1: .half 80, 140

# Estado do movimento (0 = movendo em X, 1 = movendo em Y)
S3_STATE: .word 0

# Contador de frames no eixo atual (troca de eixo após 30 frames)
S3_COUNT: .word 0

# Velocidades em X e Y
S3_DIR_X: .word 4
S3_DIR_Y: .word 4

# ============ MAPA DE COLISÃO ============
# 20x15 tiles (1 = parede, 0 = caminhável)
# Usado para detectar colisões com o cenário

LEVEL_HIT_MAP:
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1