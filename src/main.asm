#########################################################
# Universidade de Brasília
# The legend of Samara 
#########################################################

.data

# ============ CONFIGURAÇÕES ============
.eqv frame_rate 60    # Define que o jogo roda a 60 FPS

# ============ ESTADO DO JOGO ============
TEMPO_DE_EXECUCAO:     .word 0  # Guarda o tempo do último frame
VIDAS:                 .word 3  # Começa com 3 vidas
INVULNERAVEL:          .word 0  # Contador de invencibilidade (tempo piscando)
VELO_SAMARA:           .word 4  # Velocidade da boneca (pixels por frame)
SAMARA_FRAME_ANIMACAO: .word char  # Guarda o endereço de memória atual do sprite (começa no início de 'char')
SAMARA_ANIM_CONT:      .word 0  # Contador para não trocar frame rápido demais

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

# ==========================
# ESTADO DO ATAQUE (MÚLTIPLOS PROJÉTEIS)
# ==========================
ATAQUE_COOLDOWN:  .word 0       # Mantido (Timestamp global)

# Configurações do tiro
.eqv MAX_TIROS    3             # Máximo de tiros simultâneos
.eqv VEL_TIRO     8             # Velocidade
.eqv TEMPO_VIDA   40            # Distância que o tiro percorre
.eqv DELAY_TIRO   150           # Tempo entre disparos (reduzido)

# Listas de controle (Arrays com 3 posições cada)
TIRO_ATIVO: .word 0, 0, 0       # 1 = Voando, 0 = Livre
TIRO_X:     .word 0, 0, 0       # Posição X
TIRO_Y:     .word 0, 0, 0       # Posição Y
TIRO_DIR:   .word 0, 0, 0       # Direção do tiro
TIRO_TIMER: .word 0, 0, 0       # Quanto tempo o tiro dura      
# Direção: 0=Cima, 1=Baixo, 2=Esq, 3=Dir
SAMARA_DIR:       .word 1
NOTAS_FLAUTA: .byte 74, 76, 79

# ==========================
# TABELAS DE OFFSET (ALCANCE AUMENTADO)
# ==========================
# Cima(0), Baixo(1), Esq(2), Dir(3)

# Ajuste X: Empurrei de 12 para 20 pixels de distância
ATK_OFFSET_X: .word 0, 0, -12, 12   

# Ajuste Y: 
# Cima (-20): Mais alto
# Baixo (10): Mais baixo
# Lados (-4): Mantém alinhado com a mão
ATK_OFFSET_Y: .word -12, 10, -4, -4

#segundo mapa 
PTR_HIT_MAP:    .word LEVEL_HIT_MAP   # Aponta para o mapa de colisão atual
PTR_INIMIGO_1:  .word BISPO_POS       # Aponta para os dados do inimigo 1
PTR_INIMIGO_2:  .word CASTELO_POS     # Aponta para os dados do inimigo 2
PTR_INIMIGO_3:  .word CAVALO_POS      # Aponta para os dados do inimigo 3

# Slime 1 (Diagonal) - BISPO
BISPO_POS:     .half 240,60
BISPO_F0:      .half 240,60
BISPO_F1:      .half 240,60
BISPO_X:       .word -4           # Velocidade horizontal
BISPO_Y:       .word 4            # Velocidade vertical

# Slime 2 (Reto) - CASTELO
CASTELO_POS:   .half 200,100
CASTELO_F0:    .half 200,100
CASTELO_F1:    .half 200,100
CASTELO_X:     .word 4            # Só anda de lado

# Slime 3 (L-Shape) - CAVALO
CAVALO_POS:    .half 80,140
CAVALO_F0:     .half 80,140
CAVALO_F1:     .half 80,140
CAVALO_STATE:  .word 0        # 0 = andando em Y, 1 = andando em X (Máquina de estados)
CAVALO_CONT:   .word 0        # Contador de passos antes de virar
CAVALO_X:      .word 4
CAVALO_Y:      .word 4

# ==========================
# DADOS DA DAMA (BOSS MAPA 2)
# ==========================
DAMA_POS: .half 160, 100   # Começa no meio
DAMA_VEL: .word 3, 3       # Velocidade X e Y (Rápida!)
POS_OCULTA: .half 400, 400

