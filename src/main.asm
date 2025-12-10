#########################################################
# Universidade de Brasília
# The legend of Samara 
#########################################################

.data

# ============ CONFIGURAÇÕES ============
.eqv frame_rate 60    # Define que o jogo roda a 60 FPS
.eqv frame_rate 60       # Já existe no seu código
.eqv QTD_MOEDAS 3        # <--- ADICIONE ISSO
.eqv TAM_MOEDA_BYTES 6   # <--- ADICIONE ISSO
#Carneiros
.eqv SHEEP_SPAWN_TIME 180  # 3 segundos (60 fps * 3)
.eqv SHEEP_DAMAGE_TIME 300 # 5 segundos (60 fps * 5)
.eqv SHEEP_GOAL 10         # Meta para vencer
.eqv DISTANCIA_CARNEIROS 30 # Distância mínima entre eles

# ============ ESTADO DO JOGO ============
TEMPO_DE_EXECUCAO:     .word 0  # Guarda o tempo do último frame
VIDAS:                 .word 3  # Começa com 3 vidas
INVULNERAVEL:          .word 0  # Contador de invencibilidade (tempo piscando)
VELO_SAMARA:           .word 4  # Velocidade da boneca (pixels por frame)
SAMARA_ANIM_CONT:      .word 0  # Contador para não trocar frame rápido demais
PASSO_TIMER: .word 0 ##isso é pro efeito sonoro apenas 

# Timer para inimigos (Independente)
TEMP_RIVAL:  .word 0            # Cronômetro interno dos bichos
LAG_RIVAL:   .word 3            # Os bichos só andam a cada 3 frames (pra não ficarem muito rápidos)

# ============ ITENS (BAÚS) ============
# Estrutura: X, Y, Ativo (1 = sim, 0 = não)
ITEM_VELO: .half 240, 20, 1   # Azul - Baú de Velocidade
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
# ============ ESTADO DO PET (KIT) ============
KIT_POS:       .half 140, 120      # Posição X, Y inicial
KIT_FRAME_PTR: .word kit_sprites   # Ponteiro para o frame atual
KIT_ANIM_TIMER:.word 0             # Timer da animação
KIT_STATE:     .word 0             # 0 = Seguindo Samara, 1 = Buscando Item
KIT_TARGET_X:  .word 0             # X do item alvo
KIT_TARGET_Y:  .word 0             # Y do item alvo
KIT_TARGET_PTR:.word 0             # Endereço de memória do item (para desativar)
KIT_TARGET_TYPE:.word 0            # 0=Moeda, 1=Velo, 2=Vida

# ============ SPRITES DO PET ============
# ATENÇÃO: Todos os frames sequenciais aqui

kit_sprites:
    .include "sprites/kit.data"
kit_sprites_end:                   # Marcador do fim para loop
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
DAMA_VIDA: .word 12   # Começa com 12 de vida

# ============ SISTEMA DE LOJA ============
LOJA_ABERTA:   .word 0       # 0 = Fechada, 1 = Aberta
LOJA_DEBOUNCE: .word 0       # Evita abrir a loja repetidamente enquanto está em cima
KIT_SPEED:     .word 2       # Velocidade do gato (Variável, pois pode ser comprada)

# ============ SISTEMA DO MAPA 3 (CARNEIROS) ============
# Configurações
.eqv MAX_SHEEP 15          # Máximo de carneiros simultâneos na tela
.eqv SHEEP_SPAWN_TIME 180  # 3 segundos (60 fps * 3)
.eqv SHEEP_DAMAGE_TIME 300 # 5 segundos (60 fps * 5)
.eqv SHEEP_GOAL 10         # Meta para vencer

# Variáveis
SHEEP_COUNT:      .word 0  # Quantos já coletamos
SHEEP_TIMER:      .word 0  # Timer para nascer novos
DAMAGE_TIMER:     .word 0  # Timer para dar dano no player
SHEEP_ARRAY:      .space 240 # Espaço para 15 carneiros (Struct de 16 bytes cada)
# Struct do Carneiro (16 bytes):
# 0: X (word)
# 4: Y (word)
# 8: Ativo (word) - 0=Não, 1=Sim
# 12: SlowTimer (word) - Se > 0, ele está lento
# ============ CONTROLE DE ANIMAÇÃO AVANÇADO ============
SAMARA_FRAME_ANIMACAO: .word SEQ_S    # Ponteiro para o frame atual (o que é desenhado)
ANIM_TIMER:            .word 0        # Timer para controlar velocidade da troca
ANIM_DELAY_LIMIT:      .word 8        # Quanto maior, mais lenta a animação (Flicker control)
ANIM_INDEX_ATUAL:      .word 0        # Qual frame da sequência estamos (0, 1, 2...)
ANIM_SEQ_ATUAL:        .word 0        # Guarda o endereço base da sequência atual (para resetar se mudar de tecla)


# ============ CONTROLE DE ANIMAÇÃO DO CARNEIRO ============
SHEEP_FRAME_PTR:   .word sheep_anim_seq   # Aponta para o frame atual
SHEEP_ANIM_TIMER:  .word 0                # Controla a velocidade da troca
# ============ SPRITES DA SAMARA (DATA GIGANTE) ============
# AQUI FICA TUDO EM SEQUÊNCIA. O código vai navegar somando endereços.

# --- SEQUÊNCIA W (ANDAR CIMA - 3 FRAMES) ---
SEQ_W:
    .include "sprites/samara_w1.data"  # Frame 0
    .include "sprites/samara_w2.data"  # Frame 1
    .include "sprites/samara_w3.data"  # Frame 2
SEQ_W_END:

# --- SEQUÊNCIA S (ANDAR BAIXO - 3 FRAMES) ---
SEQ_S:
    .include "sprites/samara_s1.data"
    .include "sprites/samara_s2.data"
    .include "sprites/samara_s3.data"
SEQ_S_END:

# --- SEQUÊNCIA A (ANDAR ESQUERDA - 2 FRAMES) ---
SEQ_A:
    .include "sprites/samara_a1.data"
    .include "sprites/samara_a2.data"
SEQ_A_END:

# --- SEQUÊNCIA D (ANDAR DIREITA - 2 FRAMES) ---
SEQ_D:
    .include "sprites/samara_d1.data"
    .include "sprites/samara_d2.data"
SEQ_D_END:

# --- SEQUÊNCIA ESPAÇO (ATAQUE - 3 FRAMES) ---
SEQ_ATK:
    .include "sprites/samara_atk1.data"
    .include "sprites/samara_atk2.data"
    .include "sprites/samara_atk3.data"
SEQ_ATK_END:

# Sprite da loja (Overlay)
shop_sprite: 
    .include "./sprites/loja.data"

# ============ MAPA DE COLISÃO && MAPA ATUAL ============
# 0 = chão, 1 = parede
MAPA_ATUAL: .word map
LEVEL_HIT_MAP:
    # --- TOPO (Linhas 0-4): Cartas (Esq) e Dado 1 (Dir) ---
    # Linha 0 (Y=0) - Quase tudo bloqueado no topo
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
    # Linha 1 (Y=8)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
    # Linha 2 (Y=16)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 1, 1, 1, 1, 1, 1
    # Linha 3 (Y=24)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1
    # Linha 4 (Y=32) - Fim do Dado de cima
    .byte 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1

    # --- TRANSIÇÃO DAS CARTAS (Linhas 5-8) ---
    # Aqui vamos diminuindo a parede da esquerda drasticamente para fazer a diagonal
    # Linha 5 (Y=40)
    .byte 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    # Linha 6 (Y=48)
    .byte 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    # Linha 7 (Y=56)
    .byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    # Linha 8 (Y=64) - A partir daqui a esquerda (coluna 0) fica livre (0)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    # --- MEIO DO TABULEIRO COM O DADO 2 (Linhas 9-17) ---
    # O Dado 2 aparece na direita. O resto é chão (0).
    # Linha 9 (Y=72) - Começa pontinha do Dado 2 na direita
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
    # Linha 10 (Y=80)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1
    # Linha 11 (Y=88) - Dado 2 ocupa bem a direita
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
    # Linha 12 (Y=96)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
    # Linha 13 (Y=104)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
    # Linha 14 (Y=112)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
    # Linha 15 (Y=120)
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
    # Linha 16 (Y=128) - Dado 2 começa a sumir
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1
    # Linha 17 (Y=136) - Dado 2 acabou, só uma pontinha
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1

    # --- ÁREA LIVRE INFERIOR (Linhas 18-25) ---
    # Tabuleiro totalmente livre de obstáculos laterais
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 18
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 19
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 20
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 21
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 22
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 23
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # 24
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 # 25

    # --- HUD / BARRA DE STATUS (Linhas 26-29) ---
    # Área preta com "vida", "tesouros". Totalmente bloqueada.
    # Linha 26 (Y=208) - Margem de segurança logo acima das letras
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    # Linha 27 (Y=216)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    # Linha 28 (Y=224)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    # Linha 29 (Y=232)
    .byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

LEVEL_HIT_MAP_2:
# Mapa 40x30 (1200 bytes) - Arena Aberta
# Paredes no topo (Linhas 0 e 1)
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
# Arena (Linhas 2 a 27) - Zeros no meio, 1 nas pontas
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
# Paredes no fundo (Linhas 28 e 29)
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1


LEVEL_HIT_MAP_3:
# Mapa 40x30 (1200 bytes) - Arena Aberta
# Paredes no topo (Linhas 0 e 1)
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
# Arena (Linhas 2 a 27) - Zeros no meio, 1 nas pontas
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 
# Paredes no fundo (Linhas 28 e 29)
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
# ============ ECONOMIA ============
MOEDAS: .word 0              # Contador de moedas (começa com 0)

# Tabela de ponteiros para os números (Necessário para desenhar o placar)
NUMEROS_SPRITES: 
    .word digit_0, digit_1, digit_2, digit_3, digit_4
    .word digit_5, digit_6, digit_7, digit_8, digit_9

# ============ MOEDA ============
# X, Y, Ativo (1=Sim, 0=Não)
LISTA_MOEDAS: 
    .half 100, 180, 1   # Moeda 0
    .half 220, 50,  1   # Moeda 1
    .half 50,  100, 1   # Moeda 2
    # .half 280, 200, 1   # Moeda 3 (Perto do fim)
    # .half 160, 120, 1   # Moeda 4 (Meio)

# Inimigos do Mapa 2 (Posições diferentes)
M2_BISPO_POS:   .half 50, 50      # Começa no canto superior esquerdo
M2_CASTELO_POS: .half 250, 200    # Canto inferior direito
M2_CAVALO_POS:  .half 160, 120    # Meio da tela
.text

#########################################################
# CONFIGURACAO_INICIAL (SETUP)
#########################################################
CONFIGURACAO_INICIAL:
    # --- Reseta as Vidas pra 3 samara ---
    la t0, VIDAS
    li t1, 3
    sw t1, 0(t0)
    
    #Dama
    # --- RESET VIDA DO BOSS ---
    la t0, DAMA_VIDA
    li t1, 12
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

LOOP_DO_JOGO:
    # --- Controle de FPS (Trava em 60) ---
    li a7, 30         
    ecall
    la t0, TEMPO_DE_EXECUCAO
    lw t1, 0(t0)
    sub t1, a0, t1    
    li t2, frame_rate
    blt t1, t2, LOOP_DO_JOGO 
    sw a0, 0(t0)      
    
    # --- 1. LIMPEZA DO FRAME ATUAL ---
    call LIMPAR_TELA_TOTAL

    # === VERIFICAÇÃO DA LOJA ===
    la t0, LOJA_ABERTA
    lw t1, 0(t0)
    bnez t1, LOOP_DA_LOJA  # Se aberta, pula a lógica do jogo
    # ===========================
    
    j LOGICA_JOGO
    
    # --- SUB-LOOP DA LOJA (PAUSE) ---
    LOOP_DA_LOJA:
        # 1. Desenha o jogo congelado ao fundo
        call DESENHAR_TUDO
        call DESENHAR_VIDAS # Inclui o HUD de moedas
        
        # 2. Desenha o Overlay da Loja
        call DESENHAR_LOJA_OVERLAY
        
        # 3. Verifica Input da Loja (Compras e Saída)
        call VERIFICAR_INPUT_LOJA
        
        # 4. Atualiza Frame (Buffer Swap)
        j TROCA_FRAME
    
    LOGICA_JOGO:

    call TOCAR_MUSICA
    # Verifica o teclado (WASD)
    call VERIFICAR_ENTRADA
    
    call PROCESSAR_ATAQUE
    # Move os inimigos (tem timer próprio pra serem mais lentos)
    call ATUALIZAR_INIMIGOS

    call ATUALIZAR_KIT
    
    # Checa se bateu em parede, item ou bicho
    call VERIFICAR_COLISOES

    # Se vidas <= 0, já era
    la t0, VIDAS
    lw t0, 0(t0)
    blez t0, INICIO_MORTE_GAUNTLET

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
# =========================================================
# ATUALIZAR_ANIMACAO_CARNEIRO
# Calcula o próximo frame baseado em (Width * Height) + 8
# =========================================================
ATUALIZAR_ANIMACAO_CARNEIRO:
    # 1. Verificar Timer (Controle de velocidade)
    la t0, SHEEP_ANIM_TIMER
    lw t1, 0(t0)
    addi t1, t1, 1
    li t2, 10              # VELOCIDADE: Aumente para ficar mais lento
    sw t1, 0(t0)
    blt t1, t2, FIM_ANIM_S # Se não deu o tempo, sai

    # 2. Resetar Timer
    sw zero, 0(t0)

    # 3. Carregar Ponteiro do Frame Atual
    la t0, SHEEP_FRAME_PTR
    lw t1, 0(t0)           # t1 = Endereço do frame atual

    # 4. Calcular o Tamanho do Frame Atual
    # Estrutura: [Width (4b)] [Height (4b)] [Pixels...]
    lw t2, 0(t1)           # Carrega Largura (W)
    lw t3, 4(t1)           # Carrega Altura (H)
    
    # Cálculo: Offset = (W * H) + 8
    # Nota: Assumindo 1 byte por pixel conforme seu código original
    mul t4, t2, t3         # t4 = Quantidade de pixels
    addi t4, t4, 8         # Adiciona 8 bytes do cabeçalho (W e H)

    # 5. Avançar Ponteiro
    add t1, t1, t4         # Ponteiro vai para o início do PRÓXIMO frame

    # 6. Verificar se chegou ao fim do bloco .data
    la t5, sheep_anim_end
    bge t1, t5, RESET_LOOP_S

    # Salva o novo ponteiro
    sw t1, 0(t0)
    ret

    RESET_LOOP_S:
    # Volta para o primeiro frame
    la t1, sheep_anim_seq
    sw t1, 0(t0)

    FIM_ANIM_S:
    ret
