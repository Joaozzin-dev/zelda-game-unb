#########################################################
# DRAW.S - Sistema de Renderização
# 
# Modificado para blindar a função DRAW_POS contra s0 sujo
#########################################################

.text

DRAW_ALL:
    addi sp, sp, -4
    sw ra, 0(sp)

    # --- Baús ---
    la t0, CHEST_B_DATA
    lh t1, 4(t0)
    beqz t1, CHECK_CHEST_Y
    la a0, CHEST_B_DATA
    la a3, ChestB
    call DRAW_POS
    
    CHECK_CHEST_Y:
    la t0, CHEST_Y_DATA
    lh t1, 4(t0)
    beqz t1, DRAW_ENTITIES
    la a0, CHEST_Y_DATA
    la a3, ChestY
    call DRAW_POS

    # --- Entidades ---
    DRAW_ENTITIES:
    la t0, INVULNERAVEL
    lw t1, 0(t0)
    andi t1, t1, 4
    bnez t1, SKIP_PLAYER
    la a0, PLYR_POS
    la a3, char
    call DRAW_POS
    
    SKIP_PLAYER:
    la a0, S1_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    la a0, S2_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    la a0, S3_POS
    la a3, Water_Slime_Front
    call DRAW_POS
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

RESTORE_BG:
    addi sp, sp, -4
    sw ra, 0(sp)
    lh a1, 0(a0)
    lh a2, 2(a0)
    la a0, tile
    
    # PROTEÇÃO: Limpa s0 aqui também
    andi a3, s0, 1
    
    call PRINT
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

DRAW_POS:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    lh a1, 0(a0)     # X
    lh a2, 2(a0)     # Y
    mv a0, a3        # Sprite
    
    # ===== PROTEÇÃO FINAL =====
    # Mesmo que s0 esteja com "lixo", isso pega apenas 0 ou 1
    andi a3, s0, 1   
    
    call PRINT
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret