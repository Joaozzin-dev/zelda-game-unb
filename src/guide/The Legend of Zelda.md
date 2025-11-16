# Projeto Aplicativo – The Legend of Zelda (RISC-V)

## Objetivo
Aplicar os conhecimentos de programação Assembly RISC-V em um projeto prático utilizando o simulador Rars16_Custom1 ou FPGRars.

## Requerimentos Gerais

### Implementação
Desenvolver uma versão própria do jogo The Legend of Zelda (NES), com liberdade criativa para adaptações.

### Ferramentas obrigatórias no Rars
- Interface gráfica: Bitmap Display (320×240, 8 bits/pixel)
- Interface com teclado: Keyboard and Display MMIO
- Interface de áudio MIDI: ecalls 30, 31, 32 e 33
- Semestre: 2025/2

## Especificações da Implementação (pontuação)

### Cenários e mapa
- Quatro cenários com layouts diferentes (mapa pode ser estático) — (1.0)
- Pelo menos um puzzle (dungeons, chaves, portas secretas, botões etc.) — (0.25)

### Sistemas do jogo
- Loja e sistema de moedas — (0.25)
- Mecânica de itens (poções, escudos, armas etc.) — (0.5)
- Condição de vitória definida (resolver puzzle, derrotar inimigos etc.) — (0.5)

### Jogador
- Animação e movimentação — (1.0)
- Colisão com obstáculos e limites do mapa — (0.5)

### Inimigos
- Combate com inimigos — (0.5)
- Dois tipos diferentes de inimigos — (0.5)
- Animação e movimentação dos inimigos — (0.25)

### Interface
- HUD mostrando vidas, moedas, itens e fase atual — (0.25)

### Áudio
- Música e efeitos sonoros — (0.5)

## Documentação (1.0 ponto)
Produzir um artigo científico de quatro páginas seguindo o modelo fornecido, contendo:
- Resumo
- Introdução
- Metodologia
- Resultados Obtidos
- Conclusão
- Referências

Recomendação: consultar artigos do SBGames para referência de estrutura.

## Entregáveis

### Apresentação
Preparar uma apresentação de até 10 minutos abordando:
- Desenvolvimento do jogo
- Técnicas utilizadas
- Dificuldades encontradas
- Demonstração (permitido usar cheats para trocar de fase)

### Arquivos
Enviar no Moodle/Aprender3 um arquivo .zip contendo:
- Códigos-fonte (.s)
- Artigo em PDF

## Referências
Gameplay do jogo original (NES):  
https://www.youtube.com/watch?v=6g2vk8Gudqs&t=481s

Versão jogável no navegador:  
https://www.retrogames.cc/nes-games/the-legend-of-zelda-font-mod-retranslation.html