#########################################################
# TELA DE GAME OVER
#########################################################
INICIO_MORTE_GAUNTLET:
    # --- 1. PREPARAÇÃO ---
    # Toca som de morte
    li a0, 60
    call SOM_EFEITO_FALHA
    
    # Chama a nova câmera cinematográfica
    call ANIMACAO_CINEMATICA
    
    # Vai para Game Over UI
    j FIM_DE_JOGO_TELA

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
#########################################################
# TELA DE VITÓRIA (TRANSIÇÃO FASE 2 -> FASE 3)
#########################################################
INICIO_VITORIA:
    call TOCAR_SOM_COLETA
    
    # Desenha a tela de vitória
    li s0, 0
    la a0, win_sprite
    call IMPRIMIR_TELA_CHEIA
    li s0, 1
    la a0, win_sprite
    call IMPRIMIR_TELA_CHEIA

    # Loop de espera pelo 'E'
LOOP_VITORIA:
        li t1, 0xFF200000  # Teclado
        lw t0, 0(t1)
        andi t0, t0, 1
        beqz t0, LOOP_VITORIA
        lw t2, 4(t1)       # Tecla pressionada
        
        # --- SE APERTAR 'E', VAI PRO MAPA 3 ---
        li t0, 'e'
        beq t2, t0, MUDAR_PARA_MAPA_3
        
        j LOOP_VITORIA
#########################################################
# TELA FINAL REAL (FIM DE JOGO - DEPOIS DOS CARNEIROS)
#########################################################
TELA_FINAL_REAL:
    call TOCAR_SOM_COLETA
    
    # Desenha a tela de vitória nos dois frames
    li s0, 0
    la a0, win_sprite
    call IMPRIMIR_TELA_CHEIA
    li s0, 1
    la a0, win_sprite
    call IMPRIMIR_TELA_CHEIA

    # Loop Infinito de Fim de Jogo
LOOP_FINAL_REAL:
    li t1, 0xFF200000
    lw t0, 0(t1)
    andi t0, t0, 1
    beqz t0, LOOP_FINAL_REAL
    lw t2, 4(t1)
    
    # Se apertar 'q', sai do jogo
    li t0, 'q'
    beq t2, t0, FIM_DO_JOGO
    # Se apertar 'r', reinicia tudo
    li t0, 'r'
    beq t2, t0, CONFIGURACAO_INICIAL
    
    j LOOP_FINAL_REAL
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
# FUNÇÕES GRÁFICAS (CORRIGIDA: EVITA CRASH NO MAPA 3)
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
    la a3, item_velocidade
    call DESENHAR_POSICAO

    # --- DESENHAR LISTA DE MOEDAS ---
    li t0, 0                 
    la t1, LISTA_MOEDAS      

    LOOP_DRAW_MOEDAS:
        li t2, QTD_MOEDAS    
        bge t0, t2, FIM_DRAW_MOEDA

        lh t3, 4(t1)         
        beqz t3, NEXT_COIN_DRAW

        addi sp, sp, -8      
        sw t0, 0(sp)
        sw t1, 4(sp)

        mv a0, t1            
        la a3, coin_sprite   
        call DESENHAR_POSICAO

        lw t1, 4(sp)         
        lw t0, 0(sp)
        addi sp, sp, 8

    NEXT_COIN_DRAW:
        addi t1, t1, TAM_MOEDA_BYTES  
        addi t0, t0, 1                
        j LOOP_DRAW_MOEDAS

    FIM_DRAW_MOEDA:
    
    VERIFICAR_VIDA_DRAW:
    la t0, ITEM_VIDA
    lh t1, 4(t0)
    beqz t1, DESENHAR_ENTIDADES
    la a0, ITEM_VIDA
    la a3, item_vida
    call DESENHAR_POSICAO

    DESENHAR_ENTIDADES:
    # --- 3. DEPOIS O JOGADOR ---
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    andi t1, t1, 4
    bnez t1, PULAR_JOGADOR
    la a0, SAMARA_POS
    la t0, SAMARA_FRAME_ANIMACAO
    lw a3, 0(t0)            
    call DESENHAR_POSICAO
    PULAR_JOGADOR:

    call DESENHAR_NOTAS_ATK   
    call DESENHAR_KIT
    
    # === VERIFICA SE É MAPA 3 (CARNEIROS) ===
    la t0, MAPA_ATUAL
    lw t0, 0(t0)
    la t1, map_3
    bne t0, t1, DESENHAR_INIMIGOS_PADRAO # Se não for Mapa 3, desenha normal

    # --- DESENHAR APENAS CARNEIROS ---
    la t0, SHEEP_ARRAY
    li t1, 0
    li t2, MAX_SHEEP
    
    LOOP_DRAW_SHEEP:
        beq t1, t2, FIM_DESENHAR_TUDO_SAFE
        lw t3, 8(t0)     
        beqz t3, NEXT_DRAW_S
        
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t2, 8(sp)

        lw a1, 0(t0)    # X
        lw a2, 4(t0)    # Y
        
        # --- ALTERAÇÃO AQUI ---
        # Em vez de: la a0, sheep_sprite
        la t4, SHEEP_FRAME_PTR
        lw a0, 0(t4)    # Carrega o frame atual da animação
        # ----------------------
        
        mv a3, s0       
        call IMPRIMIR
        
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12

    NEXT_DRAW_S:
        addi t0, t0, 16
        addi t1, t1, 1
        j LOOP_DRAW_SHEEP

    # --- 4. INIMIGOS PADRÃO (MAPA 1 E 2) ---
    DESENHAR_INIMIGOS_PADRAO:
    
    # Slot 1: Verifica se é Mapa 1 (Bispo) ou Mapa 2 (Dama)
    la t0, MAPA_ATUAL
    lw t0, 0(t0)
    la t1, map_2
    beq t0, t1, DRAW_BOSS_DAMA

    # Desenha Bispo (Mapa 1)
    la t0, PTR_INIMIGO_1    
    lw a0, 0(t0)            
    la a3, bispo
    call DESENHAR_POSICAO
    j DRAW_SLOT_2

    DRAW_BOSS_DAMA:
    # Desenha Dama (Mapa 2)
    la t0, PTR_INIMIGO_1
    lw a0, 0(t0)
    la a3, dama_sprite      
    call DESENHAR_POSICAO

    DRAW_SLOT_2:
    # Slot 2: Torre
    la t0, PTR_INIMIGO_2
    lw a0, 0(t0)
    la a3, torre
    call DESENHAR_POSICAO

    # Slot 3: Cavalo
    la t0, PTR_INIMIGO_3
    lw a0, 0(t0)        
    la a3, cavalo       
    call DESENHAR_POSICAO
    
    FIM_DESENHAR_TUDO_SAFE:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
#########################################################
# NOVA FUNÇÃO: ANIMACAO_CINEMATICA
# Efeito: Câmera viaja do centro da tela até o player,
# fechando o foco (Iris Wipe) com interpolação suave.
#########################################################
ANIMACAO_CINEMATICA:
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp) # Camera X Atual
    sw s2, 12(sp) # Camera Y Atual
    sw s3, 16(sp) # Raio Atual
    sw s4, 20(sp) # Target X
    sw s5, 24(sp) # Target Y
    sw s6, 28(sp) # Frame Visível (Base)
    sw s7, 32(sp) # Frame Backup (Snapshot)

    # --- 1. SETUP DE BUFFERS ---
    # Descobre qual frame está na tela agora
    li t0, 0xFF200604       
    lw t1, 0(t0)            # 0 ou 1
    
    # Define endereços base
    li s6, 0xFF000000       # Frame 0
    li s7, 0xFF100000       # Frame 1
    beqz t1, SETUP_SNAPSHOT
    
    # Se t1 for 1, inverte: s6 é Frame 1 (Visível), s7 é Frame 0 (Backup)
    li s6, 0xFF100000
    li s7, 0xFF000000

    SETUP_SNAPSHOT:
    # --- 2. TIRAR SNAPSHOT (BACKUP DO JOGO) ---
    # Copia o frame visível (s6) para o backup (s7)
    # Isso permite restaurar o fundo enquanto o círculo se move
    mv t0, s6
    mv t1, s7
    li t2, 76800            # Total de pixels (320x240)
    
    LOOP_SNAPSHOT:
        lw t3, 0(t0)
        sw t3, 0(t1)
        addi t0, t0, 4
        addi t1, t1, 4
        addi t2, t2, -1
        bnez t2, LOOP_SNAPSHOT

    # --- 3. CONFIGURAR VARIÁVEIS DE ANIMAÇÃO ---
    # Posição Inicial da Câmera (Centro da Tela)
    li s1, 160              # Cam X Start
    li s2, 120              # Cam Y Start
    li s3, 220              # Raio Inicial (Tela cheia)

    # Posição Alvo (Onde o Player morreu)
    la t0, SAMARA_POS
    lh s4, 0(t0)            # Player X
    lh s5, 2(t0)            # Player Y
    addi s4, s4, 8          # Centraliza no sprite (+8)
    addi s5, s5, 8          # Centraliza no sprite (+8)

    # --- 4. LOOP DE ANIMAÇÃO ---
    LOOP_CINE:
        # A) RESTAURAR FUNDO (Copia Backup -> Visível)
        # Necessário pois o círculo se move e precisamos apagar o preto antigo
        mv t0, s7           # Origem (Backup)
        mv t1, s6           # Destino (Tela)
        li t2, 76800        # Pixels
        
        # Otimização: Copia em blocos ou loop simples
        LOOP_RESTORE:
            lw t3, 0(t0)
            sw t3, 0(t1)
            addi t0, t0, 4
            addi t1, t1, 4
            addi t2, t2, -1
            bnez t2, LOOP_RESTORE

        # B) ATUALIZAR FÍSICA (INTERPOLAÇÃO)
        # Aproximação assintótica (Ease-Out):
        # Novo = Atual + (Alvo - Atual) / Velocidade
        
        # Move X
        sub t0, s4, s1      # Distância X
        srai t0, t0, 3      # Divide por 8 (Suavidade)
        add s1, s1, t0      # Atualiza X
        
        # Move Y
        sub t0, s5, s2      # Distância Y
        srai t0, t0, 3      # Divide por 8
        add s2, s2, t0      # Atualiza Y
        
        # Move Raio (Alvo = 25 pixels)
        li t1, 25
        sub t0, s3, t1      # Diferença Raio
        srai t0, t0, 4      # Divide por 16 (Fecha mais devagar que move)
        
        # Garante que sempre diminui pelo menos 1 se ainda estiver longe
        bnez t0, APLICA_RAIO
        li t0, 1            # Velocidade mínima
        APLICA_RAIO:
        sub s3, s3, t0      # Diminui Raio
        
        # C) DESENHAR MÁSCARA PRETA (VIGNETTE)
        # Pinta preto tudo que estiver FORA do círculo (s1, s2, raio s3)
        mul s0, s3, s3      # Raio^2 (s0 temporário)
        
        li t1, 0            # Y = 0
        LOOP_Y_CINE:
            li t2, 240
            bge t1, t2, FIM_DRAW_CINE
            
            # Pré-calcula (dy^2)
            sub t4, t1, s2      # dy = Y - CamY
            mul t4, t4, t4      # dy^2
            
            # Endereço da linha
            li t5, 320
            mul t6, t1, t5      # Y * 320
            slli t6, t6, 2      # bytes
            add t6, t6, s6      # + Base Address

            li t3, 0            # X = 0
            LOOP_X_CINE:
                bge t3, t5, NEXT_LINE_CINE
                
                # Calcula Distância^2
                sub t2, t3, s1  # dx = X - CamX
                mul t2, t2, t2  # dx^2
                add t2, t2, t4  # Dist = dx^2 + dy^2
                
                # Se Dist > Raio^2, pinta PRETO
                ble t2, s0, SKIP_PIXEL_CINE
                sw zero, 0(t6)
                
                SKIP_PIXEL_CINE:
                addi t6, t6, 4
                addi t3, t3, 1
                j LOOP_X_CINE

            NEXT_LINE_CINE:
            addi t1, t1, 1
            j LOOP_Y_CINE

        FIM_DRAW_CINE:
        
        # D) CONTROLE DE TEMPO E SAÍDA
        li a7, 32
        li a0, 30           # Delay 30ms (aprox 30 FPS na animação)
        ecall
        
        # Verifica se o raio chegou perto do alvo (25)
        li t0, 28
        blt s3, t0, FIM_ANIMACAO_CINE
        
        j LOOP_CINE

    FIM_ANIMACAO_CINE:
    # Restaura pilha
    lw s7, 32(sp)
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 36
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
    
