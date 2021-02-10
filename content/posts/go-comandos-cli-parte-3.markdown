---
title: "Go: comandos CLI, parte 3"
date: 2021-01-02
draft: true
---

Para finalizar o tema, vamos aqui ver os comandos CLI que ainda restam: `list`,
`mod`, `run`, `test`, `tool`, `version` e `vet`.

### `go list [-f format] [-json] [-m] [list flags] [build flags] [packages]`

O comando `list` nos dá uma lista de informações diversas sobre os _packages_
informados, como os arquivos que compõem o _package_, suas dependências,
testes e muito mais. Vale lembrar que o comando só informa sobre pacotes
instalados, ou seja, é preciso ter o _package_ (ou _packages_) instalado para
ter sucesso no comando.

A opção `-json` coloca toda a saída de informações no formato JSON, conforme o
exemplo:

```bash
# go list -json fmt
{
  "Dir": "/usr/local/go/src/fmt",
  "ImportPath": "fmt",
  "Name": "fmt",
  "Doc": "Package fmt implements formatted I/O with functions analogous to C's printf and scanf.",
  "Target": "/usr/local/go/pkg/linux_amd64/fmt.a",
  "Root": "/usr/local/go",
  "Match": [
    "fmt"
  ],
  "Goroot": true,
  "Standard": true,
  "GoFiles": [
    "doc.go",
    "errors.go",
    "format.go",
    "print.go",
    "scan.go"
  ],
  "Imports": [
    "errors",
    "internal/fmtsort",
    "io",
    "math",
    "os",
    "reflect",
    "strconv",
    "sync",
    "unicode/utf8"
  ],
  "Deps": [
    "errors",
    "internal/bytealg",
    "internal/cpu",
    "internal/fmtsort",
    "internal/oserror",
    "internal/poll",
    "internal/race",
    "internal/reflectlite",
    "internal/syscall/execenv",
    "internal/syscall/unix",
    "internal/testlog",
    "internal/unsafeheader",
    "io",
    "math",
    "math/bits",
    "os",
    "reflect",
    "runtime",
    "runtime/internal/atomic",
    "runtime/internal/math",
    "runtime/internal/sys",
    "sort",
    "strconv",
    "sync",
    "sync/atomic",
    "syscall",
    "time",
    "unicode",
    "unicode/utf8",
    "unsafe"
    ],
    "TestGoFiles": [
      "export_test.go"
    ],
    "XTestGoFiles": [
      "errors_test.go",
      "example_test.go",
      "fmt_test.go",
      "gostringer_example_test.go",
      "scan_test.go",
      "stringer_example_test.go",
      "stringer_test.go"
    ],
    "XTestImports": [
      "bufio",
      "bytes",
      "errors",
      "fmt",
      "internal/race",
      "io",
      "math",
      "os",
      "reflect",
      "regexp",
      "runtime",
      "strings",
      "testing",
      "testing/iotest",
      "time",
      "unicode",
      "unicode/utf8"
    ]
}
```

