FLEX = flex
CC = gcc
CFLAGS = -D_POSIX_C_SOURCE=200809L -Wall -Wextra -std=c11

TARGET = minilang
SOURCE = src/minilang.l
BUILD_DIR = build
TEST_DIR = tests
OUTPUT_DIR = output
GENERATED = $(BUILD_DIR)/lex.yy.c
EXECUTABLE = $(BUILD_DIR)/$(TARGET)

# Each test keeps tokens.txt and redirects lexical diagnostics to its own file.
.PHONY: all help test comments errors unclosed clean

all: $(EXECUTABLE)

help:
	@printf '%s\n' 'miniLang lexical analyzer'
	@printf '%s\n' ''
	@printf '%s\n' '  make            Compile the analyzer (same as make all).'
	@printf '%s\n' '  make all        Generate build/lex.yy.c and build/minilang.'
	@printf '%s\n' '  make test       Run the complete valid-token test.'
	@printf '%s\n' '  make comments   Run the comments and strings test.'
	@printf '%s\n' '  make errors     Run the lexical-error test.'
	@printf '%s\n' '  make unclosed   Run the unclosed-comment test.'
	@printf '%s\n' '  make clean      Delete generated C, executable and generated outputs.'
	@printf '%s\n' '  make help       Show this help.'
	@printf '%s\n' ''
	@printf '%s\n' 'Each test writes tokens and lexical errors to separate .txt files in output/.'
	@printf '%s\n' 'Compilation flags: $(CFLAGS)'

$(GENERATED): $(SOURCE)
	mkdir -p $(BUILD_DIR)
	$(FLEX) -o $(GENERATED) $(SOURCE)

$(EXECUTABLE): $(GENERATED)
	$(CC) $(CFLAGS) -o $(EXECUTABLE) $(GENERATED)

test: $(EXECUTABLE)
	mkdir -p $(OUTPUT_DIR)
	cd $(OUTPUT_DIR) && ../$(EXECUTABLE) ../$(TEST_DIR)/todos_tokens.min 2> todos_tokens_errors.txt
	cp $(OUTPUT_DIR)/tokens.txt $(OUTPUT_DIR)/tokens_todos_tokens.txt

comments: $(EXECUTABLE)
	mkdir -p $(OUTPUT_DIR)
	cd $(OUTPUT_DIR) && ../$(EXECUTABLE) ../$(TEST_DIR)/comentarios_cadenas.min 2> comentarios_cadenas_errors.txt
	cp $(OUTPUT_DIR)/tokens.txt $(OUTPUT_DIR)/tokens_comentarios_cadenas.txt

errors: $(EXECUTABLE)
	mkdir -p $(OUTPUT_DIR)
	cd $(OUTPUT_DIR) && ../$(EXECUTABLE) ../$(TEST_DIR)/errores.min 2> errores_errors.txt
	cp $(OUTPUT_DIR)/tokens.txt $(OUTPUT_DIR)/tokens_errores.txt

unclosed: $(EXECUTABLE)
	mkdir -p $(OUTPUT_DIR)
	cd $(OUTPUT_DIR) && ../$(EXECUTABLE) ../$(TEST_DIR)/comentario_sin_cerrar.min 2> comentario_sin_cerrar_errors.txt
	cp $(OUTPUT_DIR)/tokens.txt $(OUTPUT_DIR)/tokens_comentario_sin_cerrar.txt

clean:
	rm -f $(EXECUTABLE) $(GENERATED) $(OUTPUT_DIR)/*.txt
