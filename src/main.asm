#########################################################
# Universidade de Brasília
# The legend of Samara - VERSÃO FINAL (Zero Semicolons + Sem Música)
#########################################################

.data

# ============ CONFIGURAÇÕES ============
.eqv frame_rate 60

# ============ ESTADO DO JOGO ============
RUN_TIME:     .word 0
VIDAS:        .word 3
INVULNERAVEL: .word 0
PLAYER_SPEED: .word 4

# Timer para inimigos (Independente)
ENEMY_TIMER:  .word 0
ENEMY_DELAY:  .word 3   # A cada 3 frames o inimigo move (Ajuste para velocidade)

# ============ ITENS (BAÚS) ============
CHEST_B_DATA: .half 280, 40, 1   # Azul
CHEST_Y_DATA: .half 32, 200, 1   # Amarelo

# ============ ENTIDADES ============
# Jogador
PLYR_POS:   .half 160,120
PLYR_F0:    .half 160,120
PLYR_F1:    .half 160,120

# Slime 1 (Diagonal)
S1_POS:     .half 240,60
S1_F0:      .half 240,60
S1_F1:      .half 240,60
S1_DIR_X:   .word -4
S1_DIR_Y:   .word 4

# Slime 2 (Reto)
S2_POS:     .half 200,100
S2_F0:      .half 200,100
S2_F1:      .half 200,100
S2_DIR:     .word 4

# Slime 3 (L-Shape)
S3_POS:     .half 80,140
S3_F0:      .half 80,140
S3_F1:      .half 80,140
S3_STATE:   .word 0
S3_COUNT:   .word 0
S3_DIR_X:   .word 4
S3_DIR_Y:   .word 4

# ============ MAPA DE COLISÃO ============
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

.text

#########################################################
# SETUP
#########################################################
SETUP:
    # Resetar Vidas
    la t0, VIDAS
    li t1, 3
    sw t1, 0(t0)
    
    # Resetar Velocidade
    la t0, PLAYER_SPEED
    li t1, 4
    sw t1, 0(t0)
    
    # Resetar Timer Inimigo
    la t0, ENEMY_TIMER
    sw zero, 0(t0)

    # Limpar telas
    li s0, 0
    call LIMPAR_TELA_TOTAL
    li s0, 1
    call LIMPAR_TELA_TOTAL
    
    # Resetar Frame e Tempo
    li s0, 0
    li a7, 30
    ecall
    la t0, RUN_TIME
    sw a0, 0(t0)
    
    j GAME_LOOP

LIMPAR_TELA_TOTAL:
    la a0, map
    li a1, 0
    li a2, 0
    mv a3, s0
    j PRINT

#########################################################
# GAME LOOP
#########################################################
GAME_LOOP:
    # FPS Control
    li a7, 30
    ecall
    la t0, RUN_TIME
    lw t1, 0(t0)
    sub t1, a0, t1
    li t2, frame_rate
    blt t1, t2, GAME_LOOP
    sw a0, 0(t0)
    
    # --- 1. LIMPEZA DO FRAME ATUAL ---
    bnez s0, LIMPA_FRAME_1
    
    LIMPA_FRAME_0:
        la a0, PLYR_F0
        call RESTORE_BG
        la a0, S1_F0
        call RESTORE_BG
        la a0, S2_F0
        call RESTORE_BG
        la a0, S3_F0
        call RESTORE_BG
        j LOGICA_JOGO
        
    LIMPA_FRAME_1:
        la a0, PLYR_F1
        call RESTORE_BG
        la a0, S1_F1
        call RESTORE_BG
        la a0, S2_F1
        call RESTORE_BG
        la a0, S3_F1
        call RESTORE_BG

    LOGICA_JOGO:
    # --- 2. LÓGICA ---
    
    # Player Move
    call INPUT_CHECK
    
    # Inimigos Movem (Timer Independente)
    call UPDATE_ENEMIES
    
    # Colisão e Dano
    call CHECK_COLLISIONS
    
    # Game Over Check
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, TELA_GAME_OVER

    # --- 3. RENDERIZAÇÃO ---
    call DRAW_ALL
    call DRAW_HUD_LIVES

    # --- 4. ATUALIZAR HISTÓRICO ---
    bnez s0, ATUALIZA_HIST_F1
    call UPDATE_HISTORY_F0
    j TROCA_FRAME
    
    ATUALIZA_HIST_F1:
    call UPDATE_HISTORY_F1

    TROCA_FRAME:
        li t0, 0xFF200604
        sw s0, 0(t0)
        xori s0, s0, 1
    j GAME_LOOP

