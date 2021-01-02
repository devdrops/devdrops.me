---
title: "tmux: Migrando de 2.3.* para 3.*"
date: 2020-10-04
draft: false
---

Olá!

Há poucos dias atrás, atualizei a versão do Linux Mint no meu computador pessoal
de 19 para 20, e fiquei feliz que nessa atualização a versão oferecida por
padrão tanto do _tmux_ como do _tmate_ são bem mais recentes do que eu estava
usando:

```bash
~ apt-cache show tmux

# Entre várias informações úteis, olha a versão logo ali:
Package: tmux
Architecture: amd64
Version: 3.0a-2

~ apt-cache show tmate

# E a versão do tmate também:
Package: tmate
Architecture: amd64
Version: 2.4.0-1
```

Quando terminei de instalar os meus [dotfiles](https://github.com/devdrops/my-dotfiles),
notei que alguma mudança ocorreu entre as versões de tmux que eu usava e a recém
instalada. Logo ao abrir o programa, notei que a configuração não foi carregada
corretamente e que havia uma sequência de mensagens:

```bash
# Omiti o caminho completo do arquivo por motivos óbvios ;)
.tmux.conf:120: invalid option: message-bg
.tmux.conf:121: invalid option: message-fg
.tmux.conf:122: invalid option: message-command-fg
.tmux.conf:123: invalid option: message-command-bg
.tmux.conf:125: invalid option: pane-border-fg
.tmux.conf:126: invalid option: pane-active-border-fg
.tmux.conf:130: invalid option: mode-bg
.tmux.conf:131: invalid option: mode-fg
.tmux.conf:133: invalid option: window-status-current-bg
.tmux.conf:134: invalid option: window-status-current-fg
.tmux.conf:135: invalid option: window-status-current-attr
.tmux.conf:138: invalid option: window-status-bg
```

Ficou claro que a compatibilidade mudou, o que era esperado dado a mudança do
número de versão _maior_ou _major_ (veja [Versionamento Semântico](https://semver.org/lang/pt-BR/)
para entender o que significa uma versão _maior_). Fui então ver o que mudou e o
que fazer, e achei a resposta rápida em uma issue aberta no [repositório oficial
do tmux no GitHub](https://github.com/tmux/tmux/issues/1689). A issue se refere
à mesma quebra de mudança que encontrei e que está descrita no [CHANGELOG](https://raw.githubusercontent.com/tmux/tmux/2.9/CHANGES)
da seguinte forma:

> _\* The individual -fg, -bg and -attr options have been removed; they_
> _were superseded by -style options in tmux 1.9._

Esse trecho ali não ficou muito claro, mas um [comentário](https://github.com/tmux/tmux/issues/1689#issuecomment-486722349)
na mesma issue que citei me ajudou a entender melhor o que exatamente havia
mudado:

> The form is exactly the same, it is just one option instead of three:
>
> `set -g mode-style bg=red,fg=green,blink`

O que isso quer dizer? Basicamente o seguinte:

As opções usadas na configuração que terminam em **-fg**, **-bg** e **-attr**
não existem mais. Essas opções se tornaram parâmetros de uma nova opção chamada
**-style**.

![EH FISTAILE](/2020/10/04/ehfistaile.gif#center)

Ou seja:

- Opções que separavam _foreground_, _background_ e _attribute_ agora são
unidas.
- A manipulação de _foreground_, _background_ e _attributes_ é por meio de
parâmetros, declarados um a um e separados por vírgula.

Bastou então mudar a configuração no meu `.tmux.conf` disso:

```batchfile
set -g status-bg colour235
set -g status-fg colour6

set -g message-bg colour238
set -g message-fg colour191
set -g message-command-fg colour33
set -g message-command-bg colour237

set -g pane-border-fg colour235
set -g pane-active-border-fg colour196

setw -g mode-bg colour6
setw -g mode-fg colour235

setw -g window-status-current-bg colour236
setw -g window-status-current-fg colour156
set -g window-status-current-attr bold

setw -g window-status-bg colour235
```

Para isso:

```batchfile
set -g status-style bg=colour235,fg=colour6

set -g message-style bg=colour239,fg=colour191
set -g message-command-style bg=colour237,fg=colour33

set -g pane-border-style fg=colour235
set -g pane-active-border-style fg=colour196

setw -g mode-style bg=colour6,fg=colour235

setw -g window-status-current-style bg=colour236,fg=colour156,bold

setw -g window-status-style bg=colour235
```

E pronto! A configuração foi carregada com sucesso e já faz parte do meu
[repositório de _dotfiles_](https://github.com/devdrops/my-dotfiles/commit/b4f0fdc04748dc55dd4f72c37d644f3c1a232400).