# ============ MAPA DE COLISÃO && MAPA ATUAL ============
# 0 = chão, 1 = parede
MAPA_ATUAL: .word map
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
.byte 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 

LEVEL_HIT_MAP_2:
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1 
.byte 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1 
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

# Inimigos do Mapa 2 (Posições diferentes)
M2_BISPO_POS:   .half 50, 50      # Começa no canto superior esquerdo
M2_CASTELO_POS: .half 250, 200    # Canto inferior direito
M2_CAVALO_POS:  .half 160, 120    # Meio da tela
.text

#########################################################
# CONFIGURACAO_INICIAL (SETUP)
#########################################################
CONFIGURACAO_INICIAL:
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
    
    j LOOP_DO_JOGO        # Bora pro jogo!

# Função auxiliar pra desenhar o mapa limpo
LIMPAR_TELA_TOTAL:
    la t0, MAPA_ATUAL     # <--- MUDANÇA: Carrega o endereço da variável
    lw a0, 0(t0)          # <--- Pega o mapa que estiver salvo lá (map ou map_2)
    
    li a1, 0              # X = 0
    li a2, 0              # Y = 0
    mv a3, s0             # Frame atual (0 ou 1)
    j IMPRIMIR_TELA_CHEIA

#########################################################
# LOOP_DO_JOGO (Loop principal)
#########################################################
LOOP_DO_JOGO:
    # --- Controle de FPS (Trava em 60) ---
    li a7, 30         # Pega tempo atual
    ecall
    la t0, TEMPO_DE_EXECUCAO
    lw t1, 0(t0)
    sub t1, a0, t1    # Calcula quanto tempo passou
    li t2, frame_rate
    blt t1, t2, LOOP_DO_JOGO # Se passou pouco tempo, espera (loop)
    sw a0, 0(t0)      # Atualiza o tempo do último frame
    
    # --- 1. LIMPEZA DO FRAME ATUAL ---
    # Aqui a gente redesenha o mapa por cima de tudo pra "apagar" o frame antigo
    call LIMPAR_TELA_TOTAL
    j LOGICA_JOGO
    
    LOGICA_JOGO:
    call TOCAR_MUSICA
    
    # Verifica o teclado (WASD)
    call VERIFICAR_ENTRADA
    
    call PROCESSAR_ATAQUE
    # Move os inimigos (tem timer próprio pra serem mais lentos)
    call ATUALIZAR_INIMIGOS
    
    # Checa se bateu em parede, item ou bicho
    call VERIFICAR_COLISOES
    
    

    # Se vidas <= 0, já era
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, FIM_DE_JOGO_TELA

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
    j LOOP_DO_JOGO

