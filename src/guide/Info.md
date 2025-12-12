# 📘 Documento Interno da Equipe
## Guia de Ferramentas, Recursos e Fluxo de Trabalho

<div align="center">

**Projeto:** 🌟 Samsara — Reino dos Sonhos  
**Versão:** 1.0 | **Última Atualização:** Dezembro 2025  
**Objetivo:** Padronizar o ambiente de desenvolvimento e maximizar a colaboração entre os membros da equipe

---

</div>

## 🎯 1. Visão Geral do Projeto

### 1.1 Propósito do Documento

Este guia centraliza **todos os recursos técnicos, metodologias e ferramentas** necessárias para o desenvolvimento de Samsara. Ele serve como:

- 📚 **Base de conhecimento** unificada da equipe
- 🛠️ **Referência rápida** para configuração de ambiente
- 🗺️ **Roadmap técnico** com melhores práticas
- 🤝 **Manual de colaboração** para sincronização do time

### 1.2 Escopo do Projeto

**Samsara: A Canção das Estrelas** é um jogo de ação e aventura desenvolvido em **Assembly RISC-V RV32I** que combina:

- Sistema de combate baseado em notas musicais
- Inimigos com comportamento inspirado em peças de xadrez
- Arte pixel art surrealista e onírica
- Trilha sonora MIDI integrada
- Múltiplos mapas e mecânicas progressivas

---

## 🖥️ 2. Ambiente de Desenvolvimento

### 2.1 Simuladores Oficiais

#### **FPGRARS — Ambiente Principal de Desenvolvimento** ⭐

**Por que usar:**
- ✅ Framebuffer 320×240 nativo
- ✅ Suporte completo a MIDI
- ✅ Debugger integrado
- ✅ Keyboard mapping otimizado
- ✅ Melhor performance para jogos

**Funcionalidades principais:**
- Execução de código RISC-V RV32I
- Manipulação gráfica via framebuffers
- Sistema de áudio MIDI integrado
- Testes de gameplay e animações em tempo real
- Breakpoints e inspeção de registradores

🔗 **Link oficial:** https://github.com/LeoRiether/FPGRARS

**Configuração recomendada:**
```bash
# Clone o repositório
git clone https://github.com/LeoRiether/FPGRARS.git

# Execute o simulador
./fpgrars-x86_64-pc-windows-gnu.exe
```

---

#### **LAMAR — Simulador Secundário**

**Uso estratégico:**
- 🧪 Testes isolados de instruções RISC-V
- 📊 Análise de performance de código
- 🐛 Debugging de lógica complexa
- 📚 Estudo de casos específicos

🔗 **Link oficial:** https://github.com/victorlisboa/LAMAR

**Quando usar LAMAR:**
- Testar algoritmos de movimentação de inimigos
- Validar cálculos de colisão
- Debugar funções específicas antes da integração

---

## 🖼️ 3. Pipeline de Assets Visuais

### 3.1 Conversores de Imagem (Sprites → Assembly)

Todos os assets visuais do jogo precisam ser convertidos de **imagens BMP** para **código Assembly** (.data / .s / .asm).

#### **Gerenciador de Conversão** — Ferramenta Principal

**Vantagens:**
- Interface amigável
- Batch conversion (múltiplos arquivos)
- Preview antes da conversão
- Otimização automática de paleta

🔗 https://github.com/gss214/Gerenciador-de-Conversao

**Workflow recomendado:**
```
1. Design sprite em Aseprite/Photoshop (32×32 ou 64×64)
2. Exportar como BMP de 24 bits
3. Converter usando Gerenciador
4. Integrar .data no projeto
```

---

#### **img2riscv** — Conversor Alternativo

**Quando usar:**
- Conversões via linha de comando
- Integração em scripts de build
- Processamento automatizado

🔗 https://github.com/mateusap1/img2riscv

---

#### **png2oac** — Conversor Customizado

