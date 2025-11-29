#########################################################
# Universidade de Brasília
# The legend of Samara 
#########################################################

.data

# ============ CONFIGURAÇÕES ============
.eqv frame_rate 60   # Define que o jogo roda a 60 FPS

# ============ ESTADO DO JOGO ============
TEMPO_DE_EXECUCAO:     .word 0  # Guarda o tempo do último frame
VIDAS:        .word 3           # Começa com 3 vidas
INVULNERAVEL: .word 0           # Contador de invencibilidade (tempo piscando)
VELO_SAMARA: .word 4            # Velocidade da boneca (pixels por frame)
SAMARA_FRAME_ANIMACAO: .word char  # # Guarda o endereço de memória atual do sprite (começa no início de 'char')
SAMARA_ANIM_CONT: .word 0     # Contador para não trocar frame rápido demais

# Timer para inimigos (Independente)
TEMP_RIVAL:  .word 0            # Cronômetro interno dos bichos
LAG_RIVAL:   .word 3            # Os bichos só andam a cada 3 frames (pra não ficarem muito rápidos)

# ============ ITENS (BAÚS) ============
# Estrutura: X, Y, Ativo (1 = sim, 0 = não)
ITEM_VELO: .half 280, 40, 1   # Azul - Baú de Velocidade
ITEM_VIDA: .half 32, 200, 1   # Amarelo - Baú de Vida

# ============ ENTIDADES ============
# Jogador
SAMARA_POS:   .half 160,120   # Posição atual X, Y
SAMARA_F0:    .half 160,120   # Posição no Frame 0 (pra limpar rastro)
SAMARA_F1:    .half 160,120   # Posição no Frame 1 (pra limpar rastro)

# Slime 1 (Diagonal) - BISPO
BISPO_POS:     .half 240,60
BISPO_F0:      .half 240,60
BISPO_F1:      .half 240,60
BISPO_X:   .word -4           # Velocidade horizontal
BISPO_Y:   .word 4            # Velocidade vertical

# Slime 2 (Reto) - CASTELO
CASTELO_POS:     .half 200,100
CASTELO_F0:      .half 200,100
CASTELO_F1:      .half 200,100
CASTELO_X:     .word 4        # Só anda de lado

# Slime 3 (L-Shape) - CAVALO
CAVALO_POS:     .half 80,140
CAVALO_F0:      .half 80,140
CAVALO_F1:      .half 80,140
CAVALO_STATE:   .word 0       # 0 = andando em Y, 1 = andando em X (Máquina de estados)
CAVALO_CONT:   .word 0        # Contador de passos antes de virar
CAVALO_X:   .word 4
CAVALO_Y:   .word 4

# ============ MAPA DE COLISÃO ============
# 0 = chão, 1 = parede (Mapa simples pra lógica futura)
LEVEL_HIT_MAP:
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 

.text

#########################################################
# SETUP
#########################################################
SETUP:
    # --- Reseta as Vidas pra 3 ---
    la t0, VIDAS
    li t1, 3
    sw t1, 0(t0)
    
    # --- Reseta a Velocidade pro padrão ---
    la t0, VELO_SAMARA
    li t1, 4
    sw t1, 0(t0)
    
    # --- RESET DA ANIMAÇÃO TBM ---
    la t0, SAMARA_FRAME_ANIMACAO
    la t1, char           # Carrega o endereço do início do arquivo de sprite
    sw t1, 0(t0)          # Salva na variável para começar do frame 0

    # --- Zera o timer dos inimigos ---
    la t0, TEMP_RIVAL
    sw zero, 0(t0)

    # --- Limpa os dois frames (buffer duplo) pra não ter lixo na tela ---
    li s0, 0
    call LIMPAR_TELA_TOTAL
    li s0, 1
    call LIMPAR_TELA_TOTAL
    
    # --- Pega o tempo inicial do sistema ---
    li s0, 0          # Começa no frame 0
    li a7, 30         # Syscall de tempo
    ecall
    la t0, TEMPO_DE_EXECUCAO
    sw a0, 0(t0)      # Salva o tempo atual
    
    j GAME_LOOP       # Bora pro jogo!

# Função auxiliar pra desenhar o mapa limpo
LIMPAR_TELA_TOTAL:
    la a0, map        # Endereço da imagem do mapa
    li a1, 0          # X = 0
    li a2, 0          # Y = 0
    mv a3, s0         # Qual frame (0 ou 1)
    j IMPRIMIR_TELA_CHEIA 

