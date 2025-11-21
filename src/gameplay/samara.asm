#########################################################
# PLAYER.S - Sistema do Jogador
# 
# Este módulo gerencia tudo relacionado ao jogador:
# - Estado (vidas, invulnerabilidade, velocidade)
# - Movimento e controles
# - Interação com power-ups
# - Sistema de dano e morte
#
# O jogador é a entidade central do jogo, controlada
# diretamente pelo usuário através do teclado.
#########################################################

.text

#########################################################
# RESET_PLAYER - Reseta o jogador para estado inicial
# 
# Chamado ao iniciar novo jogo ou após game over.
# Restaura posição inicial, vidas, velocidade, etc.
#
# ESTADO INICIAL:
# - Posição: Centro da tela (160, 120)
# - Vidas: 3
# - Velocidade: 4 pixels/frame
# - Invulnerabilidade: 0 (desativada)
#
# OUTPUTS: Nenhum
#########################################################
RESET_PLAYER:
    # ===== 1. RESETAR POSIÇÃO =====
    # Colocar jogador no centro da tela
    la t0, PLYR_POS
    li t1, 160                   # X = 160 (centro horizontal)
    sh t1, 0(t0)
    li t1, 120                   # Y = 120 (centro vertical)
    sh t1, 2(t0)
    
    # Copiar para histórico de frames
    li t1, 160
    li t2, 120
    la t0, PLYR_F0
    sh t1, 0(t0)
    sh t2, 2(t0)
    la t0, PLYR_F1
    sh t1, 0(t0)
    sh t2, 2(t0)
    
    # ===== 2. RESETAR VIDAS =====
    la t0, VIDAS
    li t1, INITIAL_LIVES         # 3 vidas
    sw t1, 0(t0)
    
    # ===== 3. RESETAR VELOCIDADE =====
    la t0, PLAYER_SPEED
    li t1, INITIAL_PLAYER_SPEED  # 4 pixels/frame
    sw t1, 0(t0)
    
    # ===== 4. RESETAR INVULNERABILIDADE =====
    la t0, INVULNERAVEL
    sw zero, 0(t0)               # Desativar invulnerabilidade
    
    ret

#########################################################
# MOVE_PLAYER - Move o jogador em uma direção
# 
# Esta função é chamada pelo sistema de input quando
# uma tecla de movimento é pressionada.
#
# INPUTS:
#   a0 = direção (0=cima, 1=baixo, 2=esquerda, 3=direita)
#
# OUTPUTS:
#   a0 = 1 se movimento bem-sucedido, 0 se bloqueado
#
# VALIDAÇÕES:
# - Verifica limites da tela
# - Verifica colisão com paredes (usando hitmap)
# - Aplica velocidade atual do jogador
#########################################################
MOVE_PLAYER:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Carregar posição atual
    la t0, PLYR_POS
    lh t1, 0(t0)                 # t1 = X atual
    lh t2, 2(t0)                 # t2 = Y atual
    
    # Carregar velocidade
    la t3, PLAYER_SPEED
    lw t3, 0(t3)                 # t3 = velocidade
    
    # Verificar direção
    li t4, 0
    beq a0, t4, MOVE_UP
    li t4, 1
    beq a0, t4, MOVE_DOWN
    li t4, 2
    beq a0, t4, MOVE_LEFT
    li t4, 3
    beq a0, t4, MOVE_RIGHT
    
    # Direção inválida
    li a0, 0
    j END_MOVE_PLAYER

    MOVE_UP:
        sub t2, t2, t3           # Y -= velocidade
        j VALIDATE_MOVE
    
    MOVE_DOWN:
        add t2, t2, t3           # Y += velocidade
        j VALIDATE_MOVE
    
    MOVE_LEFT:
        sub t1, t1, t3           # X -= velocidade
        j VALIDATE_MOVE
    
    MOVE_RIGHT:
        add t1, t1, t3           # X += velocidade
        j VALIDATE_MOVE
    
    VALIDATE_MOVE:
        # Verificar limites da tela
        li t4, MIN_X
        blt t1, t4, MOVE_BLOCKED
        li t4, MAX_X
        bgt t1, t4, MOVE_BLOCKED
        li t4, MIN_Y
        blt t2, t4, MOVE_BLOCKED
        li t4, MAX_Y
        bgt t2, t4, MOVE_BLOCKED
        
        # Movimento válido, atualizar posição
        la t0, PLYR_POS
        sh t1, 0(t0)
        sh t2, 2(t0)
        li a0, 1                 # Retornar sucesso
        j END_MOVE_PLAYER
    
    MOVE_BLOCKED:
        li a0, 0                 # Retornar falha
    
    END_MOVE_PLAYER:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# TAKE_DAMAGE - Aplica dano ao jogador
