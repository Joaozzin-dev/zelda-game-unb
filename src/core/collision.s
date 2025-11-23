#########################################################
# COLLISION.S - Sistema de Colisão e Itens
# 
# Este módulo gerencia:
# - Coleta de itens (baús)
# - Detecção de colisão com inimigos
# - Sistema de dano e invulnerabilidade
# - Aplicação de power-ups
#########################################################

.text

#########################################################
# CHECK_COLLISIONS - Verifica todas as colisões do jogo
# 
# ORDEM DE PROCESSAMENTO:
# 1. Colisão com itens (baús)
# 2. Aplicação de power-ups
# 3. Colisão com inimigos (se não invulnerável)
# 4. Sistema de dano
#
# OUTPUTS: Nenhum (modifica estado do jogo)
#########################################################
CHECK_COLLISIONS:
    addi sp, sp, -4
    sw ra, 0(sp)

    # ===== VERIFICAR COLETA DE ITENS =====
    
    # --- Baú Azul (Power-up de Velocidade) ---
    la a0, PLYR_POS              # a0 = posição do jogador
    la a1, CHEST_B_DATA          # a1 = posição do baú azul
    call AABB_CHECK              # Verifica colisão
    bnez a0, GET_CHEST_B         # Se colidiu, coletar baú
    
    # --- Baú Amarelo (Vida Extra) ---
    la a0, PLYR_POS              # a0 = posição do jogador
    la a1, CHEST_Y_DATA          # a1 = posição do baú amarelo
    call AABB_CHECK              # Verifica colisão
    bnez a0, GET_CHEST_Y         # Se colidiu, coletar baú
    
    # Pular para verificação de dano
    j CHECK_DMG

    # ===== COLETAR BAÚ AZUL =====
    GET_CHEST_B:
        # Carregar dados do baú
        la t0, CHEST_B_DATA
        lh t1, 4(t0)             # t1 = flag de disponibilidade
        
        # Verificar se já foi coletado
        beqz t1, CHECK_DMG       # Se já coletado (0), ignorar
        
        # Marcar como coletado
        li t1, ITEM_COLLECTED
        sh t1, 4(t0)
        
        # Limpar sprite do baú da tela
        la a0, CHEST_B_DATA
        call CLEAR_ITEM_BG
        
        # APLICAR POWER-UP: Aumentar velocidade
        la t0, PLAYER_SPEED
        li t1, BOOSTED_PLAYER_SPEED  # Velocidade = 8
        sw t1, 0(t0)
        
        j CHECK_DMG

    # ===== COLETAR BAÚ AMARELO =====
    GET_CHEST_Y:
        # Carregar dados do baú
        la t0, CHEST_Y_DATA
        lh t1, 4(t0)             # t1 = flag de disponibilidade
        
        # Verificar se já foi coletado
        beqz t1, CHECK_DMG       # Se já coletado, ignorar
        
        # Marcar como coletado
        li t1, ITEM_COLLECTED
        sh t1, 4(t0)
        
        # Limpar sprite do baú da tela
        la a0, CHEST_Y_DATA
        call CLEAR_ITEM_BG
        
        # APLICAR POWER-UP: Adicionar vida
        la t0, VIDAS
        lw t1, 0(t0)             # Carregar vidas atuais
        addi t1, t1, 1           # Adicionar 1 vida
        sw t1, 0(t0)             # Salvar novo valor

    # ===== VERIFICAR DANO DE INIMIGOS =====
    CHECK_DMG:
    
    # Verificar se jogador está invulnerável
    la t0, INVULNERAVEL
    lw t1, 0(t0)                 # t1 = frames restantes de invulnerabilidade
    
    blez t1, DO_COLLISION_CHECK  # Se não invulnerável, verificar colisões
    
    # Decrementar contador de invulnerabilidade
    addi t1, t1, -1
    sw t1, 0(t0)
    j END_COL                    # Pular verificação de dano

    # --- Verificar colisão com cada inimigo ---
    DO_COLLISION_CHECK:
    
    # Slime 1
    la a0, PLYR_POS
    la a1, S1_POS
    call AABB_CHECK
    bnez a0, TAKE_HIT            # Se colidiu, tomar dano
    
    # Slime 2
    la a0, PLYR_POS
    la a1, S2_POS
    call AABB_CHECK
    bnez a0, TAKE_HIT            # Se colidiu, tomar dano
    
    # Slime 3
    la a0, PLYR_POS
    la a1, S3_POS
    call AABB_CHECK
    bnez a0, TAKE_HIT            # Se colidiu, tomar dano
    
    # Nenhuma colisão, continuar
    j END_COL

    # ===== APLICAR DANO =====
    TAKE_HIT:
    
    # Reduzir vidas
    la t0, VIDAS
    lw t1, 0(t0)                 # Carregar vidas atuais
    addi t1, t1, -1              # Remover 1 vida
    sw t1, 0(t0)                 # Salvar novo valor
    
    # Ativar invulnerabilidade temporária
    la t0, INVULNERAVEL
    li t1, INVULNERABILITY_FRAMES  # 60 frames = 1 segundo
    sw t1, 0(t0)

    END_COL:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# AABB_CHECK - Axis-Aligned Bounding Box Collision