#########################################################
# TELA DE GAME OVER
#########################################################
TELA_GAME_OVER:
    li s0, 0
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN
    li s0, 1
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN

    WAIT_INPUT_GO:
        li t1, 0xFF200000
        lw t0, 0(t1)
        andi t0, t0, 1
        beqz t0, WAIT_INPUT_GO
        lw t2, 4(t1)
        
        li t0, 'r'
        beq t2, t0, SETUP
        li t0, 'q'
        beq t2, t0, FIM_DO_JOGO
        j WAIT_INPUT_GO

FIM_DO_JOGO:
    li a7, 10
    ecall

PRINT_FULL_SCREEN:
    li t0, 0xFF0
    add t0, t0, s0
    slli t0, t0, 20
    addi t1, a0, 8
    li t2, 0       
    li t3, 76800   
    LOOP_FULL:
        lw t4, 0(t1)
        sw t4, 0(t0)
        addi t0, t0, 4
        addi t1, t1, 4
        addi t2, t2, 1
        blt t2, t3, LOOP_FULL
    ret

#########################################################
# FUNÇÕES GRÁFICAS
#########################################################

DRAW_ALL:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Baús
    la t0, CHEST_B_DATA
    lh t1, 4(t0)
    beqz t1, CHECK_CHEST_Y
    la a0, CHEST_B_DATA
    la a3, ChestB
    call DRAW_POS
    
    CHECK_CHEST_Y:
    la t0, CHEST_Y_DATA
    lh t1, 4(t0)
    beqz t1, DRAW_ENTITIES
    la a0, CHEST_Y_DATA
    la a3, ChestY
    call DRAW_POS

    DRAW_ENTITIES:
    # Player
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    andi t1, t1, 4
    bnez t1, SKIP_PLAYER
    la a0, PLYR_POS
    la a3, char
    call DRAW_POS
    SKIP_PLAYER:

    # Slimes
    la a0, S1_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    la a0, S2_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    la a0, S3_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

RESTORE_BG:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile
    mv a3, s0
    call PRINT
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

DRAW_POS:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    mv a0, a3
    mv a3, s0
    call PRINT
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

DRAW_HUD_LIVES:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Limpa fundo do HUD
    la a0, tile
    li a1, 10
    li a2, 10
    mv a3, s0
    call PRINT
    li a1, 28
    li a2, 10
    mv a3, s0
    call PRINT
    li a1, 46
    li a2, 10
    mv a3, s0
    call PRINT
    
    # Desenha Chaves
    la t0, VIDAS
    lw t0, 0(t0)
    li a1, 10
    li a2, 10
    mv a3, s0
    la a0, KeyB
    
    LOOP_LIVES:
        blez t0, END_DRAW_LIVES
        addi sp, sp, -12
        sw a1, 0(sp)
        sw a2, 4(sp)
        sw t0, 8(sp)
        
        call PRINT
        
        lw a1, 0(sp)
        lw a2, 4(sp)
        lw t0, 8(sp)
        addi sp, sp, 12
        
        addi a1, a1, 18
        addi t0, t0, -1
        j LOOP_LIVES

    END_DRAW_LIVES:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# ATUALIZAÇÃO HISTÓRICO
#########################################################
UPDATE_HISTORY_F0:
    la t0, PLYR_POS
    lw t1, 0(t0)
    la t2, PLYR_F0
    sw t1, 0(t2)
    la t0, S1_POS
    lw t1, 0(t0)
    la t2, S1_F0
    sw t1, 0(t2)
    la t0, S2_POS
    lw t1, 0(t0)
    la t2, S2_F0
    sw t1, 0(t2)
    la t0, S3_POS
    lw t1, 0(t0)
    la t2, S3_F0
    sw t1, 0(t2)
    ret

UPDATE_HISTORY_F1:
    la t0, PLYR_POS
    lw t1, 0(t0)
    la t2, PLYR_F1
    sw t1, 0(t2)
    la t0, S1_POS
    lw t1, 0(t0)
    la t2, S1_F1
    sw t1, 0(t2)
    la t0, S2_POS
    lw t1, 0(t0)
    la t2, S2_F1
    sw t1, 0(t2)
    la t0, S3_POS
    lw t1, 0(t0)
    la t2, S3_F1
    sw t1, 0(t2)
    ret

