#########################################################
# Universidade de Brasília
# The legend of Samara - VERSÃO FINAL (Português Corrigido)
#########################################################

.data

# ============ CONFIGURAÇÕES ============
.eqv frame_rate 60   # Define que o jogo roda a 60 FPS

# ============ ESTADO DO JOGO ============
TEMPO_DE_EXECUCAO:     .word 0  # Guarda o tempo do último frame
VIDAS:        .word 3           # Começa com 3 vidas
INVULNERAVEL: .word 0           # Contador de invencibilidade (tempo piscando)
VELO_SAMARA: .word 4            # Velocidade da boneca (pixels por frame)

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
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
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

#########################################################
# INPUT E MOVIMENTOS
#########################################################
VERIFICAR_ENTRADA:
    li t1, 0xFF200000  # Endereço MMIO do Teclado
    lw t0, 0(t1)
    andi t0, t0, 1     # Tem tecla apertada?
    beqz t0, RETORNAR_ENTRADA
    lw t2, 4(t1)       # Qual tecla?
    la t0, VELO_SAMARA
    lw t3, 0(t0)       # Carrega velocidade
    
    # Compara ASCII
    li t0, 'w'
    beq t2, t0, MOVER_CIMA
    li t0, 's'
    beq t2, t0, MOVER_BAIXO
    li t0, 'a'
    beq t2, t0, MOVER_ESQUERDA
    li t0, 'd'
    beq t2, t0, MOVER_DIREITA
    j RETORNAR_ENTRADA

    MOVER_CIMA: 
        la t0, SAMARA_POS
        lh t1, 2(t0)
        sub t1, t1, t3
        li t5, 8              # Limite superior da tela
        blt t1, t5, RETORNAR_ENTRADA
        sh t1, 2(t0)
        j RETORNAR_ENTRADA
    MOVER_BAIXO: 
        la t0, SAMARA_POS
        lh t1, 2(t0)
        add t1, t1, t3
        li t5, 216            # Limite inferior
        bgt t1, t5, RETORNAR_ENTRADA
        sh t1, 2(t0)
        j RETORNAR_ENTRADA
    MOVER_ESQUERDA: 
        la t0, SAMARA_POS
        lh t1, 0(t0)
        sub t1, t1, t3
        li t5, 8              # Limite esquerdo
        blt t1, t5, RETORNAR_ENTRADA
        sh t1, 0(t0)
        j RETORNAR_ENTRADA
    MOVER_DIREITA: 
        la t0, SAMARA_POS
        lh t1, 0(t0)
        add t1, t1, t3
        li t5, 296            # Limite direito
        bgt t1, t5, RETORNAR_ENTRADA
        sh t1, 0(t0)
        j RETORNAR_ENTRADA
    
    RETORNAR_ENTRADA:
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

# CAVALO (Movimento em L)
# Lógica: Anda X frames em um eixo, depois troca pro outro eixo
MOVER_CAVALO:
    la a0, CAVALO_POS
    la a1, CAVALO_STATE    # Estado (0 ou 1)
    la a2, CAVALO_CONT     # Contador de passos
    lw t0, 0(a1)
    lw t1, 0(a2)
    la t6, CAVALO_X 
    la t5, CAVALO_Y
    
    bnez t0, CAVALO_MOVER_Y # Se estado != 0, vai pra Y
    
    CAVALO_MOVER_X:
        lw t3, 0(t6) # Vel X
        lh t4, 0(a0)
        add t4, t4, t3
        
        # Checa limites X
        li t2, 296
        bge t4, t2, CAVALO_COLIDIU_X
        li t2, 8
        blt t4, t2, CAVALO_COLIDIU_X
        
        sh t4, 0(a0)       # Salva nova pos
        addi t1, t1, 1
        li t2, 30          # Anda 30 'passos' antes de virar
        blt t1, t2, CAVALO_SALVAR
        # Troca Eixo (vira na esquina)
        li t1, 0           # Reseta contador
        li t0, 1           # Muda estado pra Y
        j CAVALO_SALVAR_ESTADO
        
        CAVALO_COLIDIU_X: 
        sub t3, zero, t3   # Inverte direção
        sw t3, 0(t6)
        li t1, 0           # Reseta contador
        li t0, 1           # Muda pra Y
        j CAVALO_SALVAR_ESTADO

    CAVALO_MOVER_Y:
        lw t3, 0(t5) # Vel Y
        lh t4, 2(a0)
        add t4, t4, t3
        
        # Checa limites Y
        li t2, 216
        bge t4, t2, CAVALO_COLIDIU_Y
        li t2, 8
        blt t4, t2, CAVALO_COLIDIU_Y
        
        sh t4, 2(a0)
        addi t1, t1, 1
        li t2, 30
        blt t1, t2, CAVALO_SALVAR
        # Troca Eixo
        li t1, 0
        li t0, 0           # Muda estado pra X
        j CAVALO_SALVAR_ESTADO

        CAVALO_COLIDIU_Y:
        sub t3, zero, t3
        sw t3, 0(t5)
        li t1, 0
        li t0, 0
        j CAVALO_SALVAR_ESTADO

    CAVALO_SALVAR_ESTADO: 
    sw t0, 0(a1)
    CAVALO_SALVAR: 
    sw t1, 0(a2)
    ret

# CASTELO (Movimento Horizontal - Bate e Volta)
MOVER_CASTELO:
    la a0, CASTELO_POS
    la a1, CASTELO_X
    lh t0, 0(a0)
    lw t2, 0(a1)
    add t0, t0, t2
    li t3, 296
    bge t0, t3, INVERTER_CASTELO # Direita
    li t3, 8
    blt t0, t3, INVERTER_CASTELO # Esquerda
    sh t0, 0(a0)
    ret
    INVERTER_CASTELO: 
    sub t2, zero, t2  # Inverte sinal
    sw t2, 0(a1)
    add t0, t0, t2
    add t0, t0, t2    # Desencalha da parede
    sh t0, 0(a0)
    ret

# BISPO (Movimento Diagonal - Quica nas paredes)
# X e Y são independentes
MOVER_BISPO:
    la a0, BISPO_POS
    la a1, BISPO_X
    la a2, BISPO_Y
    lh t0, 0(a0)      # Pos X
    lh t1, 2(a0)      # Pos Y
    lw t2, 0(a1)      # Vel X
    lw t3, 0(a2)      # Vel Y
    add t0, t0, t2
    add t1, t1, t3
    
    # Checa X
    li t4, 296
    bge t0, t4, INVERTER_BISPO_X
    li t4, 8
    blt t0, t4, INVERTER_BISPO_X
    j VERIFICAR_BISPO_Y
    INVERTER_BISPO_X: 
    sub t2, zero, t2
    sw t2, 0(a1)
    add t0, t0, t2
    add t0, t0, t2
    
    VERIFICAR_BISPO_Y:
    # Checa Y
    li t4, 216
    bge t1, t4, INVERTER_BISPO_Y
    li t4, 8
    blt t1, t4, INVERTER_BISPO_Y
    j SALVAR_BISPO
    INVERTER_BISPO_Y: 
    sub t3, zero, t3
    sw t3, 0(a2)
    add t1, t1, t3
    add t1, t1, t3
    
    SALVAR_BISPO:
    sh t0, 0(a0)
    sh t1, 2(a0)
    ret

#########################################################
# IMPRIMIR (CORRIGIDO)
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
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"