#########################################################
# DESENHAR_CENARIO_HITBOX (CORRIGIDO PARA 8x8)
#########################################################
DESENHAR_CENARIO_HITBOX:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- Ler do ponteiro (Mapa Dinâmico) ---
    la t0, PTR_HIT_MAP      
    lw t0, 0(t0)            # Carrega endereço do mapa (LEVEL_HIT_MAP ou M2)
    # ---------------------------------------
    
    li t1, 0                # Contador de índice
    li t2, 1200             # <--- MUDANÇA: Total de tiles (40 colunas * 30 linhas = 1200)

    LOOP_DESENHA_MAPA:
        beq t1, t2, FIM_DESENHA_MAPA # Acabou o array?
        
        lb t3, 0(t0)        # Lê o byte (0 ou 1)
        beqz t3, PROXIMO_TILE # Se for 0, pula

        # Calcula X e Y baseados em Grid 8x8
        li t4, 40           # <--- MUDANÇA: Largura agora é 40 tiles
        
        rem a1, t1, t4      # Coluna = índice % 40
        slli a1, a1, 3      # <--- MUDANÇA: X = Coluna * 8 (Shift Left 3)
        
        div a2, t1, t4      # Linha = índice / 40
        slli a2, a2, 3      # <--- MUDANÇA: Y = Linha * 8 (Shift Left 3)

        # Desenha o bloco (tile)
        la a0, tile_in           
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
        addi t0, t0, 1      # Próximo byte no array
        addi t1, t1, 1      # Incrementa contador
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
    la a0, tile_in
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

# =========================================================
# DESENHAR_NUMERO
# Entrada: a0 = Valor, a1 = X, a2 = Y, a3 = Frame
# =========================================================
# =========================================================
# DESENHAR_NUMERO
# Entrada: a0 = Valor, a1 = X, a2 = Y, a3 = Frame
# =========================================================
DESENHAR_NUMERO:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)   # Frame
    sw s1, 8(sp)   # X
    sw s2, 12(sp)  # Contador dígitos
    sw s3, 16(sp)  # Y

    mv s0, a3
    mv s1, a1
    mv s3, a2
    li s2, 0       

    # Caso Especial: 0
    bnez a0, EXTRAIR_DIGITOS
    la t0, NUMEROS_SPRITES
    lw a0, 0(t0)   # Sprite do 0
    mv a1, s1
    mv a2, s3
    mv a3, s0
    call IMPRIMIR
    j FIM_DESENHAR_NUMERO

    EXTRAIR_DIGITOS:
        blez a0, INICIO_IMPRESSAO
        li t0, 10
        rem t1, a0, t0    # Resto (Dígito)
        div a0, a0, t0    # Divisão
        addi sp, sp, -4
        sw t1, 0(sp)      # Empilha
        addi s2, s2, 1
        j EXTRAIR_DIGITOS

    INICIO_IMPRESSAO:
        beqz s2, FIM_DESENHAR_NUMERO
        lw t1, 0(sp)      # Desempilha
        addi sp, sp, 4
        addi s2, s2, -1
        
        la t2, NUMEROS_SPRITES
        slli t1, t1, 2
        add t2, t2, t1
        lw a0, 0(t2)      # Carrega Sprite
        
        mv a1, s1
        mv a2, s3
        mv a3, s0
        
        # Salva vars críticas antes de chamar IMPRIMIR
        addi sp, sp, -12
        sw s1, 0(sp)
        sw s2, 4(sp)
        sw s3, 8(sp)
        
        call IMPRIMIR
        
        lw s3, 8(sp)
        lw s2, 4(sp)
        lw s1, 0(sp)
        addi sp, sp, 12
        
        addi s1, s1, 9    # Avança X (8 pixels + 1 espaço)
        j INICIO_IMPRESSAO

    FIM_DESENHAR_NUMERO:
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 20
    ret:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)   # Frame
    sw s1, 8(sp)   # X
    sw s2, 12(sp)  # Contador dígitos
    sw s3, 16(sp)  # Y

    mv s0, a3
    mv s1, a1
    mv s3, a2
    li s2, 0       

    # Caso Especial: 0
    bnez a0, EXTRAIR_DIGITOS
    la t0, NUMEROS_SPRITES
    lw a0, 0(t0)   # Sprite do 0
    mv a1, s1
    mv a2, s3
    mv a3, s0
    call IMPRIMIR
    j FIM_DESENHAR_NUMERO

    EXTRAIR_DIGITOS:
        blez a0, INICIO_IMPRESSAO
        li t0, 10
        rem t1, a0, t0    # Resto (Dígito)
        div a0, a0, t0    # Divisão
        addi sp, sp, -4
        sw t1, 0(sp)      # Empilha
        addi s2, s2, 1
        j EXTRAIR_DIGITOS

    INICIO_IMPRESSAO:
        beqz s2, FIM_DESENHAR_NUMERO
        lw t1, 0(sp)      # Desempilha
        addi sp, sp, 4
        addi s2, s2, -1
        
        la t2, NUMEROS_SPRITES
        slli t1, t1, 2
        add t2, t2, t1
        lw a0, 0(t2)      # Carrega Sprite
        
        mv a1, s1
        mv a2, s3
        mv a3, s0
        
        # Salva vars críticas antes de chamar IMPRIMIR
        addi sp, sp, -12
        sw s1, 0(sp)
        sw s2, 4(sp)
        sw s3, 8(sp)
        
        call IMPRIMIR
        
        lw s3, 8(sp)
        lw s2, 4(sp)
        lw s1, 0(sp)
        addi sp, sp, 12
        
        addi s1, s1, 9    # Avança X (8 pixels + 1 espaço)
        j INICIO_IMPRESSAO

    FIM_DESENHAR_NUMERO:
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 20
    ret

# =========================================================
# HUD / BARRA DE STATUS (ATUALIZADA)
# =========================================================
DESENHAR_VIDAS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # --- 1. Apaga/Desenha Corações ---
    la a0, tile_in
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
    
    # Desenha quantos corações restam
    la t0, VIDAS
    lw t0, 0(t0)
    li a1, 30
    li a2, 208
    mv a3, s0
    la a0, hud_coracao
    
    LOOP_VIDAS:
        blez t0, FIM_DESENHAR_VIDAS
        
        addi sp, sp, -12
        sw a1, 0(sp)
        sw a2, 4(sp)
        sw t0, 8(sp)
        
        call IMPRIMIR
        
        lw a1, 0(sp)
        lw a2, 4(sp)
        lw t0, 8(sp)
        addi sp, sp, 12
        
        addi a1, a1, 18
        addi t0, t0, -1
        j LOOP_VIDAS

    FIM_DESENHAR_VIDAS:
    
    # --- 2. PLACAR DE MOEDAS (ESQUERDA) ---
    # Ícone da moeda
    li a1, 63         
    li a2, 223          
    mv a3, s0
    la a0, coin_sprite 
    call IMPRIMIR

    # Número de moedas
    la t0, MOEDAS
    lw a0, 0(t0)       
    li a1, 52         
    li a2, 225          
    mv a3, s0          
    call DESENHAR_NUMERO

    # --- 3. PLACAR DE CARNEIROS (DIREITA - FASE) ---
    # Verifica se estamos no Mapa 3 para desenhar o contador
    la t0, MAPA_ATUAL
    lw t0, 0(t0)
    la t1, map_3
    bne t0, t1, FIM_HUD_FINAL # Se não for mapa 3, não desenha ou desenha 0
    
    # Desenha o número de carneiros coletados
    la t0, SHEEP_COUNT
    lw a0, 0(t0)       # Carrega o valor (Ex: 0, 1, 2...)
    
    # Posição X=280 (Ajuste fino para cair ao lado de "fase:")
    li a1, 280         
    li a2, 225         # Mesma altura das moedas
    mv a3, s0          # Frame buffer atual
    
    call DESENHAR_NUMERO

    FIM_HUD_FINAL:
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

# ... (Dentro de PROCESSAR_ATAQUE)
        # === COLISÃO TIRO vs CARNEIROS (MAPA 3) ===
        la t4, MAPA_ATUAL
        lw t4, 0(t4)
        la t6, map_3
        bne t4, t6, PULA_ATK_SHEEP

        la s3, SHEEP_ARRAY
        li s4, 0
        li s5, MAX_SHEEP
        
        # (Assumindo que X do Tiro está em t5, Y do Tiro está em a7)
        
        LOOP_ATK_SHEEP:
            beq s4, s5, PULA_ATK_SHEEP
            lw t4, 8(s3)     # Ativo?
            beqz t4, NEXT_ATK_S
            
            # Checa Colisão (Box 20x20 aprox)
            lw t6, 0(s3) # SheepX
            sub t6, t6, t5
            bgez t6, ABS_TX
            neg t6, t6
            ABS_TX:
            li a4, 20
            bgt t6, a4, NEXT_ATK_S
            
            lw t6, 4(s3) # SheepY
            sub t6, t6, a7
            bgez t6, ABS_TY
            neg t6, t6
            ABS_TY:
            bgt t6, a4, NEXT_ATK_S
            
            # === ACERTOU CARNEIRO ===
            
            # APLICA LENTIDÃO (SLOW)
            lw t6, 12(s3)      
            li a4, 0x0000FFFF  
            and t6, t6, a4     
            
            li a4, 180         
            slli a4, a4, 16    
            or t6, t6, a4      
            sw t6, 12(s3)      
            
            # --- CORREÇÃO AQUI ---
            addi sp, sp, 8     # <--- ADICIONE ESTA LINHA (Limpa a pilha antes de sair)
            # ---------------------

            # O TIRO MORRE
            j MATAR_TIRO

        NEXT_ATK_S:
            addi s3, s3, 16
            addi s4, s4, 1
            j LOOP_ATK_SHEEP

        PULA_ATK_SHEEP:


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

    ACERTOU_INIMIGO_1:
            lw t0, 4(sp)        
            addi sp, sp, 8
            
            # --- VERIFICA SE É BOSS (MAPA 2) ---
            la t4, MAPA_ATUAL
            lw t4, 0(t4)
            la t5, map_2
            bne t4, t5, MORTE_PADRAO_1 
            
            # --- LÓGICA DE VIDA DO BOSS ---
            la t4, DAMA_VIDA
            lw t5, 0(t4)
            addi t5, t5, -1     # Tira 1 de vida
            sw t5, 0(t4)
            
            # === SE A DAMA MORREU ===
            # Vai para a tela de vitória (onde espera o 'E')
            blez t5, INICIO_VITORIA  
            
            j MATAR_TIRO 

            MORTE_PADRAO_1:
            # (Morte do bispo normal...)
            la t2, PTR_INIMIGO_1
            lw t2, 0(t2)
            li t3, 400          
            sh t3, 0(t2)
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
    
    # Alcance da espada: 24 pixels
    li t4, 24     
    # Tamanho do Inimigo: 30 pixels (margem de segurança do 32)
    li t6, 30

    # Lógica de Caixa (AABB)
    add t5, t2, t6        # X Inimigo + Largura Inimigo
    bge t0, t5, SEM_COLISAO_ATK  # Espada tá à direita do inimigo?
    
    add t5, t0, t4        # X Espada + Largura Espada
    ble t5, t2, SEM_COLISAO_ATK  # Espada tá à esquerda do inimigo?
    
    add t5, t3, t6        # Y Inimigo + Altura Inimigo
    bge t1, t5, SEM_COLISAO_ATK  # Espada tá abaixo?
    
    add t5, t1, t4        # Y Espada + Altura Espada
    ble t5, t3, SEM_COLISAO_ATK  # Espada tá acima?
    
    li a0, 1      # Acertou!
    ret
    SEM_COLISAO_ATK: 
    li a0, 0      # Errou
    ret