#########################################################
# GAME LOOP
#########################################################
GAME_LOOP:
    # --- Controle de FPS (Trava em 60) ---
    li a7, 30         # Pega tempo atual
    ecall
    la t0, TEMPO_DE_EXECUCAO
    lw t1, 0(t0)
    sub t1, a0, t1    # Calcula quanto tempo passou
    li t2, frame_rate
    blt t1, t2, GAME_LOOP # Se passou pouco tempo, espera (loop)
    sw a0, 0(t0)      # Atualiza o tempo do último frame
    
    # --- 1. LIMPEZA DO FRAME ATUAL ---
    # Aqui a gente redesenha o mapa por cima de tudo pra "apagar" o frame antigo
    call LIMPAR_TELA_TOTAL
    j LOGICA_JOGO
    
    LOGICA_JOGO:
    # --- 2. LÓGICA ---
    
    # Verifica o teclado (WASD)
    call VERIFICAR_ENTRADA
    
    # Move os inimigos (tem timer próprio pra serem mais lentos)
    call ATUALIZAR_INIMIGOS
    
    # Checa se bateu em parede, item ou bicho
    call VERIFICAR_COLISOES
    
    # Se vidas <= 0, já era
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, GAME_OVER

    # --- 3. RENDERIZAÇÃO ---
    # Desenha bonecos e baús
    call DESENHAR_TUDO
    # Desenha o HUD (corações/chaves)
    call DESENHAR_VIDAS

    # --- 4. ATUALIZAR HISTÓRICO ---
    # Salva onde estava pra saber o que apagar no próximo frame
    bnez s0, ATUALIZA_HIST_F1
    call ATUALIZAR_HISTORICO_F0
    j TROCA_FRAME
    
    ATUALIZA_HIST_F1:
    call ATUALIZAR_HISTORICO_F1

    TROCA_FRAME:
        li t0, 0xFF200604  # Endereço que troca o frame exibido
        sw s0, 0(t0)       # Manda exibir o frame s0
        xori s0, s0, 1     # Inverte s0 (se é 0 vira 1, se é 1 vira 0)

    # Limpa a tela pro próximo round e repete
    call LIMPAR_TELA_TOTAL
    j GAME_LOOP

#########################################################
# TELA DE GAME OVER
#########################################################
GAME_OVER:
    # Desenha a tela de derrota nos dois frames pra garantir
    li s0, 0
    la a0, Game_Over_Menu
    call IMPRIMIR_TELA_CHEIA
    li s0, 1
    la a0, Game_Over_Menu
    call IMPRIMIR_TELA_CHEIA

    AGUARDAR_ENTRADA:
        li t1, 0xFF200000  # Endereço do teclado
        lw t0, 0(t1)       # Verifica se tem tecla
        andi t0, t0, 1
        beqz t0, AGUARDAR_ENTRADA
        lw t2, 4(t1)       # Pega a tecla
        
        li t0, 'r'
        beq t2, t0, SETUP  # Se apertar 'r', reinicia
        li t0, 'q'
        beq t2, t0, FIM_DO_JOGO # Se apertar 'q', sai
        j AGUARDAR_ENTRADA

FIM_DO_JOGO:
    li a7, 10
    ecall                  # Encerra o programa

# Rotina rápida pra pintar a tela inteira (background)
IMPRIMIR_TELA_CHEIA:
    li t0, 0xFF0
    add t0, t0, s0
    slli t0, t0, 20        # Calcula endereço do buffer de vídeo
    addi t1, a0, 8         # Pula cabeçalho da imagem (w, h)
    li t2, 0       
    li t3, 76800           # 320x240 pixels = 76800 bytes
    LOOP_TELA_CHEIA:
        lw t4, 0(t1)
        sw t4, 0(t0)       # Copia pixel por pixel (word por word na real)
        addi t0, t0, 4
        addi t1, t1, 4
        addi t2, t2, 1
        blt t2, t3, LOOP_TELA_CHEIA
    ret

#########################################################
# FUNÇÕES GRÁFICAS
#########################################################

DESENHAR_TUDO:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- 1. AS PAREDES VÊM PRIMEIRO ---
    call DESENHAR_CENARIO_HITBOX 

    # --- 2. DEPOIS OS ITENS ---
    la t0, ITEM_VELO
    lh t1, 4(t0)
    beqz t1, VERIFICAR_VIDA
    la a0, ITEM_VELO
    la a3, ChestB
    call DESENHAR_POSICAO
    
    VERIFICAR_VIDA:
    la t0, ITEM_VIDA
    lh t1, 4(t0)
    beqz t1, DESENHAR_ENTIDADES
    la a0, ITEM_VIDA
    la a3, ChestY
    call DESENHAR_POSICAO

    DESENHAR_ENTIDADES:
    # --- 3. DEPOIS O JOGADOR ---
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    andi t1, t1, 4
    bnez t1, PULAR_JOGADOR
    la a0, SAMARA_POS
    la t0, SAMARA_FRAME_ANIMACAO
    lw a3, 0(t0)            # Carrega o quadro atual (char + offset)
    call DESENHAR_POSICAO
    PULAR_JOGADOR:

    # --- 4. POR ÚLTIMO OS INIMIGOS ---
    la a0, BISPO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    la a0, CASTELO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    la a0, CAVALO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# ==========================================
