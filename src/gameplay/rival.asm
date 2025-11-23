#########################################################
# RIVAL.S - Sistema de Inimigos (Slimes)
# 
# Este módulo gerencia o comportamento de todos os inimigos:
# - Slime 1: Movimento diagonal (ricochete nas paredes)
# - Slime 2: Movimento horizontal (vai e volta)
# - Slime 3: Movimento em L (muda de eixo periodicamente)
#
# Cada inimigo tem IA independente e padrão de movimento único.
#########################################################

.text

#########################################################
# UPDATE_ENEMIES - Atualiza todos os inimigos
# 
# SISTEMA DE TIMER INDEPENDENTE:
# Os inimigos se movem em velocidade diferente do jogador.
# Um timer controla quando eles devem se mover.
#
# FUNCIONAMENTO:
# 1. Incrementa timer a cada frame
# 2. Quando timer atinge ENEMY_DELAY, move todos os inimigos
# 3. Reseta timer para 0
#
# Isso permite ajustar dificuldade mudando apenas ENEMY_DELAY:
# - ENEMY_DELAY = 1: Inimigos muito rápidos
# - ENEMY_DELAY = 3: Velocidade balanceada (padrão)
# - ENEMY_DELAY = 5: Inimigos mais lentos
#########################################################
UPDATE_ENEMIES:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # ===== 1. ATUALIZAR TIMER =====
    la t0, ENEMY_TIMER
    lw t1, 0(t0)                 # t1 = timer atual
    addi t1, t1, 1               # Incrementar timer
    
    # Verificar se é hora de mover
    li t2, 3                 # t2 = delay configurado (3)
    bge t1, t2, DO_MOVE          # Se timer >= delay, mover
    
    # Ainda não é hora, apenas salvar timer e retornar
    sw t1, 0(t0)
    j END_UPDATE_ENEMIES
    
    # ===== 2. MOVER TODOS OS INIMIGOS =====
    DO_MOVE:
    sw zero, 0(t0)               # Resetar timer
    
    # Mover cada inimigo em ordem
    # (ordem não importa, mas Slime 3 primeiro por ser mais complexo)
    call MOVE_S3_LOGIC
    call MOVE_S2_LOGIC
    call MOVE_S1_LOGIC
    
    END_UPDATE_ENEMIES:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# MOVE_S3_LOGIC - Slime 3 (Movimento em L)
# 
# PADRÃO DE MOVIMENTO:
# - Move em um eixo por 30 frames
# - Depois troca para o outro eixo por 30 frames
# - Repete infinitamente
# - Ricocheia nas paredes
#
# EXEMPLO:
# → → → → (30 frames) ↓
#                      ↓ ↓ ↓ (30 frames)
# ← ← ← ← (30 frames) ↓
#
# DADOS USADOS:
# - S3_POS: Posição atual (X, Y)
# - S3_STATE: Estado atual (0 = movimento X, 1 = movimento Y)
# - S3_COUNT: Contador de frames no eixo atual
# - S3_DIR_X: Velocidade em X (+4 ou -4)
# - S3_DIR_Y: Velocidade em Y (+4 ou -4)
#########################################################
MOVE_S3_LOGIC:
    # Carregar endereços dos dados
    la a0, S3_POS                # a0 = posição
    la a1, S3_STATE              # a1 = estado (X ou Y)
    la a2, S3_COUNT              # a2 = contador
    
    lw t0, 0(a1)                 # t0 = estado atual (0 ou 1)
    lw t1, 0(a2)                 # t1 = frames no eixo atual
    
    # Carregar velocidades
    la t6, S3_DIR_X 
    la t5, S3_DIR_Y
    
    # Verificar qual eixo está ativo
    bnez t0, S3_MOVE_Y

    # ===== MOVIMENTO EM X =====
    S3_MOVE_X:
        lw t3, 0(t6)             # t3 = velocidade X
        lh t4, 0(a0)             # t4 = posição X atual
        add t4, t4, t3           # t4 = nova posição X
        
        # Verificar colisão com parede direita
        li t2, MAX_X             # t2 = 296
        bge t4, t2, S3_HIT_X
        
        # Verificar colisão com parede esquerda
        li t2, MIN_X             # t2 = 8
        blt t4, t2, S3_HIT_X
        
        # Movimento válido, atualizar posição
        sh t4, 0(a0)
        
        # Incrementar contador
        addi t1, t1, 1
        
        # Verificar se completou 30 frames
        li t2, 30
        blt t1, t2, S3_SAVE      # Se < 30, continuar neste eixo
        
        # Completou 30 frames, trocar para eixo Y
        li t1, 0                 # Resetar contador
        li t0, 1                 # Estado = Y
        j S3_SAVE_STATE
        
        # Colidiu com parede, inverter direção E trocar eixo
        S3_HIT_X: 
        sub t3, zero, t3         # Inverter velocidade X
        sw t3, 0(t6)
        li t1, 0                 # Resetar contador
        li t0, 1                 # Trocar para eixo Y
        j S3_SAVE_STATE

    # ===== MOVIMENTO EM Y =====
    S3_MOVE_Y:
        lw t3, 0(t5)             # t3 = velocidade Y
        lh t4, 2(a0)             # t4 = posição Y atual
        add t4, t4, t3           # t4 = nova posição Y
        
        # Verificar colisão com parede inferior
        li t2, MAX_Y             # t2 = 216
        bge t4, t2, S3_HIT_Y
        
        # Verificar colisão com parede superior
        li t2, MIN_Y             # t2 = 8
        blt t4, t2, S3_HIT_Y
        
        # Movimento válido, atualizar posição
        sh t4, 2(a0)
        
        # Incrementar contador
        addi t1, t1, 1
        
        # Verificar se completou 30 frames
        li t2, 30
        blt t1, t2, S3_SAVE      # Se < 30, continuar neste eixo
        
        # Completou 30 frames, trocar para eixo X
        li t1, 0                 # Resetar contador
        li t0, 0                 # Estado = X
        j S3_SAVE_STATE

        # Colidiu com parede, inverter direção E trocar eixo
        S3_HIT_Y:
        sub t3, zero, t3         # Inverter velocidade Y
        sw t3, 0(t5)
        li t1, 0                 # Resetar contador
        li t0, 0                 # Trocar para eixo X
        j S3_SAVE_STATE

    # Salvar novo estado e contador
    S3_SAVE_STATE: 
    sw t0, 0(a1)                 # Salvar estado
    S3_SAVE: 
    sw t1, 0(a2)                 # Salvar contador
    ret