#########################################################
# VERIFICAR COLISÕES (CORRIGIDO: FLUXO MOEDAS -> CARNEIROS)
#########################################################
VERIFICAR_COLISOES:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    # --- Checa Itens ---
    la a0, SAMARA_POS
    la a1, ITEM_VELO
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, PEGAR_ITEM_VELOCIDADE
    
    la a0, SAMARA_POS
    la a1, ITEM_VIDA
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, PEGAR_ITEM_VIDA
    
    j CHECK_MOEDAS_LOOP  

    PEGAR_ITEM_VELOCIDADE:
        la t0, ITEM_VELO
        lh t1, 4(t0)
        beqz t1, CHECK_MOEDAS_LOOP   
        li t1, 0
        sh t1, 4(t0) 
        call TOCAR_SOM_COLETA
        la a0, ITEM_VELO
        call LIMPAR_FUNDO_ITEM
        la t0, VELO_SAMARA
        li t1, 8
        sw t1, 0(t0)
        j CHECK_MOEDAS_LOOP      

    PEGAR_ITEM_VIDA:
        la t0, ITEM_VIDA
        lh t1, 4(t0)
        beqz t1, CHECK_MOEDAS_LOOP
        li t1, 0
        sh t1, 4(t0)
        call TOCAR_SOM_COLETA
        la a0, ITEM_VIDA
        call LIMPAR_FUNDO_ITEM
        la t0, VIDAS
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)

    # --- LOOP DE COLISÃO MOEDAS ---
    CHECK_MOEDAS_LOOP:
    li s1, 0                 
    la s2, LISTA_MOEDAS      

    LOOP_COLISAO_MOEDAS:
        li t0, QTD_MOEDAS
        # === CORREÇÃO AQUI ===
        # Antes pulava para VERIFICAR_DANO. Agora vai para os carneiros.
        bge s1, t0, VERIFICAR_CARNEIROS  
        # =====================

        lh t1, 4(s2)
        beqz t1, NEXT_COIN_COL

        la a0, SAMARA_POS    
        mv a1, s2            
        call VERIFICAR_COLISAO_CAIXA
        bnez a0, ROTINA_PEGAR_MOEDA
        
        j NEXT_COIN_COL

    ROTINA_PEGAR_MOEDA:
        li t0, 0
        sh t0, 4(s2)         

        call TOCAR_SOM_COLETA
        mv a0, s2            
        call LIMPAR_FUNDO_ITEM

        la t0, MOEDAS
        lw t1, 0(t0)
        addi t1, t1, 1      
        sw t1, 0(t0)
        
    NEXT_COIN_COL:
        addi s2, s2, TAM_MOEDA_BYTES  
        addi s1, s1, 1
        j LOOP_COLISAO_MOEDAS

    # === COLETA DE CARNEIROS ===
    VERIFICAR_CARNEIROS:  # <--- RÓTULO ADICIONADO PARA O PULO
    
    # 1. Verifica se estamos no Mapa 3
    la t0, PTR_HIT_MAP
    lw t0, 0(t0)
    la t1, LEVEL_HIT_MAP_3
    bne t0, t1, FIM_CHECK_SHEEP 

    la s2, SHEEP_ARRAY  
    li s1, 0
    li t2, 8        
    
    LOOP_COL_SHEEP:
        beq s1, t2, FIM_CHECK_SHEEP
        
        lw t3, 8(s2)     # Ativo?
        beqz t3, NEXT_COL_S
        
        # --- COLISÃO BOX ---
        lw t0, 0(s2)    # Sheep X
        lw t1, 4(s2)    # Sheep Y
        la t3, SAMARA_POS
        lh t4, 0(t3)    # Samara X
        lh t5, 2(t3)    # Samara Y
        
        li t6, 20       # Distância de coleta
        
        # Distância X
        sub a4, t0, t4
        bgez a4, ABS_SX
        neg a4, a4
        ABS_SX:
        bgt a4, t6, NEXT_COL_S 
        
        # Distância Y
        sub a4, t1, t5
        bgez a4, ABS_SY
        neg a4, a4
        ABS_SY:
        bgt a4, t6, NEXT_COL_S 
        
        # === COLETOU! ===
        sw zero, 8(s2)  # Desativa
        call TOCAR_SOM_COLETA
        
        # INCREMENTA CONTADOR
        la t0, SHEEP_COUNT
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)
        
        # Checa Vitória (8 Coletados)
        li t3, 8
        bge t1, t3, TELA_FINAL_REAL

    NEXT_COL_S:
        addi s2, s2, 16
        addi s1, s1, 1
        j LOOP_COL_SHEEP

    FIM_CHECK_SHEEP:

    VERIFICAR_DANO:
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    blez t1, FAZER_VERIFICACAO    
    addi t1, t1, -1               
    sw t1, 0(t0)
    j FIM_COLISOES

    FAZER_VERIFICACAO:
    # Slot 1
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_1    
    lw a1, 0(t0)            
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO   

    # Slot 2
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_2
    lw a1, 0(t0)
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO

    # Slot 3
    la a0, SAMARA_POS
    la t0, PTR_INIMIGO_3
    lw a1, 0(t0)
    call VERIFICAR_COLISAO_CAIXA
    bnez a0, RECEBEU_DANO

    j FIM_COLISOES

    RECEBEU_DANO:
    call SOM_DANO
    la t0, VIDAS
    lw t1, 0(t0)
    addi t1, t1, -1       
    sw t1, 0(t0)
    la t0, INVULNERAVEL
    li t1, 60             
    sw t1, 0(t0)

    FIM_COLISOES:
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12
    ret

# Apaga o item da tela desenhando chão (0) e parede (1) em volta?
# (A lógica aqui tá meio hardcoded pra limpar a área do item)
LIMPAR_FUNDO_ITEM:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile_in
    li a3, 0
    call IMPRIMIR
    li a3, 1
    call IMPRIMIR
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# =========================================================
# Lógica AABB (Axis-Aligned Bounding Box) - 32x32 COMPATÍVEL
# =========================================================
VERIFICAR_COLISAO_CAIXA:
    lh t0, 0(a0)  # X1 (Objeto 1 - Ex: Samara)
    lh t1, 2(a0)  # Y1 (Objeto 1)
    lh t2, 0(a1)  # X2 (Objeto 2 - Ex: Inimigo 32x32)
    lh t3, 2(a1)  # Y2 (Objeto 2)
    
    # --- TAMANHO DA HITBOX ---
    # Se o sprite é 32x32, usamos ~26 ou 28 para dar uma folga
    li t4, 26      
    
    # Verifica sobreposição X
    add t5, t2, t4      # X2 + Largura
    bge t0, t5, SEM_COLISAO # Se X1 >= (X2 + Largura), tá à direita
    
    add t5, t0, t4      # X1 + Largura
    ble t5, t2, SEM_COLISAO # Se (X1 + Largura) <= X2, tá à esquerda
    
    # Verifica sobreposição Y
    add t5, t3, t4      # Y2 + Altura
    bge t1, t5, SEM_COLISAO # Se Y1 >= (Y2 + Altura), tá abaixo
    
    add t5, t1, t4      # Y1 + Altura
    ble t5, t3, SEM_COLISAO # Se (Y1 + Altura) <= Y2, tá acima
    
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
    srli t0, a0, 3      # Coluna = X / 8  <--- ALTERADO: Divisão por 8 (antigo 4)
    srli t1, a1, 3      # Linha = Y / 8   <--- ALTERADO: Divisão por 8 (antigo 4)
    
    # 2. Proteção de limites
    li t2, 40           # <--- ALTERADO: 40 Colunas (antigo 20)
    bge t0, t2, DEU_COLISAO
    li t2, 30           # <--- ALTERADO: 30 Linhas (antigo 15)
    bge t1, t2, DEU_COLISAO

    # 3. Calcular Índice no Array
    li t2, 40           # <--- ALTERADO: Multiplicador 40 (antigo 20)
    mul t1, t1, t2      # Linha * 40
    add t0, t0, t1      # + Coluna
    
    la t3, PTR_HIT_MAP
    lw t3, 0(t3)
    # -------------------------------------

    add t3, t3, t0      # Soma offset no mapa atual
    lb t4, 0(t3)        # Lê o valor (0, 1 ou 3)
    
    mv a0, t4           
    ret

    DEU_COLISAO:
    li a0, 1
    ret

# =========================================================
# VERIFICAR ENTRADA (MOVIMENTO + DIREÇÃO + ATAQUE + LOJA)
# COM NOVA LÓGICA DE ANIMAÇÃO DINÂMICA
# =========================================================
VERIFICAR_ENTRADA:
    # 1. Salvar RA na pilha
    addi sp, sp, -4
    sw ra, 0(sp)

    # Verifica se há tecla pressionada
    li t1, 0xFF200000
    lw t0, 0(t1)
    andi t0, t0, 1
    beqz t0, RETORNAR_ENTRADA_NO_KEY
    lw t2, 4(t1)       # t2 = Tecla pressionada
    
    # --- PRIORIDADE DO ATAQUE ---
    li t0, 32          # ASCII do Espaço
    beq t2, t0, INPUT_ATACAR
    # ----------------------------------------

    # Carrega velocidade
    la t0, VELO_SAMARA
    lw t3, 0(t0)
    
    li t6, 0    # FLAG: 0 = Parado, 1 = Andou
    
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
        # --- ATUALIZA DIREÇÃO (0 = CIMA) ---
        la t0, SAMARA_DIR
        li t1, 0
        sw t1, 0(t0)

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
        addi a0, a0, 8
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

        # === DETECÇÃO DA LOJA (4) ===
        li t4, 4
        beq t5, t4, TENTAR_ABRIR_LOJA

        # === RESET DEBOUNCE DA LOJA ===
        bnez t5, CHECK_WALL_W
        la t4, LOJA_DEBOUNCE
        sw zero, 0(t4)
        CHECK_WALL_W:

        # Se bateu (t5 != 0), sai
        bnez t5, RETORNAR_ENTRADA 
        
        # Se livre:
        sh t1, 2(t0)
        
        # --- CHAMA ANIMAÇÃO W (3 Frames) ---
        la a0, SEQ_W       # Label da sequência no .data
        li a1, 3           # Quantidade de frames
        call PROCESSAR_ANIM_ESTADO
        j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # MOVIMENTO BAIXO (S)
    # -----------------------------------------------------
    MOVER_BAIXO: 
        # --- ATUALIZA DIREÇÃO (1 = BAIXO) ---
        la t0, SAMARA_DIR
        li t1, 1
        sw t1, 0(t0)

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
        addi a1, a1, 8
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

        # === DETECÇÃO DA LOJA (4) ===
        li t4, 4
        beq t5, t4, TENTAR_ABRIR_LOJA

        # === RESET DEBOUNCE DA LOJA ===
        bnez t5, CHECK_WALL_S
        la t4, LOJA_DEBOUNCE
        sw zero, 0(t4)
        CHECK_WALL_S:

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 2(t0)
        
        # --- CHAMA ANIMAÇÃO S (3 Frames) ---
        la a0, SEQ_S
        li a1, 3
        call PROCESSAR_ANIM_ESTADO
        j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # MOVIMENTO ESQUERDA (A)
    # -----------------------------------------------------
    MOVER_ESQUERDA: 
        # --- ATUALIZA DIREÇÃO (2 = ESQ) ---
        la t0, SAMARA_DIR
        li t1, 2
        sw t1, 0(t0)

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
        addi a1, a1, 8
        
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

        # === DETECÇÃO DA LOJA (4) ===
        li t4, 4
        beq t5, t4, TENTAR_ABRIR_LOJA

        # === RESET DEBOUNCE DA LOJA ===
        bnez t5, CHECK_WALL_A
        la t4, LOJA_DEBOUNCE
        sw zero, 0(t4)
        CHECK_WALL_A:

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        
        # --- CHAMA ANIMAÇÃO A (2 Frames) ---
        la a0, SEQ_A
        li a1, 2
        call PROCESSAR_ANIM_ESTADO
        j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # MOVIMENTO DIREITA (D)
    # -----------------------------------------------------
    MOVER_DIREITA: 
        # --- ATUALIZA DIREÇÃO (3 = DIR) ---
        la t0, SAMARA_DIR
        li t1, 3
        sw t1, 0(t0)

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
        addi a0, a0, 8
        mv a1, t2
        call CHECAR_COLISAO_MAPA
        mv t5, a0

        # Checa Canto Inferior Direito
        lw t1, 4(sp)
        mv a0, t1
        addi a0, a0, 8
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

        # === DETECÇÃO DA LOJA (4) ===
        li t4, 4
        beq t5, t4, TENTAR_ABRIR_LOJA

        # === RESET DEBOUNCE DA LOJA ===
        bnez t5, CHECK_WALL_D
        la t4, LOJA_DEBOUNCE
        sw zero, 0(t4)
        CHECK_WALL_D:

        bnez t5, RETORNAR_ENTRADA
        
        sh t1, 0(t0)
        
        # --- CHAMA ANIMAÇÃO D (2 Frames) ---
        la a0, SEQ_D
        li a1, 2
        call PROCESSAR_ANIM_ESTADO
        j RETORNAR_ENTRADA
    
    # -----------------------------------------------------
    # LÓGICA DE ABRIR A LOJA
    # -----------------------------------------------------
    TENTAR_ABRIR_LOJA:
        la t0, LOJA_DEBOUNCE
        lw t1, 0(t0)
        bnez t1, RETORNAR_ENTRADA # Se já visitou (debounce=1), ignora e não abre

        # Abre a loja
        la t0, LOJA_ABERTA
        li t1, 1
        sw t1, 0(t0)
        
        # Trava (Debounce)
        la t0, LOJA_DEBOUNCE
        sw t1, 0(t0)
        
        j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # INPUT DE ATAQUE (ESPAÇO)
    # -----------------------------------------------------
    INPUT_ATACAR:
        call TENTAR_ATACAR

        # --- CHAMA ANIMAÇÃO DE ATAQUE (3 Frames) ---
        la a0, SEQ_ATK
        li a1, 3
        call PROCESSAR_ANIM_ESTADO
        j RETORNAR_ENTRADA

    # -----------------------------------------------------
    # SAÍDA DA FUNÇÃO
    # -----------------------------------------------------
    RETORNAR_ENTRADA:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

    RETORNAR_ENTRADA_NO_KEY:
        # Se não tem tecla pressionada, não chamamos PROCESSAR_ANIM_ESTADO.
        # O ponteiro de frame não atualiza, fazendo a animação "parar"
        # no último frame desenhado (efeito correto).
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

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
        beqz t6, RESETAR_TIMER_PASSO  # Se t6 for 0 (parado), não anima
        # --- Se chegou aqui, ele está andando (t6=1) ---
        call ATUALIZAR_FRAME       
        
    RETORNAR_ENTRADA:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret
    RESETAR_TIMER_PASSO:
        # Faz o próximo passo sair instantâneo quando começar a andar de novo
        la t0, PASSO_TIMER
        li t1, 19          
        sw t1, 0(t0)
        j RETORNAR_ENTRADA
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