#########################################################
# TELA DE GAME OVER
#########################################################
FIM_DE_JOGO_TELA:
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
        beq t2, t0, CONFIGURACAO_INICIAL  # Se apertar 'r', reinicia
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
#########################################################
# FUNÇÕES GRÁFICAS (CORRIGIDA PARA INIMIGOS DINÂMICOS)
#########################################################
DESENHAR_TUDO:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- 1. AS PAREDES VÊM PRIMEIRO ---
    call DESENHAR_CENARIO_HITBOX 

    # --- 2. DEPOIS OS ITENS ---
    la t0, ITEM_VELO
    lh t1, 4(t0)
    beqz t1, VERIFICAR_VIDA_DRAW
    la a0, ITEM_VELO
    la a3, ChestB
    call DESENHAR_POSICAO
    
    VERIFICAR_VIDA_DRAW:
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
    lw a3, 0(t0)            # Carrega o quadro atual
    call DESENHAR_POSICAO
    PULAR_JOGADOR:


    
    call DESENHAR_NOTAS_ATK   # <--- AQUI!
    
    # --- 4. POR ÚLTIMO OS INIMIGOS (USANDO PONTEIROS) ---
    
    # Slot 1: No Mapa 1 é o Bispo, no Mapa 2 é a Dama
    la t0, PTR_INIMIGO_1    # Carrega endereço do ponteiro
    lw a0, 0(t0)            # Carrega o endereço REAL (BISPO_POS ou DAMA_POS)
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    # Slot 2: No Mapa 1 é Castelo, no Mapa 2 é Oculto
    la t0, PTR_INIMIGO_2
    lw a0, 0(t0)
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    # Slot 3: No Mapa 1 é Cavalo, no Mapa 2 é Oculto
    la t0, PTR_INIMIGO_3
    lw a0, 0(t0)
    la a3, Water_Slime_Front
    call DESENHAR_POSICAO
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# =========================================================
# DESENHAR TODOS OS TIROS ATIVOS
# =========================================================
DESENHAR_NOTAS_ATK:
    addi sp, sp, -4
    sw ra, 0(sp)

    li s1, 0            # Índice
    li s2, MAX_TIROS    # Limite

    LOOP_DESENHAR_TIROS:
        beq s1, s2, FIM_DESENHAR_TIROS
        
        # Verifica se está ativo
        la t0, TIRO_ATIVO
        slli t1, s1, 2
        add t0, t0, t1
        lw t2, 0(t0)
        beqz t2, SKIP_DESENHO_TIRO

        # Pega X e Y
        la t0, TIRO_X
        add t0, t0, t1
        lw a1, 0(t0)    # X para desenhar
        
        la t0, TIRO_Y
        add t0, t0, t1
        lw a2, 0(t0)    # Y para desenhar

        # Prepara chamada de desenho
        # (Código otimizado para não chamar função externa e poluir registradores)
        
        # Salva registradores do loop externo
        addi sp, sp, -8
        sw s1, 0(sp)
        sw s2, 4(sp)

        la a0, sword_sprite 
        mv a3, s0           # Frame Atual (Buffer)

        # --- LÓGICA DE PINTAR PIXEL POR PIXEL ---
        li t0, 0xFF0        
        add t0, t0, a3      
        slli t0, t0, 20     
        li t6, 320          
        mul t6, t6, a2      # Y * 320
        add t0, t0, t6      
        add t0, t0, a1      # + X

        lw t4, 0(a0)        # Largura
        lw t5, 4(a0)        # Altura
        addi t1, a0, 8      # Dados Pixel
        mv t2, zero         # Cont Y

        L_LINHA_P:
            mv t3, zero     # Cont X
        L_PIXEL_P:
            lbu a4, 0(t1)
            addi t1, t1, 1
            li a5, 199      # Cor rosa (transparente)    
            beq a4, a5, SKIP_PIX_P
            sb a4, 0(t0) 
        SKIP_PIX_P:
            addi t0, t0, 1
            addi t3, t3, 1
            blt t3, t4, L_PIXEL_P 
            sub t0, t0, t4      # Volta X
            addi t0, t0, 320    # Desce linha
            addi t2, t2, 1     
            blt t2, t5, L_LINHA_P 
        # ---------------------------------------------

        lw s2, 4(sp)
        lw s1, 0(sp)
        addi sp, sp, 8

        SKIP_DESENHO_TIRO:
        addi s1, s1, 1
        j LOOP_DESENHAR_TIROS

    FIM_DESENHAR_TIROS:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
    
