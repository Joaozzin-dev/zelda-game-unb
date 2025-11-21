#########################################################
# DRAW.S - Sistema de Renderização de Sprites
# 
# Este módulo gerencia a renderização de todos os
# elementos visuais do jogo:
# - Itens (baús)
# - Jogador
# - Inimigos
# - Background (tiles)
#########################################################

.text

#########################################################
# DRAW_ALL - Desenha todos os elementos do jogo
# 
# ORDEM DE RENDERIZAÇÃO:
# 1. Itens (baús) - Camada de fundo
# 2. Jogador - Camada intermediária
# 3. Inimigos - Camada de frente
#
# Esta ordem garante que os sprites se sobreponham
# corretamente na tela.
#
# OUTPUTS: Nenhum
#########################################################
DRAW_ALL:
    addi sp, sp, -4
    sw ra, 0(sp)

    # ===== DESENHAR ITENS (BAÚS) =====
    
    # --- Baú Azul ---
    la t0, CHEST_B_DATA
    lh t1, 4(t0)                 # t1 = flag de disponibilidade
    beqz t1, CHECK_CHEST_Y       # Se coletado (0), pular
    
    # Baú ainda disponível, desenhar
    la a0, CHEST_B_DATA          # Posição
    la a3, ChestB                # Sprite
    call DRAW_POS
    
    # --- Baú Amarelo ---
    CHECK_CHEST_Y:
    la t0, CHEST_Y_DATA
    lh t1, 4(t0)                 # t1 = flag de disponibilidade
    beqz t1, DRAW_ENTITIES       # Se coletado, pular
    
    # Baú ainda disponível, desenhar
    la a0, CHEST_Y_DATA          # Posição
    la a3, ChestY                # Sprite
    call DRAW_POS

    # ===== DESENHAR ENTIDADES =====
    DRAW_ENTITIES:
    
    # --- Jogador (com efeito de invulnerabilidade) ---
    la t0, INVULNERAVEL
    lw t1, 0(t0)                 # t1 = frames de invulnerabilidade
    
    # Efeito de piscar: desenhar apenas em frames pares
    andi t1, t1, 4               # Isola bit 2 (alterna a cada 4 frames)
    bnez t1, SKIP_PLAYER         # Se bit ativo, pular (efeito de piscar)
    
    # Desenhar jogador normalmente
    la a0, PLYR_POS
    la a3, char
    call DRAW_POS
    
    SKIP_PLAYER:

    # --- Slime 1 (Movimento Diagonal) ---
    la a0, S1_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    # --- Slime 2 (Movimento Horizontal) ---
    la a0, S2_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    # --- Slime 3 (Movimento em L) ---
    la a0, S3_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# RESTORE_BG - Restaura tile de fundo em posição anterior
# 
# Esta função é usada no sistema de double buffering para
# apagar sprites desenhados no frame anterior antes de
# desenhar na nova posição.
#
# INPUTS:
#   a0 = endereço da posição (formato: X, Y em half-words)
#   s0 = frame atual (0 ou 1) - variável global
#
# OUTPUTS: Nenhum
#########################################################
RESTORE_BG:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Carregar posição anterior
    lh a1, 0(a0)                 # a1 = X anterior
    lh a2, 2(a0)                 # a2 = Y anterior
    
    # Desenhar tile de fundo na posição anterior
    la a0, tile                  # Sprite do tile
    mv a3, s0                    # Frame atual
    call PRINT
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# DRAW_POS - Desenha sprite em posição específica
# 
# Função auxiliar que extrai X e Y de um endereço e
# chama PRINT para renderizar o sprite.
#
# INPUTS:
#   a0 = endereço da posição (formato: X, Y em half-words)
#   a3 = endereço do sprite a desenhar
#   s0 = frame atual (0 ou 1) - variável global
#
# OUTPUTS: Nenhum
#########################################################
DRAW_POS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Carregar coordenadas
    lh a1, 0(a0)                 # a1 = X
    lh a2, 2(a0)                 # a2 = Y
    
    # Mover sprite para a0 (PRINT espera sprite em a0)
    mv a0, a3
    
    # Frame já está em s0, copiar para a3 (parâmetro do PRINT)
    mv a3, s0
    
    # Chamar função de impressão
    call PRINT
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# NOTAS SOBRE O SISTEMA DE RENDERIZAÇÃO:
#
# 1. DOUBLE BUFFERING:
#    O jogo usa dois frames (buffers) alternados:
#    - Enquanto um é exibido, o outro é desenhado
#    - Previne flickering (tremulação) visual
#    - RESTORE_BG limpa o buffer que será usado
#
# 2. ORDEM DE RENDERIZAÇÃO:
#    A ordem importa! Elementos desenhados depois aparecem
#    "sobre" os anteriores:
#    Fundo → Itens → Jogador → Inimigos
#
# 3. EFEITO DE INVULNERABILIDADE:
#    O jogador "pisca" quando invulnerável:
#    - Usa operação AND com bit 2 do contador
#    - Alterna visibilidade a cada 4 frames
#    - Feedback visual claro para o jogador
#
# 4. OTIMIZAÇÃO:
#    - Itens coletados não são desenhados (check de flag)
#    - Evita desenhar sprites desnecessários
#    - Melhora performance especialmente com muitos itens
#
# 5. FLEXIBILIDADE:
#    DRAW_POS é genérica e pode ser usada para qualquer
#    sprite, facilitando adicionar novos elementos ao jogo.
#
# 6. SPRITES 16x16:
#    Todos os sprites seguem padrão 16x16 pixels:
#    - Facilita alinhamento e colisão
#    - Permite grid-based design se necessário
#    - Consistência visual
#########################################################