# FUNÇÃO SEPARADA: DESENHA PAREDES
# ==========================================
DESENHAR_CENARIO_HITBOX:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, LEVEL_HIT_MAP    # Endereço do mapa
    li t1, 0                # Contador de índice (0 a 299)
    li t2, 300              # Total de tiles (20x15 = 300)

    LOOP_DESENHA_MAPA:
        beq t1, t2, FIM_DESENHA_MAPA # Acabou o array?
        
        lb t3, 0(t0)        # Lê o byte (0 ou 1)
        beqz t3, PROXIMO_TILE # Se for 0, pula

        # Calcula X e Y
        li t4, 20
        rem a1, t1, t4      # Coluna
        slli a1, a1, 4      # X = Coluna * 16
        
        div a2, t1, t4      # Linha
        slli a2, a2, 4      # Y = Linha * 16

        # IMPORTANTE: Use um sprite pequeno (16x16) aqui. 
        # Se 'tile' for o fundo grande, vai travar o jogo.
        # Se não tiver 'wall', use 'tile' mas garanta que ele é 16x16.
        la a0, tile          
        mv a3, s0           
        
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        
        call IMPRIMIR
        
        lw t0, 0(sp)
        lw t1, 4(sp)
        lw t2, 8(sp)
        addi sp, sp, 12

    PROXIMO_TILE:
        addi t0, t0, 1
        addi t1, t1, 1
        j LOOP_DESENHA_MAPA

    FIM_DESENHA_MAPA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

    # --- Desenha Baú de Velocidade (se não pegou ainda) ---
    la t0, ITEM_VELO
    lh t1, 4(t0)           # Verifica flag 'ativo'
    beqz t1, VERIFICAR_VIDA
    la a0, ITEM_VELO
    la a3, ChestB
    call DESENHAR_POSICAO
    
    VERIFICAR_VIDA:
    # --- Desenha Baú de Vida (se não pegou ainda) ---
    la t0, ITEM_VIDA
    lh t1, 4(t0)
    beqz t1, DESENHAR_ENTIDADES
    la a0, ITEM_VIDA
    la a3, ChestY
    call DESENHAR_POSICAO

    DESENHAR_ENTIDADES:
    # --- Desenha Jogador (com efeito de piscar se invulnerável) ---
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    andi t1, t1, 4         # Truque: só desenha se o bit 2 for 0 (faz piscar)
    bnez t1, PULAR_JOGADOR
    la a0, SAMARA_POS
    la a3, char
    call DESENHAR_POSICAO
    PULAR_JOGADOR:

    # --- Desenha os inimigos ---
    la a0, BISPO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    la a0, CASTELO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    la a0, CAVALO_POS
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Função não usada no loop principal, mas útil se precisar apagar só um pedaço
RESTAURAR_FUNDO:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile
    mv a3, s0
    call IMPRIMIR
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Helper pra desenhar sprite na posição X,Y da memória
DESENHAR_POSICAO:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)    # a1 = x
    lh a2, 2(a0)    # a2 = y
    mv a0, a3       # a0 = sprite
    mv a3, s0       # qual frame
    call IMPRIMIR
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Desenha o HUD (Vidas no topo esquerdo)
DESENHAR_VIDAS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # 1. Apaga os corações antigos (desenha fundo do mapa neles)
    la a0, tile
    li a1, 10
    li a2, 10
    mv a3, s0
    call IMPRIMIR
    li a1, 28
    li a2, 10
    mv a3, s0
    call IMPRIMIR
    li a1, 46
    li a2, 10
    mv a3, s0
    call IMPRIMIR
    
    # 2. Desenha quantos corações restam
    la t0, VIDAS
    lw t0, 0(t0)
    li a1, 10
    li a2, 10
    mv a3, s0
    la a0, KeyB     # Sprite da "vida" (Chave/Coração)
    
    LOOP_VIDAS:
        blez t0, FIM_DESENHAR_VIDAS
        # Salva registradores antes de chamar IMPRIMIR
        addi sp, sp, -12
        sw a1, 0(sp)
        sw a2, 4(sp)
        sw t0, 8(sp)
        
        call IMPRIMIR
        
        lw a1, 0(sp)
        lw a2, 4(sp)
        lw t0, 8(sp)
        addi sp, sp, 12
        
        addi a1, a1, 18  # Avança X pro próximo coração
        addi t0, t0, -1
        j LOOP_VIDAS

    FIM_DESENHAR_VIDAS:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

#########################################################
# ATUALIZAÇÃO HISTÓRICO
# (Salva onde estava pra limpar depois)
#########################################################
ATUALIZAR_HISTORICO_F0:
    la t0, SAMARA_POS
    lw t1, 0(t0)
    la t2, SAMARA_F0
    sw t1, 0(t2)
    la t0, BISPO_POS
    lw t1, 0(t0)
    la t2, BISPO_F0
    sw t1, 0(t2)
    la t0, CASTELO_POS
    lw t1, 0(t0)
    la t2, CASTELO_F0
    sw t1, 0(t2)
    la t0, CAVALO_POS
    lw t1, 0(t0)
    la t2, CAVALO_F0
    sw t1, 0(t2)
    ret