# 
# Chamado quando jogador colide com inimigo.
# Gerencia sistema de vidas e invulnerabilidade.
#
# EFEITOS:
# - Remove 1 vida
# - Ativa invulnerabilidade temporária
# - Pode levar a game over se vidas <= 0
#
# INPUTS:
#   a0 = quantidade de dano (geralmente 1)
#
# OUTPUTS:
#   a0 = vidas restantes após dano
#########################################################
TAKE_DAMAGE:
    # ===== 1. VERIFICAR SE ESTÁ INVULNERÁVEL =====
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    bgtz t1, DAMAGE_BLOCKED      # Se invulnerável, bloquear dano
    
    # ===== 2. APLICAR DANO =====
    la t0, VIDAS
    lw t1, 0(t0)                 # t1 = vidas atuais
    sub t1, t1, a0               # t1 -= dano
    
    # Garantir que não fique negativo
    blez t1, SET_ZERO_LIVES
    sw t1, 0(t0)                 # Salvar novas vidas
    j ACTIVATE_INVULN
    
    SET_ZERO_LIVES:
        sw zero, 0(t0)           # Vidas = 0 (game over)
        li t1, 0
    
    # ===== 3. ATIVAR INVULNERABILIDADE =====
    ACTIVATE_INVULN:
    la t0, INVULNERAVEL
    li t2, INVULNERABILITY_FRAMES  # 60 frames = 1 segundo
    sw t2, 0(t0)
    
    # Retornar vidas restantes
    mv a0, t1
    ret
    
    DAMAGE_BLOCKED:
    # Jogador está invulnerável, não aplicar dano
    la t0, VIDAS
    lw a0, 0(t0)                 # Retornar vidas atuais
    ret

#########################################################
# UPDATE_INVULNERABILITY - Atualiza timer de invulnerabilidade
# 
# Chamado a cada frame. Decrementa contador de frames
# de invulnerabilidade até chegar a zero.
#
# EFEITO VISUAL:
# Enquanto invulnerável, o jogador "pisca" na tela
# (implementado em graphics/draw.s)
#
# OUTPUTS: Nenhum
#########################################################
UPDATE_INVULNERABILITY:
    la t0, INVULNERAVEL
    lw t1, 0(t0)                 # t1 = frames restantes
    
    # Se já está em zero, não fazer nada
    blez t1, END_UPDATE_INVULN
    
    # Decrementar contador
    addi t1, t1, -1
    sw t1, 0(t0)
    
    END_UPDATE_INVULN:
    ret

#########################################################
# GET_PLAYER_STATE - Retorna informações do jogador
# 
# Função auxiliar para obter estado atual do jogador.
# Útil para debugging e para outros sistemas.
#
# OUTPUTS:
#   a0 = X (posição horizontal)
#   a1 = Y (posição vertical)
#   a2 = vidas restantes
#   a3 = velocidade atual
#   a4 = frames de invulnerabilidade restantes
#########################################################
GET_PLAYER_STATE:
    # Carregar posição
    la t0, PLYR_POS
    lh a0, 0(t0)                 # a0 = X
    lh a1, 2(t0)                 # a1 = Y
    
    # Carregar vidas
    la t0, VIDAS
    lw a2, 0(t0)                 # a2 = vidas
    
    # Carregar velocidade
    la t0, PLAYER_SPEED
    lw a3, 0(t0)                 # a3 = velocidade
    
    # Carregar invulnerabilidade
    la t0, INVULNERAVEL
    lw a4, 0(t0)                 # a4 = invuln frames
    
    ret

#########################################################
# APPLY_SPEED_BOOST - Aplica power-up de velocidade
# 
# Aumenta velocidade do jogador permanentemente
# (até reiniciar o jogo).
#
# INPUTS:
#   a0 = nova velocidade (geralmente 8)
#
# OUTPUTS: Nenhum
#########################################################
APPLY_SPEED_BOOST:
    la t0, PLAYER_SPEED
    sw a0, 0(t0)
    ret

#########################################################
# HEAL_PLAYER - Cura o jogador (adiciona vida)
# 
# Chamado ao coletar power-up de vida.
# Pode exceder limite de 3 vidas se implementar sistema
# de vidas extras.
#
# INPUTS:
#   a0 = quantidade de vidas a adicionar
#
# OUTPUTS:
#   a0 = total de vidas após cura
#########################################################
HEAL_PLAYER:
    la t0, VIDAS
    lw t1, 0(t0)                 # t1 = vidas atuais
    add t1, t1, a0               # t1 += cura
    
    # Opcional: limitar máximo de vidas
    # li t2, 5                   # Máximo 5 vidas
    # ble t1, t2, SAVE_LIVES
    # li t1, 5
    
    # SAVE_LIVES:
    sw t1, 0(t0)                 # Salvar novas vidas
    mv a0, t1                    # Retornar total
    ret