A opção `-f` serve para usar uma formatação de saída do comando como sintaxe de
busca (semelhante ao comando
[_docker inspect_](https://docs.docker.com/engine/reference/commandline/inspect/),
que filtra por uma sintaxe da árvore de uso no _package_, exibindo somente
parte das informações. Lembrando que essa sintaxe deve respeitar maiúsculas e
minúsculas, conforme o exemplo abaixo:

```bash
# go list -f {{.TestGoFiles}} fmt
[export_test.go]
```

A opção `-compiled`, usada junto de `-json` adiciona um grupo de
informações na lista chamado `CompiledGoFiles`, que são basicamente os mesmos
arquivos de `GoFiles`, sem muita utilidade aparente dado que essa é sua
principal diferença.

A opção `-deps` adiciona à saída informações sobre as dependências dos
_packages_ nomeados. Usa-se junto da opção `-json` para ter uma lista de
informações completa.

A opção `-e` impede que erros em _packages_ que não puderam ser encontrados
ou que a informação está mal formada.

A opção `-export` adiciona na saída do comando um campo adicional chamado
`Exports`, que mostra o arquivo fonte tipo `*.a` (junto do caminho completo) do
_package_.

A opção `-find` reduz a quantidade de informações, sem informar a lista de
dependências.

A opção `-test` adiciona à saída do comando todo um conjunto de
informações sobre os testes do _package_ analisado: dependências, arquivos e
muito mais.

A opção `-m`, como sugere, lista módulos ao invés de _packages_. Muitos dos
campos informados no uso de `-json` tem características afetadas quando
estamos falando de contexto de módulos, e a explicação dessa parte é densa
demais para este texto, pedindo um texto só para isso.

Para finalizar este comando, vale lembrar que este também aceita as mesmas
opções do comando `build`, descritas na
[primeira parte](/posts/go-comandos-cli-parte-1/) deste assunto.

### `go mod <command> [arguments]`

O comando `mod` permite toda uma série de operações sobre módulos. Este
comando possui uma série de comandos para ações diferentes:

- `download`
- `edit`
- `graph`
- `init`
- `tidy`
- `vendor`
- `verify`
- `why`

#### `go mod download [-x] [-json] [modules]`

O comando `download`, como o nome sugere, faz o download de módulos para o
cache local. Por padrão, o comando `go` automaticamente baixa os módulos
necessários para a aplicação. Porém, o `go mod download` pode fazer o
download para preencher o cache local.

A opção `-x` descreve as ações que o download executa.

A opção `-json` descreve no formato JSON cada módulo baixado, ou mensagem de
erro, dentro de um formato padrão de _struct_:

```golang
type Module struct {
  Path     string // module path
  Version  string // module version
  Error    string // error loading module
  Info     string // absolute path to cached .info file
  GoMod    string // absolute path to cached .mod file
  Zip      string // absolute path to cached .zip file
  Dir      string // absolute path to cached source root directory
  Sum      string // checksum for path, version (as in go.sum)
  GoModSum string // checksum for go.mod (as in go.sum)
}
```

#### `go mod edit [editing flags] [go.mod]`

O comando `edit` serve para editar o arquivo _go.mod_. Sua função principal
é de oferecer uma forma de edição do _go.mod_ através de comandos
automatizados, seja por algum script ou comando num fluxo de integração
contínua, por exemplo.

A opção `-fmt` serve para formatar o arquivo, sem fazer outro tipo de
alteração. Essa formatação acontece de forma implícita no uso de qualquer
outro uso de `go mod` que usam e/ou rescrevem o arquivo _go.mod_, portanto
seu uso explícito só é necessário se nenhuma outra opção for usada em
conjunto.

Por exemplo, considere este trecho de `go.mod` de um projeto que importa dois
_packages_: `"go.uber.org/zap"` e `"github.com/sirupsen/logrus"`:

```go
require (
        github.com/sirupsen/logrus v1.7.0 // indirect
        go.uber.org/zap v1.16.0 // indirect
)
```

Se voluntariamente mudamos a ordem dos _packages_, da seguinte forma:

```go
require (
        go.uber.org/zap v1.16.0 // indirect
        github.com/sirupsen/logrus v1.7.0 // indirect
)
```

Ao executar o comando `go mod edit -fmt go.mod`, a instrução `require` volta
à formatação original:

```go
require (
        github.com/sirupsen/logrus v1.7.0 // indirect
        go.uber.org/zap v1.16.0 // indirect
)
```

Nota: o comando aceita a opção `-x`, porém mesmo assim, sua execução não
escreve nada na saída.

A opção `-module` serve para mudar o conteúdo da linha `module` no começo
do arquivo `go.mod`, sem executar nenhuma validação. Útil caso o diretório
e/ou caminho do módulo mudou e você quer mudar o arquivo de forma automática.

Por exemplo, se no arquivo `go.mod` temos:

```go
module exemplo.com/eita
```

Ao executar o comando `go mod edit -module github.com/exemplo/eita`, teremos:

```go
module github.com/exemplo/eita
```

As opções `-require` e `-droprequire` servem respectivamente adicionar e
remover um _package_ na instrução `require` do `go.mod`.

Tomando por exemplo o mesmo trecho de `require` do exemplo anterior:

```go
require (
        github.com/sirupsen/logrus v1.7.0 // indirect
        go.uber.org/zap v1.16.0 // indirect
)
```

Se executamos o comando
`go mod edit -require=github.com/eita/preula@v1.2.3 go.mod`, temos o resultado:

```go
require (
        github.com/eita/preula v1.2.3
        github.com/sirupsen/logrus v1.7.0 // indirect
        go.uber.org/zap v1.16.0 // indirect
)
```

Essa opção não performa validações no conteúdo passado.

Agora, se executamos o comando
`go mod edit -droprequire=github.com/eita/preula go.mod`, teremos:

```go
require (
        github.com/sirupsen/logrus v1.7.0 // indirect
        go.uber.org/zap v1.16.0 // indirect
)
```

As opções `-exclude` e `-dropexclude` servem respectivamente adicionar e
remover um _package_ na instrução de `exclude` do `go.mod`.

Se executamos o comando
`go mod edit -exclude=github.com/eita/preula@v1.2.3 go.mod`, temos o resultado
no arquivo `go.mod`:

```go
exclude github.com/eita/preula v1.2.3
```

E assim como o `-droprequire`, a opção `-dropexclude` retira um _package_ da
instrução `exclude`.

As opções `-replace` e `-dropreplace`, bom, funcionam de forma bem parecida
das anteriores, mas neste caso, na instrução `replace` do arquivo `go.mod`.

Se executarmos o comando
`go mod edit -replace=exemplo.com/test1@v1.2.3=exemplo.com/test1@v1.3.0`, temos
o seguinte resultado:

```go
replace exemplo.com/test1 v1.2.3 => exemplo.com/test1 v1.3.0
```

E como podemos deduzir, a opção `-dropreplace` retira a instrução, apontando
o nome do _package_ antigo (`go mod edit -dropreplace=exemplo.com/test1@v1.2.3`,
por exemplo).

A opção `-go` define qual a versão de Go declarada no arquivo `go.mod`.

A opção `-print` mostra na saída do comando como ficará o arquivo `go.mod`
após as ações, sem editar de fato o arquivo. Bem útil para validar a ação
sem mudar nada.

E a opção `-json` escreve na saída como ficará o arquivo `go.mod`, só que
no formato JSON, e também sem alterar o arquivo `go.mod`.

#### `go mod graph`

O comando `graph` escreve um gráfico de requisitos do módulo. Este comando
não oferece nenhuma opção extra e pode retornar erros caso os _packages_ da
instrução `require` apresentarem falha para download.

O resultado é uma lista de dependências entre o módulo e suas dependências.
Considerando o seguinte arquivo `go.mod`:

```go
module exemplo.com/teste

go 1.15

require go.uber.org/zap v1.16.0 // indirect
```

Se executamos o comando `go mod graph`, temos o seguinte resultado:

```text
exemplo.com/teste go.uber.org/zap@v1.16.0
go.uber.org/zap@v1.16.0 github.com/pkg/errors@v0.8.1
go.uber.org/zap@v1.16.0 github.com/stretchr/testify@v1.4.0
go.uber.org/zap@v1.16.0 go.uber.org/atomic@v1.6.0
go.uber.org/zap@v1.16.0 go.uber.org/multierr@v1.5.0
go.uber.org/zap@v1.16.0 golang.org/x/lint@v0.0.0-20190930215403-16217165b5de
go.uber.org/zap@v1.16.0 gopkg.in/yaml.v2@v2.2.2
go.uber.org/zap@v1.16.0 honnef.co/go/tools@v0.0.1-2019.2.3
golang.org/x/lint@v0.0.0-20190930215403-16217165b5de golang.org/x/tools@v0.0.0-20190311212946-11955173bddd
golang.org/x/tools@v0.0.0-20190311212946-11955173bddd golang.org/x/net@v0.0.0-20190311183353-d8887717615a
gopkg.in/yaml.v2@v2.2.2 gopkg.in/check.v1@v0.0.0-20161208181325-20d25e280405
golang.org/x/net@v0.0.0-20190311183353-d8887717615a golang.org/x/crypto@v0.0.0-20190308221718-c2843e01d9a2
golang.org/x/net@v0.0.0-20190311183353-d8887717615a golang.org/x/text@v0.3.0
golang.org/x/net@v0.0.0-20190404232315-eb5bcb51f2a3 golang.org/x/crypto@v0.0.0-20190308221718-c2843e01d9a2
github.com/kr/text@v0.1.0 github.com/kr/pty@v1.1.1
golang.org/x/crypto@v0.0.0-20190510104115-cbcb75029529 golang.org/x/sys@v0.0.0-20190412213103-97732733099d
golang.org/x/crypto@v0.0.0-20190510104115-cbcb75029529 golang.org/x/net@v0.0.0-20190404232315-eb5bcb51f2a3
golang.org/x/mod@v0.0.0-20190513183733-4bf6d317e70e golang.org/x/crypto@v0.0.0-20190510104115-cbcb75029529
github.com/stretchr/testify@v1.4.0 gopkg.in/yaml.v2@v2.2.2
golang.org/x/crypto@v0.0.0-20190308221718-c2843e01d9a2 golang.org/x/sys@v0.0.0-20190215142949-d0b11bdaac8a
golang.org/x/tools@v0.0.0-20190621195816-6e04913cbbac golang.org/x/net@v0.0.0-20190311183353-d8887717615a
golang.org/x/tools@v0.0.0-20190621195816-6e04913cbbac golang.org/x/sync@v0.0.0-20190423024810-112230192c58
go.uber.org/atomic@v1.6.0 github.com/davecgh/go-spew@v1.1.1
go.uber.org/atomic@v1.6.0 github.com/stretchr/testify@v1.3.0
go.uber.org/atomic@v1.6.0 golang.org/x/lint@v0.0.0-20190930215403-16217165b5de
go.uber.org/atomic@v1.6.0 golang.org/x/tools@v0.0.0-20191029041327-9cc4af7d6b2c
github.com/rogpeppe/go-internal@v1.3.0 gopkg.in/errgo.v2@v2.1.0
github.com/stretchr/testify@v1.3.0 github.com/davecgh/go-spew@v1.1.0
github.com/stretchr/testify@v1.3.0 github.com/pmezard/go-difflib@v1.0.0
github.com/stretchr/testify@v1.4.0 github.com/pmezard/go-difflib@v1.0.0
go.uber.org/multierr@v1.5.0 github.com/stretchr/testify@v1.3.0
go.uber.org/multierr@v1.5.0 go.uber.org/atomic@v1.6.0
go.uber.org/multierr@v1.5.0 go.uber.org/tools@v0.0.0-20190618225709-2cfd321de3ee
go.uber.org/multierr@v1.5.0 golang.org/x/lint@v0.0.0-20190930215403-16217165b5de
go.uber.org/multierr@v1.5.0 golang.org/x/tools@v0.0.0-20191029190741-b9c20aec41a5
go.uber.org/multierr@v1.5.0 honnef.co/go/tools@v0.0.1-2019.2.3
gopkg.in/errgo.v2@v2.1.0 github.com/kr/pretty@v0.1.0
gopkg.in/errgo.v2@v2.1.0 gopkg.in/check.v1@v1.0.0-20180628173108-788fd7840127
golang.org/x/tools@v0.0.0-20191029190741-b9c20aec41a5 golang.org/x/net@v0.0.0-20190620200207-3b0461eec859
golang.org/x/tools@v0.0.0-20191029190741-b9c20aec41a5 golang.org/x/sync@v0.0.0-20190423024810-112230192c58
golang.org/x/tools@v0.0.0-20191029190741-b9c20aec41a5 golang.org/x/xerrors@v0.0.0-20190717185122-a985d3407aa7
golang.org/x/tools@v0.0.0-20191029041327-9cc4af7d6b2c golang.org/x/net@v0.0.0-20190620200207-3b0461eec859
golang.org/x/tools@v0.0.0-20191029041327-9cc4af7d6b2c golang.org/x/sync@v0.0.0-20190423024810-112230192c58
golang.org/x/tools@v0.0.0-20191029041327-9cc4af7d6b2c golang.org/x/xerrors@v0.0.0-20190717185122-a985d3407aa7
golang.org/x/net@v0.0.0-20190620200207-3b0461eec859 golang.org/x/crypto@v0.0.0-20190308221718-c2843e01d9a2
golang.org/x/net@v0.0.0-20190620200207-3b0461eec859 golang.org/x/sys@v0.0.0-20190215142949-d0b11bdaac8a
golang.org/x/net@v0.0.0-20190620200207-3b0461eec859 golang.org/x/text@v0.3.0
github.com/kr/pretty@v0.1.0 github.com/kr/text@v0.1.0
github.com/stretchr/testify@v1.4.0 github.com/davecgh/go-spew@v1.1.0
github.com/stretchr/testify@v1.3.0 github.com/stretchr/objx@v0.1.0
github.com/stretchr/testify@v1.4.0 github.com/stretchr/objx@v0.1.0
golang.org/x/net@v0.0.0-20190404232315-eb5bcb51f2a3 golang.org/x/text@v0.3.0
honnef.co/go/tools@v0.0.1-2019.2.3 golang.org/x/mod@v0.0.0-20190513183733-4bf6d317e70e
honnef.co/go/tools@v0.0.1-2019.2.3 github.com/rogpeppe/go-internal@v1.3.0
honnef.co/go/tools@v0.0.1-2019.2.3 github.com/kisielk/gotool@v1.0.0
honnef.co/go/tools@v0.0.1-2019.2.3 github.com/google/renameio@v0.1.0
honnef.co/go/tools@v0.0.1-2019.2.3 github.com/BurntSushi/toml@v0.3.1
honnef.co/go/tools@v0.0.1-2019.2.3 golang.org/x/tools@v0.0.0-20190621195816-6e04913cbbac
```

Uma saída bem verbosa, mas que também é completa sobre as dependências
diretas e indiretas do que colocamos nos projetos, não?

#### `go mod init [module]`

O comando `init` inicializa um módulo no diretório atual, criando um arquivo
`go.mod` se ainda não existir nenhum no mesmo diretório. É o ponto de partida
do uso de módulos em Go.

#### `go mod tidy [-v]`

O comando `tidy` adiciona módulos faltantes e apaga os que não são mais
usados. Sua função principal é de garantir que o conteúdo de `go.mod` é o
mesmo que seu projeto usa. Vale destacar que o comando também faz o mesmo no
arquivo `go.sum`.

A opção `-v` descreve as ações realizadas no comando.

Como exemplo, se tivermos este `go.mod`:

```go
module exemplo.com/teste

go 1.15

require go.uber.org/zap v1.16.0
```

Se usarmos o comando `go mod tidy -v`, sem ter feito o download das
dependências nem executado o código, teremos algo parecido na saída:

```text
go: downloading go.uber.org/zap v1.16.0
go: downloading go.uber.org/atomic v1.6.0
go: downloading go.uber.org/multierr v1.5.0
go: downloading github.com/stretchr/testify v1.4.0
go: downloading honnef.co/go/tools v0.0.1-2019.2.3
go: downloading github.com/pkg/errors v0.8.1
go: downloading gopkg.in/yaml.v2 v2.2.2
go: downloading golang.org/x/lint v0.0.0-20190930215403-16217165b5de
go: downloading go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee
go: downloading golang.org/x/tools v0.0.0-20191029190741-b9c20aec41a5
go: downloading github.com/davecgh/go-spew v1.1.1
go: downloading github.com/pmezard/go-difflib v1.0.0
go: downloading github.com/BurntSushi/toml v0.3.1
go: downloading gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127
go: downloading github.com/kr/pretty v0.1.0
go: downloading github.com/kr/text v0.1.0
```

#### `go mod vendor [-v]`

O comando `vendor` faz cópias das dependências no modelo _vendor_. O comando
"limpa" a pasta `vendor` do módulo principal e então inclui nela todos os
_packages_ necessários ao projeto, incluindo as dependências de testes.

A opção `-v` escreve na saída cada módulo e _package_ envolvido na
operação.

Se temos o seguinte `go.mod`:

```go
module exemplo.com/teste

go 1.15

require go.uber.org/zap v1.16.0
```

O comando `go mod vendor -v` terá a seguinte saída:

```text
# go.uber.org/atomic v1.6.0
go.uber.org/atomic
# go.uber.org/multierr v1.5.0
go.uber.org/multierr
# go.uber.org/zap v1.16.0
## explicit
go.uber.org/zap
go.uber.org/zap/buffer
go.uber.org/zap/internal/bufferpool
go.uber.org/zap/internal/color
go.uber.org/zap/internal/exit
go.uber.org/zap/zapcore
```

E uma pasta `vendor` com a seguinte estrutura de pastas:

```text
vendor
├── go.uber.org
│   ├── atomic
│   ├── multierr
│   └── zap
└── modules.txt
```

#### `go mod verify`

O comando `verify` verifica se as dependências tem o conteúdo esperado. O
comando analise o código das dependências no diretório de cache local (onde
o download é armazenado) e vê se houve alguma alteração desde o download.
Se nenhuma mudança foi encontrada, o resultado será a mensagem `"all modules
verified"`; se alguma mudança aconteceu, o comando indica qual (ou quais) e
retorna um status diferente de zero.

#### `go mod why [-m] [-vendor] packages...`

E o comando `why` serve para explicar por quê um _package_ ou módulo é
necessário. O comando traz contexto explicando onde o _package_ (ou
_packages_) é usado, numa lista de dependências parecida com o resultado de
`go mod graph`.

Por exemplo, se temos o seguinte `go.mod`:

```go
module github.com/exemplo/eita

go 1.15

require (
	github.com/sirupsen/logrus v1.7.0 // indirect
	go.uber.org/zap v1.16.0 // indirect
)
```

E executamos o comando `go mod why -m github.com/sirupsen/logrus`, teremos o
seguinte resultado:

```text
go: downloading gopkg.in/yaml.v2 v2.2.2
go: downloading github.com/pkg/errors v0.8.1
go: downloading golang.org/x/lint v0.0.0-20190930215403-16217165b5de
go: downloading github.com/stretchr/testify v1.4.0
go: downloading honnef.co/go/tools v0.0.1-2019.2.3
go: downloading go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee
go: downloading golang.org/x/tools v0.0.0-20191029190741-b9c20aec41a5
go: downloading gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127
go: downloading github.com/pmezard/go-difflib v1.0.0
go: downloading github.com/davecgh/go-spew v1.1.1
go: downloading github.com/kr/pretty v0.1.0
go: downloading github.com/BurntSushi/toml v0.3.1
go: downloading github.com/kr/text v0.1.0
# github.com/sirupsen/logrus
github.com/exemplo/eita
github.com/sirupsen/logrus
```

Primeiro, o comando executa uma série de downloads (mesmo se as dependências
já estão presentes no cache). Depois, temos o resultado explicando que o
módulo `github.com/exemplo/eita` tem dependência de
`github.com/sirupsen/logrus`.

### `go run [build flags] [-exec xprog] package [arguments...]`

O comando `run` compila e executa o _package_ ou arquivo passado no comando.

Este comando, assim como outros casos, aceita as mesmas opções exclusivas do
comando `go build`, vistas na [primeira parte](/posts/go-comandos-cli-parte-1/)
desta série.

### `go test`

### `go tool`

### `go version`

### `go vet`

---

## Referências