ATUALIZAR_HISTORICO_F1:
    la t0, SAMARA_POS
    lw t1, 0(t0)
    la t2, SAMARA_F1
    sw t1, 0(t2)
    la t0, BISPO_POS
    lw t1, 0(t0)
    la t2, BISPO_F1
    sw t1, 0(t2)
    la t0, CASTELO_POS
    lw t1, 0(t0)
    la t2, CASTELO_F1
    sw t1, 0(t2)
    la t0, CAVALO_POS
    lw t1, 0(t0)
    la t2, CAVALO_F1
    sw t1, 0(t2)
    ret

#########################################################
# COLISÃO E ITENS
#########################################################
VERIFICAR_COLISOES:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- Checa Itens ---
    la a0, SAMARA_POS
    la a1, ITEM_VELO
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, PEGAR_ITEM_VELOCIDADE
    
    la a0, SAMARA_POS
    la a1, ITEM_VIDA
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, PEGAR_ITEM_VIDA
    j VERIFICAR_DANO

    PEGAR_ITEM_VELOCIDADE:
        la t0, ITEM_VELO
        lh t1, 4(t0)
        beqz t1, VERIFICAR_DANO   # Se já pegou, ignora
        li t1, 0
        sh t1, 4(t0)              # Marca como pego (0)
        call TOCAR_SOM_COLETA
        la a0, ITEM_VELO
        call LIMPAR_FUNDO_ITEM
        la t0, VELO_SAMARA
        li t1, 8                  # Dobra a velocidade!
        sw t1, 0(t0)
        j VERIFICAR_DANO

    PEGAR_ITEM_VIDA:
        la t0, ITEM_VIDA
        lh t1, 4(t0)
        beqz t1, VERIFICAR_DANO
        li t1, 0
        sh t1, 4(t0)              # Marca como pego
        call TOCAR_SOM_COLETA
        la a0, ITEM_VIDA
        call LIMPAR_FUNDO_ITEM
        la t0, VIDAS
        lw t1, 0(t0)
        addi t1, t1, 1            # Vida +1
        sw t1, 0(t0)

    # --- Checa Dano (Inimigos) ---
    VERIFICAR_DANO:
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    blez t1, FAZER_VERIFICACAO    # Se timer > 0, tá invencível
    addi t1, t1, -1               # Diminui timer
    sw t1, 0(t0)
    j FIM_COLISOES

    FAZER_VERIFICACAO:
    la a0, SAMARA_POS
    la a1, BISPO_POS
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO
    la a0, SAMARA_POS
    la a1, CASTELO_POS
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO
    la a0, SAMARA_POS
    la a1, CAVALO_POS
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO
    j FIM_COLISOES

    RECEBEU_DANO:
    la t0, VIDAS
    lw t1, 0(t0)
    addi t1, t1, -1       # Perde vida
    sw t1, 0(t0)
    la t0, INVULNERAVEL
    li t1, 60             # Fica 1s (60 frames) invencível
    sw t1, 0(t0)

    FIM_COLISOES:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Apaga o item da tela desenhando chão (0) e parede (1) em volta?
# (A lógica aqui tá meio hardcoded pra limpar a área do item)
LIMPAR_FUNDO_ITEM:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile
    li a3, 0
    call IMPRIMIR
    li a3, 1
    call IMPRIMIR
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Lógica AABB (Axis-Aligned Bounding Box)
# Verifica se dois retângulos se sobrepõem
VERIFICAR_COLISAO_CAIXA:
    lh t0, 0(a0)  # X1
    lh t1, 2(a0)  # Y1
    lh t2, 0(a1)  # X2
    lh t3, 2(a1)  # Y2
    li t4, 14     # Tamanho da caixa de colisão
    
    add t5, t2, t4
    bge t0, t5, SEM_COLISAO  # X1 >= X2 + Tam (tá à direita)
    add t5, t0, t4
    ble t5, t2, SEM_COLISAO  # X1 + Tam <= X2 (tá à esquerda)
    add t5, t3, t4
    bge t1, t5, SEM_COLISAO  # Y1 >= Y2 + Tam (tá abaixo)
    add t5, t1, t4
    ble t5, t3, SEM_COLISAO  # Y1 + Tam <= Y2 (tá acima)
    li a0, 1      # Bateu!
    ret
    SEM_COLISAO: 
    li a0, 0      # Não bateu
    ret
# ==========================================
# VERIFICAR SE PIXEL ESTÁ EM PAREDE
# Entrada: a0 = X, a1 = Y
# Saída: a0 = 1 (Bateu), 0 (Livre)
# ==========================================
CHECK_MAP_COLLISION:
    # Converter Pixel para Grid (Dividir por 16 é shift right 4)
    srli t0, a0, 4      # Coluna = X / 16
    srli t1, a1, 4      # Linha = Y / 16
    
    # Proteção de índices (pra não sair do array)
    li t2, 20
    bge t0, t2, DEU_COLISAO # X fora do mapa
    li t2, 15
    bge t1, t2, DEU_COLISAO # Y fora do mapa

    # Calcular Índice no Array: (Linha * 20) + Coluna
    li t2, 20
    mul t1, t1, t2      # Linha * 20
    add t0, t0, t1      # + Coluna
    
    la t3, LEVEL_HIT_MAP
    add t3, t3, t0      # Endereço Base + Offset
    lb t4, 0(t3)        # Carrega o valor (0 ou 1)
    
    mv a0, t4           # Retorna o valor
    ret

    DEU_COLISAO:
    li a0, 1
    ret

