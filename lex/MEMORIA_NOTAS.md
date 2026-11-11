# miniLang lexical analyzer

## Project structure

```text
src/       Lex/Flex source (`minilang.l`)
tests/     `.min` test files
output/    Generated `.txt` token outputs
build/     Generated C source and executable
docs/      Assignment materials and starter example
Makefile   Build and test commands
```

## Commands

```bash
make help       # List all available commands
make            # Build the analyzer
make test       # Run tests/todos_tokens.min
make comments   # Run tests/comentarios_cadenas.min
make errors     # Run tests/errores.min
make unclosed   # Run tests/comentario_sin_cerrar.min
make clean      # Remove generated build and output files
```

All test commands write `output/tokens.txt` and a named `.txt` copy in `output/`.