**Especificidades:**
- Suporte direto a PNG
- Otimizado para FPGRARS
- Melhor compressão de dados

**Uso prático:**
```python
python png2oac.py sprite.png -o sprite.s
```

---

### 3.2 Especificações de Assets

#### **Sprites de Personagens**

| Tipo | Dimensões | Formato | Paleta |
|------|-----------|---------|--------|
| Samsara (Idle/Walk) | 32×32 | BMP 24-bit | 16 cores |
| Inimigos (Chess) | 32×32 | BMP 24-bit | 12 cores |
| Boss (Dama) | 64×64 | BMP 24-bit | 24 cores |
| Carneiro | 24×24 | BMP 24-bit | 8 cores |
| Projéteis (Notas) | 16×16 | BMP 24-bit | 4 cores |

#### **Backgrounds e Mapas**

| Elemento | Dimensões | Layers |
|----------|-----------|--------|
| Tile Base | 16×16 | 1 |
| Mapa Completo | 320×240 | 3 (Base, Decoração, Colisão) |
| Tela de Menu | 320×240 | 2 (Background, UI) |

---

## 🎥 4. Recursos de Aprendizado

### 4.1 Playlists Essenciais

#### **Playlist 1 — Fundamentos RISC-V e Arquitetura**

🔗 https://www.youtube.com/playlist?list=PLL0Kob75DU32afhLBN5nY2KzOJ5k6lw-Q

**Conteúdo abordado:**
- ✅ Instruções básicas RISC-V (add, sub, lw, sw)
- ✅ Registradores e convenções de chamada
- ✅ Estruturas de controle (loops, condicionais)
- ✅ Manipulação de memória e pilha

**Vídeos prioritários para revisar:**
1. Introdução ao RISC-V
2. Registradores e Memória
3. Instruções de Controle de Fluxo

---

#### **Playlist 2 — Desenvolvimento Prático de Jogos**

🔗 https://www.youtube.com/watch?v=AGLKNB2pC6E&list=PLL0Kob75DU3389JeYb-z-_N5KBbbwNWpa

**Tópicos essenciais:**
- 🎨 Desenho de pixels e renderização de sprites
- ⌨️ Leitura de teclado e input handling
- 🔊 Sistema de áudio MIDI via ecall
- 🗂️ Organização de código Assembly em múltiplos arquivos
- 🎮 Game loops e controle de FPS

**Projetos práticos inspiradores:**
- Snake Game em Assembly
- Pong com física básica
- Platformer simples

---

### 4.2 Documentação Técnica Oficial

#### **RISC-V ISA Specification**
🔗 https://riscv.org/technical/specifications/

**Capítulos importantes:**
- Chapter 2: RV32I Base Integer Instruction Set
- Chapter 20: Assembler Directives

#### **FPGRARS Documentation**
🔗 https://github.com/LeoRiether/FPGRARS/wiki

**Seções essenciais:**
- Framebuffer API
- MIDI System Calls
- Keyboard Input

---

## 🗂️ 5. Estrutura do Projeto e Organização


### 5.1 Convenções de Código

#### **Nomenclatura**

```asm
# Funções: snake_case
player_update:
enemy_move_knight:

# Labels: PascalCase
MainGameLoop:
RenderSprites:

# Constantes: UPPER_SNAKE_CASE
SCREEN_WIDTH = 320
PLAYER_SPEED = 2

# Registradores temporários: t0-t6
# Registradores salvos: s0-s11
# Argumentos: a0-a7
# Retorno: a0
```

#### **Comentários Padronizados**

```asm
#===============================================
# FUNÇÃO: player_update
# DESCRIÇÃO: Atualiza posição e estado do jogador
# ENTRADA:
#   a0 - pointer para struct do player
# SAÍDA:
#   a0 - 1 se atualizado, 0 se erro
# REGISTRADORES MODIFICADOS: t0-t3, s0
#===============================================
player_update:
    # Salvar contexto
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    
    # Implementação...
    
    # Restaurar contexto
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
```

