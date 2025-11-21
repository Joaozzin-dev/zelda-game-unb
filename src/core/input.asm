#########################################################
# INPUT.S - Sistema de Entrada do Jogador
# 
# Este módulo processa a entrada do teclado e move o jogador.
#
# TECLAS SUPORTADAS:
# W - Mover para cima
# S - Mover para baixo
# A - Mover para esquerda
# D - Mover para direita
#
# LIMITES DE MOVIMENTO:
# O jogador não pode sair da área jogável (8-296 em X, 8-216 em Y)
#########################################################

.text

#########################################################
# INPUT_CHECK - Verifica e processa entrada do teclado
# 
# FUNCIONAMENTO:
# 1. Verifica se há tecla pressionada
# 2. Identifica qual tecla foi pressionada
# 3. Move o jogador na direção correspondente
# 4. Valida limites da tela
#
# INPUTS: Nenhum (lê do registrador de teclado)
# 
# OUTPUTS: Nenhum (modifica PLYR_POS diretamente)
# 
# MODIFICA:
# - PLYR_POS: atualiza posição X ou Y do jogador
# 
# REGISTRADORES USADOS:
# t0 = buffer para comparações
# t1 = endereço do teclado / posição atual
# t2 = tecla pressionada
# t3 = velocidade do jogador
# t5 = limite temporário
#########################################################
INPUT_CHECK:
    # ===== 1. Verificar se há entrada disponível =====
    li t1, KEYBOARD_CONTROL        # Endereço do registrador de controle
    lw t0, 0(t1)                   # Ler status do teclado
    andi t0, t0, 1                 # Isolar bit de "ready"
    beqz t0, RET_INPUT             # Se não há input, retornar
    
    # ===== 2. Ler qual tecla foi pressionada =====
    lw t2, KEYBOARD_DATA(t1)       # t2 = código da tecla
    
    # ===== 3. Carregar velocidade atual do jogador =====
    la t0, PLAYER_SPEED
    lw t3, 0(t0)                   # t3 = velocidade (4 ou 8)
    
    # ===== 4. Comparar com cada tecla possível =====
    
    # Comparar com 'W' (subir)
    li t0, KEY_W
    beq t2, t0, DO_W
    
    # Comparar com 'S' (descer)
    li t0, KEY_S
    beq t2, t0, DO_S
    
    # Comparar com 'A' (esquerda)
    li t0, KEY_A
    beq t2, t0, DO_A
    
    # Comparar com 'D' (direita)
    li t0, KEY_D
    beq t2, t0, DO_D
    
    # Se nenhuma tecla válida, retornar
    j RET_INPUT

#########################################################
# DO_W - Mover jogador para CIMA
# 
# Subtrai velocidade da posição Y.
# Limita movimento ao topo da tela (Y >= 8).
#########################################################
DO_W: 
    la t0, PLYR_POS                # Carregar endereço da posição
    lh t1, 2(t0)                   # t1 = posição Y atual
    sub t1, t1, t3                 # t1 = Y - velocidade
    
    # Verificar limite superior
    li t5, MIN_Y                   # t5 = 8 (limite superior)
    blt t1, t5, RET_INPUT          # Se Y < 8, cancelar movimento
    
    # Movimento válido, atualizar posição
    sh t1, 2(t0)
    j RET_INPUT

#########################################################
# DO_S - Mover jogador para BAIXO
# 
# Adiciona velocidade à posição Y.
# Limita movimento ao fundo da tela (Y <= 216).
#########################################################
DO_S: 
    la t0, PLYR_POS
    lh t1, 2(t0)                   # t1 = posição Y atual
    add t1, t1, t3                 # t1 = Y + velocidade
    
    # Verificar limite inferior
    li t5, MAX_Y                   # t5 = 216 (limite inferior)
    bgt t1, t5, RET_INPUT          # Se Y > 216, cancelar movimento
    
    # Movimento válido, atualizar posição
    sh t1, 2(t0)
    j RET_INPUT

#########################################################
# DO_A - Mover jogador para ESQUERDA
# 
# Subtrai velocidade da posição X.
# Limita movimento à borda esquerda (X >= 8).
#########################################################
DO_A: 
    la t0, PLYR_POS
    lh t1, 0(t0)                   # t1 = posição X atual
    sub t1, t1, t3                 # t1 = X - velocidade
    
    # Verificar limite esquerdo
    li t5, MIN_X                   # t5 = 8 (limite esquerdo)
    blt t1, t5, RET_INPUT          # Se X < 8, cancelar movimento
    
    # Movimento válido, atualizar posição
    sh t1, 0(t0)
    j RET_INPUT

#########################################################
# DO_D - Mover jogador para DIREITA
# 
# Adiciona velocidade à posição X.
# Limita movimento à borda direita (X <= 296).
#########################################################
DO_D: 
    la t0, PLYR_POS
    lh t1, 0(t0)                   # t1 = posição X atual
    add t1, t1, t3                 # t1 = X + velocidade
    
    # Verificar limite direito
    li t5, MAX_X                   # t5 = 296 (limite direito)
    bgt t1, t5, RET_INPUT          # Se X > 296, cancelar movimento
    
    # Movimento válido, atualizar posição
    sh t1, 0(t0)
    j RET_INPUT

#########################################################
# RET_INPUT - Retorno da função
#########################################################
RET_INPUT:
    ret

#########################################################
# NOTAS DE IMPLEMENTAÇÃO:
# 
# 1. VELOCIDADE VARIÁVEL:
#    A velocidade é carregada dinamicamente de PLAYER_SPEED,
#    permitindo que power-ups aumentem a velocidade sem
#    modificar este código.
#
# 2. VALIDAÇÃO DE LIMITES:
#    Cada movimento verifica se a nova posição está dentro
#    dos limites antes de aplicar. Isso previne que o jogador
#    saia da tela ou entre em áreas inválidas.
#
# 3. HALF-WORDS:
#    Posições são armazenadas como half-words (16 bits) usando
#    'lh' e 'sh' para economizar memória.
#
# 4. BUFFER ÚNICO:
#    Apenas uma tecla é processada por frame. Se múltiplas
#    teclas forem pressionadas, apenas a primeira detectada
#    terá efeito naquele frame.
#
# 5. EXTENSIBILIDADE:
#    Para adicionar novas teclas (pause, ataque, etc.):
#    - Definir constante em constants.s
#    - Adicionar comparação após DO_D
#    - Criar nova label DO_X com a ação desejada
#########################################################