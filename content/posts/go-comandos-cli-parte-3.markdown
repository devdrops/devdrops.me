---
title: "Go: comandos CLI, parte 3"
date: 2021-01-02
draft: true
---

Para finalizar o tema, vamos aqui ver os comandos CLI que ainda restam: `list`,
`mod`, `run`, `test`, `tool`, `version` e `vet`.

### `go list [-f format] [-json] [-m] [list flags] [build flags] [packages]`

O comando `list` nos dá uma lista de informações diversas sobre os _packages_
informados. Vale lembrar que o comando só informa sobre pacotes instalados, ou
seja, é preciso ter o _package_ (ou _packages_) instalado para ter sucesso no
comando.

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
busca (semelhante ao comando [`docker inspect`](https://docs.docker.com/engine/reference/commandline/inspect/),
que filtra por sintaxe da árvore de uso, como o exemplo abaixo:

```bash
# go list -f {{.TestGoFiles}} fmt
[export_test.go]
```

### `go mod`

### `go run`

### `go test`

### `go tool`

### `go version`

### `go vet`

---

## Referências

