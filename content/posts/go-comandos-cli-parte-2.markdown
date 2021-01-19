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
alterar ou criar arquivos de código Go. O `generate` faz uma análise estática dos
arquivos procurando por essas diretivas e, ao encontrá-las, as executa.
Lembrando que o comando não é executado de forma automática por nenhum outro,
como `build` por exemplo; logo, se seu código tem essas diretivas, este comando
deve ser sempre executado de forma explícita. Os comandos a serem executados
pelo `generate` podem ser chamadas à binários que podem estar declarados em
_$PATH_, por caminho completo ou um atalho (ou _alias_).

Um detalhe importante: durante a execução, o comando `generate` pode definir
algumas variáveis de ambiente (daquela lista do `go env`, lembra?), como
_$GOARCH_, _$GOOS_ entre outras, necessárias à sua execução.

Pode-se também usar a sintaxe `//go:generate -command binário argumentos`,
onde `-command` é como uma _flag_ indicando que a string `binário` é um
comando seguido dos argumentos. Isso permite a criação de um atalho, que
poderá ser usado em outras diretivas. Funciona assim: primeiro, usamos uma
diretiva como `//go:generate -command xablau go tool fix`, por exemplo. Com
essa diretiva declarada, podemos usar então a chamada à `xablau` através da
diretiva `//go:generate -command xablau ./daora.go`, como um atalho.

Um detalhe bacana: se a operação de uma diretiva sobre um dado _package_
retorna um erro, todas as execuções desse _package_ são puladas, e o comando
parte para o próximo _package_, se houver mais de um _package_ declarado como
argumento.

Dado todas essas informações, vale lembrar que o comando tem uma única opção,
`-run`. Por padrão, a opção assume uma string vazia (`-run=""`); mas, se
passamos algum valor, esse deve ser uma expressão regular para identificar
algum padrão de arquivos a servirem como objeto da execução. Há outras
opções aceitas pelo comando, como `-v`, `-n` e `-x`, que funcionam da mesma
forma como são declaradas nos demais comandos:

- `-n` exibe o que será feito sem de fato executar.
- `-v` excreve o nome dos _packages_ conforme são processados.
- `-x` escreve os comandos na ordem como são executados.

Há também a opção de usar as mesmas opções do comando `build`.

### `go get [-d] [-f] [-t] [-u] [-v] [-fix] [-insecure] [build flags] [packages]`

O comando `get` serve para fazer o download de _packages_ com base em seus
nomes completos de importação, e também suas dependências, assim como o
`go install`. Este comando possui algumas opções próprias, que valem a pena ser
entendidas:

A opção `-d` instrui o comando a somente baixar os _packages_, sem instalá-los.

A opção `-u` diz para o comando usar a rede para atualizar os _packages_ e suas
dependências. Nota-se que por padrão o `get` usa a rede para buscar _packages_
faltando, mas não busca atualizar os que já tem. Logo, esta opção é bem poderosa
e deve ser usada com ponderação.

A opção `-f` só funciona em conjunto com a opção `-u`, forçando `get -u` a não
verificar se os _packages_ envolvidos na ação vieram de fato da origem descrita
no seu caminho de _import_. Isso permite pegar referências locais ao invés de
dados vindos do mundo externo, se assim desejarmos.

A opção `-fix` aplica `go tool fix` nos _packages_ baixados antes de resolver
suas dependências ou de seguir para o _build_.

A opção `-insecure` instrui o comando a ignorar a ausência e/ou invalidade de
HTTPS nas origens do que você está baixando, semelhante à `GOINSECURE` de que
falamos antes.

A opção `-t` instrui para que, além dos _packages_ serem baixados, que os
_packages_ necessários para os testes do que foi baixado sejam baixados junto.

A opção `-v` habilita a verbosidade do comando, escrevendo na saída o que está
sendo executado para o download.

Vale lembrar também que `get` aceita as mesmas opções do comando `build`.

Quando executado para baixar um novo _package_, `get` cria o diretório de
download em `GOPATH/src/<import-path>`, usando sempre a primeira entrada
presente em `GOPATH`, se tiver mais de uma. Já quando `get` é usado para conferir
ou atualizar um _package_, `get` procura na dependência um branch ou tag cujo
nome confere com a versão de Go em execução. Se não encontrar, o branch
principal do repositório é utilizado. Essa pode ser uma estratégia interessante
para libs que desejam fazer experimentos usando `go2` por exemplo, deixando uma
branch com esse nome para ser identificada na execução de `get`, sem quebrar o
que já estiver em `main` por exemplo. Um outro detalhe é que se o _package_ a
ser baixado usar algum submódulo de git (uma forma de vincular repositórios
externos ao projeto como dependências diretas), esses submódulos também serão
baixados.

Há mais informações relevantes sobre `get`. Por exemplo, o comando nunca confere
nem atualiza código localizado dentro da pasta `vendor`. Além disso, se a execução
está no modo _module-aware_, o comportamento de `get` e suas opções pode mudar.
Como o uso de `GOPATH` é mais antigo e considerado legado, é importante conhecer as
diferenças de execução do comando dependendo de seu contexto de execução.



### `go install`

---

## Referências

- https://golang.org/doc/go1.14
- https://fantashit.com/cmd-go-add-goinsecure-for-insecure-dependencies/
- https://github.com/timob/jnigi
- https://golang.org/cmd/cgo/
- https://developer.android.com/reference/android/opengl/EGLDisplay
-


