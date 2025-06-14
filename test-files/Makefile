# Makefile for testing 42 environment
# ===================================

NAME = test_environment

CC = gcc
CFLAGS = -Wall -Wextra -Werror -pthread

SRCDIR = .
SOURCES = test_environment.c
OBJECTS = $(SOURCES:.c=.o)

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[1;33m
NC = \033[0m # No Color

all: $(NAME)
	@echo "$(GREEN)✅ Test environment compiled successfully$(NC)"

$(NAME): $(OBJECTS)
	@echo "$(YELLOW)🔨 Linking $(NAME)...$(NC)"
	$(CC) $(CFLAGS) -o $(NAME) $(OBJECTS)

%.o: %.c
	@echo "$(YELLOW)🔨 Compiling $<...$(NC)"
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "$(YELLOW)🧹 Cleaning object files...$(NC)"
	rm -f $(OBJECTS)

fclean: clean
	@echo "$(YELLOW)🧹 Cleaning executable...$(NC)"
	rm -f $(NAME)

re: fclean all

# Testing targets
test: $(NAME)
	@echo "$(GREEN)🧪 Running basic test...$(NC)"
	./$(NAME)

norm:
	@echo "$(GREEN)📏 Checking norminette...$(NC)"
	norminette $(SOURCES) || echo "$(RED)❌ Norminette errors found$(NC)"

debug: CFLAGS += -g
debug: $(NAME)
	@echo "$(GREEN)🐛 Debug version compiled$(NC)"

valgrind: $(NAME)
	@echo "$(GREEN)🔍 Running Valgrind memory check...$(NC)"
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(NAME)

helgrind: $(NAME)
	@echo "$(GREEN)🔍 Running Helgrind race condition check...$(NC)"
	valgrind --tool=helgrind ./$(NAME)

tsan: CFLAGS += -fsanitize=thread -g
tsan: $(NAME)
	@echo "$(GREEN)🔍 Running ThreadSanitizer...$(NC)"
	./$(NAME)

# Full test suite
fulltest: $(NAME) norm test valgrind helgrind
	@echo "$(GREEN)🎉 All tests completed!$(NC)"

# Help target
help:
	@echo "$(GREEN)📖 Available targets:$(NC)"
	@echo "  all       - Compile the test program"
	@echo "  test      - Run the test program"
	@echo "  norm      - Check norminette compliance"
	@echo "  debug     - Compile with debug symbols"
	@echo "  valgrind  - Run with memory leak detection"
	@echo "  helgrind  - Run with race condition detection"
	@echo "  tsan      - Compile and run with ThreadSanitizer"
	@echo "  fulltest  - Run all tests"
	@echo "  clean     - Remove object files"
	@echo "  fclean    - Remove object files and executable"
	@echo "  re        - Rebuild everything"

.PHONY: all clean fclean re test norm debug valgrind helgrind tsan fulltest help
