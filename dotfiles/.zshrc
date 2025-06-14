# 42 School Zsh Configuration
# ============================

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 42 School specific environment
export USER42=${USER42:-student}
export MAIL42=${MAIL42:-student@student.42madrid.com}

# 42 Development aliases
alias norm="norminette"
alias 42header="vim +Stdheader"
alias valgrind-full="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"

# Compilation aliases
alias gcc42="gcc -Wall -Wextra -Werror"
alias make42="make CC=gcc CFLAGS='-Wall -Wextra -Werror'"

# General aliases
alias ll="ls -la"
alias la="ls -la"
alias l="ls -l"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"

# Development shortcuts
alias c="clear"
alias h="history"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# 42 project specific aliases
alias libft="cd ~/workspace/libft"
alias printf="cd ~/workspace/ft_printf"
alias gnl="cd ~/workspace/get_next_line"
alias philo="cd ~/workspace/philosophers"
alias minishell="cd ~/workspace/minishell"
alias cub3d="cd ~/workspace/cub3d"

# Useful functions
# Quick compilation and run
function qcr() {
    if [ -z "$1" ]; then
        echo "Usage: qcr <filename.c> [args...]"
        return 1
    fi
    
    local filename="$1"
    shift
    local program="${filename%.*}"
    
    echo "🔨 Compiling $filename..."
    gcc42 -g -o "$program" "$filename"
    
    if [ $? -eq 0 ]; then
        echo "✅ Compilation successful"
        echo "🚀 Running $program $@..."
        "./$program" "$@"
    else
        echo "❌ Compilation failed"
    fi
}

# Quick norminette check
function qnorm() {
    if [ $# -eq 0 ]; then
        echo "🔍 Running norminette on all C files..."
        norminette *.c *.h 2>/dev/null || norminette *.c 2>/dev/null || echo "No C files found"
    else
        norminette "$@"
    fi
}

# Quick valgrind check
function qval() {
    if [ -z "$1" ]; then
        echo "Usage: qval <program> [args...]"
        return 1
    fi
    
    echo "🔍 Running Valgrind on $1..."
    valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes "$@"
}

# Create new 42 project structure
function new42() {
    if [ -z "$1" ]; then
        echo "Usage: new42 <project_name>"
        return 1
    fi
    
    local project_name="$1"
    echo "📁 Creating 42 project: $project_name"
    
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Create basic Makefile
    cat > Makefile << 'EOF'
NAME = program

CC = gcc
CFLAGS = -Wall -Wextra -Werror

SRCDIR = .
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)

all: $(NAME)

$(NAME): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(NAME) $(OBJECTS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS)

fclean: clean
	rm -f $(NAME)

re: fclean all

norm:
	norminette $(SOURCES)

.PHONY: all clean fclean re norm
EOF

    # Create main.c with header
    vim +Stdheader main.c
    
    echo "✅ Project $project_name created successfully!"
}

# Welcome message
echo "🚀 Welcome to 42 School Development Environment!"
echo "📍 Ubuntu 22.04 (42 Madrid compatible)"
echo ""
echo "🛠️  Available tools:"
echo "   norm           - Check norminette"
echo "   gcc42          - Compile with 42 flags"
echo "   valgrind-full  - Full memory check"
echo "   42header       - Open vim with header"
echo ""
echo "📖 Quick functions:"
echo "   qcr file.c     - Quick compile and run"
echo "   qnorm          - Quick norminette check"
echo "   qval program   - Quick valgrind check"
echo "   new42 project  - Create new 42 project"
echo ""
echo "💡 Press F1 in vim to insert 42 header"

# Environment info
if [ -n "$USER42" ] && [ -n "$MAIL42" ]; then
    echo ""
    echo "👤 42 Profile: $USER42 ($MAIL42)"
fi

# Custom prompt with 42 info
PROMPT='%{$fg[cyan]%}42:%{$fg[green]%}%c%{$reset_color%} $(git_prompt_info)%{$reset_color%}$ '

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# Auto-completion
autoload -U compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# PATH configuration
export PATH="$HOME/.local/bin:$PATH"