MUDAR_PARA_MAPA_3:
    # 1. Troca Imagem e Colisão
    la t0, MAPA_ATUAL
    la t1, map_3        
    sw t1, 0(t0)
    
    la t0, PTR_HIT_MAP
    la t1, LEVEL_HIT_MAP_3
    sw t1, 0(t0)

    # 2. LIMPA INIMIGOS ANTIGOS
    la t0, POS_OCULTA
    la t1, PTR_INIMIGO_1
    sw t0, 0(t1)
    la t1, PTR_INIMIGO_2
    sw t0, 0(t1)
    la t1, PTR_INIMIGO_3
    sw t0, 0(t1)
    
    # === CORREÇÃO: LIMPEZA DE ESTADO SUJO ===
    
    # A) Remove todos os tiros da tela (Zera TIRO_ATIVO)
    la t0, TIRO_ATIVO
    sw zero, 0(t0)
    sw zero, 4(t0)
    sw zero, 8(t0)

    # B) Reseta o Pet (Para de buscar itens antigos)
    la t0, KIT_STATE
    sw zero, 0(t0)     # Volta para o estado 0 (Seguir Samara)
    la t0, KIT_TARGET_PTR
    sw zero, 0(t0)     # Limpa ponteiro de alvo
    
    # ========================================

    # 3. RESET E SPAWN DOS 8 CARNEIROS
    la t0, SHEEP_COUNT
    sw zero, 0(t0)
    la t0, SHEEP_TIMER
    sw zero, 0(t0)
    
    # ... (O resto da sua função continua igual)
    # --- LIMPEZA TOTAL DO ARRAY ---
    la t0, SHEEP_ARRAY
    li t1, 60 
    LOOP_CLEAR_M3:
        sw zero, 0(t0)
        addi t0, t0, 4
        addi t1, t1, -1
        bnez t1, LOOP_CLEAR_M3
    
    # --- SPAWNAR 8 FIXOS ---
    la t0, SHEEP_ARRAY
    
    # Carneiro 0
    li t1, 50   # X
    sw t1, 0(t0)
    li t1, 50   # Y
    sw t1, 4(t0)
    li t1, 1    # Ativo
    sw t1, 8(t0)
    
    # Carneiro 1
    addi t0, t0, 16
    li t1, 100
    sw t1, 0(t0)
    li t1, 50
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 2
    addi t0, t0, 16
    li t1, 150
    sw t1, 0(t0)
    li t1, 50
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 3
    addi t0, t0, 16
    li t1, 200
    sw t1, 0(t0)
    li t1, 50
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 4
    addi t0, t0, 16
    li t1, 50
    sw t1, 0(t0)
    li t1, 150
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 5
    addi t0, t0, 16
    li t1, 100
    sw t1, 0(t0)
    li t1, 150
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 6
    addi t0, t0, 16
    li t1, 150
    sw t1, 0(t0)
    li t1, 150
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # Carneiro 7
    addi t0, t0, 16
    li t1, 200
    sw t1, 0(t0)
    li t1, 150
    sw t1, 4(t0)
    li t1, 1
    sw t1, 8(t0)

    # 4. Teleporta Jogador
    la t0, SAMARA_POS
    li t1, 160
    sh t1, 0(t0)
    li t1, 100
    sh t1, 2(t0)
    
    call TOCAR_SOM_COLETA
    
    # Limpa tela
    li s0, 0
    call LIMPAR_TELA_TOTAL
    li s0, 1
    call LIMPAR_TELA_TOTAL
    
    j LOOP_DO_JOGO

# ATUALIZAÇÃO DE INIMIGOS (INDEPENDENTE)
ATUALIZAR_INIMIGOS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Verifica Mapa
    la t0, MAPA_ATUAL
    lw t0, 0(t0)
    
    la t1, map_2
    beq t0, t1, MODO_BOSS_DAMA 
    
    la t1, map_3
    beq t0, t1, MODO_CARNEIROS_M3  # <--- NOVO DESVIO

    # --- MODO NORMAL (MAPA 1) ---
    # Controle de Delay para inimigos normais
    la t0, TEMP_RIVAL
    lw t1, 0(t0)
    addi t1, t1, 1
    la t2, LAG_RIVAL
    lw t2, 0(t2)
    bge t1, t2, EXECUTAR_MOVIMENTO_NORMAL
    sw t1, 0(t0)
    j FIM_ATUALIZAR_INIMIGOS

    EXECUTAR_MOVIMENTO_NORMAL:
    sw zero, 0(t0) 
    call MOVER_CAVALO
    call MOVER_CASTELO
    call MOVER_BISPO
    j FIM_ATUALIZAR_INIMIGOS

    MODO_BOSS_DAMA:
    call MOVER_DAMA
    j FIM_ATUALIZAR_INIMIGOS

    # --- MODO MAPA 3 (CARNEIROS) ---
    MODO_CARNEIROS_M3:
    call LOGICA_CARNEIROS
    
    FIM_ATUALIZAR_INIMIGOS:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# CAVALO - Lógica 32x32