DESENHAR_CENARIO_HITBOX:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- Ler do ponteiro (Mapa Dinâmico) ---
    la t0, PTR_HIT_MAP      
    lw t0, 0(t0)            # Carrega M1 ou M2
    # ---------------------------------------
    
    li t1, 0                # Contador de índice
    li t2, 300              # Total de tiles

    LOOP_DESENHA_MAPA:
        beq t1, t2, FIM_DESENHA_MAPA # Acabou o array?
        
        lb t3, 0(t0)        # Lê o byte (0, 1 ou 3)
        beqz t3, PROXIMO_TILE # Se for 0, pula

        # Calcula X e Y
        li t4, 20
        rem a1, t1, t4      # Coluna
        slli a1, a1, 4      # X = Coluna * 16
        
        div a2, t1, t4      # Linha
        slli a2, a2, 4      # Y = Linha * 16

        # Desenha o bloco (tile)
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
# ==========================================
# PROCESSAR ATAQUE (MOVE E CHECA TODOS)
# ==========================================
PROCESSAR_ATAQUE:
    addi sp, sp, -4
    sw ra, 0(sp)

    li s1, 0            # s1 = Índice do tiro atual
    li s2, MAX_TIROS    # Limite

    LOOP_TIROS:
        beq s1, s2, FIM_LOOP_TIROS
        
        # Carrega TIRO_ATIVO[s1]
        la t0, TIRO_ATIVO
        slli t1, s1, 2     # Offset
        add t0, t0, t1
        lw t2, 0(t0)
        beqz t2, PROXIMO_TIRO  # Se inativo, ignora
        
        # --- 1. DIMINUI TEMPO DE VIDA ---
        la t3, TIRO_TIMER
        add t3, t3, t1
        lw t4, 0(t3)
        addi t4, t4, -1
        sw t4, 0(t3)
        blez t4, MATAR_TIRO  # Acabou o tempo -> some

        # --- 2. MOVIMENTAÇÃO ---
        la t3, TIRO_DIR
        add t3, t3, t1
        lw t3, 0(t3)        # Direção
        
        la t4, TIRO_X
        add t4, t4, t1      # Endereço X
        lw t5, 0(t4)        # Valor X
        
        la t6, TIRO_Y
        add t6, t6, t1      # Endereço Y
        lw a7, 0(t6)        # Valor Y (usando a7 temporário)

        li t2, VEL_TIRO
        
        # Switch de direção simples
        beqz t3, TIRO_CIMA
        li a5, 1
        beq t3, a5, TIRO_BAIXO
        li a5, 2
        beq t3, a5, TIRO_ESQ
        # Direita
        add t5, t5, t2
        j SALVAR_POS_TIRO
        
        TIRO_CIMA:
        sub a7, a7, t2
        j SALVAR_POS_TIRO
        TIRO_BAIXO:
        add a7, a7, t2
        j SALVAR_POS_TIRO
        TIRO_ESQ:
        sub t5, t5, t2
        
        SALVAR_POS_TIRO:
        sw t5, 0(t4)        # Salva novo X
        sw a7, 0(t6)        # Salva novo Y

        # --- 3. COLISÃO COM PAREDE ---
        # Salva contexto crítico antes de chamar função
        addi sp, sp, -12
        sw t0, 0(sp)        # Endereço do flag Ativo
        sw t1, 4(sp)        # Offset atual
        sw s1, 8(sp)        # Índice do loop
        
        mv a0, t5           # X
        mv a1, a7           # Y
        call CHECAR_COLISAO_MAPA
        mv t5, a0           # t5 = 1 se bateu

        lw s1, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12
        
        bnez t5, MATAR_TIRO  # Bateu parede -> some

        # --- COLISÃO COM INIMIGOS ---
        # Cria struct temporária na pilha pra usar sua função VERIFICAR_COLISAO_ATAQUE
        # A função espera um ponteiro para X,Y (half), mas nossas listas são .word
        # Vamos converter rapidinho na pilha
        
        addi sp, sp, -8
        la t4, TIRO_X
        add t4, t4, t1
        lw t5, 0(t4)
        sh t5, 0(sp)        # Salva X como half na pilha
        
        la t6, TIRO_Y
        add t6, t6, t1
        lw t5, 0(t6)
        sh t5, 2(sp)        # Salva Y como half na pilha
        
        mv a0, sp           # a0 aponta para (X,Y) na pilha
        
        # -- Inimigo 1 --
        sw t0, 4(sp)        # Salva t0 (Endereço Ativo) rapidão
        la t2, PTR_INIMIGO_1
        lw a1, 0(t2)
        call VERIFICAR_COLISAO_ATAQUE
        bnez a0, ACERTOU_INIMIGO_1
        
        # -- Inimigo 2 --
        mv a0, sp           # Recarrega ponteiro
        la t2, PTR_INIMIGO_2
        lw a1, 0(t2)
        call VERIFICAR_COLISAO_ATAQUE
        bnez a0, ACERTOU_INIMIGO_2
        
        # -- Inimigo 3 --
        mv a0, sp
        la t2, PTR_INIMIGO_3
        lw a1, 0(t2)
        call VERIFICAR_COLISAO_ATAQUE
        bnez a0, ACERTOU_INIMIGO_3
        
        lw t0, 4(sp)        # Recupera t0
        addi sp, sp, 8      # Limpa pilha temp
        j PROXIMO_TIRO

        # -- TRATAMENTO DE ACERTO --
        ACERTOU_INIMIGO_1:
            lw t0, 4(sp)
            addi sp, sp, 8
            la t2, PTR_INIMIGO_1
            lw t2, 0(t2)
            li t3, 400
            sh t3, 0(t2)    # Teleporta inimigo
            sh t3, 2(t2)
            j MATAR_TIRO

        ACERTOU_INIMIGO_2:
            lw t0, 4(sp)
            addi sp, sp, 8
            la t2, PTR_INIMIGO_2
            lw t2, 0(t2)
            li t3, 400
            sh t3, 0(t2)
            sh t3, 2(t2)
            j MATAR_TIRO

        ACERTOU_INIMIGO_3:
            lw t0, 4(sp)
            addi sp, sp, 8
            la t2, PTR_INIMIGO_3
            lw t2, 0(t2)
            li t3, 400
            sh t3, 0(t2)
            sh t3, 2(t2)
            j MATAR_TIRO

    MATAR_TIRO:
        sw zero, 0(t0)      # TIRO_ATIVO = 0

    PROXIMO_TIRO:
        addi s1, s1, 1
        j LOOP_TIROS

    FIM_LOOP_TIROS:
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

