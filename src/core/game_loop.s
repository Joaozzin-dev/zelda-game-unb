#########################################################
# GAME_LOOP.S - Loop Principal do Jogo
# 
# Adicionada proteção contra corrupção do registrador s0
#########################################################

.text

GAME_LOOP:
    # ===== 1. CONTROLE DE FPS =====
    li a7, 30              # Syscall: obter tempo
    ecall
    
    la t0, RUN_TIME        # Carregar timer
    lw t1, 0(t0)           # Tempo do frame anterior
    
    sub t1, a0, t1         # Diferença de tempo
    li t2, FRAME_RATE      # 60ms
    
    blt t1, t2, GAME_LOOP  # Esperar se muito rápido
    
    sw a0, 0(t0)           # Atualizar timer
    
    # ===== [PROTEÇÃO 1] =====
    # Garante que s0 seja 0 ou 1 antes de começar
    andi s0, s0, 1
    
    # ===== 2. LIMPEZA DO FRAME ANTERIOR =====
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

    # ===== 3. LÓGICA DO JOGO =====
    LOGICA_JOGO:
    
    call INPUT_CHECK       # Processar teclas (WASD)
    
    call UPDATE_MUSIC      # Tocar música
    
    # ===== [PROTEÇÃO 2 - CRÍTICA] =====
    # A música pode ter sujado o s0. Limpamos de novo.
    andi s0, s0, 1
    
    call UPDATE_ENEMIES    # Mover inimigos
    call CHECK_COLLISIONS  # Colisões
    
    # Verificar Game Over
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, TELA_GAME_OVER

    # ===== 4. RENDERIZAÇÃO =====
    call DRAW_ALL          # Desenha tudo
    call DRAW_HUD_LIVES    # Desenha vida

    # ===== 5. ATUALIZAÇÃO DE HISTÓRICO =====
    bnez s0, ATUALIZA_HIST_F1
    call UPDATE_HISTORY_F0
    j TROCA_FRAME
    
    ATUALIZA_HIST_F1:
    call UPDATE_HISTORY_F1

    # ===== 6. TROCA DE FRAME =====
    TROCA_FRAME:
        li t0, VRAM_FRAME_SELECT
        sw s0, 0(t0)       # Troca o buffer de vídeo
        xori s0, s0, 1     # Alterna frame (0 -> 1 -> 0)
        
    j GAME_LOOP

# --- Rotinas de Fim de Jogo ---

TELA_GAME_OVER:
    call STOP_MUSIC
    
    # Desenha tela final nos dois frames
    li s0, 0
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN
    li s0, 1
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN

    WAIT_INPUT_GO:
        li t1, KEYBOARD_CONTROL
        lw t0, 0(t1)
        andi t0, t0, 1
        beqz t0, WAIT_INPUT_GO
        lw t2, 4(t1)
        
        li t0, KEY_RESTART
        beq t2, t0, SETUP
        li t0, KEY_QUIT
        beq t2, t0, FIM_DO_JOGO
        j WAIT_INPUT_GO

FIM_DO_JOGO:
    li a7, 10
    ecall

RESET_GAME_STATE:
    la t0, VIDAS
    li t1, INITIAL_LIVES
    sw t1, 0(t0)
    la t0, PLAYER_SPEED
    li t1, INITIAL_PLAYER_SPEED
    sw t1, 0(t0)
    la t0, INVULNERAVEL
    sw zero, 0(t0)
    la t0, ENEMY_TIMER
    sw zero, 0(t0)
    la t0, CHEST_B_DATA
    li t1, ITEM_AVAILABLE
    sh t1, 4(t0)
    la t0, CHEST_Y_DATA
    li t1, ITEM_AVAILABLE
    sh t1, 4(t0)
    ret

CLEAR_BOTH_SCREENS:
    addi sp, sp, -4
    sw ra, 0(sp)
    li s0, 0
    call LIMPAR_TELA_TOTAL
    li s0, 1
    call LIMPAR_TELA_TOTAL
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

LIMPAR_TELA_TOTAL:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, map
    li a1, 0
    li a2, 0
    mv a3, s0
    call PRINT
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

RESET_GAME_TIMER:
    li a7, 30
    ecall
    la t0, RUN_TIME
    sw a0, 0(t0)
    ret

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