MOVER_CAVALO:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a1, CAVALO_STATE
    la a2, CAVALO_CONT
    lw t0, 0(a1)        
    lw t1, 0(a2)        
    
    bnez t0, CAVALO_MOVER_Y 

    # --- MOVIMENTO X ---
    CAVALO_MOVER_X:
        la t6, CAVALO_X
        lw t3, 0(t6)        
        la a0, CAVALO_POS
        lh t4, 0(a0)        
        add t4, t4, t3      
        
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t4, 8(sp)

        mv a0, t4
        blt t3, zero, VERIFICAR_CANTO_X_ESQ
        addi a0, a0, 28     # <--- X + 28
        VERIFICAR_CANTO_X_ESQ:
        la t2, CAVALO_POS
        lh a1, 2(t2)        
        addi a1, a1, 16     # <--- Y + 16 (Meio)
        call CHECAR_COLISAO_MAPA
        mv t5, a0 

        lw t4, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12

        bnez t5, CAVALO_BATEU_X
        
        li t2, 288          # <--- 320 - 32
        bge t4, t2, CAVALO_BATEU_X
        li t2, 8
        blt t4, t2, CAVALO_BATEU_X
        
        la a0, CAVALO_POS
        sh t4, 0(a0)        
        
        addi t1, t1, 1      
        li t2, 30
        blt t1, t2, CAVALO_SAIR 
        
        li t1, 0            
        li t0, 1            
        j CAVALO_SALVAR_ESTADO
        
        CAVALO_BATEU_X: 
        la t6, CAVALO_X
        lw t3, 0(t6)
        sub t3, zero, t3    
        sw t3, 0(t6)
        li t1, 0            
        li t0, 1            
        j CAVALO_SALVAR_ESTADO

    # --- MOVIMENTO Y ---
    CAVALO_MOVER_Y:
        la t5, CAVALO_Y
        lw t3, 0(t5)        
        la a0, CAVALO_POS
        lh t4, 2(a0)        
        add t4, t4, t3      
        
        addi sp, sp, -12
        sw t0, 0(sp)
        sw t1, 4(sp)
        sw t4, 8(sp)

        la t2, CAVALO_POS
        lh a0, 0(t2)        
        addi a0, a0, 16     # <--- X + 16 (Meio)
        mv a1, t4           
        blt t3, zero, CHK_C_Y_CIMA
        addi a1, a1, 28     # <--- Y + 28
        CHK_C_Y_CIMA:
        call CHECAR_COLISAO_MAPA
        mv t5, a0           

        lw t4, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 12

        bnez t5, CAVALO_BATEU_Y
        li t2, 208          # <--- 240 - 32
        bge t4, t2, CAVALO_BATEU_Y
        li t2, 8
        blt t4, t2, CAVALO_BATEU_Y
        
        la a0, CAVALO_POS
        sh t4, 2(a0)        
        
        addi t1, t1, 1
        li t2, 30
        blt t1, t2, CAVALO_SAIR
        
        li t1, 0
        li t0, 0            
        j CAVALO_SALVAR_ESTADO

        CAVALO_BATEU_Y:
        la t5, CAVALO_Y
        lw t3, 0(t5)
        sub t3, zero, t3
        sw t3, 0(t5)
        li t1, 0
        li t0, 0            
        j CAVALO_SALVAR_ESTADO

    CAVALO_SALVAR_ESTADO: 
    la a1, CAVALO_STATE
    sw t0, 0(a1)        
    CAVALO_SAIR:
    la a2, CAVALO_CONT
    sw t1, 0(a2)        
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# CASTELO (Torre) - Lógica 32x32
MOVER_CASTELO:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, CASTELO_POS
    la a1, CASTELO_X
    lh t0, 0(a0)      # X Atual
    lw t2, 0(a1)      # Velocidade
    add t0, t0, t2    # X Futuro

    # --- CHECK 1: Canto Esquerdo (X_Futuro, Y + Centro) ---
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t2, 4(sp)
    sw a0, 8(sp)
    sw a1, 12(sp)

    mv a0, t0           # X Futuro
    la t5, CASTELO_POS
    lh a1, 2(t5)        # Y Atual
    addi a1, a1, 16     # <--- Y + 16 (Centro da altura 32)
    call CHECAR_COLISAO_MAPA
    mv t5, a0           

    # --- CHECK 2: Canto Direito (X_Futuro + 28, Y + Centro) ---
    lw t0, 0(sp)        
    mv a0, t0
    addi a0, a0, 28     # <--- X + 28 (Borda Direita do Sprite 32)
    la t6, CASTELO_POS
    lh a1, 2(t6)
    addi a1, a1, 16     # <--- Y + 16 (Centro)
    
    addi sp, sp, -4
    sw t5, 0(sp)
    call CHECAR_COLISAO_MAPA
    lw t5, 0(sp)
    addi sp, sp, 4

    or t5, t5, a0       # Bateu na Esq OU na Dir?

    lw a1, 12(sp)
    lw a0, 8(sp)
    lw t2, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    bnez t5, INVERTER_CASTELO

    # Check Bordas da Tela (Considerando 32px)
    li t3, 288          # <--- 320 - 32 = 288 (Borda direita segura)
    bge t0, t3, INVERTER_CASTELO
    li t3, 8
    blt t0, t3, INVERTER_CASTELO
    
    sh t0, 0(a0) 
    lw ra, 0(sp)      
    addi sp, sp, 4
    ret
    
    INVERTER_CASTELO: 
    sub t2, zero, t2  
    sw t2, 0(a1)
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# BISPO (Slime Diagonal) - Lógica 32x32
MOVER_BISPO:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, BISPO_POS
    la a1, BISPO_X
    la a2, BISPO_Y
    lh t0, 0(a0)      # X
    lh t1, 2(a0)      # Y
    lw t2, 0(a1)      # Vel X
    lw t3, 0(a2)      # Vel Y

    # === MOVIMENTO X ===
    add t4, t0, t2    
    
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    mv a0, t4         
    blt t2, zero, VERIFICAR_BISPO_X
    addi a0, a0, 28   # <--- Se indo pra direita, checa X + 28
    VERIFICAR_BISPO_X:
    la t6, BISPO_POS
    lh a1, 2(t6)      
    addi a1, a1, 16   # <--- Checa Y no meio (16)
    call CHECAR_COLISAO_MAPA
    mv t5, a0         

    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    bnez t5, INVERTER_BISPO_X
    
    # Limites de tela (32px)
    li t6, 288        # <--- 320 - 32
    bge t4, t6, INVERTER_BISPO_X
    li t6, 8
    blt t4, t6, INVERTER_BISPO_X
    
    mv t0, t4
    j FIM_BISPO_X

    INVERTER_BISPO_X:
    sub t2, zero, t2  
    la a1, BISPO_X    
    sw t2, 0(a1)      

    FIM_BISPO_X:

    # === MOVIMENTO Y ===
    add t4, t1, t3    
    
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)

    mv a1, t4         
    blt t3, zero, CHK_B_Y
    addi a1, a1, 28   # <--- Se indo pra baixo, checa Y + 28
    CHK_B_Y:
    mv a0, t0         
    addi a0, a0, 16   # <--- Checa X no meio (16)
    call CHECAR_COLISAO_MAPA
    mv t5, a0

    lw t4, 16(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 20

    bnez t5, INVERTER_BISPO_Y
    
    li t6, 208        # <--- 240 - 32
    bge t4, t6, INVERTER_BISPO_Y
    li t6, 8
    blt t4, t6, INVERTER_BISPO_Y
    
    mv t1, t4
    j FIM_BISPO_Y

    INVERTER_BISPO_Y:
    sub t3, zero, t3  
    la a2, BISPO_Y    
    sw t3, 0(a2)

    FIM_BISPO_Y:
    la a0, BISPO_POS  
    sh t0, 0(a0)
    sh t1, 2(a0)

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
# ==========================================
# MOVER DAMA (COM DESEMPERRADOR AUTOMÁTICO)
# ==========================================
MOVER_DAMA:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, DAMA_POS
    lh t1, 0(t0)        # t1 = Dama X
    lh t2, 2(t0)        # t2 = Dama Y

    # --- VERIFICA SE ESTÁ MORTA ---
    li t3, 350
    bge t1, t3, FIM_MOVER_DAMA  # Se X >= 350, ela tá morta. Não faz nada.

    # --- 1. CERCA DE SEGURANÇA (ANTI-STUCK) ---
    # Se ela estiver na parede (X < 16 ou Y < 16), empurra pra dentro da arena
    li t3, 16           
    
    # Checa Esquerda/Topo
    blt t1, t3, FORCAR_POSICAO
    blt t2, t3, FORCAR_POSICAO
    
    # Checa Direita/Baixo (Limites da tela - margem)
    li t3, 290
    bgt t1, t3, FORCAR_POSICAO
    li t3, 210
    bgt t2, t3, FORCAR_POSICAO
    
    j INICIO_MOVIMENTO

    FORCAR_POSICAO:
    # Se caiu aqui, ela está bugada na parede. 
    # Força ela para uma posição segura próxima (16, 16) ou apenas ajusta a borda.
    # Vamos usar um "clamp" simples: se < 16, vira 16.
    
    li t3, 16
    bge t1, t3, CHECK_MAX_X
    mv t1, t3           # X = 16
    sh t1, 0(t0)
    CHECK_MAX_X:
    li t3, 290
    ble t1, t3, CHECK_MIN_Y
    mv t1, t3           # X = 290
    sh t1, 0(t0)
    
    CHECK_MIN_Y:
    li t3, 16
    bge t2, t3, CHECK_MAX_Y
    mv t2, t3           # Y = 16 (Sai de cima das chaves/HUD)
    sh t2, 2(t0)
    CHECK_MAX_Y:
    li t3, 210
    ble t2, t3, INICIO_MOVIMENTO
    mv t2, t3           # Y = 210
    sh t2, 2(t0)

    # --- 2. LÓGICA DE PERSEGUIÇÃO ---
    INICIO_MOVIMENTO:
    la t3, SAMARA_POS
    lh t4, 0(t3)        # Samara X
    lh t5, 2(t3)        # Samara Y
    li s1, 2            # Velocidade

    # --- EIXO X ---
    beq t1, t4, CHECK_Y_DAMA
    blt t1, t4, DAMA_DIR       
    
    # Esquerda
    sub t6, t1, s1      # X Futuro
    mv a0, t6           
    j TESTAR_COLISAO_X
    
    DAMA_DIR:
    # Direita
    add t6, t1, s1      
    addi a0, t6, 8     

    TESTAR_COLISAO_X:
    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t4, 12(sp) # Salva Samara X só pra garantir alinhamento
    sw t5, 16(sp) # Salva Samara Y
    sw t6, 20(sp) 
    sw a0, 24(sp) # Reusa slot 12 pra salvar X teste

    mv a1, t2    
    addi a1, a1, 3    # Y + 4 (Margem segura)
    call CHECAR_COLISAO_MAPA
    mv t3, a0

    lw a0, 12(sp)
    mv a1, t2
    addi a1, a1, 12   # Y + 10 (Margem segura)
    
    addi sp, sp, -4
    sw t3, 0(sp)
    call CHECAR_COLISAO_MAPA
    lw t3, 0(sp)
    addi sp, sp, 4
    
    or t3, t3, a0 

    lw t6, 20(sp)
    lw t5, 16(sp)
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 28

    bnez t3, CHECK_Y_DAMA
    sh t6, 0(t0)        
    mv t1, t6           

    # --- EIXO Y ---
    CHECK_Y_DAMA:
    # Recarrega Samara Y garantido
    la t3, SAMARA_POS
    lh t5, 2(t3)

    beq t2, t5, FIM_MOVER_DAMA
    blt t2, t5, DAMA_BAIXO

    # Cima
    sub t6, t2, s1             
    mv a1, t6
    j TESTAR_COLISAO_Y

    DAMA_BAIXO:
    # Baixo
    add t6, t2, s1             
    addi a1, t6, 8

TESTAR_COLISAO_Y:
    addi sp, sp, -28
    sw t6, 0(sp)        # Y Futuro
    sw a1, 4(sp)        # Y de Teste
    sw t0, 8(sp)        # Endereço Dama
    sw t1, 12(sp)       # <--- CRUCIAL: Salva X da Dama (t1)
    # (t2 não é usado aqui dentro, mas t1 é obrigatório)

    mv a0, t1    
    addi a0, a0, 3     # X + 3
    call CHECAR_COLISAO_MAPA
    mv t3, a0

    lw a1, 4(sp)       # Recupera Y de Teste
    lw t1, 12(sp)      # <--- RECUPERA X DA DAMA (t1)
    mv a0, t1
    addi a0, a0, 12    # X + 12
    
    addi sp, sp, -4
    sw t3, 0(sp)
    call CHECAR_COLISAO_MAPA
    lw t3, 0(sp)
    addi sp, sp, 4

    or t3, t3, a0 

    # Restaura registradores originais
    lw t1, 12(sp)       # <--- Restaura t1 para o estado original
    lw t0, 8(sp)
    lw a1, 4(sp)
    lw t6, 0(sp)
    addi sp, sp, 28

    bnez t3, FIM_MOVER_DAMA
    sh t6, 2(t0)        # Atualiza Y na memória

    FIM_MOVER_DAMA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
ATUALIZAR_KIT:
    addi sp, sp, -4
    sw ra, 0(sp)

    # 1. Máquina de Estados
    la t0, KIT_STATE
    lw t1, 0(t0)
    bnez t1, KIT_ESTADO_BUSCA

    # --- ESTADO 0: SEGUINDO SAMARA ---
    # Escaneia itens
    call KIT_SCANNER
    la t0, KIT_STATE
    lw t1, 0(t0)
    bnez t1, KIT_ESTADO_BUSCA 

    # Se não tem item, segue a Samara
    la t0, SAMARA_POS
    lh a0, 0(t0)    # Alvo X
    lh a1, 2(t0)    # Alvo Y
    
    # === MUDANÇA AQUI: DE 4 PARA 24 PIXELS ===
    li a2, 18       # Distância "confortável" (não cola no player)
    # =========================================
    
    call KIT_MOVIMENTO
    j FIM_ATT_KIT

    # --- ESTADO 1: BUSCANDO ITEM ---
    KIT_ESTADO_BUSCA:
    la t0, KIT_TARGET_X
    lw a0, 0(t0)
    la t0, KIT_TARGET_Y
    lw a1, 0(t0)
    li a2, 0        # Para itens, ele vai até encostar (0)
    call KIT_MOVIMENTO

    call KIT_VERIFICAR_COLETA

    FIM_ATT_KIT:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# -------------------------------------------------------
# SCANNER DE ITENS (RAIO 32 PIXELS)
# -------------------------------------------------------
KIT_SCANNER:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Verifica Item Velocidade
    la t0, ITEM_VELO
    lh t1, 4(t0)       # Ativo?
    beqz t1, CHECK_SCAN_VIDA
    mv a0, t0
    li a1, 1           # Tipo 1 = Velo
    call KIT_CHECA_DISTANCIA
    bnez a0, ACHOU_ITEM

    # Verifica Item Vida
    CHECK_SCAN_VIDA:
    la t0, ITEM_VIDA
    lh t1, 4(t0)
    beqz t1, CHECK_SCAN_MOEDAS
    mv a0, t0
    li a1, 2           # Tipo 2 = Vida
    call KIT_CHECA_DISTANCIA
    bnez a0, ACHOU_ITEM

    # Verifica Lista de Moedas
    CHECK_SCAN_MOEDAS:
    li t2, 0                 # Índice
    la t3, LISTA_MOEDAS      # Ponteiro
    li t4, QTD_MOEDAS
    
    LOOP_SCAN_MOEDAS:
        bge t2, t4, SAIR_SCANNER
        lh t5, 4(t3)         # Ativo?
        beqz t5, PROX_SCAN_MOEDA
        
        # Salva regs temp
        addi sp, sp, -16
        sw t2, 0(sp)
        sw t3, 4(sp)
        sw t4, 8(sp)
        
        mv a0, t3            # Endereço da moeda atual
        li a1, 0             # Tipo 0 = Moeda
        call KIT_CHECA_DISTANCIA
        mv t5, a0            # Resultado
        
        lw t4, 8(sp)
        lw t3, 4(sp)
        lw t2, 0(sp)
        addi sp, sp, 16
        
        bnez t5, ACHOU_ITEM  # Se achou, a função KIT_CHECA já configurou o alvo

    PROX_SCAN_MOEDA:
        addi t3, t3, 6       # Próxima moeda (6 bytes)
        addi t2, t2, 1
        j LOOP_SCAN_MOEDAS

    SAIR_SCANNER:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

ACHOU_ITEM:
    # Configura estado para buscar
    la t0, KIT_STATE
    li t1, 1
    sw t1, 0(t0)
    
    # === ADICIONADO: TOCA O MIADO AO SAIR ===
    call TOCAR_SOM_MIADO
    # ========================================
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Helper: Checa se Item em A0 está perto do Kit. Se sim, seta alvo.
# Entrada: a0 = Endereço Item, a1 = Tipo
# Saída: a0 = 1 se achou, 0 se não
KIT_CHECA_DISTANCIA:
    lh t0, 0(a0)     # Item X
    lh t1, 2(a0)     # Item Y
    la t2, KIT_POS
    lh t3, 0(t2)     # Kit X
    lh t4, 2(t2)     # Kit Y

    # Distância Manhattan Simples (dx < 32 && dy < 32)
    sub t5, t0, t3   # dx
    bgez t5, ABS_DX
    neg t5, t5
    ABS_DX:
    li t6, 32
    bge t5, t6, LONGE

    sub t5, t1, t4   # dy
    bgez t5, ABS_DY
    neg t5, t5
    ABS_DY:
    li t6, 32
    bge t5, t6, LONGE

    # ESTÁ PERTO! Configura Alvo
    la t2, KIT_TARGET_X
    sw t0, 0(t2)
    la t2, KIT_TARGET_Y
    sw t1, 0(t2)
    la t2, KIT_TARGET_PTR
    sw a0, 0(t2)
    la t2, KIT_TARGET_TYPE
    sw a1, 0(t2)
    
    li a0, 1
    ret

    LONGE:
    li a0, 0
    ret

# -------------------------------------------------------
# MOVIMENTAÇÃO INTELIGENTE DO PET
# a0 = Destino X, a1 = Destino Y, a2 = Distância Mínima
# -------------------------------------------------------
KIT_MOVIMENTO:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li s10, 0        # Flag: Se moveu (para animação)
    # --- MUDANÇA: VELOCIDADE VARIÁVEL ---
    la t0, KIT_SPEED
    lw s11, 0(t0)    # Carrega a velocidade comprada na loja
    # ------------------------------------

    la t0, KIT_POS
    lh t1, 0(t0)     # Kit X
    lh t2, 2(t0)     # Kit Y

    # --- EIXO X ---
    sub t3, t1, a0   # Distância X (Kit - Dest)
    bgez t3, KIT_DX_POS
    neg t3, t3       # abs(dx)
    KIT_DX_POS:
    ble t3, a2, KIT_CHECK_Y # Se dentro da margem, não move X

    # Move X
    blt t1, a0, KIT_DIR
    sub t1, t1, s11  # Esquerda
    j KIT_MOVE_X_OK
    KIT_DIR:
    add t1, t1, s11  # Direita
    KIT_MOVE_X_OK:
    sh t1, 0(t0)     # Salva X
    li s10, 1        # Moveu

    # --- EIXO Y ---
    KIT_CHECK_Y:
    sub t3, t2, a1   # Distância Y
    bgez t3, KIT_DY_POS
    neg t3, t3
    KIT_DY_POS:
    ble t3, a2, FIM_KIT_MOV # Se dentro da margem, não move Y

    # Move Y
    blt t2, a1, KIT_BAIXO
    sub t2, t2, s11  # Cima
    j KIT_MOVE_Y_OK
    KIT_BAIXO:
    add t2, t2, s11  # Baixo
    KIT_MOVE_Y_OK:
    sh t2, 2(t0)     # Salva Y
    li s10, 1        # Moveu

    FIM_KIT_MOV:
    # Só anima se moveu
    bnez s10, EXECUTA_ANIM_KIT
    
    # Se parado, reseta para frame 0 (opcional, ou mantém último)
    # la t0, KIT_FRAME_PTR
    # la t1, kit_sprites
    # sw t1, 0(t0)
    j SAIR_KIT_MOV

    EXECUTA_ANIM_KIT:
    call KIT_ANIMACAO_LOGICA

    SAIR_KIT_MOV:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# -------------------------------------------------------
# ANIMAÇÃO DINÂMICA (Conforme Regras do .data)
# -------------------------------------------------------
KIT_ANIMACAO_LOGICA:
    # 1. Timer de Animação
    la t0, KIT_ANIM_TIMER
    lw t1, 0(t0)
    addi t1, t1, 1
    li t2, 5           # Velocidade da troca de frame
    sw t1, 0(t0)
    blt t1, t2, RET_ANIM_KIT
    sw zero, 0(t0)     # Reseta timer

    # 2. Pega Ponteiro Atual
    la t0, KIT_FRAME_PTR
    lw t1, 0(t0)       # Endereço atual

    # 3. Lê Largura e Altura do Frame Atual para calcular salto
    # O formato é: [Width (4 bytes)] [Height (4 bytes)] [Pixels...]
    lw t2, 0(t1)       # Largura
    lw t3, 4(t1)       # Altura
    
    # 4. Calcula Tamanho Total do Frame
    mul t4, t2, t3     # Pixels = W * H
    addi t4, t4, 8     # Total = Pixels + 8 bytes de cabeçalho
    
    # 5. Avança Ponteiro
    add t1, t1, t4     # Aponta para o PRÓXIMO frame

    # 6. Verifica se saiu do bloco de dados
    la t5, kit_sprites_end
    bge t1, t5, RESET_KIT_ANIM

    # Salva novo ponteiro
    sw t1, 0(t0)
    ret

    RESET_KIT_ANIM:
    la t1, kit_sprites
    sw t1, 0(t0)
    
    RET_ANIM_KIT:
    ret

# -------------------------------------------------------
# VERIFICAR COLETA E RETORNAR AO PLAYER
# -------------------------------------------------------
KIT_VERIFICAR_COLETA:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, KIT_TARGET_PTR
    lw t0, 0(t0)      # Endereço do item alvo
    
    # Checa colisão simples (caixa 8x8)
    la a0, KIT_POS
    mv a1, t0
    call VERIFICAR_COLISAO_CAIXA
    beqz a0, SAIR_VERIF_COLETA

    # --- COLETOU! ---
    call TOCAR_SOM_COLETA
    
    # Desativa o item (Ativo = 0)
    la t0, KIT_TARGET_PTR
    lw t0, 0(t0)
    sh zero, 4(t0)    # offset 4 é o flag 'ativo' em todos os itens

    # Aplica Efeito baseado no Tipo
    la t0, KIT_TARGET_TYPE
    lw t0, 0(t0)
    
    li t1, 0 # Moeda
    beq t0, t1, APLICAR_MOEDA_KIT
    li t1, 1 # Velo
    beq t0, t1, APLICAR_VELO_KIT
    li t1, 2 # Vida
    beq t0, t1, APLICAR_VIDA_KIT
    j FIM_APLICA_KIT

    APLICAR_MOEDA_KIT:
        la t0, MOEDAS
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)
        j FIM_APLICA_KIT

    APLICAR_VELO_KIT:
        la t0, VELO_SAMARA
        li t1, 8
        sw t1, 0(t0)
        j FIM_APLICA_KIT

    APLICAR_VIDA_KIT:
        la t0, VIDAS
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)

    FIM_APLICA_KIT:
    # Volta para o estado de seguir Samara
    la t0, KIT_STATE
    sw zero, 0(t0)

    SAIR_VERIF_COLETA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# -------------------------------------------------------