VERIFICAR_COLISAO_ATAQUE:
    lh t0, 0(a0)  # X1 (Espada)
    lh t1, 2(a0)  # Y1 (Espada)
    lh t2, 0(a1)  # X2 (Inimigo)
    lh t3, 2(a1)  # Y2 (Inimigo)
    
    li t4, 24     # <--- ALCANCE AUMENTADO! (Antes era 14)
                  # Isso faz a espada acertar uma área muito maior
    
    add t5, t2, t4
    bge t0, t5, SEM_COLISAO_ATK
    add t5, t0, t4
    ble t5, t2, SEM_COLISAO_ATK
    add t5, t3, t4
    bge t1, t5, SEM_COLISAO_ATK
    add t5, t1, t4
    ble t5, t3, SEM_COLISAO_ATK
    li a0, 1      # Acertou!
    ret
    SEM_COLISAO_ATK: 
    li a0, 0      # Errou
    ret

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
    # --- Check Inimigo Slot 1 (Pode ser Bispo ou Dama) ---
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_1    # Pega o ponteiro
    lw a1, 0(t0)            # Carrega o endereço do inimigo atual
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO   # Se bateu, toma dano

    # --- Check Inimigo Slot 2 (Pode ser Castelo ou Oculto) ---
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_2
    lw a1, 0(t0)
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO

    # --- Check Inimigo Slot 3 (Pode ser Cavalo ou Oculto) ---
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_3
    lw a1, 0(t0)
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
CHECAR_COLISAO_MAPA:
    # 1. Converter Pixel para Grid
    srli t0, a0, 4      # Coluna = X / 16
    srli t1, a1, 4      # Linha = Y / 16
    
    # 2. Proteção de limites
    li t2, 20
    bge t0, t2, DEU_COLISAO
    li t2, 15
    bge t1, t2, DEU_COLISAO

    # 3. Calcular Índice no Array
    li t2, 20
    mul t1, t1, t2      # Linha * 20
    add t0, t0, t1      # + Coluna
    
    la t3, PTR_HIT_MAP  # Carrega o endereço do PONTEIRO
    lw t3, 0(t3)        # Carrega o endereço do MAPA ATUAL (Map 1 ou 2)
    # -------------------------------------

    add t3, t3, t0      # Soma offset no mapa atual
    lb t4, 0(t3)        # Lê o valor (0, 1 ou 3)
    
    mv a0, t4           
    ret

    DEU_COLISAO:
    li a0, 1
    ret

