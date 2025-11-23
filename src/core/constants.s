#########################################################
# CONSTANTS.S - Constantes e Configurações do Jogo
# 
# Este arquivo contém todas as constantes usadas no jogo,
# incluindo configurações de gameplay e limites de tela.
#########################################################

# ============ CONFIGURAÇÕES DE SISTEMA ============
# Taxa de atualização do jogo (60 FPS)
.eqv FRAME_RATE 60

# ============ DIMENSÕES DA TELA ============
# Largura e altura da área de jogo em pixels
.eqv SCREEN_WIDTH 320
.eqv SCREEN_HEIGHT 240

# Tamanho dos sprites (16x16 pixels)
.eqv SPRITE_SIZE 16

# ============ LIMITES DE MOVIMENTO ============
# Área jogável (evita que entidades saiam da tela)
.eqv MIN_X 8
.eqv MAX_X 296
.eqv MIN_Y 8
.eqv MAX_Y 216

# ============ CONFIGURAÇÕES DE GAMEPLAY ============
# Velocidade inicial do jogador (pixels por frame)
.eqv INITIAL_PLAYER_SPEED 4

# Velocidade melhorada (após pegar baú azul)
.eqv BOOSTED_PLAYER_SPEED 8

# Vidas iniciais do jogador
.eqv INITIAL_LIVES 3

# Frames de invulnerabilidade após levar dano
.eqv INVULNERABILITY_FRAMES 60

# ============ CONFIGURAÇÕES DE INIMIGOS ============
# Delay entre movimentos dos inimigos (em frames)
# Quanto maior, mais lento os inimigos se movem
.eqv ENEMY_DELAY_VAL 3

# Velocidade dos inimigos (pixels por movimento)
.eqv ENEMY_SPEED 4

# ============ CONFIGURAÇÕES DE COLISÃO ============
# Tamanho da hitbox (área de colisão) das entidades
.eqv HITBOX_SIZE 14

# ============ POSIÇÕES DO HUD ============
# Posições X para desenhar os corações de vida
.eqv HUD_LIFE1_X 10
.eqv HUD_LIFE2_X 28
.eqv HUD_LIFE3_X 46
.eqv HUD_LIFE_Y 10
.eqv HUD_SPACING 18

# ============ ENDEREÇOS DE MEMÓRIA ============
# Endereço base do bitmap display (frame 0)
.eqv VRAM_BASE_0 0xFF000000

# Endereço base do bitmap display (frame 1)
.eqv VRAM_BASE_1 0xFF100000

# Endereço do registrador de seleção de frame
.eqv VRAM_FRAME_SELECT 0xFF200604

# Endereço do registrador de input do teclado
.eqv KEYBOARD_CONTROL 0xFF200000
.eqv KEYBOARD_DATA 0xFF200004

# ============ CÓDIGOS DE TECLAS ============
# Teclas de movimento
.eqv KEY_W 'w'
.eqv KEY_S 's'
.eqv KEY_A 'a'
.eqv KEY_D 'd'

# Teclas de menu
.eqv KEY_RESTART 'r'
.eqv KEY_QUIT 'q'

# ============ VALORES ESPECIAIS ============
# Valor para indicar item coletado (0 = já foi coletado)
.eqv ITEM_COLLECTED 0
.eqv ITEM_AVAILABLE 1