# DESENHO
# -------------------------------------------------------
DESENHAR_KIT:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t0, KIT_POS
    lh a1, 0(t0)      # X
    lh a2, 2(t0)      # Y
    
    la t0, KIT_FRAME_PTR
    lw a0, 0(t0)      # Sprite atual (calculado dinamicamente)
    
    mv a3, s0         # Frame buffer global
    
    # Usa a função IMPRIMIR existente
    # Nota: a função IMPRIMIR usa lw 0(a0) e lw 4(a0),
    # o que é compatível com nossa estrutura de dados.
    call IMPRIMIR

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
# =========================================================
# LÓGICA FINAL: CAMINHADA INTELIGENTE (SEM BATER CABEÇA)
# =========================================================
LOGICA_CARNEIROS:
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # Player X
    sw s4, 20(sp) # Player Y
    sw s5, 24(sp) # Tempo

    call ATUALIZAR_ANIMACAO_CARNEIRO

    # 1. Carrega Posição do Player e Tempo
    la t0, SAMARA_POS
    lh s3, 0(t0)
    lh s4, 2(t0)
    
    la t0, TEMPO_DE_EXECUCAO
    lw s5, 0(t0)     

    # Loop pelos 8 carneiros
    la s0, SHEEP_ARRAY
    li s1, 0
    li s2, 8         

    LOOP_MOVIMENTO_WALK:
        beq s1, s2, FIM_LOGICA_WALK
        
        lw t0, 8(s0)     # Ativo?
        beqz t0, PROXIMO_CARNEIRO_WALK

# === LÓGICA DE SLOW (NOVO) ===
        lw t6, 12(s0)          # Lê a word de controle (Direção + Slow)
        srli a4, t6, 16        # Pega a parte alta (Timer do Slow)
        beqz a4, MOVIMENTO_NORMAL_SHEEP # Se for 0, vida normal
        
        # Se tem slow:
        addi a4, a4, -1        # Decrementa timer
        slli a4, a4, 16        # Move de volta pro topo
        li a5, 0x0000FFFF      # Máscara
        and t6, t6, a5         # Pega só a direção original
        or t6, t6, a4          # Junta novo timer
        sw t6, 12(s0)          # Salva
        
        # EFEITO DE LENTIDÃO: Só anda frame sim, frame não (50% speed)
        andi a4, s5, 1         # Usa o tempo global (s5) par/impar
        bnez a4, PROXIMO_CARNEIRO_WALK # Se ímpar, PULA O MOVIMENTO (congela)

        MOVIMENTO_NORMAL_SHEEP:
        # ==============================

        lw t1, 0(s0)     # Sheep X
        lw t2, 4(s0)     # Sheep Y
        lw t1, 0(s0)     # Sheep X
        lw t2, 4(s0)     # Sheep Y
        
        # Salva posições originais para saber se bateu
        mv a6, t1        # X Antigo
        mv a7, t2        # Y Antigo

        # --- FASE 1: CHECA DISTÂNCIA (FUGA OU PASSEIO?) ---
        sub t3, t1, s3
        bgez t3, ABS_DX_W
        neg t3, t3
        ABS_DX_W:
        
        sub t4, t2, s4
        bgez t4, ABS_DY_W
        neg t4, t4
        ABS_DY_W:

        li t5, 110      # Raio de detecção
        bge t3, t5, MODO_PASSEIO_REAL
        bge t4, t5, MODO_PASSEIO_REAL

        # === MODO FUGA (SAMARA PERTO - REATIVO) ===
        # Prioridade máxima: Correr dela agora!
        
        # X
        beq s3, t1, FOGE_CONT_Y_W
        blt s3, t1, FOGE_DIR_CW
        addi t1, t1, -4    # Foge Esq
        j FOGE_CONT_Y_W
        FOGE_DIR_CW:
        addi t1, t1, 4     # Foge Dir

        FOGE_CONT_Y_W:
        blt s4, t2, FOGE_BAIXO_CW
        addi t2, t2, -4    # Foge Cima
        j CHECK_REPULSAO_W
        FOGE_BAIXO_CW:
        addi t2, t2, 4     # Foge Baixo
        j CHECK_REPULSAO_W

# === MODO PASSEIO (CAMINHADA LONGA) ===
        MODO_PASSEIO_REAL:
        
        # Usa o offset 12 da struct como "Direção Atual"
        # Se 12(s0) == 0, precisa escolher nova direção
        lw t6, 12(s0)   # Lê [TIMER | DIREÇÃO]
        
        # >>>>> ADICIONE ESTAS DUAS LINHAS AQUI <<<<<
        slli t6, t6, 16  # Empurra pra esquerda (apaga o timer)
        srli t6, t6, 16  # Traz de volta (agora t6 tem só a direção pura)
        # ============================================

        # A cada ~60 frames (1 seg), força troca de direção
        andi t5, s5, 63  # Pega últimos 6 bits do tempo
        bnez t5, MANTER_DIRECAO
        li t6, 0         # Força recálculo
        
        MANTER_DIRECAO:
        bnez t6, EXECUTA_MOVIMENTO
        
        # --- ESCOLHER NOVA DIREÇÃO (Pseudo-Random) ---
        add t5, s5, s1   # Tempo + Index
        andi t5, t5, 3   # 0 a 3
        addi t6, t5, 1   # 1 a 4 (Dir, Esq, Baixo, Cima)
        sw t6, 12(s0)    # Salva na memória do carneiro
        
        EXECUTA_MOVIMENTO:
        li t5, 1
        beq t6, t5, ANDAR_DIR
        li t5, 2
        beq t6, t5, ANDAR_ESQ
        li t5, 3
        beq t6, t5, ANDAR_BAIXO
        
        # ANDAR_CIMA (4)
        addi t2, t2, -1
        j CHECK_REPULSAO_W
        
        ANDAR_BAIXO:
        addi t2, t2, 1
        j CHECK_REPULSAO_W
        
        ANDAR_ESQ:
        addi t1, t1, -1
        j CHECK_REPULSAO_W
        
        ANDAR_DIR:
        addi t1, t1, 1

        # --- FASE 2: REPULSÃO ENTRE CARNEIROS ---
        CHECK_REPULSAO_W:
        la s5, SHEEP_ARRAY
        li t5, 0 # j = 0
        
        LOOP_REPULSAO_W:
            li t6, 8
            beq t5, t6, FIM_REPULSAO_W
            
            beq s1, t5, NEXT_REP_W 
            
            lw t6, 8(s5)    
            beqz t6, NEXT_REP_W

            lw t3, 0(s5)    # Outro X
            lw t4, 4(s5)    # Outro Y
            
            # Checa Distancia (Raio 30px)
            sub t6, t1, t3  
            bgez t6, ABS_RX_W
            neg t6, t6
            ABS_RX_W:
            li a0, 30
            bge t6, a0, NEXT_REP_W

            sub t6, t2, t4  
            bgez t6, ABS_RY_W
            neg t6, t6
            ABS_RY_W:
            bge t6, a0, NEXT_REP_W

            # Empurra
            blt t1, t3, EMPURRA_ESQ_W
            addi t1, t1, 1  
            j EMPURRA_Y_W
            EMPURRA_ESQ_W:
            addi t1, t1, -1 
            
            EMPURRA_Y_W:
            blt t2, t4, EMPURRA_CIMA_W
            addi t2, t2, 1
            j NEXT_REP_W
            EMPURRA_CIMA_W:
            addi t2, t2, -1

            NEXT_REP_W:
            addi s5, s5, 16
            addi t5, t5, 1
            j LOOP_REPULSAO_W
        
        FIM_REPULSAO_W:

        # --- FASE 3: TRAVAS DE SEGURANÇA ---
        li t6, 24
        blt t1, t6, FIX_MIN_X_W
        
        li t6, 280
        bgt t1, t6, FIX_MAX_X_W
        j CHECK_Y_LIMIT_W
        
        FIX_MIN_X_W: 
            li t1, 24
            j CHECK_Y_LIMIT_W
        FIX_MAX_X_W: 
            li t1, 280
        
        CHECK_Y_LIMIT_W:
        li t6, 24
        blt t2, t6, FIX_MIN_Y_W
        
        li t6, 200
        bgt t2, t6, FIX_MAX_Y_W
        j SALVA_POS_W
        
        FIX_MIN_Y_W: 
            li t2, 24
            j SALVA_POS_W
        FIX_MAX_Y_W: 
            li t2, 200

        SALVA_POS_W:
        sw t1, 0(s0)
        sw t2, 4(s0)

        # === MUDANÇA CRUCIAL: DETECTOR DE PAREDE ===
        # Se a posição nova for igual à antiga (bateu na trava), muda a direção AGORA.
        bne t1, a6, CHECK_Y_WALL  # Se X mudou, ok
        # X não mudou -> Bateu na parede lateral -> Força nova direção
        sw zero, 12(s0)           # Zera a direção (força escolha nova no prox frame)
        j FIM_WALL_CHECK

        CHECK_Y_WALL:
        bne t2, a7, FIM_WALL_CHECK # Se Y mudou, ok
        # Y não mudou -> Bateu no teto/chão -> Força nova direção
        sw zero, 12(s0)

        FIM_WALL_CHECK:
        # Recupera s5 (Tempo)
        la t0, TEMPO_DE_EXECUCAO
        lw s5, 0(t0) 

    PROXIMO_CARNEIRO_WALK:
        addi s0, s0, 16
        addi s1, s1, 1
        j LOOP_MOVIMENTO_WALK

    FIM_LOGICA_WALK:
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 28
    ret