# =========================================================
# VERIFICAR ENTRADA (MOVIMENTO + DIREÇÃO + ATAQUE)
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
    lw t2, 4(t1)       # t2 = Tecla pressionada
    
    # --- PRIORIDADE DO ATAQUE ---
    # Verifica o espaço ANTES de verificar movimento
    li t0, 32          # ASCII do Espaço
    beq t2, t0, TENTAR_ATACAR
    # ----------------------------------------

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
    
    # (Remova a verificação do espaço que estava aqui embaixo)
    
    j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # MOVIMENTO CIMA (W)
    # -----------------------------------------------------
    MOVER_CIMA: 
        # --- ATUALIZA DIREÇÃO (0 = CIMA) ---
        la t0, SAMARA_DIR
        li t1, 0
        sw t1, 0(t0)
        # -----------------------------------

        la t0, SAMARA_POS
        lh t2, 0(t0)      # X atual
        lh t1, 2(t0)      # Y atual
        sub t1, t1, t3    # Y Futuro
        
        # -- Salva contexto --
        addi sp, sp, -16
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)
        sw t3, 12(sp)

        # Checa Canto Superior Esquerdo
        mv a0, t2
        mv a1, t1
        call CHECAR_COLISAO_MAPA
        mv t5, a0 

        # Checa Canto Superior Direito
        lw t2, 8(sp)
        mv a0, t2
        addi a0, a0, 14
        lw a1, 4(sp)
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECAR_COLISAO_MAPA
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0     

        # -- Restaura contexto --
        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        # === DETECÇÃO DA PORTA (3) ===
        li t4, 3
        beq t5, t4, MUDAR_PARA_MAPA_2

        # Se bateu (t5 != 0), sai
        bnez t5, RETORNAR_ENTRADA 
        
        # Se livre:
        sh t1, 2(t0)
        li t6, 1          # Marca que andou
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO BAIXO (S)
    # -----------------------------------------------------
    MOVER_BAIXO: 
        # --- ATUALIZA DIREÇÃO (1 = BAIXO) ---
        la t0, SAMARA_DIR
        li t1, 1
        sw t1, 0(t0)
        # ------------------------------------

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
        addi a1, a1, 14
        call CHECAR_COLISAO_MAPA
        mv t5, a0

        # Checa Canto Inferior Direito
        lw t2, 8(sp)
        mv a0, t2
        addi a0, a0, 14
        lw a1, 4(sp)
        addi a1, a1, 14
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECAR_COLISAO_MAPA
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        # === DETECÇÃO DA PORTA (3) ===
        li t4, 3
        beq t5, t4, MUDAR_PARA_MAPA_2

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 2(t0)
        li t6, 1
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO ESQUERDA (A)
    # -----------------------------------------------------
    MOVER_ESQUERDA: 
        # --- ATUALIZA DIREÇÃO (2 = ESQ) ---
        la t0, SAMARA_DIR
        li t1, 2
        sw t1, 0(t0)
        # ----------------------------------

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
        call CHECAR_COLISAO_MAPA
        mv t5, a0

        # Checa Canto Inferior Esquerdo
        lw t1, 4(sp)
        mv a0, t1
        lw t2, 8(sp)
        mv a1, t2
        addi a1, a1, 14
        
        addi sp, sp, -4
        sw t5, 0(sp)
        call CHECAR_COLISAO_MAPA
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        # === DETECÇÃO DA PORTA (3) ===
        li t4, 3
        beq t5, t4, MUDAR_PARA_MAPA_2

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        li t6, 1
        j PROCESSAR_ANIMACAO

    # -----------------------------------------------------
    # MOVIMENTO DIREITA (D)
    # -----------------------------------------------------
    MOVER_DIREITA: 
        # --- ATUALIZA DIREÇÃO (3 = DIR) ---
        la t0, SAMARA_DIR
        li t1, 3
        sw t1, 0(t0)
        # ----------------------------------

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
        call CHECAR_COLISAO_MAPA
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
        call CHECAR_COLISAO_MAPA
        lw t5, 0(sp)
        addi sp, sp, 4
        or t5, t5, a0

        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 16

        # === DETECÇÃO DA PORTA (3) ===
        li t4, 3
        beq t5, t4, MUDAR_PARA_MAPA_2

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        li t6, 1
        j PROCESSAR_ANIMACAO
    
