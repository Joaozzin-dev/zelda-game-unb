#########################################################
# Universidade de Brasília
# The Legend of Samara - Arquivo Principal
# 
# zelda-game-unb/
# ├── art/
# ├── assets/
# ├── audio/
# │   └── music.s           ← Sistema de música
# ├── src/
# │   ├── core/
# │   │   ├── collision.s   ← Sistema de colisão
# │   │   ├── constants.s   ← Constantes
# │   │   ├── data.s        ← Dados do jogo
# │   │   ├── game_loop.s   ← Loop principal
# │   │   └── input.asm     ← Sistema de entrada
# │   ├── engine/
# │   │   ├── draw.asm      ← Sistema de desenho
# │   │   ├── hud.asm       ← Interface (HUD)
# │   │   └── print.s       ← Função de impressão
# │   ├── gameplay/
# │   │   ├── rival.asm     ← Lógica dos inimigos
# │   │   └── samara.asm    ← Lógica do jogador
# │   └── guide/
# ├── sprites/
# │   └── main.asm          ← Arquivo principal
# └── fpgrars-x86_64-pc-windows-gnu.exe
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

# ============ CONFIGURAÇÕES ============
.include "core/constants.s"
.include "core/data.s"

# ============ NÚCLEO DO JOGO ============
.include "core/game_loop.s"
.include "core/input.asm"
.include "core/collision.s"

# ============ ENGINE GRÁFICA ============
.include "engine/draw.asm"
.include "engine/hud.asm"
.include "engine/print.s"

# ============ GAMEPLAY ============
.include "gameplay/samara.asm"      # Jogador
.include "gameplay/rival.asm"       # Inimigos

# ============ ÁUDIO ============
.include "audio/music.s"

# ============ ASSETS (SPRITES) ============
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"

#########################################################
# FIM DO ARQUIVO PRINCIPAL
#########################################################