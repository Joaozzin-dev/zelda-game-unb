#########################################################
# Universidade de Brasília
# The Legend of Samara - Arquivo Principal
# 
# ESTRUTURA DO PROJETO:
# main.s              - Loop principal e inicialização
# config/constants.s  - Constantes e configurações
# config/data.s       - Dados do jogo (vidas, posições, etc)
# core/game_loop.s    - Loop principal do jogo
# core/input.s        - Processamento de entrada
# core/collision.s    - Sistema de colisão
# graphics/draw.s     - Funções de desenho
# graphics/hud.s      - Interface (vidas, etc)
# entities/player.s   - Lógica do jogador
# entities/enemies.s  - Lógica dos inimigos
# audio/music.s       - Sistema de música
# utils/print.s       - Função básica de impressão
#########################################################

.data
# Placeholder para dados (importados de data.s)

.text
#########################################################
# PONTO DE ENTRADA DO PROGRAMA
#########################################################
main:
    # Inicializa o jogo
    jal SETUP
    
    # Inicia o loop principal
    jal GAME_LOOP
    
    # Finaliza (nunca deveria chegar aqui)
    li a7, 10
    ecall

#########################################################
# SETUP - Inicializa todos os sistemas do jogo
#########################################################
SETUP:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # 1. Resetar estado do jogo
    call RESET_GAME_STATE
    
    # 2. Limpar ambas as telas (frame 0 e 1)
    call CLEAR_BOTH_SCREENS
    
    # 3. Inicializar sistema de música
    call INIT_MUSIC
    
    # 4. Resetar timer do jogo
    call RESET_GAME_TIMER
    
    # 5. Inicializar frame atual (começa no frame 0)
    li s0, 0
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# IMPORTS - Incluir todos os módulos do jogo
#########################################################

# Configurações
.include "config/constants.s"
.include "config/data.s"

# Loop principal
.include "core/game_loop.s"
.include "core/input.s"
.include "core/collision.s"

# Gráficos
.include "graphics/draw.s"
.include "graphics/hud.s"

# Entidades
.include "entities/player.s"
.include "entities/enemies.s"

# Áudio
.include "audio/music.s"

# Utilitários
.include "utils/print.s"

# Sprites e Assets
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"