---

## 🔄 6. Fluxo de Trabalho (Workflow)

### 6.1 Git Flow Simplificado

```
main (produção estável)
  ↓
develop (integração contínua)
  ↓
feature/* (desenvolvimento individual)
```

#### **Branches**

| Branch | Propósito | Regra |
|--------|-----------|-------|
| `main` | Versão estável para apresentação | Apenas merges de `develop` |
| `develop` | Integração de features | Testes passando obrigatórios |
| `feature/player-movement` | Feature específica | 1 feature por branch |
| `joaozzin` | Correção de bugs | Merge direto em `develop` |

#### **Commit Messages**

```bash
# Formato: <tipo>: <descrição curta>

feat: adiciona movimento do Bispo
fix: corrige colisão com paredes
docs: atualiza guia de sprites
refactor: otimiza rendering loop
test: adiciona teste de IA do Cavalo
```

---

### 6.2 Ciclo de Desenvolvimento Semanal

#### **Segunda-feira: Planning**
- 📋 Review das tarefas da semana
- 🎯 Definir prioridades
- 🔀 Criar branches de feature

#### **Terça a Quinta: Development**
- 💻 Implementação de features
- 🧪 Testes locais
- 📝 Documentação inline

#### **Sexta: Integration & Testing**
- 🔀 Merge de features em `develop`
- 🧪 Testes integrados
- 🐛 Correção de bugs críticos

#### **Sábado (opcional): Polish**
- 🎨 Refinamento de arte
- 🔊 Ajustes de áudio
- 📊 Otimização de performance

---

## 🎮 7. Mecânicas e Sistemas do Jogo

### 7.1 Sistema de Combate

**Projéteis Musicais:**
- Velocidade: 4 pixels/frame
- Dano base: 1 HP
- Cooldown: 15 frames (0.25s @ 60fps)
- Range: 160 pixels (metade da tela)

**Inimigos:**
| Tipo | HP | Velocidade | Comportamento |
|------|----|-----------|--------------| 
| Cavalo | 3 | 2 px/frame | Movimento em L (xadrez) |
| Bispo | 3 | 1.5 px/frame | Diagonal contínua |
| Torre | 4 | 2 px/frame | Horizontal/Vertical |
| Dama | 12 | 2.5 px/frame | Pathfinding agressivo |
| Carneiro | 1 | 3 px/frame | Fuga do player |

---

### 7.2 Sistema de Colisão

**Hitboxes:**
```asm
# Struct de Hitbox (16 bytes)
.struct Hitbox
    x:      .word    # offset 0
    y:      .word    # offset 4
    width:  .word    # offset 8
    height: .word    # offset 12
.end
```

**Algoritmo AABB (Axis-Aligned Bounding Box):**
```asm
check_collision:
    # if (box1.x < box2.x + box2.width &&
    #     box1.x + box1.width > box2.x &&
    #     box1.y < box2.y + box2.height &&
    #     box1.y + box1.height > box2.y)
    # return 1 (colidiu)
```

---

## 🐛 8. Debugging e Troubleshooting

### 8.1 Problemas Comuns

#### **Sprites não aparecem**
```asm
# Verificar:
1. Endereço do framebuffer correto? (0xFF000000)
2. Sprite convertido corretamente?
3. Coordenadas dentro da tela (0-319, 0-239)?
4. Cor de fundo transparente configurada?
```

#### **Input não responde**
```asm
# Checklist:
1. MMIO keyboard ativado? (0xFF200000)
2. Polling a cada frame?
3. Debounce implementado?
```

#### **MIDI não toca**
```asm
# Troubleshooting:
1. ecall 31 (play note) configurado?
2. Canal MIDI correto (0-15)?
3. Volume > 0?
4. Duração válida?
```

---

### 8.2 Tools de Debug

