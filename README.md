# Biubox Game 🎮

## 📱 Sobre o Projeto
Biubox é um jogo inspirado no clássico Stack Attack (Siemens, 2003), recriado em Flutter + Flame. Uma viagem nostálgica aos primórdios dos jogos mobile, quando jogar em celulares era uma experiência similar ao Atari.

## 🎯 Objetivo
- Faça pontos combinando caixas na horizontal
- Estoure caixas pulando contra elas
- Colete estrelas para pontos extras
- Evite que as caixas cheguem ao topo

## 🕹️ Controles
- Setas ←/→: Movimentação (propositalmente lenta, estilo retrô)
- Seta ↑: Pulo
- Espaço: Pausar/Continuar

## 🛠️ Tecnologias
- Flutter
- Flame Engine
- SharedPreferences (sistema de recordes)

## ⚙️ Instalação

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Execute os comandos:
```bash
flutter pub get
flutter run
```

Para rodar na web:
```bash
flutter run -d chrome
```

## 📂 Estrutura Principal
- `lib/main.dart` - Ponto de entrada
- `lib/game.dart` - Motor do jogo
- `lib/player.dart` - Lógica do jogador
- `lib/box.dart` - Sistema de caixas
- `lib/star.dart` - Sistema de estrelas
- `lib/crane.dart` - Sistema de guindastes

## 🎮 Gameplay
O jogo emula perfeitamente a experiência do Stack Attack original do Siemens A55, incluindo:
- Movimentação característica
- Sistema de pontuação desafiador
- Dificuldade crescente
- Mecânicas nostálgicas

## 💡 Nota Histórica
Stack Attack (2003) era conhecido por sua dificuldade elevada comparado aos jogos atuais, sendo um verdadeiro exercício de paciência e habilidade. Este remake busca preservar essa experiência única dos primeiros jogos mobile.

## 🤝 Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Enviar pull requests
