# 📘 Documento Interno da Equipe  
## Guia de Ferramentas, Recursos e Fluxo de Trabalho  
**Projeto:** Samsara — Reino dos Sonhos  
**Objetivo:** Padronizar o ambiente de desenvolvimento e facilitar a colaboração entre os membros da equipe.


## 🧭 1. Visão Geral

Este documento centraliza:
- os simuladores que usaremos,
- conversores de imagem necessários para sprites e mapas,
- playlists e vídeos de referência técnica,
- recomendações de organização do projeto e fluxo de trabalho.

É um guia rápido e direto para que toda a equipe esteja sempre alinhada.


## 🖥️ 2. Simuladores Oficiais

### **FPGRARS — Ambiente Principal**
Usaremos este simulador para:
- execução do código RISC-V,
- manipulação gráfica via framebuffers,
- testes de gameplay e animações.

🔗 https://github.com/LeoRiether/FPGRARS


### **LAMAR**
Simulador secundário para testes e estudo de instruções.

🔗 https://github.com/victorlisboa/LAMAR?tab=readme-ov-file


## 🖼️ 3. Conversores de Imagem (Sprites, Backgrounds e HUD)

Esses programas convertem `.bmp` → `.data` / `.s` / `.asm`,  
que é o formato aceito pelo FPGRARS.

### **Gerenciador de Conversão**
🔗 https://github.com/gss214/Gerenciador-de-Conversao

### **img2riscv**
🔗 https://github.com/mateusap1/img2riscv

**Uso na prática:**  
- Todos os sprites do jogo (Samsara, inimigos, carneirinhos, chefes, etc.) devem ser convertidos aqui.  
- Tamanhos recomendados: **32×32** ou **64×64**.


## 🎥 4. Vídeos e Playlists de Estudo

### Playlist 1 — RISC-V e noções de arquitetura  
🔗 https://www.youtube.com/playlist?list=PLL0Kob75DU32afhLBN5nY2KzOJ5k6lw-Q

### Playlist 2 — Projetos, prática e desenvolvimento  
🔗 https://www.youtube.com/watch?v=AGLKNB2pC6E&list=PLL0Kob75DU3389JeYb-z-_N5KBbbwNWpa&index=1

Essas playlists são extremamente úteis para entender:
- desenho de pixels e imagens,
- leitura de teclado,
- uso de ecall para MIDI/áudio,
- estruturação de código grande em Assembly.