#########################################################
# MOVE_S2_LOGIC - Slime 2 (Movimento Horizontal)
# 
# PADRÃO DE MOVIMENTO:
# - Move horizontalmente (esquerda/direita)
# - Ricocheia quando atinge paredes
# - Velocidade constante
#
# EXEMPLO:
# → → → → → (parede) ← ← ← ← ← (parede) → → →
#
# DADOS USADOS:
# - S2_POS: Posição atual (X, Y)
# - S2_DIR: Direção (+4 = direita, -4 = esquerda)
#########################################################
MOVE_S2_LOGIC:
    # Carregar dados
    la a0, S2_POS                # a0 = posição
    la a1, S2_DIR                # a1 = direção
    
    lh t0, 0(a0)                 # t0 = X atual
    lw t2, 0(a1)                 # t2 = velocidade
    
    # Calcular nova posição
    add t0, t0, t2               # t0 = nova X
    
    # Verificar colisão com parede direita
    li t3, MAX_X                 # t3 = 296
    bge t0, t3, INV_S2
    
    # Verificar colisão com parede esquerda
    li t3, MIN_X                 # t3 = 8
    blt t0, t3, INV_S2
    
    # Movimento válido, salvar posição
    sh t0, 0(a0)
    ret
    
    # Colidiu com parede, inverter direção
    INV_S2: 
    sub t2, zero, t2             # Inverter velocidade
    sw t2, 0(a1)                 # Salvar nova direção
    
    # Recalcular posição com direção invertida
    add t0, t0, t2               # Voltar
    add t0, t0, t2               # Avançar na direção correta
    sh t0, 0(a0)                 # Salvar posição corrigida
    ret

#########################################################
# MOVE_S1_LOGIC - Slime 1 (Movimento Diagonal)
# 
# PADRÃO DE MOVIMENTO:
# - Move diagonalmente (X e Y simultaneamente)
# - Ricocheia nas paredes (como bola de bilhar)
# - Cada eixo inverte independentemente
#
# EXEMPLO:
#   ↗ ↗ ↗ (parede superior) ↘ ↘ ↘
#       ↗ ↗ ↗                 ↘ ↘ ↘
#           ↗ ↗ ↗ (parede direita) ↙ ↙ ↙
#
# DADOS USADOS:
# - S1_POS: Posição atual (X, Y)
# - S1_DIR_X: Velocidade em X (+4 ou -4)
# - S1_DIR_Y: Velocidade em Y (+4 ou -4)
#########################################################
MOVE_S1_LOGIC:
    # Carregar dados
    la a0, S1_POS                # a0 = posição
    la a1, S1_DIR_X              # a1 = velocidade X
    la a2, S1_DIR_Y              # a2 = velocidade Y
    
    lh t0, 0(a0)                 # t0 = X atual
    lh t1, 2(a0)                 # t1 = Y atual
    lw t2, 0(a1)                 # t2 = velocidade X
    lw t3, 0(a2)                 # t3 = velocidade Y
    
    # Calcular novas posições
    add t0, t0, t2               # Nova X
    add t1, t1, t3               # Nova Y
    
    # ===== VERIFICAR COLISÃO EM X =====
    li t4, MAX_X                 # t4 = 296
    bge t0, t4, INV_S1_X         # Parede direita
    
    li t4, MIN_X                 # t4 = 8
    blt t0, t4, INV_S1_X         # Parede esquerda
    
    j CHECK_S1_Y                 # X válido, verificar Y
    
    INV_S1_X: 
    sub t2, zero, t2             # Inverter velocidade X
    sw t2, 0(a1)                 # Salvar
    add t0, t0, t2               # Voltar
    add t0, t0, t2               # Avançar corretamente
    
    # ===== VERIFICAR COLISÃO EM Y =====
    CHECK_S1_Y:
    li t4, MAX_Y                 # t4 = 216
    bge t1, t4, INV_S1_Y         # Parede inferior
    
    li t4, MIN_Y                 # t4 = 8
    blt t1, t4, INV_S1_Y         # Parede superior
    
    j SAVE_S1                    # Y válido, salvar posições
    
    INV_S1_Y: 
    sub t3, zero, t3             # Inverter velocidade Y
    sw t3, 0(a2)                 # Salvar
    add t1, t1, t3               # Voltar
    add t1, t1, t3               # Avançar corretamente
    
    # Salvar novas posições
    SAVE_S1:
    sh t0, 0(a0)                 # Salvar X
    sh t1, 2(a0)                 # Salvar Y
    ret

#########################################################
# UPDATE_HISTORY_F0 - Salva posições atuais no frame 0
# 
# Copia posições atuais para histórico do frame 0.
# Usado para limpeza no próximo ciclo de renderização.
#########################################################
UPDATE_HISTORY_F0:
    # Jogador
    la t0, PLYR_POS
    lw t1, 0(t0)
    la t2, PLYR_F0
    sw t1, 0(t2)
    
    # Slime 1
    la t0, S1_POS
    lw t1, 0(t0)
    la t2, S1_F0
    sw t1, 0(t2)
    
    # Slime 2
    la t0, S2_POS
    lw t1, 0(t0)
    la t2, S2_F0
    sw t1, 0(t2)
    
    # Slime 3
    la t0, S3_POS
    lw t1, 0(t0)
    la t2, S3_F0
    sw t1, 0(t2)
    ret

#########################################################
# UPDATE_HISTORY_F1 - Salva posições atuais no frame 1
# 
# Copia posições atuais para histórico do frame 1.
# Usado para limpeza no próximo ciclo de renderização.
#########################################################
UPDATE_HISTORY_F1:
    # Jogador
    la t0, PLYR_POS
    lw t1, 0(t0)
    la t2, PLYR_F1
    sw t1, 0(t2)
    
    # Slime 1
    la t0, S1_POS
    lw t1, 0(t0)
    la t2, S1_F1
    sw t1, 0(t2)
    
    # Slime 2
    la t0, S2_POS
    lw t1, 0(t0)
    la t2, S2_F1
    sw t1, 0(t2)
    
    # Slime 3
    la t0, S3_POS
    lw t1, 0(t0)
    la t2, S3_F1
    sw t1, 0(t2)
    ret

#########################################################
# NOTAS SOBRE O SISTEMA DE INIMIGOS:
#
# 1. DIVERSIDADE DE COMPORTAMENTO:
#    Cada slime tem padrão único, tornando o jogo mais dinâmico
#    e desafiador. Jogador precisa adaptar estratégia.
#
# 2. TIMER INDEPENDENTE:
#    Inimigos não se movem todo frame, criando ritmo diferente
#    do jogador e permitindo controle de dificuldade.
#
# 3. FÍSICA DE RICOCHETE:
#    Movimento realista: quando bate na parede, inverte direção
#    e corrige posição para evitar ficar "preso" na parede.
#
# 4. SLIME 3 COMPLEXO:
#    Movimento em L adiciona imprevisibilidade:
#    - Difícil prever trajetória
#    - Cria situações táticas interessantes
#    - Mais desafiador que movimento simples
#
# 5. ESCALABILIDADE:
#    Para adicionar novo inimigo:
#    
#    # Em data.s:
#    S4_POS: .half 100, 100
#    S4_F0: .half 100, 100
#    S4_F1: .half 100, 100
#    S4_DIR: .word 3
#    
#    # Neste arquivo:
#    MOVE_S4_LOGIC:
#        # Implementar padrão único
#        ret
#    
#    # Em UPDATE_ENEMIES:
#    call MOVE_S4_LOGIC
#
# 6. PERFORMANCE:
#    - Apenas 3 inimigos ativos simultaneamente
#    - Lógica simples (sem pathfinding)
#    - Otimizado para rodar a 60 FPS
#########################################################