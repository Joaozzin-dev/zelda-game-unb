Beleza — vamos montar **4 setores claros**, bem organizados, para um projeto em Assembly RISC-V com gráfico, HUD, lógica, ranking e assets.

Aqui estão **as divisões mais inteligentes para acelerar o desenvolvimento**:

---

# 🔵 **1) Setor de LÓGICA & MECÂNICAS (Gameplay Team) João pedro, Marianna**

**Responsáveis por:**

* Sistema de jogo (movimento, colisões, regras).
* Rotinas principais (`main`, loop do jogo).
* Sistema de pontuação.
* Condições de vitória/derrota.
* Chamada das funções do HUD e Draw.

**Arquivos típicos:**

* `main.asm`
* `logic.asm`
* `input.asm`
* `ranking.asm` (parte lógica; gravação de score pode ser juntos ou separado)

**Perfil ideal:**
Pessoas boas em lógica, gostam de quebrar problemas, entender fluxo, usar registradores com cuidado.

---

# 🟣 **2) Setor de GRÁFICOS & RENDER (Render Team) **

**Responsáveis por:**

* Sistema de desenho na tela.
* Manipulação do framebuffer (VGA).
* Funções como:

  * `draw_pixel`
  * `draw_sprite`
  * `clear_screen`
  * `draw_background`
* Organização do pallete, posições dos sprites.
* Otimizações visuais (reduzir flicker, desenhar mais rápido).

**Arquivos típicos:**

* `draw.asm`
* `sprites.asm`
* `frame.asm`

**Perfil ideal:**
Pessoas que gostam de matemática simples, coordenadas, otimização e parte visual.

---

# 🟢 **3) Setor de HUD & INTERFACE (HUD / UI Team)**

**Responsáveis por:**

* Mostrar:

  * Score
  * Vida
  * Tempo
  * Objetivos
  * Mensagens (“GAME OVER”, “START”, etc.)
* Conexão com o setor de lógica.
* Rotinas organizadas para texto e numeração.

**Arquivos típicos:**

* `hud.asm`
* `text.asm`

**Perfil ideal:**
Pessoas que gostam de organização, padronização, parte visual porém estruturada.

---

# 🟠 **4) Setor de ASSETS & FERRAMENTAS (Assets Team) Josiel & CARLOS MANOEL**

**Responsáveis por:**

* Converter imagens para `.bmp` → `.data`
* Organizar paletas, tamanhos, estilos.
* Criar o arquivo `info.txt` com instruções pra equipe.
* Garantir que todos os sprites tenham o mesmo:

  * tamanho
  * paleta
  * alinhamento
  * orientação
* Testar sprites no simulador (FPGRARS).
* Ajudar o setor de draw a integrar os assets.

**Arquivos típicos:**

* `assets/`
* `tools/`
* `info.txt`

**Perfil ideal:**
Pessoas que gostam de design, padronização, e configurar ferramentas.

---

# 🎯 **Resumo em uma tabela rápida**

| Setor           | Responsabilidades               | Arquivos              | Perfil            |
| --------------- | ------------------------------- | --------------------- | ----------------- |
| **1) Lógica**   | mecânica, input, física, score  | main.asm, logic.asm   | pessoa lógica     |
| **2) Gráficos** | render, sprites, pixel          | draw.asm, sprites.asm | pessoa visual     |
| **3) HUD**      | textos, números, interface      | hud.asm, text.asm     | pessoa organizada |
| **4) Assets**   | conversão, paleta, documentação | info.txt, assets/     | pessoa artística  |

---

# Se quiser, faço um **documento oficial em Markdown (para colocar no GitHub)** com:

* Descrição bonita pros setores
* Funções de cada setor
* Requisitos
* Frases curtas e profissionais
* Emoji, ícones e estilo clean

É só pedir: **"faz o documento com os setores bonitinho"**.