# -----------------------------------------------------
# TENTAR ATACAR (BUSCA SLOT VAZIO)
# -----------------------------------------------------
TENTAR_ATACAR:
    addi sp, sp, -4
    sw ra, 0(sp)

    # 1. VERIFICA COOLDOWN GLOBAL
    li a7, 30
    ecall
    mv t3, a0
    
    la t0, ATAQUE_COOLDOWN
    lw t1, 0(t0)
    sub t2, t3, t1
    
    li t4, DELAY_TIRO      # 150ms
    # Usa bltu para evitar bugs de overflow de tempo
    bltu t2, t4, SAIR_TENTATIVA 

    # 2. PROCURA UM SLOT LIVRE (0, 1 ou 2)
    li t5, 0                # Índice (i)
    li t6, MAX_TIROS        # Limite
    
    LOOP_ACHAR_SLOT:
        beq t5, t6, SAIR_TENTATIVA # Se checou os 3 e tá cheio, sai
        
        # Calcula endereço: TIRO_ATIVO + (i * 4)
        la t0, TIRO_ATIVO
        slli t1, t5, 2      # Offset = i * 4
        add t0, t0, t1      # Endereço final
        
        lw t2, 0(t0)        # Lê o valor
        beqz t2, CRIAR_TIRO # Se for 0, achamos vaga!
        
        addi t5, t5, 1
        j LOOP_ACHAR_SLOT

    CRIAR_TIRO:
    # t5 = Índice livre
    # t0 = Endereço do slot em TIRO_ATIVO
    # t1 = Offset (i * 4)

    # Atualiza Cooldown Global
    la t2, ATAQUE_COOLDOWN
    sw t3, 0(t2)

    # Ativa o Tiro
    li t2, 1
    sw t2, 0(t0)

    # Define tempo de vida
    la t0, TIRO_TIMER
    add t0, t0, t1
    li t2, TEMPO_VIDA
    sw t2, 0(t0)

    # Pega Direção da Samara e Salva no Tiro
    la t0, SAMARA_DIR
    lw t2, 0(t0)          # Direção Samara
    la t0, TIRO_DIR
    add t0, t0, t1        # Usa mesmo offset
    sw t2, 0(t0)

    # --- CÁLCULO DE POSIÇÃO INICIAL ---
    la t0, SAMARA_POS
    lh t4, 0(t0)          # Samara X
    lh t6, 2(t0)          # Samara Y

    # Aplica os Offsets existentes (Tabela ATK_OFFSET)
    slli t2, t2, 2        # Dir * 4
    
    la t0, ATK_OFFSET_X
    add t0, t0, t2
    lw t0, 0(t0)
    add t4, t4, t0        # X Inicial do tiro
    
    la t0, ATK_OFFSET_Y
    add t0, t0, t2
    lw t0, 0(t0)
    add t6, t6, t0        # Y Inicial do tiro

    # Salva nas listas X e Y
    la t0, TIRO_X
    add t0, t0, t1
    sw t4, 0(t0)
    
    la t0, TIRO_Y
    add t0, t0, t1
    sw t6, 0(t0)

    mv a0, t5              # Passa o índice do slot (0, 1 ou 2) como argumento
    call TOCAR_SOM_FLAUTA  # Toca a nota correspondente
    # --------------------

    SAIR_TENTATIVA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

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
MUDAR_PARA_MAPA_2:
    # 1. Troca Imagem de Fundo
    la t0, MAPA_ATUAL
    la t1, map_2
    sw t1, 0(t0)
    
    # 2. Troca Mapa de Colisão
    la t0, PTR_HIT_MAP
    la t1, LEVEL_HIT_MAP_2
    sw t1, 0(t0)

    # 3. CONFIGURA INIMIGOS (SÓ A DAMA!)
    
    # Slot 1 -> Vira a DAMA
    la t0, PTR_INIMIGO_1
    la t1, DAMA_POS
    sw t1, 0(t0)
    
    # Slot 2 -> Some (Oculto)
    la t0, PTR_INIMIGO_2
    la t1, POS_OCULTA
    sw t1, 0(t0)
    
    # Slot 3 -> Some (Oculto)
    la t0, PTR_INIMIGO_3
    la t1, POS_OCULTA
    sw t1, 0(t0)

    # 4. Teleporta Jogador (Segurança)
    la t0, SAMARA_POS
    li t1, 32
    sh t1, 0(t0)
    sh t1, 2(t0)

    call TOCAR_SOM_COLETA
    j RETORNAR_ENTRADA