# =========================================================
# VERIFICAR ENTRADA (COM COLISÃO E ANIMAÇÃO INTEGRADA)
# =========================================================
VERIFICAR_ENTRADA:
    # 1. Salvar RA na pilha
    addi sp, sp, -4
    sw ra, 0(sp)

    # Verifica se há tecla pressionada
    li t1, 0xFF200000
    lw t0, 0(t1)
    andi t0, t0, 1
    beqz t0, RETORNAR_ENTRADA
    lw t2, 4(t1)
    
    # Carrega velocidade
    la t0, VELO_SAMARA
    lw t3, 0(t0)
    
    li t6, 0    # <--- FLAG: 0 = Parado, 1 = Andou
    
    # Verifica qual tecla foi apertada
    li t0, 'w'
    beq t2, t0, MOVER_CIMA
    li t0, 's'
    beq t2, t0, MOVER_BAIXO
    li t0, 'a'
    beq t2, t0, MOVER_ESQUERDA
    li t0, 'd'
    beq t2, t0, MOVER_DIREITA
    j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # MOVIMENTO CIMA (W)
    # -----------------------------------------------------
    MOVER_CIMA: 
        la t0, SAMARA_POS
        lh t2, 0(t0)      # X atual
        lh t1, 2(t0)      # Y atual
        sub t1, t1, t3    # Y Futuro
        
        # -- Salva contexto antes da colisão --
        addi sp, sp, -16
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        sw t3, 12(sp)

        # Checa Canto Superior Esquerdo
        mv a0, t2
        mv a1, t1
        call CHECK_MAP_COLLISION
        mv t5, a0 

        # Checa Canto Superior Direito
        lw t2, 8(sp)
        mv a0, t2
        addi a0, a0, 14   # +14 pixels (largura do boneco)
        lw a1, 4(sp)
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECK_MAP_COLLISION
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0     # Se bateu em qualquer um dos dois, t5 = 1

        # -- Restaura contexto --
        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        # Se bateu (t5 != 0), sai sem salvar e sem animar
        bnez t5, RETORNAR_ENTRADA 
        
        # Se livre:
        sh t1, 2(t0)      # Salva novo Y na memória
        li t6, 1          # <--- MARCA QUE ANDOU!
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO BAIXO (S)
    # -----------------------------------------------------
    MOVER_BAIXO: 
        la t0, SAMARA_POS
        lh t2, 0(t0)
        lh t1, 2(t0)
        add t1, t1, t3
        
        addi sp, sp, -16
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        sw t3, 12(sp)

        # Checa Canto Inferior Esquerdo
        mv a0, t2
        mv a1, t1
        addi a1, a1, 14   # +14 pixels (pé do boneco)
        call CHECK_MAP_COLLISION
        mv t5, a0

        # Checa Canto Inferior Direito
        lw t2, 8(sp)
        mv a0, t2
        addi a0, a0, 14
        lw a1, 4(sp)
        addi a1, a1, 14
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECK_MAP_COLLISION
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 2(t0)
        li t6, 1          # <--- MARCA QUE ANDOU!
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO ESQUERDA (A)
    # -----------------------------------------------------
    MOVER_ESQUERDA: 
        la t0, SAMARA_POS
        lh t1, 0(t0)
        lh t2, 2(t0)
        sub t1, t1, t3
        
        addi sp, sp, -16
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        sw t3, 12(sp)

        # Checa Canto Superior Esquerdo
        mv a0, t1
        mv a1, t2
        call CHECK_MAP_COLLISION
        mv t5, a0

        # Checa Canto Inferior Esquerdo
        lw t1, 4(sp)
        mv a0, t1
        lw t2, 8(sp)
        mv a1, t2
        addi a1, a1, 14
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECK_MAP_COLLISION
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        li t6, 1          # <--- MARCA QUE ANDOU!
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO DIREITA (D)
    # -----------------------------------------------------
    MOVER_DIREITA: 
        la t0, SAMARA_POS
        lh t1, 0(t0)
        lh t2, 2(t0)
        add t1, t1, t3
        
        addi sp, sp, -16
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        sw t3, 12(sp)

        # Checa Canto Superior Direito
        mv a0, t1
        addi a0, a0, 14
        mv a1, t2
        call CHECK_MAP_COLLISION
        mv t5, a0

        # Checa Canto Inferior Direito
        lw t1, 4(sp)
        mv a0, t1
        addi a0, a0, 14
        lw t2, 8(sp)
        mv a1, t2
        addi a1, a1, 14
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECK_MAP_COLLISION
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        li t6, 1          # <--- MARCA QUE ANDOU!
        j PROCESSAR_ANIMACAO
    
    # -----------------------------------------------------
    # LÓGICA DE ANIMAÇÃO
    # -----------------------------------------------------
    PROCESSAR_ANIMACAO:
        beqz t6, RETORNAR_ENTRADA  # Se t6 for 0 (parado), não anima
        call ATUALIZAR_FRAME       # Se t6 for 1 (andou), troca o frame

    RETORNAR_ENTRADA:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