# 
# Detecta colisão entre dois retângulos usando o algoritmo AABB.
# É o método mais eficiente para colisões 2D com sprites retangulares.
#
# ALGORITMO:
# Dois retângulos colidem se:
# 1. rect1.right > rect2.left   E
# 2. rect1.left < rect2.right   E
# 3. rect1.bottom > rect2.top   E
# 4. rect1.top < rect2.bottom
#
# INPUTS:
#   a0 = endereço da entidade 1 (formato: X, Y em half-words)
#   a1 = endereço da entidade 2 (formato: X, Y em half-words)
#
# OUTPUTS:
#   a0 = 1 se há colisão, 0 se não há
#
# REGISTRADORES:
#   t0 = X da entidade 1
#   t1 = Y da entidade 1
#   t2 = X da entidade 2
#   t3 = Y da entidade 2
#   t4 = tamanho da hitbox (14 pixels)
#   t5 = cálculo temporário
#########################################################
AABB_CHECK:
    # Carregar posições das entidades
    lh t0, 0(a0)                 # t0 = X1
    lh t1, 2(a0)                 # t1 = Y1
    lh t2, 0(a1)                 # t2 = X2
    lh t3, 2(a1)                 # t3 = Y2
    
    # Tamanho da hitbox (sprite 16x16, mas hitbox 14x14 para melhor gameplay)
    li t4, HITBOX_SIZE
    
    # ===== TESTE 1: X1 + largura > X2 ? =====
    add t5, t2, t4               # t5 = X2 + hitbox
    bge t0, t5, NO_HIT           # Se X1 >= X2+hitbox, não colide
    
    # ===== TESTE 2: X1 < X2 + largura ? =====
    add t5, t0, t4               # t5 = X1 + hitbox
    ble t5, t2, NO_HIT           # Se X1+hitbox <= X2, não colide
    
    # ===== TESTE 3: Y1 + altura > Y2 ? =====
    add t5, t3, t4               # t5 = Y2 + hitbox
    bge t1, t5, NO_HIT           # Se Y1 >= Y2+hitbox, não colide
    
    # ===== TESTE 4: Y1 < Y2 + altura ? =====
    add t5, t1, t4               # t5 = Y1 + hitbox
    ble t5, t3, NO_HIT           # Se Y1+hitbox <= Y2, não colide
    
    # Todos os testes passaram = COLISÃO!
    li a0, 1
    ret
    
    NO_HIT: 
    # Algum teste falhou = SEM COLISÃO
    li a0, 0
    ret

#########################################################
# CLEAR_ITEM_BG - Limpa sprite de item coletado
# 
# Desenha tile de fundo sobre a posição do item em ambos
# os frames para remover visualmente o item da tela.
#
# INPUTS:
#   a0 = endereço do item (formato: X, Y, disponível)
#
# OUTPUTS: Nenhum
#########################################################
CLEAR_ITEM_BG:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Carregar posição do item
    lh a1, 0(a0)                 # a1 = X
    lh a2, 2(a0)                 # a2 = Y
    
    # Desenhar tile de fundo no frame 0
    la a0, tile
    li a3, 0                     # Frame 0
    call PRINT
    
    # Desenhar tile de fundo no frame 1
    li a3, 1                     # Frame 1
    call PRINT
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# NOTAS SOBRE O SISTEMA DE COLISÃO:
#
# 1. PRIORIDADE DE PROCESSAMENTO:
#    Itens são verificados antes de inimigos para garantir
#    que o jogador possa coletar power-ups mesmo se houver
#    um inimigo próximo.
#
# 2. INVULNERABILIDADE:
#    Após tomar dano, o jogador fica invulnerável por 60 frames
#    (1 segundo a 60 FPS). Isso previne múltiplos hits instantâneos
#    e dá tempo para o jogador reagir.
#
# 3. HITBOX REDUZIDA:
#    Sprites são 16x16, mas hitbox é 14x14. Isso torna o jogo
#    mais justo, permitindo que o jogador passe mais perto
#    de inimigos sem colidir.
#
# 4. ALGORITMO AABB:
#    AABB (Axis-Aligned Bounding Box) é extremamente eficiente:
#    - Apenas 4 comparações por par de entidades
#    - Não usa multiplicação ou divisão
#    - Perfeito para jogos 2D com grid ou movimento livre
#
# 5. PERSISTÊNCIA DE ITENS:
#    Itens coletados permanecem coletados. Para resetar,
#    é necessário chamar RESET_GAME_STATE (feito no SETUP).
#########################################################