#########################################################
# PRINT.S - Função Base de Impressão de Sprites
# 
# Esta é a função fundamental que desenha sprites na tela.
# Todo o sistema gráfico do jogo depende desta função.
#
# FORMATO DE SPRITE:
# Os sprites seguem este formato na memória:
# [0-3]: Largura em bytes (4 bytes por linha, pois cada pixel = 4 bytes)
# [4-7]: Altura em pixels
# [8+]:  Dados dos pixels (4 bytes RGBA por pixel)
#########################################################

.text

#########################################################
# PRINT - Desenha sprite na tela
# 
# Esta função copia dados de um sprite da memória para
# o bitmap display (VRAM), renderizando a imagem na tela.
#
# ALGORITMO:
# 1. Calcular endereço base do frame (0 ou 1)
# 2. Calcular offset da posição (X, Y)
# 3. Copiar linha por linha do sprite para VRAM
# 4. Pular para próxima linha (width_screen - width_sprite)
#
# INPUTS:
#   a0 = endereço do sprite na memória
#   a1 = posição X na tela (0-319)
#   a2 = posição Y na tela (0-239)
#   a3 = frame (0 ou 1)
#
# OUTPUTS: Nenhum
#
# FORMATO DO SPRITE (na memória):
#   [0-3]: largura em bytes (geralmente 64 para sprite 16x16)
#   [4-7]: altura em pixels (geralmente 16)
#   [8+]:  dados RGB dos pixels (4 bytes por pixel)
#
# REGISTRADORES USADOS:
#   t0 = endereço atual na VRAM
#   t1 = endereço atual no sprite
#   t2 = contador de linha atual
#   t3 = contador de byte na linha atual
#   t4 = largura do sprite em bytes
#   t5 = altura do sprite em pixels
#   t6 = pixel atual (valor RGBA)
#########################################################
PRINT:
    # ===== 1. CALCULAR ENDEREÇO BASE DO FRAME =====
    # Frame 0 = 0xFF000000
    # Frame 1 = 0xFF100000
    
    li t0, 0xFF0                 # Base = 0xFF0
    add t0, t0, a3               # Adicionar frame (0 ou 1)
    slli t0, t0, 20              # Shift left 20 bits = multiplicar por 1048576
    
    # Agora t0 = 0xFF000000 ou 0xFF100000
    
    # ===== 2. ADICIONAR OFFSET DA POSIÇÃO X =====
    # Cada pixel = 4 bytes, então X em bytes = X * 4
    # Mas X já está em pixels, então apenas adicionar
    
    add t0, t0, a1               # t0 += X (offset horizontal)
    
    # ===== 3. ADICIONAR OFFSET DA POSIÇÃO Y =====
    # Y em bytes = Y * largura_tela * 4
    # largura_tela = 320 pixels = 320 bytes (já considerando 4 bytes/pixel)
    
    li t1, SCREEN_WIDTH          # t1 = 320
    mul t1, t1, a2               # t1 = Y * 320
    add t0, t0, t1               # t0 += offset vertical
    
    # Agora t0 aponta para a posição (X, Y) no frame correto
    
    # ===== 4. PREPARAR DADOS DO SPRITE =====
    
    addi t1, a0, 8               # t1 = início dos dados do sprite (pula header)
    
    mv t2, zero                  # t2 = linha atual (contador)
    mv t3, zero                  # t3 = byte na linha (contador)
    
    lw t4, 0(a0)                 # t4 = largura do sprite em bytes
    lw t5, 4(a0)                 # t5 = altura do sprite em pixels
    
    # ===== 5. COPIAR PIXELS LINHA POR LINHA =====
    