# ==========================================
# FUNÇÃO DE ANIMAÇÃO (CORRIGIDA)
# ==========================================
ATUALIZAR_FRAME:
    # 1. Verifica Timer (Velocidade da Animação)
    la t0, SAMARA_ANIM_CONT
    lw t1, 0(t0)
    addi t1, t1, 1
    li t2, 2                  # <--- VELOCIDADE: Aumente se estiver muito rápido
    sw t1, 0(t0)
    blt t1, t2, RET_ANIM      
    
    sw zero, 0(t0)            # Reseta timer

    # 2. Carrega Endereço do Frame Atual
    la t0, SAMARA_FRAME_ANIMACAO
    lw t1, 0(t0)              

    # 3. Avança o Ponteiro (CORREÇÃO DE TAMANHO)
    # Pula 264 bytes (16x16 pixels + Header)
    addi t1, t1, 264          

    # 4. Verifica Limite (Loop)
    la t2, char               
    addi t2, t2, 1056         # Limite = 264 bytes * 4 frames
    
    blt t1, t2, SAVE_FRAME    
    
    # Se passou do limite, volta para o começo (Frame 0)
    la t1, char

    SAVE_FRAME:
    sw t1, 0(t0)              
    
    RET_ANIM:
    ret

# ATUALIZAÇÃO DE INIMIGOS (INDEPENDENTE)
ATUALIZAR_INIMIGOS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # --- Controle de Delay dos Inimigos ---
    la t0, TEMP_RIVAL
    lw t1, 0(t0)
    addi t1, t1, 1
    la t2, LAG_RIVAL
    lw t2, 0(t2)
    bge t1, t2, EXECUTAR_MOVIMENTO # Só move se estourou o timer
    
    sw t1, 0(t0)
    j FIM_ATUALIZAR_INIMIGOS
    
    EXECUTAR_MOVIMENTO:
    sw zero, 0(t0) # Reseta timer
    
    call MOVER_CAVALO
    call MOVER_CASTELO
    call MOVER_BISPO
    
    FIM_ATUALIZAR_INIMIGOS:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# CAVALO 
