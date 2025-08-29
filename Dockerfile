FROM ubuntu:22.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=student
ENV HOME=/home/$USER
ENV SHELL=/bin/zsh

# Install base dependencies
RUN apt-get update && apt-get install -y \
    # Development tools
    build-essential \
    gcc \
    gdb \
    valgrind \
    make \
    git \
    curl \
    wget \
    # Libraries needed for 42 projects
    libreadline-dev \
    libncurses5-dev \
    # Python for norminette
    python3 \
    python3-pip \
    python3-setuptools \
    # Shells and utilities
    zsh \
    vim \
    htop \
    tree \
    man-db \
    # Debug and tracing tools
    strace \
    ltrace \
    lsof \
    net-tools \
    # Additional utilities
    libc6-dev \
    pkg-config \
    software-properties-common \
    # Node.js dependencies
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install norminette (official 42 version) and c_formatter_42
RUN python3 -m pip install --upgrade pip setuptools && \
    python3 -m pip install norminette && \
    python3 -m pip install c-formatter-42


# Create student user with proper home directory
RUN useradd -m -s /bin/zsh $USER && \
    echo "$USER:$USER" | chpasswd && \
    usermod -aG sudo $USER && \
    chown -R $USER:$USER $HOME

# Switch to student user
USER $USER
WORKDIR $HOME

# Install Oh My Zsh for better shell experience
RUN RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Copy configuration files
COPY --chown=$USER:$USER dotfiles/.vimrc $HOME/.vimrc
COPY --chown=$USER:$USER dotfiles/.zshrc $HOME/.zshrc
COPY --chown=$USER:$USER dotfiles/.gdbinit $HOME/.gdbinit

# Install 42 Header for Vim
RUN git clone https://github.com/42Paris/42header.git $HOME/.42header && \
    mkdir -p $HOME/.vim/plugin && \
    cp $HOME/.42header/plugin/stdheader.vim $HOME/.vim/plugin/

# Configure environment variables for 42 Header
ENV USER42=student
ENV MAIL42=student@student.42madrid.com

# Configure gdb for debugging
RUN echo "set auto-load safe-path /" >> $HOME/.gdbinit

# Create useful aliases (append to existing .zshrc)
RUN echo '' >> $HOME/.zshrc && \
    echo '# 42 School aliases' >> $HOME/.zshrc && \
    echo 'alias ll="ls -la"' >> $HOME/.zshrc && \
    echo 'alias la="ls -la"' >> $HOME/.zshrc && \
    echo 'alias ..="cd .."' >> $HOME/.zshrc && \
    echo 'alias norm="norminette"' >> $HOME/.zshrc && \
    echo 'alias cf42="c_formatter_42"' >> $HOME/.zshrc && \
    echo 'alias valgrind-full="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"' >> $HOME/.zshrc && \
    echo 'alias 42header="vim +Stdheader"' >> $HOME/.zshrc && \
    echo 'alias gcc42="gcc -Wall -Wextra -Werror"' >> $HOME/.zshrc && \
    echo '# Debug aliases' >> $HOME/.zshrc && \
    echo 'alias strace-philo="strace -f -e trace=sem_wait,sem_post"' >> $HOME/.zshrc && \
    echo 'alias strace-full="strace -f -tt"' >> $HOME/.zshrc && \
    echo 'alias check-sems="ls -la /dev/shm/ | grep philo"' >> $HOME/.zshrc && \
    echo '# Norma fixing aliases' >> $HOME/.zshrc && \
    echo 'alias fix-norm="cf42 srcs/*.c srcs/*/*.c includes/*.h"' >> $HOME/.zshrc && \
    echo 'alias check-norm="norm includes/ srcs/ | grep Error | wc -l"' >> $HOME/.zshrc && \

# Create workspace directory
RUN mkdir -p $HOME/workspace

WORKDIR $HOME/workspace

# Default command
CMD ["/bin/zsh"]