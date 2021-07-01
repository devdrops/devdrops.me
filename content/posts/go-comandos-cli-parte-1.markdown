---
title: "Go: comandos CLI, parte 1"
date: 2021-01-02
draft: false
---

Por curiosidade e vontade de aprender mais, fiquei intrigado com a quantidade de
comandos disponíveis pela ferramenta CLI **Go**.

![](/2021/01/02/215px-Go_Logo_Blue.svg.png#center)

Este texto faz parte de uma série de 3 materiais no assunto:

- Parte 1: [`bug`, `build`, `clean` e `doc`](/posts/go-comandos-cli-parte-1/)
- Parte 2: [`env`, `fix`, `fmt`, `generate`, `get` e `install`](/posts/go-comandos-cli-parte-2/)
- Parte 3: [`list`, `mod`, `run`, `test`, `tool`, `version` e `vet`](/posts/go-comandos-cli-parte-3/)

Vale destacar que toda a documentação de referência utilizada foi baseada na
versão _1.15.6 linux/amd64_, obtida pela
[imagem oficial da linguagem Go no Docker Hub](https://hub.docker.com/_/golang).

A linguagem de programação Go é muito bacana nesse ponto: preza pela
simplicidade, porém traz consigo todo um conjunto de ferramentas bem diverso,
para várias tarefas. Muitas linguagens também tem isso, porém poucas trazem
tanta coisa de forma nativa, de brinde, pronta para uso.

Para quem não conhece, CLI é uma sigla em inglês que significa _Command Line
Interface_, que em nosso idioma podemos traduzir como Interface de Linha de
Comando. Num resumo, é uma forma de usar um programa pelo terminal, onde
executamos comandos em linha e não por botões ou caixas de texto da interface
gráfica do seu sistema operacional.

Como no dia a dia usamos poucos comandos (eu mesmo uso mais `fmt`, `test`, `run`
e `build`), decidi me dedicar a aprender mais o que posso fazer com todos os
comandos. Ao todo, a ferramenta `go` possui hoje (_1.15.6 linux/amd_)
**17** comandos que, a partir deste artigo, vou tratando aos poucos, dado a
quantidade de conhecimento agregado em cada comando.

Este texto é a parte 1 da série de artigos das ferramentas de linha de comando
da linguagem Go, onde vou falar de **go bug**, **go build**, **go clean** e **go
doc**.

|Comando|Descrição|Resumo|
|:---|:---|:---|
|`bug`|_start a bug report_|Instruções para abrir uma issue em _golang.org/issue/new_.|
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

### go bug

Abre o navegador padrão do seu sistema operacional para reportar um bug como
registro oficial, fornecendo informações diversas sobre a versão de Go que está
usando, variáveis de compilação, ambiente etc. É um atalho para reportar
problemas.

### go build [-o output] [-i] [build flags] [packages]

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
comando `go build` crie versões em Assembly do seu código. Isso quer dizer que a
linguagem resolveu sua própria forma de "produzir" código Assembly, e não que
tem toda a bagagem de outra linguagem, o que torna a linguagem "portátil". Esta
opção permite o uso de flags específicas no resultado desse tipo de compilação.
Recomendo demais assistir [esta apresentação](https://www.youtube.com/watch?v=KINIAgRpkDA)
do Rob Pike que explica a abordagem de Assembly desenvolvida na linguagem para
se aprofundar mais no assunto.

`-buildmode mode` serve para indicar qual o modo de compilação (_build_)
desejado. Cada modo de compilação vai gerar um resultado diferente. Todas as
opções de modo de compilação podem ser lidas [aqui](https://golang.org/cmd/go/#hdr-Build_modes).

`-compiler name` define qual compilador usar: _gccgo_ (compilador baseado no GCC
GNU Compiler) ou _gc_ (compilador padrão da linguagem).

`-gccgoflags '[pattern=]arg list'` serve para enviar argumentos específicos
quando usamos a opção `-compiler gccgo`.

`-gcflags '[pattern=]arg list'` por sua vez serve para argumentos específicos
quando usamos a opção `-compiler gc`.

`-installsuffix suffix` serve como um sufixo para o nome do diretório onde vai
ficar a instalação da compilação, para separar cada diretório de outros
_builds_.

`-ldflags '[pattern=]arg list'` serve para inserir argumentos na fase de _link_
(quando, durante a compilação, os arquivos _obj_ estão prontos para se tornar um
arquivo binário; veja a apresentação do Rob Pike citada acima para entender mais
do assunto), ou seja, parâmetros a usar na preparação do arquivo binário. Esta
opção é bem interessante, por isso recomendo a leitura [deste texto](https://blog.cloudflare.com/setting-go-variables-at-compile-time/)
e [deste outro texto](https://www.digitalocean.com/community/tutorials/using-ldflags-to-set-version-information-for-go-applications)
para entender as possibilidades oferecidas por esta opção.

`-linkshared` serve para uso junto da opção `-buildmode=shared`. Com esta opção,
a compilação vai preparar o código que será "linkado" pelas libs compartilhadas
geradas pelo `buildmode` citado.

`-mod mode` define qual o modo de download dos módulos, o que afeta o uso do
arquivo `go.mod`: _readonly_ (permite ao comando `go` somente a leitura do
arquivo `go.mod`, falhando em qualquer tentativa de atualização), _vendor_
(carrega as dependêndias de um diretório _vendor_ ao invés de tentar fazer o
download ou carregar do cache de módulos) ou _mod_ (carrega os módulos do
diretório de cache de módulos, mesmo se tiver um diretório _vendor_ presente).

`-modcacherw` serve para deixar os diretórios de módulos recém criados no cache
de leitura e escrita ao invés de somente leitura. Ou seja, guarda módulos em um
diretório de cache de módulos com permissões de leitura e escrita.

`-modfile file` serve para usar outro arquivo de controle de módulos além do
arquivo `go.mod` presente na raiz. Este uso é bem curioso porque ainda precisa
de um arquivo `go.mod` na raiz, porém este não é utilizado, somente o arquivo
inserido nesta opção. Seu uso também gera outro arquivo `go.sum` referente ao
arquivo de módulo passado na opção.

`-pkgdir dir` serve para fornecer um diretório onde serão instalados e
carregados todos os módulos, ao invés dos locais padrão. É útil para quando é
necessário criar uma onfiguração fora do padrão do projeto.

`-tags tag,list` serve para passar uma lista de tags a ser usada no processo de
compilação. Estas tags tem relação com as diretivas que podemos inserir no
código. Para saber mais quais diretivas usar, leia com atenção
[este texto](https://golang.org/cmd/compile/#hdr-Compiler_Directives).

`-trimpath` serve para substituir todos os caminhos absolutos do sistema
operacional presentes no binário final. No lugar, os caminhos são substituídos
por _go_ (no caso de packages nativos) ou _path@version_ no caso de módulos, ou
um caminho de _import_ simples (no uso de _GOPATH_).

`-toolexec 'cmd args'` serve para evocar chamadas de outras ferramentas de `go
tool` numa sequência, como `vet`, `asm` etc.

Vale destacar que muitas opções aqui presentes servem não só para o comando `go
build`, mas também para `go test`, `go run` e `go clean`.

### go clean [clean flags] [build flags] [packages]

O comando `clean` serve para limpeza de itens desnecessários, como arquivos,
diretórios, cache entre outros, criados na compilação. Seu objetivo principal é
de encontrar esses arquivos criados por outras ferramentas como Makefiles por
exemplo, ou chamadas manuais de `go build`.

A flag `-i` habilita a remoção do arquivo ou binário instalado passado no
comando, que teria sido criado pelo comando `go install`.

A flag `-n` é a execução silenciosa: escreve a execução dos comandos que seriam
executados, sem executá-los de fato.

A flag `-r` habilita o uso recursivo do comando, incluindo as dependências dos
packages importados no código.

A flag `-x` faz com que comandos de remoção sejam escritos conforme são
executados.

A flag `-cache` faz com que o comando apague todo o conteúdo de cache de `go
build`.

A flag `-testcache` expira todo o conteúdo de testes guardado no cache de `go
build`.

A flag `-modcache`, por sua vez, apaga todo o conteúdo de cache de módulos, por
completo.

### go doc [-u] [-c] [package|[package.]symbol[.methodOrField]]

O comando `go doc` exibe a documentação do pacote, podendo mostrar a
documentação completa ou parcial, dependendo da forma de uso do comando. Essa
documentação é exatamente a explicação inserida no código (olha o valor de
documentar bem o código que vocẽ faz!), fornecida em cada arquivo `doc.go`
presente no
[repositório oficial da linguagem](https://github.com/golang/go), só que
offline, o que é bem útil!

Se usamos o comando sem passar o nome do package, apenas `go doc`, o comando
busca a documentação do package do diretório onde se encontra.

O argumento de package passado é interpretado da forma como na sintaxe esperada
da documentação da linguagem. Ou seja, `go doc net/http` exibe a documentação de
_http_, assim como `go doc net/http.Handler` exibe somente a parte da
documentação do _type Handler_ contido no package _http_, e por aí vai. Note que
o uso da inicial maiúscula em _Handler_ é o que faz toda a diferença.

A flag `-all` exibe toda a documentação do package.

A flag `-c` torna o uso de _case sensitive_, ou seja, o parâmetro deve respeitar
maiúsculas e minúsculas. `go doc net/http.handler` funciona, mas `go doc -c
net/http.handler` retorna um erro de documentação não encontrada.

A flag `-cmd` trata a presença do package `main` como um package comum. Se
ausente, o package `main` é ignorado na exibição.

A flag `-short` faz com que só seja exibida uma forma resumida da documentação.

A flag `-src` exibe todo o código fonte do package/símbolo usado. Isso inclui o
código fonte, função, tipos, bem como outros detalhes não declarados.

A flag `-u` mostra a documentação de símbolos, métodos e campos não exportados.

---

E é isto! Se gostou, não deixe de acompanhar os próximos artigos para ver mais
sobre outros comandos de CLI da linguagem Go! :wink:

---

## Referências

- https://maori.geek.nz/how-go-build-works-750bb2ba6d8e
- https://groups.google.com/g/golang-nuts/c/5KkBfRR8kik
- https://stackoverflow.com/questions/63059865/how-do-i-run-go-test-with-the-msan-option-on-ubuntu-18-04
- https://blog.golang.org/race-detector
- https://github.com/google/sanitizers/wiki/MemorySanitizer
- https://pt.stackoverflow.com/questions/3797/o-que-s%C3%A3o-e-onde-est%C3%A3o-a-stack-e-heap
- https://medium.com/martinomburajr/go-tools-the-compiler-part-1-assembly-language-and-go-ffc42cbf579d
- https://golang.org/doc/asm
- https://golang.org/cmd/asm/
- https://golang.org/doc/install/gccgo
- https://golang.org/cmd/link/