#########################################################
# COLISÃO E ITENS
#########################################################
CHECK_COLLISIONS:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Itens
    la a0, PLYR_POS
    la a1, CHEST_B_DATA
    call AABB_CHECK
    bnez a0, GET_CHEST_B
    
    la a0, PLYR_POS
    la a1, CHEST_Y_DATA
    call AABB_CHECK
    bnez a0, GET_CHEST_Y
    j CHECK_DMG

    GET_CHEST_B:
        la t0, CHEST_B_DATA
        lh t1, 4(t0)
        beqz t1, CHECK_DMG
        li t1, 0
        sh t1, 4(t0)
        la a0, CHEST_B_DATA
        call CLEAR_ITEM_BG
        la t0, PLAYER_SPEED
        li t1, 8
        sw t1, 0(t0)
        j CHECK_DMG

    GET_CHEST_Y:
        la t0, CHEST_Y_DATA
        lh t1, 4(t0)
        beqz t1, CHECK_DMG
        li t1, 0
        sh t1, 4(t0)
        la a0, CHEST_Y_DATA
        call CLEAR_ITEM_BG
        la t0, VIDAS
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)

    # Dano
    CHECK_DMG:
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    blez t1, DO_C
    addi t1, t1, -1
    sw t1, 0(t0)
    j END_COL

    DO_C:
    la a0, PLYR_POS
    la a1, S1_POS
    call AABB_CHECK
    bnez a0, HIT
    la a0, PLYR_POS
    la a1, S2_POS
    call AABB_CHECK
    bnez a0, HIT
    la a0, PLYR_POS
    la a1, S3_POS
    call AABB_CHECK
    bnez a0, HIT
    j END_COL

    HIT:
    la t0, VIDAS
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)
    la t0, INVULNERAVEL
    li t1, 60
    sw t1, 0(t0)

    END_COL:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

CLEAR_ITEM_BG:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

AABB_CHECK:
    lh t0, 0(a0)
    lh t1, 2(a0)
    lh t2, 0(a1)
    lh t3, 2(a1)
    li t4, 14
    
    add t5, t2, t4
    bge t0, t5, NO_HIT
    add t5, t0, t4
    ble t5, t2, NO_HIT
    add t5, t3, t4
    bge t1, t5, NO_HIT
    add t5, t1, t4
    ble t5, t3, NO_HIT
    li a0, 1
    ret
    NO_HIT: 
    li a0, 0
    ret

#########################################################
# INPUT E MOVIMENTOS
#########################################################
INPUT_CHECK:
    li t1, 0xFF200000
    lw t0, 0(t1)
    andi t0, t0, 1
    beqz t0, RET_INPUT
    lw t2, 4(t1)
    la t0, PLAYER_SPEED
    lw t3, 0(t0)
    
    li t0, 'w'
    beq t2, t0, DO_W
    li t0, 's'
    beq t2, t0, DO_S
    li t0, 'a'
    beq t2, t0, DO_A
    li t0, 'd'
    beq t2, t0, DO_D
    j RET_INPUT

    DO_W: 
        la t0, PLYR_POS
        lh t1, 2(t0)
        sub t1, t1, t3
        li t5, 8
        blt t1, t5, RET_INPUT
        sh t1, 2(t0)
        j RET_INPUT
    DO_S: 
        la t0, PLYR_POS
        lh t1, 2(t0)
        add t1, t1, t3
        li t5, 216
        bgt t1, t5, RET_INPUT
        sh t1, 2(t0)
        j RET_INPUT
    DO_A: 
        la t0, PLYR_POS
        lh t1, 0(t0)
        sub t1, t1, t3
        li t5, 8
        blt t1, t5, RET_INPUT
        sh t1, 0(t0)
        j RET_INPUT
    DO_D: 
        la t0, PLYR_POS
        lh t1, 0(t0)
        add t1, t1, t3
        li t5, 296
        bgt t1, t5, RET_INPUT
        sh t1, 0(t0)
        j RET_INPUT
    
    RET_INPUT:
    ret

# ATUALIZAÇÃO DE INIMIGOS (INDEPENDENTE)
UPDATE_ENEMIES:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Timer
    la t0, ENEMY_TIMER
    lw t1, 0(t0)
    addi t1, t1, 1
    la t2, ENEMY_DELAY
    lw t2, 0(t2)
    bge t1, t2, DO_MOVE
    
    sw t1, 0(t0)
    j END_UPDATE_ENEMIES
    
    DO_MOVE:
    sw zero, 0(t0)
    
    call MOVE_S3_LOGIC
    call MOVE_S2_LOGIC
    call MOVE_S1_LOGIC
    
    END_UPDATE_ENEMIES:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# SLIME 3 (L-SHAPE)
