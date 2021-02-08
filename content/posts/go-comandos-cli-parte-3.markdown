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

O comando `edit` serve para editar o arquivo _go.mod_.

#### `go mod graph`

O comando `graph` escreve um gráfico de requisitos do módulo.

#### `go mod init [module]`

O comando `init` inicializa um módulo no diretório atual.

#### `go mod tidy [-v]`

O comando `tidy` adiciona módulos faltantes e apaga os que não são mais
usados.

#### `go mod vendor [-v]`

O comando `vendor` faz cópias das dpendências no modelo _vendor_.

#### `go mod verify`

O comando `verify` verifica se as dependências tem o conteúdo esperado.

#### `go mod why [-m] [-vendor] packages...`

E o comando `why` serve para explicar por quê um _package_ ou módulo é
necessário.

### `go run`

### `go test`

### `go tool`

### `go version`

### `go vet`

---

## Referências

