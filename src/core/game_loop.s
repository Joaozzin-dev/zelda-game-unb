#########################################################
# GAME_LOOP.S - Loop Principal do Jogo
# 
# Este é o coração do jogo. Executa continuamente e:
# 1. Controla FPS (60 frames por segundo)
# 2. Limpa sprites anteriores
# 3. Processa lógica do jogo
# 4. Renderiza novos sprites
# 5. Troca de frame (double buffering)
#########################################################

.text

#########################################################
# GAME_LOOP - Loop principal infinito
# 
# ESTRUTURA DO LOOP:
# ┌─────────────────────────────────┐
# │ 1. Controle de FPS              │
# │ 2. Limpeza do frame anterior    │
# │ 3. Lógica do jogo               │
# │ 4. Renderização                 │
# │ 5. Atualização de histórico     │
# │ 6. Troca de frame               │
# └─────────────────────────────────┘
#
# VARIÁVEL GLOBAL:
# s0 = frame atual (0 ou 1) - alterna a cada ciclo
#########################################################
GAME_LOOP:
    # ===== 1. CONTROLE DE FPS =====
    # Garante que o jogo rode a 60 FPS
    
    li a7, 30              # Syscall: obter tempo atual
    ecall
    
    la t0, RUN_TIME        # Carregar endereço do timer
    lw t1, 0(t0)           # t1 = tempo do último frame
    
    sub t1, a0, t1         # t1 = tempo decorrido
    li t2, FRAME_RATE      # t2 = 60 (ms por frame)
    
    # Se ainda não passou tempo suficiente, aguardar
    blt t1, t2, GAME_LOOP
    
    # Atualizar timestamp do último frame
    sw a0, 0(t0)
    
    # ===== 2. LIMPEZA DO FRAME ANTERIOR =====
    # Remove sprites desenhados no frame anterior
    # usando double buffering
    
    bnez s0, LIMPA_FRAME_1
    
    LIMPA_FRAME_0:
        # Limpar posições antigas no frame 0
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
        # Limpar posições antigas no frame 1
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
    
    # Processar entrada do jogador
    call INPUT_CHECK
    
    # Atualizar música de fundo
    call UPDATE_MUSIC
    
    # Mover inimigos (usa timer independente)
    call UPDATE_ENEMIES
    
    # Verificar colisões e aplicar dano
    call CHECK_COLLISIONS
    
    # Verificar Game Over
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, TELA_GAME_OVER

    # ===== 4. RENDERIZAÇÃO =====
    # Desenhar todos os elementos na tela
    
    call DRAW_ALL          # Desenha entidades e itens
    call DRAW_HUD_LIVES    # Desenha interface (vidas)

    # ===== 5. ATUALIZAÇÃO DE HISTÓRICO =====
    # Salvar posições atuais para limpeza no próximo frame
    
    bnez s0, ATUALIZA_HIST_F1
    call UPDATE_HISTORY_F0
    j TROCA_FRAME
    
    ATUALIZA_HIST_F1:
    call UPDATE_HISTORY_F1

    # ===== 6. TROCA DE FRAME =====
    # Alternar entre frame 0 e 1 (double buffering)
    
    TROCA_FRAME:
        li t0, VRAM_FRAME_SELECT
        sw s0, 0(t0)       # Selecionar frame atual
        xori s0, s0, 1     # Alternar: 0 → 1, 1 → 0
        
    # Repetir o loop infinitamente
    j GAME_LOOP

#########################################################
# TELA_GAME_OVER - Exibida quando o jogador perde
# 
# Aguarda entrada do jogador:
# - 'r': Reiniciar jogo
# - 'q': Sair do jogo
#########################################################
TELA_GAME_OVER:
    # Para a música
    call STOP_MUSIC
    
    # Desenhar tela de game over em ambos os frames
    li s0, 0
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN
    
    li s0, 1
    la a0, Game_Over_Menu
    call PRINT_FULL_SCREEN

    # ===== Loop de espera por input =====
    WAIT_INPUT_GO:
        li t1, KEYBOARD_CONTROL
        lw t0, 0(t1)
        andi t0, t0, 1
        beqz t0, WAIT_INPUT_GO  # Se não há input, continuar esperando
        
        lw t2, 4(t1)            # Ler tecla pressionada
        
        # Verificar qual tecla foi pressionada
        li t0, KEY_RESTART
        beq t2, t0, SETUP       # 'r' = reiniciar
        
        li t0, KEY_QUIT
        beq t2, t0, FIM_DO_JOGO # 'q' = sair
        
        j WAIT_INPUT_GO         # Tecla inválida, continuar esperando

#########################################################
# FIM_DO_JOGO - Encerra o programa
#########################################################
FIM_DO_JOGO:
    li a7, 10
    ecall

#########################################################
# RESET_GAME_STATE - Reseta todas as variáveis do jogo
# 
# Chamado no início e ao reiniciar após game over.
#########################################################
RESET_GAME_STATE:
    # Resetar vidas
    la t0, VIDAS
    li t1, INITIAL_LIVES
    sw t1, 0(t0)
    
    # Resetar velocidade do jogador
    la t0, PLAYER_SPEED
    li t1, INITIAL_PLAYER_SPEED
    sw t1, 0(t0)
    
    # Resetar invulnerabilidade
    la t0, INVULNERAVEL
    sw zero, 0(t0)
    
    # Resetar timer de inimigos
    la t0, ENEMY_TIMER
    sw zero, 0(t0)
    
    # Resetar baús (torná-los disponíveis novamente)
    la t0, CHEST_B_DATA
    li t1, ITEM_AVAILABLE
    sh t1, 4(t0)
    
    la t0, CHEST_Y_DATA
    li t1, ITEM_AVAILABLE
    sh t1, 4(t0)
    
    ret

#########################################################
# CLEAR_BOTH_SCREENS - Limpa ambos os frames
# 
# Desenha o mapa de fundo em frame 0 e frame 1.
#########################################################
CLEAR_BOTH_SCREENS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Limpar frame 0
    li s0, 0
    call LIMPAR_TELA_TOTAL
    
    # Limpar frame 1
    li s0, 1
    call LIMPAR_TELA_TOTAL
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# LIMPAR_TELA_TOTAL - Desenha o mapa de fundo
# 
# Input: s0 = frame (0 ou 1)
#########################################################
LIMPAR_TELA_TOTAL:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    la a0, map             # Sprite do mapa
    li a1, 0               # X = 0
    li a2, 0               # Y = 0
    mv a3, s0              # Frame atual
    call PRINT
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# RESET_GAME_TIMER - Inicializa o timer do jogo
#########################################################
RESET_GAME_TIMER:
    li a7, 30
    ecall
    la t0, RUN_TIME
    sw a0, 0(t0)
    ret

#########################################################
# PRINT_FULL_SCREEN - Desenha imagem em tela cheia
# 
# Inputs:
# a0 = endereço da imagem
# s0 = frame (0 ou 1)
#########################################################
PRINT_FULL_SCREEN:
    # Calcular endereço base do frame
    li t0, 0xFF0
    add t0, t0, s0
    slli t0, t0, 20
    
    addi t1, a0, 8         # Pular header da imagem
    li t2, 0               # Contador
    li t3, 76800           # Total de pixels (320*240)
    
    LOOP_FULL:
        lw t4, 0(t1)
        sw t4, 0(t0)
        addi t0, t0, 4
        addi t1, t1, 4
        addi t2, t2, 1
        blt t2, t3, LOOP_FULL
    ret