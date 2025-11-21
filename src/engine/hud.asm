#########################################################
# HUD.S - Heads-Up Display (Interface do Usuário)
# 
# Este módulo gerencia a interface visual que mostra
# informações importantes ao jogador:
# - Vidas restantes (representadas por chaves)
# - Futuramente: pontuação, timer, etc.
#########################################################

.text

#########################################################
# DRAW_HUD_LIVES - Desenha indicador de vidas
# 
# FUNCIONAMENTO:
# 1. Limpa área do HUD (desenha tiles de fundo)
# 2. Desenha uma chave para cada vida restante
# 3. Posições fixas: X = 10, 28, 46 | Y = 10
#
# VISUAL:
# 3 vidas: 🔑 🔑 🔑
# 2 vidas: 🔑 🔑
# 1 vida:  🔑
# 0 vidas: (game over)
#
# OUTPUTS: Nenhum
# 
# REGISTRADORES PRESERVADOS:
# Função salva/restaura todos os registradores usados
#########################################################
DRAW_HUD_LIVES:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # ===== 1. LIMPAR ÁREA DO HUD =====
    # Desenha tiles de fundo nas 3 posições possíveis
    # para garantir que vidas perdidas sejam apagadas
    
    # Posição 1 (primeira vida)
    la a0, tile                  # Sprite do tile de fundo
    li a1, HUD_LIFE1_X          # X = 10
    li a2, HUD_LIFE_Y           # Y = 10
    mv a3, s0                    # Frame atual
    call PRINT
    
    # Posição 2 (segunda vida)
    li a1, HUD_LIFE2_X          # X = 28
    li a2, HUD_LIFE_Y           # Y = 10
    mv a3, s0                    # Frame atual
    call PRINT
    
    # Posição 3 (terceira vida)
    li a1, HUD_LIFE3_X          # X = 46
    li a2, HUD_LIFE_Y           # Y = 10
    mv a3, s0                    # Frame atual
    call PRINT
    
    # ===== 2. CARREGAR NÚMERO DE VIDAS =====
    la t0, VIDAS
    lw t0, 0(t0)                 # t0 = vidas restantes (0-3)
    
    # ===== 3. CONFIGURAR POSIÇÃO INICIAL =====
    li a1, HUD_LIFE1_X          # X inicial = 10
    li a2, HUD_LIFE_Y           # Y = 10 (constante)
    mv a3, s0                    # Frame atual
    la a0, KeyB                  # Sprite da chave azul
    
    # ===== 4. DESENHAR CADA VIDA =====
    LOOP_LIVES:
        # Verificar se ainda há vidas para desenhar
        blez t0, END_DRAW_LIVES  # Se t0 <= 0, terminar
        
        # Salvar registradores na pilha
        # (PRINT pode modificar registradores temporários)
        addi sp, sp, -12
        sw a1, 0(sp)             # Salvar X
        sw a2, 4(sp)             # Salvar Y
        sw t0, 8(sp)             # Salvar contador de vidas
        
        # Desenhar chave na posição atual
        call PRINT
        
        # Restaurar registradores da pilha
        lw a1, 0(sp)             # Restaurar X
        lw a2, 4(sp)             # Restaurar Y
        lw t0, 8(sp)             # Restaurar contador
        addi sp, sp, 12
        
        # Avançar para próxima posição
        addi a1, a1, HUD_SPACING # X += 18 pixels
        
        # Decrementar contador de vidas
        addi t0, t0, -1
        
        # Repetir para próxima vida
        j LOOP_LIVES

    END_DRAW_LIVES:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# NOTAS SOBRE O SISTEMA DE HUD:
#
# 1. POSICIONAMENTO FIXO:
#    HUD sempre no mesmo lugar (canto superior esquerdo)
#    para facilitar visualização rápida durante gameplay.
#
# 2. LIMPEZA PREVENTIVA:
#    Sempre limpa todas as 3 posições antes de desenhar.
#    Garante que vidas perdidas não apareçam como "fantasmas".
#
# 3. ESPAÇAMENTO:
#    18 pixels entre cada chave (HUD_SPACING):
#    - Sprite = 16 pixels
#    - Gap = 2 pixels
#    - Total = 18 pixels para cada vida
#
# 4. SPRITE DE CHAVE:
#    Usa chave azul (KeyB) em vez de coração para
#    manter consistência temática do jogo.
#
# 5. EXTENSIBILIDADE:
#    Para adicionar mais elementos ao HUD:
#    
#    DRAW_HUD_SCORE:
#        # Desenhar pontuação
#        li a1, 260           # X (canto direito)
#        li a2, 10            # Y (topo)
#        la a0, score_sprite
#        call PRINT
#        ret
#    
#    Chamar no DRAW_ALL:
#        call DRAW_HUD_LIVES
#        call DRAW_HUD_SCORE  # Nova função
#
# 6. DOUBLE BUFFERING:
#    HUD é redesenhado a cada frame em ambos os buffers
#    para manter consistência visual.
#
# 7. PERFORMANCE:
#    - Desenha apenas o necessário
#    - Usa loop eficiente em vez de código repetido
#    - Mínimo de acessos à memória
#
# 8. FEEDBACK VISUAL:
#    Jogador vê imediatamente quando perde vida:
#    - Chave desaparece
#    - Sem animação (instantâneo)
#    - Claro e direto
#
# 9. ZERO VIDAS:
#    Quando vidas chegam a 0, nenhuma chave é desenhada
#    e o game loop detecta game over antes da próxima renderização.
#########################################################