# ATUALIZAÇÃO DE INIMIGOS (INDEPENDENTE)
ATUALIZAR_INIMIGOS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # --- Controle de Delay ---
    la t0, TEMP_RIVAL
    lw t1, 0(t0)
    addi t1, t1, 1
    la t2, LAG_RIVAL
    lw t2, 0(t2)
    bge t1, t2, EXECUTAR_MOVIMENTO
    sw t1, 0(t0)
    j FIM_ATUALIZAR_INIMIGOS
    
    EXECUTAR_MOVIMENTO:
    sw zero, 0(t0) 
    
    # --- VERIFICA QUAL MAPA ESTÁ ---
    la t0, MAPA_ATUAL
    lw t0, 0(t0)
    la t1, map_2
    beq t0, t1, MODO_BOSS_DAMA # Se for map_2, vai pro modo Boss
    
    # --- MODO NORMAL (MAPA 1) ---
    call MOVER_CAVALO
    call MOVER_CASTELO
    call MOVER_BISPO
    j FIM_ATUALIZAR_INIMIGOS

    # --- MODO BOSS (MAPA 2) ---
    MODO_BOSS_DAMA:
    call MOVER_DAMA   # Só ela se mexe!
    
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
        blt t3, zero, VERIFICAR_CANTO_X_ESQ
        addi a0, a0, 14     # Se direita, checa lado direito
        VERIFICAR_CANTO_X_ESQ:
        la t2, CAVALO_POS
        lh a1, 2(t2)        # Y Atual
        addi a1, a1, 8      # Meio da altura
        call CHECAR_COLISAO_MAPA
        
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
        call CHECAR_COLISAO_MAPA
        
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
    call CHECAR_COLISAO_MAPA
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
    call CHECAR_COLISAO_MAPA
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
    blt t2, zero, VERIFICAR_BISPO_X
    addi a0, a0, 14   # Se direita, testa borda direita
    VERIFICAR_BISPO_X:
    la t6, BISPO_POS
    lh a1, 2(t6)      # Y Atual
    addi a1, a1, 8    # Altura média
    call CHECAR_COLISAO_MAPA
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
    call CHECAR_COLISAO_MAPA
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
# MOVER DAMA (BOSS)
# ==========================================
MOVER_DAMA:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Carrega dados
    la a0, DAMA_POS
    la a1, DAMA_VEL     # Pointer da velocidade
    lh t0, 0(a0)        # X Atual
    lh t1, 2(a0)        # Y Atual
    lw t2, 0(a1)        # Vel X
    lw t3, 4(a1)        # Vel Y (Note o offset 4, pois é .word 3, 3)

    # --- MOVIMENTO X ---
    add t4, t0, t2      # X Futuro
    
    # Check Colisão X
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    mv a0, t4           # Testa X Futuro
    la t6, DAMA_POS     
    lh a1, 2(t6)        # Y Atual
    addi a1, a1, 8      
    call CHECAR_COLISAO_MAPA
    mv t5, a0 

    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    # Se bateu X, inverte
    bnez t5, INV_DAMA_X
    li t6, 296
    bge t4, t6, INV_DAMA_X
    li t6, 8
    blt t4, t6, INV_DAMA_X
    
    mv t0, t4           # Aceita X
    j DAMA_Y

    INV_DAMA_X:
    sub t2, zero, t2    # Inverte Vel X
    la t6, DAMA_VEL
    sw t2, 0(t6)

    DAMA_Y:
    # --- MOVIMENTO Y ---
    add t4, t1, t3      # Y Futuro

    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    mv a1, t4           # Testa Y Futuro
    mv a0, t0           # X já atualizado
    addi a0, a0, 8
    call CHECAR_COLISAO_MAPA
    mv t5, a0

    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    # Se bateu Y, inverte
    bnez t5, INV_DAMA_Y
    li t6, 216
    bge t4, t6, INV_DAMA_Y
    li t6, 8
    blt t4, t6, INV_DAMA_Y
    
    mv t1, t4           # Aceita Y
    j FIM_DAMA

    INV_DAMA_Y:
    sub t3, zero, t3    # Inverte Vel Y
    la t6, DAMA_VEL
    sw t3, 4(t6)

    FIM_DAMA:
    la a0, DAMA_POS
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
    blt t1, t2, FIM_ANIMACAO      
    
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
    
    blt t1, t2, SALVAR_FRAME    
    
    # Se passou do limite, volta para o começo
    la t1, char

    SALVAR_FRAME:
    sw t1, 0(t0)              
    
    FIM_ANIMACAO:
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
.include "sounds/music.s"
.include "sounds/music_ef.asm"
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
.include "sprites/sword_sprite.data"
.include "sprites/Water_Slime_Front.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/KeyB.data"
.include "sprites/Game_Over_Menu.data"