**Breakpoints estratégicos:**
```asm
# Colocar em:
- Início do game loop
- Antes de renderização
- Após input handling
- Em colisões críticas
```

**Watchpoints:**
```
# Monitorar:
- Player X/Y position
- Enemy state
- HP counter
- Frame counter
```

---

## 📊 9. Métricas de Performance

### 9.1 Targets de Performance

| Métrica | Target | Crítico |
|---------|--------|---------|
| FPS | 60 | 30 |
| Input Lag | <16ms | <33ms |
| Loading Time | <2s | <5s |
| Memory Usage | <128KB | <256KB |

### 9.2 Otimização

**Técnicas aplicadas:**
- Loop unrolling em rendering
- Lookup tables para trigonometria
- Sprite pooling (evitar alocação dinâmica)
- Dirty rectangles (renderizar apenas mudanças)

---

## 🤝 10. Comunicação da Equipe

### 10.1 Canais

| Canal | Propósito | Frequência |
|-------|-----------|-----------|
| Discord #dev | Dúvidas técnicas | Sempre |
| Discord #assets | Review de arte | Diário |
| GitHub Issues | Bugs e features | Conforme necessário |
| GitHub Projects | Tracking de tarefas | Atualização diária |

### 10.2 Reuniões

**Daily Stand-up (15 min):**
- O que fiz ontem?
- O que farei hoje?
- Algum bloqueio?

**Weekly Review (1h):**
- Demo das features
- Retrospectiva
- Planning da próxima semana

---

## 📚 11. Recursos Adicionais

### 11.1 Ferramentas Recomendadas

**Editores de Código:**
- VS Code + RISC-V extension
- Sublime Text + Assembly syntax

**Arte:**
- Aseprite (pixel art)
- Tiled (mapas)
- GIMP (edição de imagens)

**Áudio:**
- MuseScore (composição MIDI)
- Audacity (edição)

---

### 11.2 Leitura Complementar

📖 **"Computer Organization and Design: RISC-V Edition"**  
   Por Patterson & Hennessy

📖 **"Game Programming Patterns"**  
   Por Robert Nystrom

📖 **"The Art of Assembly Language"**  
   Por Randall Hyde

---

## ✅ 12. Checklist de Onboarding

Novo membro da equipe deve:

- [ ] Clonar repositório do projeto
- [ ] Instalar FPGRARS
- [ ] Rodar hello_world.asm de teste
- [ ] Converter 1 sprite usando Gerenciador
- [ ] Assistir Playlist 1 (primeiros 3 vídeos)
- [ ] Ler seções 1-6 deste documento
- [ ] Fazer primeiro commit (ex: adicionar nome no README)
- [ ] Participar de 1 reunião de equipe

---

## 🎯 13. Metas do Projeto

### Milestone 1 (Semana 1-2): Core Engine
- [x] Game loop funcional
- [x] Renderização de sprites
- [x] Input de teclado
- [x] Colisão básica

### Milestone 2 (Semana 3-4): Gameplay
- [ ] Movimentação do Samsara
- [ ] Sistema de projéteis
- [ ] 3 tipos de inimigos
- [ ] 1 mapa completo

### Milestone 3 (Semana 5-6): Polish
- [ ] Boss fight (Dama)
- [ ] Sistema de vidas
- [ ] Tela de Game Over
- [ ] Trilha sonora completa
- [ ] Menu principal

### Milestone 4 (Semana 7-8): Release
- [ ] Testes finais
- [ ] Documentação completa
- [ ] Vídeo de gameplay
- [ ] Apresentação final

---

<div align="center">

## 🌟 Lembrete Final

**"Um jogo bem documentado é um jogo bem desenvolvido."**

Este guia é vivo e deve ser atualizado conforme o projeto evolui.  
Dúvidas? Abra uma issue ou pergunte no Discord!

**Feito com 💙 pela Equipe Samsara**

---

_Última revisão: Dezembro 2025_

</div>