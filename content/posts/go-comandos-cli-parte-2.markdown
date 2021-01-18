---
title: "Go: comandos CLI, parte 2"
date: 2021-01-17
draft: true
---

Dando sequência do [artigo anterior](/posts/go-comandos-cli-parte-1/), veremos
mais detalhes de outros comandos da ferramenta CLI.

### `go env [-json] [-u] [-w] [var ...]`

O comando `env` serve para descrever informações importantes da versão de Go em
execução, como por exemplo variáveis de ambiente, informações de sistema
operacional, entre muitas outras.

O comando permite algumas opções:

`-json` define o formato de saída das informações. Por padrão, as informações
são exibidas no formato shell, como uma série de variáveis de ambiente, por
exemplo. Usando essa opção, os valores são escritos no formato JSON, chave e
valor.

As opções `-u` e `-w` são as mais interessantes deste comando: servem para
definir ou desfazer valores das variáveis de ambiente usadas pela linguagem.
Para explicar melhor, cabe aqui um exemplo.

Vamos tomar por exemplo a variável `GOINSECURE` (introduzida na versão 1.14,
serve para indicar domínios onde deve-se ignorar a ausência e validade de
certificados HTTPS no ato de obter módulos do mundo externo). Por padrão, na
versão 1.15, ela vem definida da seguinte forma:

```bash
GOINSECURE=""
```

Caso você quiser inserir um domínio a ser incluído nessa regra, você pode
usar a opção `-w`, que vai inserir o valor desejado conforme o exemplo:

```bash
# A sintaxe deve ser VARIAVEL=valor
go env -w GOINSECURE="site.com"

# Agora, go env vai exibir GOINSECURE="site.com"
```

Podemos passar uma lista de variáveis para alterar o valor.

Já a opção `-u` serve para devolver à variável editada por `-w` seu valor
original:

```bash
# A sintaxe aqui deve ser só VARIAVEL
go env -u GOINSECURE

# Agora, go env vai exibir o valor original, GOINSECURE=""
```

Lembrando que  `-u` só funciona para variáveis editadas por `-w` :wink:

### `go fix [packages]`

Este é um comando muito importante quando desejamos fazer atualizações de versão
com segurança de que mudanças na interface de packages não serão quebradas. O
`fix` identifica no pacote passado o uso de APIs antigas da linguagem e as
atualiza para versões novas.

O comando oferece algumas opções extras, mas que para serem usadas, devemos usar
o comando fix através do comando `tool`, na forma `go tool fix`. Dessa forma, a
sintaxe do comando pode ser lida da seguinte forma:

`go tool fix [-diff] [-r fixname,...] [-force fixname,...] [path ...]`

A opção `-diff` exibe as alterações a fazer sem fazê-las de fato. Uma excelente
forma de verificar antes se há mudanças e quais serão feitas!

A opção `-r` aqui não se trata de recursividade, mas sim de qual grupo de
rescritas deverão ser feitas. O comando `go tool fix -help` exibe a lista de
opções e, por padrão, todos os grupos são utilizados, mas podemos passar
somente um ou mais grupos se desejamos uma ação mais específica:

- `cftype` para inicializadores e conversões de _C.\*Ref_ e tipos _JNI_ (Java
  Native Interface, uma forma de acessar código Java através do seu código Go).
- `context` de _golang.org/x/net/context_.
- `egl` para inicializadores de EGLDisplay, da EGL API (_Embedded-System_
  _Graphics Library_, de Android).
- `eglconf` para inicializadores de EGLConfig, da EGL API (_Embedded-System_
  _Graphics Library_, de Android).
- `gotypes` de _golang.org/x/tools/go/{exact,types}_  para
  _go/{constant,types}_.
- `jni` para inicializadores de jobjects e subtipos da _JNI_.
- `netipv6zone` para literais de _IPAddr_, _UDPAddr_ ou _TCPAddr_.
- `printerconfig` que adiciona elementos para literais de _Config_.

Já a opção `-force` é como sugere: força a aplicação de `fix`, mesmo se o código
já foi atualizado.

Um detalhe importante: assim como muitas ferramentas, o comando não oferece
nenhuma forma de backup. Ou seja, use um controle de versão (git, svn, o que
preferir) antes de rodar o comando.

### `go fmt [-n] [-x] [packages]`

O comando `fmt` executa uma análise e correção de sintaxe padrão da linguagem.
Ao ser executado, o comando `gofmt -l -w` é disparado nos pacotes passados no
comando, onde `-l` orienta a escrever o nome dos pacotes identificados para
alteração e `-w` orienta a sobrescrever o arquivo quando encontrado. Ou seja, o
comando é como um atalho para identificação e aplicação de outra ferramenta,
`gofmt`, que é a real ferramenta padrão de formatação.

A opção `-n` serve para exibir quais mudanças poderão ser feitas, sem
aplicá-las.

Já a opção `-x` escreve os comandos conforme são executados.

Há ainda uma terceira opção, `-mod`, que funciona nas mesmas regras usadas no
comando `go build` só que aplicadas no contexto de `fmt`: define qual o tipo de
módulo onde se aplicar, _readonly_ ou _vendor_.

### `go generate [-run regexp] [-n] [-v] [-x] [build flags] [file.go... | packages]`

O comando `generate` serve para executar comandos descritos nas diretivas
contidas dentro do seu código Go. Por diretivas, estamos aqui falando de
instruções contidas no código, na forma `//go:generate comando argumento`.

Esses comandos podem executar quaisquer tarefas, mas no geral, são usados para
alterar ou criar arquivos de código Go. O comando faz uma análise estática dos
arquivos procurando por essas diretivas e, ao encontrá-las, as executa.
Lembrando que o comando não é executado de forma automática por nenhum outro,
como `build` por exemplo; logo, se seu código tem essas diretivas, este comando
deve ser sempre executado de forma explícita.

No ato da execução, o comando observa cada arquivo atrás de diretivas, que podem
ser chamadas à binários que podem estar declarados em _$PATH_, por caminho
completo ou um atalho (ou _alias_).

É importante notar que, para facilitar a identificação desses arquivos gerados
tanto para humanos como para máquinas, este arquivo gerado deverá conter a
seguinte declaração (por padrão no começo do arquivo):

```bash
^// Code generated .* DO NOT EDIT\.$
```

Um detalhe importante: durante a execução, o comando `generate` pode definir
algumas variáveis de ambiente (daquela lista do `go env`, lembra?), como
_$GOARCH_, _$GOOS_ entre outras, necessárias à sua execução.

### `go get`

### `go install`

---

## Referências

- https://golang.org/doc/go1.14
- https://fantashit.com/cmd-go-add-goinsecure-for-insecure-dependencies/
- https://github.com/timob/jnigi
- https://golang.org/cmd/cgo/
- https://developer.android.com/reference/android/opengl/EGLDisplay
- 