# =========================================================
# FUNÇÃO: CHECAR_COLISAO_ENTRE_CARNEIROS
# Saída: a0 = 1 (Vai bater), 0 (Livre)
# =========================================================
CHECAR_COLISAO_ENTRE_CARNEIROS:
    li t0, 0             # Índice
    li t1, MAX_SHEEP
    la t2, SHEEP_ARRAY   

    LOOP_CHECK_COLL:
        beq t0, t1, FIM_CHECK_COLL_SAFE 
        
        beq t2, a2, SKIP_THIS_SHEEP     # Ignora a si mesmo
        
        lw t3, 8(t2)     # Está ativo?
        beqz t3, SKIP_THIS_SHEEP
        
        # Checa Distância Manhattan Simplificada ou Box
        # Regra: Distância < 30 pixels = Colisão
        
        # Eixo X
        lw t4, 0(t2)     # Outro X
        sub t5, a0, t4
        bgez t5, ABS_CX
        neg t5, t5
        ABS_CX:
        li t6, DISTANCIA_CARNEIROS  # <--- 30 PIXELS
        bge t5, t6, SKIP_THIS_SHEEP 
        
        # Eixo Y
        lw t4, 4(t2)     # Outro Y
        sub t5, a1, t4
        bgez t5, ABS_CY
        neg t5, t5
        ABS_CY:
        bge t5, t6, SKIP_THIS_SHEEP 
        
        # SE CHEGOU AQUI, ESTÁ MUITO PERTO (< 30 nos dois eixos)
        li a0, 1
        ret

    SKIP_THIS_SHEEP:
        addi t2, t2, 16  
        addi t0, t0, 1   
        j LOOP_CHECK_COLL

    FIM_CHECK_COLL_SAFE:
    li a0, 0             
    ret
# =========================================================
# PROCESSAR_ANIM_ESTADO
# Entrada: 
#   a0 = Endereço Base da Sequência (Ex: SEQ_W)
#   a1 = Quantidade Máxima de Frames (Ex: 3)
# =========================================================
PROCESSAR_ANIM_ESTADO:
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)

    # 1. Verifica se mudou de estado (Ex: estava em W, foi pra D)
    la t0, ANIM_SEQ_ATUAL
    lw t1, 0(t0)
    beq t1, a0, CHECK_TIMER   # Se é a mesma sequência, verifica o tempo
    
    # --- MUDOU DE ESTADO (RESET IMEDIATO) ---
    sw a0, 0(t0)              # Salva nova sequência como atual
    la t0, ANIM_INDEX_ATUAL
    sw zero, 0(t0)            # Reseta índice para 0
    la t0, ANIM_TIMER
    sw zero, 0(t0)            # Reseta timer pra trocar já
    
    # Atualiza o ponteiro de desenho imediatamente para o frame 0 da nova seq
    la t0, SAMARA_FRAME_ANIMACAO
    sw a0, 0(t0)
    j FIM_ANIM_PROC

    # 2. Controle de Velocidade (Timer)
    CHECK_TIMER:
    la t0, ANIM_TIMER
    lw t1, 0(t0)
    addi t1, t1, 1
    la t2, ANIM_DELAY_LIMIT
    lw t2, 0(t2)
    sw t1, 0(t0)              # Salva timer ++
    blt t1, t2, FIM_ANIM_PROC # Se não deu o tempo, sai (mantém frame atual)

    # --- TROCAR FRAME (Time to switch!) ---
    sw zero, 0(t0)            # Reseta timer

    # 3. Avança Índice do Frame
    la t0, ANIM_INDEX_ATUAL
    lw t1, 0(t0)              # Índice atual (ex: 0)
    addi t1, t1, 1            # Próximo (ex: 1)
    
    # Verifica Loop (Se Index >= MaxFrames, volta pra 0)
    blt t1, a1, CALC_POINTER
    li t1, 0                  # Loop volta pro começo

    CALC_POINTER:
    sw t1, 0(t0)              # Salva novo índice

    # 4. CALCULAR ENDEREÇO NA MEMÓRIA (O PULO DO GATO)
    # Lógica: Pointer = BaseAddress
    # Repete 'Index' vezes: Pointer = Pointer + (W * H) + 8
    
    mv t2, a0                 # t2 começa na Base (Frame 0)
    mv t3, t1                 # t3 é o contador de loops (Índice)

    LOOP_FIND_FRAME:
        beqz t3, UPDATE_RENDER_PTR  # Se contador é 0, t2 é o endereço correto
        
        # Lê cabeçalho do frame atual para saber o tamanho
        lw t4, 0(t2)          # Largura (W)
        lw t5, 4(t2)          # Altura (H)
        
        # Calcula tamanho em bytes: (W * H) + 8 bytes de cabeçalho
        mul t6, t4, t5        # Pixels
        addi t6, t6, 8        # + 8 bytes (Offset Largura + Altura)
        
        # Avança ponteiro para o próximo frame
        add t2, t2, t6        
        
        addi t3, t3, -1       # Decrementa loop
        j LOOP_FIND_FRAME

    UPDATE_RENDER_PTR:
    # 5. Atualiza a variável global que o DESENHAR_TUDO usa
    la t0, SAMARA_FRAME_ANIMACAO
    sw t2, 0(t0)

    FIM_ANIM_PROC:
    lw t2, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 12
    ret
# =========================================================
# SPAWNAR TRIO (SIMPLIFICADO)
# Procura 3 vagas livres e coloca carneiros em posições aleatórias seguras
# =========================================================
# =========================================================
# SPAWN SEGURO (SEM VALORES NEGATIVOS)
# =========================================================
M3_SPAWNAR_TRIO:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    li t0, 3             # Spawnar 3
    la t1, SHEEP_ARRAY
    li t2, 0             # Índice
    li t3, MAX_SHEEP
    
    la t5, TEMPO_DE_EXECUCAO
    lw t5, 0(t5)         

    M3_LOOP_SPAWN:
        beqz t0, M3_FIM_SPAWN     
        beq t2, t3, M3_FIM_SPAWN  
        
        lw t4, 8(t1)     # Ativo?
        bnez t4, M3_NEXT_SLOT
        
        # --- ATIVAR ---
        li t4, 1
        sw t4, 8(t1)     
        sw zero, 12(t1)  
        
        # --- GERAR X SEGURO ---
        # Usa abs para garantir positivo
        bgez t5, POS_X_SEED
        neg t5, t5
        POS_X_SEED:
        
        li a1, 200
        rem t6, t5, a1    # Resto seguro (0 a 199)
        addi t6, t6, 50   # 50 a 249
        sw t6, 0(t1)      # Salva X
        
        # --- GERAR Y SEGURO ---
        # Modifica a seed
        addi t5, t5, 123
        srli t5, t5, 1
        
        li a1, 130
        rem t6, t5, a1    # Resto (0 a 129)
        addi t6, t6, 50   # 50 a 179
        sw t6, 4(t1)      # Salva Y
        
        addi t0, t0, -1   
        addi t5, t5, 45   # Muda seed para o próximo

    M3_NEXT_SLOT:
        addi t1, t1, 16
        addi t2, t2, 1
        j M3_LOOP_SPAWN

    M3_FIM_SPAWN:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

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
#########################################################
# SISTEMA DE LOJA (FUNÇÕES)
#########################################################

# Desenha o Sprite da Loja centralizado
DESENHAR_LOJA_OVERLAY:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    la a0, shop_sprite   # Sprite incluído no .data
    li a1, 60            # X (Centralizado aprox. 320 - largura / 2)
    li a2, 40            # Y
    mv a3, s0            # Frame atual
    call IMPRIMIR
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Lógica de Input exclusiva da Loja
VERIFICAR_INPUT_LOJA:
    addi sp, sp, -4
    sw ra, 0(sp)

    li t1, 0xFF200000    # Endereço do teclado
    lw t0, 0(t1)
    andi t0, t0, 1
    beqz t0, FIM_INPUT_LOJA # Nenhuma tecla
    lw t2, 4(t1)         # Tecla pressionada

    # --- CONTROLE DE SAÍDA (WASD) ---
    li t0, 'w'
    beq t2, t0, FECHAR_LOJA
    li t0, 'a'
    beq t2, t0, FECHAR_LOJA
    li t0, 's'
    beq t2, t0, FECHAR_LOJA
    li t0, 'd'
    beq t2, t0, FECHAR_LOJA

    # --- COMPRAS (1, 2, 3) ---
    li t0, '1'
    beq t2, t0, COMPRAR_VELOCIDADE
    li t0, '2'
    beq t2, t0, COMPRAR_VIDA
    li t0, '3'
    beq t2, t0, COMPRAR_PET_UP

    j FIM_INPUT_LOJA

    # === AÇÕES ===
    
    FECHAR_LOJA:
        la t0, LOJA_ABERTA
        sw zero, 0(t0)      # Fecha a loja (volta ao jogo)
        # Nota: LOJA_DEBOUNCE continua 1 até o player sair do tile 4
        j FIM_INPUT_LOJA

    COMPRAR_VELOCIDADE:
        call VERIFICAR_SALDO
        beqz a0, FIM_INPUT_LOJA  # Sem dinheiro

        # Efeito: Aumenta velocidade
        la t0, VELO_SAMARA
        li t1, 6             # Define velocidade 6 (Normal é 4)
        sw t1, 0(t0)
        
        call DESCONTAR_MOEDA
        call TOCAR_SOM_COLETA # Feedback sonoro
        j FIM_INPUT_LOJA

    COMPRAR_VIDA:
        call VERIFICAR_SALDO
        beqz a0, FIM_INPUT_LOJA

        # Efeito: +1 Vida
        la t0, VIDAS
        lw t1, 0(t0)
        addi t1, t1, 1
        sw t1, 0(t0)

        call DESCONTAR_MOEDA
        call TOCAR_SOM_COLETA
        j FIM_INPUT_LOJA

    COMPRAR_PET_UP:
        call VERIFICAR_SALDO
        beqz a0, FIM_INPUT_LOJA

        # Efeito: Aumenta velocidade do Pet
        la t0, KIT_SPEED
        li t1, 4             # Dobra a velocidade (Normal era 2)
        sw t1, 0(t0)

        call DESCONTAR_MOEDA
        call TOCAR_SOM_MIADO # Feedback do gato
        j FIM_INPUT_LOJA

    FIM_INPUT_LOJA:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# Retorna 1 se tiver moedas, 0 se não
VERIFICAR_SALDO:
    la t0, MOEDAS
    lw t1, 0(t0)
    li a0, 0
    blez t1, RET_SALDO
    li a0, 1
    RET_SALDO:
    ret

# Remove 1 moeda do inventário
DESCONTAR_MOEDA:
    la t0, MOEDAS
    lw t1, 0(t0)
    addi t1, t1, -1
    sw t1, 0(t0)
    ret

# INCLUDES
.include "sounds/music.s"
.include "sounds/music_ef.asm"
.include "sprites/tile.s"
.include "sprites/coin.s"
.include "sprites/tilein.data"
.include "sprites/map.s"
.include "sprites/sheep.data"
.include "sprites/char.s"
.include "sprites/sword_sprite.data"
.include "sprites/Water_Slime_Front.data"
.include "sprites/bispo.data"
.include "sprites/cavalo.data"
.include "sprites/castelo.data"
.include "sprites/hud_coracao.data"
.include "sprites/item_vida.data"
.include "sprites/item_velocidade.data"
.include "sprites/numeros.data"
.include "sprites/Game_Over_Menu.data"
dama_sprite: 
    .include "sprites/dama.data"   # (Adicionei .data, verifique se o arquivo tem extensão)

win_sprite:  
    .include "sprites/win.data"