PRINT_LOOP:
    # Copiar um pixel (4 bytes)
    lw t6, 0(t1)                 # Ler pixel do sprite
    sw t6, 0(t0)                 # Escrever pixel na VRAM
    
    # Avançar para próximo pixel
    addi t0, t0, 4               # VRAM: próximo pixel
    addi t1, t1, 4               # Sprite: próximo pixel
    addi t3, t3, 4               # Incrementar contador de bytes
    
    # Verificar se terminou a linha
    blt t3, t4, PRINT_LOOP       # Se não terminou linha, continuar
    
    # ===== 6. PREPARAR PRÓXIMA LINHA =====
    
    # Retornar ao início da linha na VRAM e descer uma linha
    addi t0, t0, SCREEN_WIDTH    # Descer para próxima linha (320 bytes)
    sub t0, t0, t4               # Voltar ao início da linha (subtrair largura do sprite)
    
    # Resetar contador de bytes na linha
    mv t3, zero
    
    # Incrementar contador de linhas
    addi t2, t2, 1
    
    # Verificar se terminou todas as linhas
    bgt t5, t2, PRINT_LOOP       # Se ainda há linhas, continuar
    
    # ===== 7. FINALIZAR =====
    ret

#########################################################
# EXEMPLO DE USO:
#
# Para desenhar jogador na posição (160, 120) no frame 0:
#
#   la a0, char          # Carregar sprite do personagem
#   li a1, 160           # X = 160
#   li a2, 120           # Y = 120
#   li a3, 0             # Frame 0
#   call PRINT
#
#########################################################

#########################################################
# NOTAS SOBRE A FUNÇÃO PRINT:
#
# 1. BITMAP DISPLAY:
#    O jogo usa "Bitmap Display" do RARS/Mars:
#    - Cada pixel = 4 bytes (RGBA: Red, Green, Blue, Alpha)
#    - Resolução: 320x240 pixels
#    - Total: 307,200 bytes por frame
#
# 2. DOUBLE BUFFERING:
#    Dois frames (buffers) são alternados:
#    - Frame 0 = 0xFF000000
#    - Frame 1 = 0xFF100000
#    - Evita flickering (tremulação visual)
#
# 3. COORDENADAS:
#    - (0, 0) = canto superior esquerdo
#    - X cresce para direita (0-319)
#    - Y cresce para baixo (0-239)
#
# 4. CÁLCULO DE ENDEREÇO:
#    Endereço = base_frame + (Y * largura_tela) + X
#    - base_frame: 0xFF000000 ou 0xFF100000
#    - largura_tela: 320 bytes (já considera 4 bytes/pixel)
#
# 5. FORMATO DE SPRITE:
#    Sprites são arrays de pixels:
#    - Header: largura (bytes) e altura (pixels)
#    - Dados: sequência de valores RGBA
#    - Organizados linha por linha
#
# 6. PERFORMANCE:
#    - Loop otimizado (mínimas operações por pixel)
#    - Sem validação de limites (responsabilidade do chamador)
#    - Copia blocos de 4 bytes (lw/sw) em vez de bytes individuais
#
# 7. LIMITAÇÕES:
#    - Não suporta transparência (todos os pixels são opacos)
#    - Não suporta rotação ou escala
#    - Não faz clipping (recorte em bordas)
#
# 8. EXTENSÕES POSSÍVEIS:
#    Para adicionar transparência:
#    
#    PRINT_TRANSPARENT:
#        lw t6, 0(t1)             # Ler pixel
#        li t7, 0x00FF00FF        # Cor transparente (magenta)
#        beq t6, t7, SKIP_PIXEL   # Se transparente, pular
#        sw t6, 0(t0)             # Escrever pixel
#        SKIP_PIXEL:
#        addi t0, t0, 4
#        addi t1, t1, 4
#        # ... resto do loop
#
# 9. DEBUGGING:
#    Se sprites não aparecem:
#    - Verificar se coordenadas estão dentro da tela (0-319, 0-239)
#    - Confirmar que sprite tem header correto
#    - Testar com sprite simples (quadrado colorido)
#    - Verificar configuração do Bitmap Display no simulador
#
# 10. SPRITE CREATION:
#     Para criar novos sprites, use ferramenta externa e converta para:
#     
#     sprite_name:
#     .word 64, 16           # 64 bytes largura (16 pixels * 4), 16 pixels altura
#     .word 0xFF0000FF       # Pixel vermelho
#     .word 0xFF0000FF       # Pixel vermelho
#     # ... 254 pixels mais
#########################################################