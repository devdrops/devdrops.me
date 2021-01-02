---
title: "Go: comandos CLI"
date: 2021-01-02
draft: true
---

Por curiosidade e vontade de aprender mais, fiquei intrigado com a quantidade de
comandos disponíveis pela ferramenta CLI **Go**.

Para quem não conhece, CLI é uma sigla em inglês que significa _Command Line
Interface_, que em nosso idioma podemos traduzir como Interface de Linha de
Comando. Num resumo, é uma forma de usar um programa pelo terminal, onde
executamos comandos em linha e não por botões ou caixas de texto da interface
gráfica do seu sistema operacional.

A linguagem de programação Go é muito bacana nesse ponto: preza pela
simplicidade, porém traz consigo todo um conjunto de ferramentas bem diverso,
para várias tarefas. Muitas linguagens também tem isso, porém poucas trazem
tanta coisa de forma nativa, de brinde, pronta para uso.

Como no dia a dia usamos poucos comandos (eu mesmo uso mais `fmt`, `test`, `run`
e `build`), decidi me dedicar a aprender mais o que posso fazer com todos os
comandos. Ao todo, a ferramenta `go` possui hoje (_1.15.6 linux/amd_)
**17** comandos:

|Comando|Descrição|Resumo|
|:---|:---|:---|
|`bug`|_start a bug report_|Instruções para abrir uma issue em `golang.org/issue/new`.|
|`build`|_compile packages and dependencies_|Cria binário.|
|`clean`|_remove object files and cached files_|Limpa arquivos desnecessários criados por packages.|
|`doc`|_show documentation for package or symbol_|Exibe documentação de um pacote.|
|`env`|_print Go environment information_|Exibe informações do ambiente atual.|
|`fix`|_update packages to use new APIs_|Atualiza o uso de APIs antigas no código.|
|`fmt`|_gofmt (reformat) package sources_|Aplica a formatação tradicional no código.|
|`generate`|_generate Go files by processing source_|Executa comandos descritos por diretivas no código.|
|`get`|_download and install packages and dependencies_|Baixa packages importados e suas dependências.|
|`install`|_compile and install packages and dependencies_|Compila e instala packages importados.|
|`list`|_list packages or modules_|Lista packages nomeados no projeto.|
|`mod`|_module maintenance_|Gerenciamento do uso de módulos no projeto.|
|`run`|_compile and run Go program_|Compila e executa código Go.|
|`test`|_test packages_|Executa testes dos packages importados.|
|`tool`|_run specified go tool_|Executa uma das ferramentas listadas por `go tool`.|
|`version`|_print Go version_|Exibe a versão de Go.|
|`vet`|_report likely mistakes in packages_|Examina código Go por erros não identificados por compiladores.|

Mas para quê servem?

### `go bug`

Abre o navegador padrão do seu sistema operacional para reportar um bug como
registro oficial, fornecendo informações diversas sobre a versão de Go que está
usando, variáveis de compilação, ambiente etc. É um atalho para reportar
problemas.

### `go build [-o output] [-i] [build flags] [packages]`

O comando faz a compilação do seu código, incluindo as dependências, e só. Isso
exclui arquivos com extensão `_test.go` (padrão de arquivo de teste), ou seja,
seus testes e os testes das dependências não farão parte da compilação por
padrão.

A flag `-o` serve para definir o nome e caminho do arquivo binário criado pela
compilação. É opcional, mas recomenda-se o uso. O comando `go build -o ./abc .`,
por exemplo, instrui o compilador para criar no diretório atual o binário `abc`.

A flag `-i` serve para que a compilação instale os packages que são dependências
do código.

Depois temos uma série de opções (_build flags_) para a compilação:

`-a` serve para forçar o _rebuild_ de pacotes que já estão atualizados.

`-n` escreve os comandos no terminal, mas sem executá-los.

`-p number` define o número de programas que podem ser executados em
paralelo. O padrão usado é o número de CPUs disponíveis. Para usá-la, basta
substituir _number_ pelo número desejado.

`-race` habilita detecção de _race conditions_ no momento da compilação. Uma
_race condition_ ocorre quando dois ou mais processos são executados fora da
ordem sequencial esperada, causando efeitos indesejados no programa. Se uma
_race condition_ é encontrada, o compilador escreve uma mensagem de atenção.
Mesmo sendo um excelente recurso da linguagem, é preciso ser usado com
prudência: uma vez habilitado, pode consumir 10 vezes o uso de CPU e memória.
Recomendo a leitura [deste texto](https://blog.golang.org/race-detector) para
entender quando usar essa opção da forma mais adequada.

`-msan` ou _memory sanitizer_, serve para que o ato de compilação faça uso de
sanitização de memória, que é um processo bem interessante: em casos de
memória em pilha (_stack_) ou monte (_heap_), algumas alocações de memória podem
ser lidas antes de serem escritas. O sanitizador de memória detecta esses casos
onde pode haver efeitos na execução do programa. Recomendo a leitura
[deste texto](https://github.com/google/sanitizers/wiki/MemorySanitizer) para se
aprofundar mais no assunto.

`-v` escreve o nome dos packages conforme são compilados.

`-work` se refere ao diretório temporário criado e usado na compilação. Go se
utiliza de diretórios temporários para criar o binário na compilação para
várias tarefas e os apaga depois da tarefa cumprida. Quando usamos esta flag, o
comando exibe o local desse diretório e o preserva, sem apagá-lo.

`-x` escreve cada comando realizado no ato da compilação.

`-asmflags '[pattern=]arg list'` serve para operações à nível de máquina. Go
possui partes de código Assembly em algumas de suas libs nativas e permite que o
comando `go build` crie versões em Assembly do seu código. Esta opção permite o
uso de flags no resultado desse tipo de compilação.

### `go clean`

### `go doc`

### `go env`

### `go fix`

### `go fmt`

### `go generate`

### `go get`

### `go install`

### `go list`

### `go mod`

### `go run`

### `go test`

### `go tool`

### `go version`

### `go vet`