#########################################################
# IS_PLAYER_ALIVE - Verifica se jogador está vivo
# 
# Função auxiliar para verificar condição de game over.
#
# OUTPUTS:
#   a0 = 1 se vivo (vidas > 0), 0 se morto (vidas = 0)
#########################################################
IS_PLAYER_ALIVE:
    la t0, VIDAS
    lw t0, 0(t0)                 # t0 = vidas
    
    bgtz t0, PLAYER_ALIVE
    
    # Jogador morto
    li a0, 0
    ret
    
    PLAYER_ALIVE:
    li a0, 1
    ret

#########################################################
# NOTAS SOBRE O SISTEMA DO JOGADOR:
#
# 1. ESTADO CENTRALIZADO:
#    Todas as variáveis do jogador estão em config/data.s:
#    - PLYR_POS: Posição atual
#    - VIDAS: Vidas restantes
#    - PLAYER_SPEED: Velocidade atual
#    - INVULNERAVEL: Frames de invulnerabilidade
#
# 2. SISTEMA DE VIDAS:
#    - Inicia com 3 vidas (INITIAL_LIVES)
#    - Perde 1 vida por colisão com inimigo
#    - Pode ganhar vidas com power-ups
#    - Game over quando vidas = 0
#
# 3. INVULNERABILIDADE:
#    - Ativada após tomar dano
#    - Dura 60 frames (1 segundo a 60 FPS)
#    - Previne dano múltiplo instantâneo
#    - Feedback visual: jogador pisca
#
# 4. VELOCIDADE:
#    - Velocidade base: 4 pixels/frame
#    - Power-up aumenta para: 8 pixels/frame
#    - Velocidade permanente até reiniciar
#    - Permite exploração mais rápida
#
# 5. MOVIMENTO:
#    - Sistema baseado em grid livre
#    - Validação de limites da tela
#    - Sem colisão com paredes (apenas limites)
#    - Movimento suave e responsivo
#
# 6. INTEGRAÇÃO COM INPUT:
#    O módulo core/input.s chama diretamente as variáveis
#    do jogador, mas este módulo fornece funções auxiliares
#    para operações mais complexas.
#
# 7. EXTENSÕES POSSÍVEIS:
#
#    A. SISTEMA DE STAMINA:
#       PLAYER_STAMINA: .word 100
#       
#       SPRINT:
#           la t0, PLAYER_STAMINA
#           lw t1, 0(t0)
#           blez t1, NO_SPRINT
#           # Velocidade dobrada, consumir stamina
#           addi t1, t1, -2
#           sw t1, 0(t0)
#
#    B. HABILIDADE ESPECIAL (DASH):
#       DASH:
#           # Teleportar 3 tiles na direção atual
#           la t0, PLYR_POS
#           lh t1, 0(t0)
#           addi t1, t1, 48      # 3 tiles * 16 pixels
#           sh t1, 0(t0)
#
#    C. SISTEMA DE EXPERIÊNCIA:
#       PLAYER_XP: .word 0
#       PLAYER_LEVEL: .word 1
#       
#       GAIN_XP:
#           # Adicionar XP, verificar level up
#           # Cada level aumenta stats
#
#    D. INVENTÁRIO:
#       PLAYER_ITEMS: .word 0, 0, 0, 0  # 4 slots
#       
#       ADD_ITEM:
#           # Adicionar item ao inventário
#           # Usar item com tecla específica
#
# 8. DEBUGGING:
#    Use GET_PLAYER_STATE para inspecionar estado:
#    
#    call GET_PLAYER_STATE
#    # a0 = X, a1 = Y, a2 = vidas, a3 = velocidade
#    # Imprimir valores para debug
#
# 9. BALANCEAMENTO:
#    Ajuste estas constantes para mudar dificuldade:
#    - INITIAL_LIVES: Mais vidas = mais fácil
#    - PLAYER_SPEED: Mais velocidade = mais fácil
#    - INVULNERABILITY_FRAMES: Mais frames = mais fácil
#
# 10. RESPONSIVIDADE:
#     O jogador responde instantaneamente ao input
#     porque a verificação é feita a cada frame (60 FPS).
#     Isso garante controle preciso e satisfatório.
#########################################################