MOVER_CAVALO:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Carrega Estado e Contador
    la a1, CAVALO_STATE
    la a2, CAVALO_CONT
    lw t0, 0(a1)        # t0 = Estado (0=Y, 1=X)
    lw t1, 0(a2)        # t1 = Contador de passos
    
    # Decide se move X ou Y
    bnez t0, CAVALO_MOVER_Y 

    # ========================
    # MOVIMENTO EIXO X (Estado 0)
    # ========================
    CAVALO_MOVER_X:
        la t6, CAVALO_X
        lw t3, 0(t6)        # t3 = Vel X
        la a0, CAVALO_POS
        lh t4, 0(a0)        # t4 = X Atual
        add t4, t4, t3      # t4 = X Futuro
        
        # --- COLISÃO X ---
        # Salva t0 (Estado) e t1 (Contador) na pilha para não perder
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t4, 8(sp) # Salva X Futuro

        # Prepara Check
        mv a0, t4
        blt t3, zero, CHK_C_X_ESQ
        addi a0, a0, 14     # Se direita, checa lado direito
        CHK_C_X_ESQ:
        la t2, CAVALO_POS
        lh a1, 2(t2)        # Y Atual
        addi a1, a1, 8      # Meio da altura
        call CHECK_MAP_COLLISION
        
        # O resultado da colisão está em a0
        mv t5, a0 

        # Restaura
        lw t4, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12

        # Se bateu parede (t5=1), trata colisão
        bnez t5, CAVALO_BATEU_X
        
        # Se bateu borda tela, trata colisão
        li t2, 296
        bge t4, t2, CAVALO_BATEU_X
        li t2, 8
        blt t4, t2, CAVALO_BATEU_X
        
        # --- MOVIMENTO LIVRE ---
        la a0, CAVALO_POS
        sh t4, 0(a0)        # Atualiza X
        
        addi t1, t1, 1      # Incrementa contador
        li t2, 30
        blt t1, t2, CAVALO_SAIR # Se < 30, só sai
        
        # Timer estourou: Troca Eixo
        li t1, 0            # Zera contador
        li t0, 1            # Muda estado para Y
        j CAVALO_SALVAR_ESTADO
        
        # --- BATEU ---
        CAVALO_BATEU_X: 
        la t6, CAVALO_X
        lw t3, 0(t6)
        sub t3, zero, t3    # Inverte Vel
        sw t3, 0(t6)
        
        li t1, 0            # Zera contador
        li t0, 1            # Força troca para Y
        j CAVALO_SALVAR_ESTADO

    # ========================
    # MOVIMENTO EIXO Y (Estado 1)
    # ========================
    CAVALO_MOVER_Y:
        la t5, CAVALO_Y
        lw t3, 0(t5)        # t3 = Vel Y
        la a0, CAVALO_POS
        lh t4, 2(a0)        # t4 = Y Atual
        add t4, t4, t3      # t4 = Y Futuro
        
        # --- COLISÃO Y ---
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t4, 8(sp)

        # Prepara Check
        la t2, CAVALO_POS
        lh a0, 0(t2)        # X Atual
        addi a0, a0, 8      # Meio da largura
        mv a1, t4           # Y Futuro
        blt t3, zero, CHK_C_Y_CIMA
        addi a1, a1, 14     # Se baixo, checa pé
        CHK_C_Y_CIMA:
        call CHECK_MAP_COLLISION
        
        mv t5, a0           # Resultado

        lw t4, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12

        # Colisões
        bnez t5, CAVALO_BATEU_Y
        li t2, 216
        bge t4, t2, CAVALO_BATEU_Y
        li t2, 8
        blt t4, t2, CAVALO_BATEU_Y
        
        # --- MOVIMENTO LIVRE ---
        la a0, CAVALO_POS
        sh t4, 2(a0)        # Atualiza Y
        
        addi t1, t1, 1
        li t2, 30
        blt t1, t2, CAVALO_SAIR
        
        # Timer estourou: Troca Eixo
        li t1, 0
        li t0, 0            # Muda estado para X
        j CAVALO_SALVAR_ESTADO

        # --- BATEU ---
        CAVALO_BATEU_Y:
        la t5, CAVALO_Y
        lw t3, 0(t5)
        sub t3, zero, t3
        sw t3, 0(t5)
        
        li t1, 0
        li t0, 0            # Força troca para X
        j CAVALO_SALVAR_ESTADO

    # ========================
    # SALVAR E SAIR
    # ========================
    CAVALO_SALVAR_ESTADO: 
    la a1, CAVALO_STATE
    sw t0, 0(a1)        # Salva novo Estado
    # Cai no salvar contador...

    CAVALO_SAIR:
    la a2, CAVALO_CONT
    sw t1, 0(a2)        # Salva novo Contador
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
# CASTELO 
MOVER_CASTELO:
    addi sp, sp, -4
    sw ra, 0(sp)      # 1. Salva o retorno (RA)

    la a0, CASTELO_POS
    la a1, CASTELO_X
    lh t0, 0(a0)      # X Atual
    lw t2, 0(a1)      # Velocidade
    add t0, t0, t2    # X Futuro (Tentativa)

    # --- CHECK 1: Canto Esquerdo (X_Futuro, Y) ---
    # Salva registradores importantes antes de chamar função
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t2, 4(sp)
    sw a0, 8(sp)
    sw a1, 12(sp)

    mv a0, t0           # Argumento X: X Futuro
    la t5, CASTELO_POS
    lh a1, 2(t5)        # Argumento Y: Y Atual
    addi a1, a1, 8      # (+8) Pega o meio da altura pra não prender no chão
    call CHECK_MAP_COLLISION
    mv t5, a0           # t5 = Resultado Check 1

    # --- CHECK 2: Canto Direito (X_Futuro + 14, Y) ---
    lw t0, 0(sp)        # Recupera X Futuro da pilha
    mv a0, t0
    addi a0, a0, 14     # Checa o lado direito (largura do sprite)
    la t6, CASTELO_POS
    lh a1, 2(t6)
    addi a1, a1, 8      # Altura média
    
    # Salva t5 na pilha rapidinho
    addi sp, sp, -4
    sw t5, 0(sp)
    call CHECK_MAP_COLLISION
    lw t5, 0(sp)
    addi sp, sp, 4

    or t5, t5, a0       # t5 = (Bateu Esq) OU (Bateu Dir)

    # Restaura tudo da pilha
    lw a1, 12(sp)
    lw a0, 8(sp)
    lw t2, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    # Se bateu no mapa (t5 != 0), inverte a direção
    bnez t5, INVERTER_CASTELO

    # Check Bordas da Tela (Segurança extra)
    li t3, 296
    bge t0, t3, INVERTER_CASTELO
    li t3, 8
    blt t0, t3, INVERTER_CASTELO
    
    sh t0, 0(a0) # Se livre, salva movimento
    
    lw ra, 0(sp)      # Restaura RA
    addi sp, sp, 4
    ret
    
    INVERTER_CASTELO: 
    sub t2, zero, t2  # Inverte velocidade
    sw t2, 0(a1)
    
    lw ra, 0(sp)      # Restaura RA
    addi sp, sp, 4
    ret