MOVE_S3_LOGIC:
    la a0, S3_POS
    la a1, S3_STATE
    la a2, S3_COUNT
    lw t0, 0(a1)
    lw t1, 0(a2)
    la t6, S3_DIR_X 
    la t5, S3_DIR_Y
    
    bnez t0, S3_MOVE_Y
    
    S3_MOVE_X:
        lw t3, 0(t6) # Vel X
        lh t4, 0(a0)
        add t4, t4, t3
        
        li t2, 296
        bge t4, t2, S3_HIT_X
        li t2, 8
        blt t4, t2, S3_HIT_X
        
        sh t4, 0(a0)
        addi t1, t1, 1
        li t2, 30
        blt t1, t2, S3_SAVE
        # Troca Eixo
        li t1, 0
        li t0, 1
        j S3_SAVE_STATE
        
        S3_HIT_X: 
        sub t3, zero, t3
        sw t3, 0(t6)
        li t1, 0
        li t0, 1
        j S3_SAVE_STATE

    S3_MOVE_Y:
        lw t3, 0(t5) # Vel Y
        lh t4, 2(a0)
        add t4, t4, t3
        
        li t2, 216
        bge t4, t2, S3_HIT_Y
        li t2, 8
        blt t4, t2, S3_HIT_Y
        
        sh t4, 2(a0)
        addi t1, t1, 1
        li t2, 30
        blt t1, t2, S3_SAVE
        # Troca Eixo
        li t1, 0
        li t0, 0
        j S3_SAVE_STATE

        S3_HIT_Y:
        sub t3, zero, t3
        sw t3, 0(t5)
        li t1, 0
        li t0, 0
        j S3_SAVE_STATE

    S3_SAVE_STATE: 
    sw t0, 0(a1)
    S3_SAVE: 
    sw t1, 0(a2)
    ret

# SLIME 2 (Horizontal)
MOVE_S2_LOGIC:
    la a0, S2_POS
    la a1, S2_DIR
    lh t0, 0(a0)
    lw t2, 0(a1)
    add t0, t0, t2
    li t3, 296
    bge t0, t3, INV_S2
    li t3, 8
    blt t0, t3, INV_S2
    sh t0, 0(a0)
    ret
    INV_S2: 
    sub t2, zero, t2
    sw t2, 0(a1)
    add t0, t0, t2
    add t0, t0, t2
    sh t0, 0(a0)
    ret

# SLIME 1 (Diagonal)
MOVE_S1_LOGIC:
    la a0, S1_POS
    la a1, S1_DIR_X
    la a2, S1_DIR_Y
    lh t0, 0(a0)
    lh t1, 2(a0)
    lw t2, 0(a1)
    lw t3, 0(a2)
    add t0, t0, t2
    add t1, t1, t3
    
    li t4, 296
    bge t0, t4, INV_S1_X
    li t4, 8
    blt t0, t4, INV_S1_X
    j CHECK_S1_Y
    INV_S1_X: 
    sub t2, zero, t2
    sw t2, 0(a1)
    add t0, t0, t2
    add t0, t0, t2
    
    CHECK_S1_Y:
    li t4, 216
    bge t1, t4, INV_S1_Y
    li t4, 8
    blt t1, t4, INV_S1_Y
    j SAVE_S1
    INV_S1_Y: 
    sub t3, zero, t3
    sw t3, 0(a2)
    add t1, t1, t3
    add t1, t1, t3
    
    SAVE_S1:
    sh t0, 0(a0)
    sh t1, 2(a0)
    ret

#########################################################
# PRINT
#########################################################
PRINT:
    li t0, 0xFF0
    add t0, t0, a3
    slli t0, t0, 20
    add t0, t0, a1
    li t1, 320
    mul t1, t1, a2
    add t0, t0, t1
    addi t1, a0, 8
    mv t2, zero
    mv t3, zero
    lw t4, 0(a0)
    lw t5, 4(a0)
PRINT_LOOP:
    lw t6, 0(t1)
    sw t6, 0(t0)
    addi t0, t0, 4
    addi t1, t1, 4
    addi t3, t3, 4
    blt t3, t4, PRINT_LOOP
    addi t0, t0, 320
    sub t0, t0, t4
    mv t3, zero
    addi t2, t2, 1
    bgt t5, t2, PRINT_LOOP
    ret

# INCLUDES
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"