# BISPO 
MOVER_BISPO:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Carrega dados iniciais
    la a0, BISPO_POS
    la a1, BISPO_X
    la a2, BISPO_Y
    lh t0, 0(a0)      # X Atual
    lh t1, 2(a0)      # Y Atual
    lw t2, 0(a1)      # Vel X
    lw t3, 0(a2)      # Vel Y

    # ==========================
    # MOVIMENTO X
    # ==========================
    add t4, t0, t2    # t4 = X Futuro
    
    # Salva contexto na pilha
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)     # Salva X Futuro

    # Prepara Check X
    mv a0, t4         # Testar X Futuro
    blt t2, zero, CHK_B_X
    addi a0, a0, 14   # Se direita, testa borda direita
    CHK_B_X:
    la t6, BISPO_POS
    lh a1, 2(t6)      # Y Atual
    addi a1, a1, 8    # Altura média
    call CHECK_MAP_COLLISION
    mv t5, a0         # t5 = Colidiu?

    # Restaura
    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    # Lógica de Colisão X
    bnez t5, INVERTER_BISPO_X
    
    # Check Bordas Tela X
    li t6, 296
    bge t4, t6, INVERTER_BISPO_X
    li t6, 8
    blt t4, t6, INVERTER_BISPO_X
    
    # Se livre, aceita novo X
    mv t0, t4
    j FIM_BISPO_X

    INVERTER_BISPO_X:
    sub t2, zero, t2  # Inverte Vel X
    la a1, BISPO_X    # <--- RECARREGA ENDEREÇO (Segurança)
    sw t2, 0(a1)      # Salva Vel X
    # t0 continua sendo o X antigo (não anda)

    FIM_BISPO_X:

    # ==========================
    # MOVIMENTO Y
    # ==========================
    add t4, t1, t3    # t4 = Y Futuro
    
    # Salva contexto
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    # Prepara Check Y
    mv a1, t4         # Testar Y Futuro
    blt t3, zero, CHK_B_Y
    addi a1, a1, 14   # Se baixo, testa pé
    CHK_B_Y:
    # Usa o t0 (X já atualizado) para o teste ficar fluido
    mv a0, t0         
    addi a0, a0, 8    # Meio do corpo
    call CHECK_MAP_COLLISION
    mv t5, a0

    # Restaura
    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    # Lógica de Colisão Y
    bnez t5, INVERTER_BISPO_Y
    
    # Check Bordas Tela Y
    li t6, 216
    bge t4, t6, INVERTER_BISPO_Y
    li t6, 8
    blt t4, t6, INVERTER_BISPO_Y
    
    # Se livre, aceita novo Y
    mv t1, t4
    j FIM_BISPO_Y

    INVERTER_BISPO_Y:
    sub t3, zero, t3  # Inverte Vel Y
    la a2, BISPO_Y    # <--- RECARREGA ENDEREÇO
    sw t3, 0(a2)
    # t1 continua sendo o Y antigo

    FIM_BISPO_Y:
    
    # Salva Posição Final
    la a0, BISPO_POS  # <--- RECARREGA ENDEREÇO
    sh t0, 0(a0)
    sh t1, 2(a0)

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
# ==========================================
ATUALIZAR_FRAME:
    # 1. Verifica Timer (Delay de Animação)
    la t0, SAMARA_ANIM_CONT
    lw t1, 0(t0)
    addi t1, t1, 1
    li t2, 2                  
    sw t1, 0(t0)
    blt t1, t2, RET_ANIM      
    
    sw zero, 0(t0)            # Reseta timer

    # 2. Carrega Endereço Atual
    la t0, SAMARA_FRAME_ANIMACAO
    lw t1, 0(t0)              

    # 3. Avança o Ponteiro (CORREÇÃO AQUI)
    # Tamanho real = 256 (pixels) + 8 (header) = 264 bytes
    addi t1, t1, 264          # <--- MUDADO DE 1032 PARA 264

    # 4. Verifica Limite (Loop)
    la t2, char               
    addi t2, t2, 1056         # <--- MUDADO DE 4128 PARA 1056 (264 * 4 frames)
    
    blt t1, t2, SAVE_FRAME    
    
    # Se passou do limite, volta para o começo
    la t1, char

    SAVE_FRAME:
    sw t1, 0(t0)              
    
    RET_ANIM:
    ret
#########################################################
# IMPRIMIR
# Função genérica pra pintar sprite na tela
#########################################################
IMPRIMIR:
    li t0, 0xFF0        # Base do vídeo
    add t0, t0, a3      # + Frame (0 ou 1)
    slli t0, t0, 20     # Shift pra posição correta na memória
    add t0, t0, a1      # + X
    li t1, 320          # Largura da tela
    mul t1, t1, a2
    add t0, t0, t1      # + Y * 320
    addi t1, a0, 8      # Pula header do sprite
    mv t2, zero         # Y do sprite atual
    mv t3, zero         # X do sprite atual
    lw t4, 0(a0)        # Largura do sprite
    lw t5, 4(a0)        # Altura do sprite
LOOP_IMPRIMIR:
    lw t6, 0(t1)        # Carrega cor do pixel
    sw t6, 0(t0)        # Pinta na tela
    addi t0, t0, 4
    addi t1, t1, 4
    addi t3, t3, 4
    blt t3, t4, LOOP_IMPRIMIR # Fim da linha?
    addi t0, t0, 320    # Próxima linha na tela
    sub t0, t0, t4      # Volta pro X inicial
    mv t3, zero
    addi t2, t2, 1
    bgt t5, t2, LOOP_IMPRIMIR # Fim do sprite?
    ret

# INCLUDES
.include "music_ef.asm"
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"