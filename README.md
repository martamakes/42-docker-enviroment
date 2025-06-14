# 🚀 42 School Docker Development Environment

A complete, portable development environment for 42 School students that replicates the exact Ubuntu 22.04 setup used at 42 Madrid campus.

## 🎯 Why This Environment?

**Cross-Platform Consistency**: Whether you're on macOS (Intel/Apple Silicon), Windows, or Linux, this environment ensures you have the exact same development setup as the 42 Madrid campus computers.

**Complete Toolchain**: Includes all essential 42 tools pre-configured and ready to use:
- ✅ **Norminette v3** (official 42 linter)
- ✅ **GCC, GDB, Valgrind** (development & debugging tools)
- ✅ **42 Header** (automatic header insertion)
- ✅ **VS Code integration** with 42-specific extensions
- ✅ **Ubuntu 22.04** (identical to 42 Madrid)
- ✅ **Git & SSH** (automatic configuration and key management)

**No Setup Headaches**: Skip the tedious installation and configuration process. Everything works out of the box.

**Portable SSH Keys**: Your Git configuration and SSH keys are automatically backed up and restored across different computers.

## 📋 Prerequisites

### Docker Installation

#### 🍎 macOS
```bash
# Option 1: Docker Desktop (Recommended)
# Download from: https://www.docker.com/products/docker-desktop
# Install the .dmg file

# Option 2: Homebrew
brew install --cask docker
```

#### 🐧 Linux (Ubuntu/Debian)
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect
```

#### 🪟 Windows
```bash
# Download Docker Desktop for Windows
# From: https://www.docker.com/products/docker-desktop
# Enable WSL 2 backend during installation
```

### Verify Installation
```bash
docker --version
docker-compose --version
```

## 🚀 Quick Start

### 1. Clone & Setup
```bash
git clone https://github.com/yourusername/42-docker-environment.git
cd 42-docker-environment
chmod +x scripts/*.sh
```

### 2. Complete Installation
```bash
./scripts/install.sh
```

The installer will automatically:
- ✅ **Configure your 42 profile** (login, campus, email)
- ✅ **Setup Git configuration** (name, email, GitHub username)
- ✅ **Generate SSH keys** for GitHub (if chosen)
- ✅ **Build the Docker environment**
- ✅ **Run validation tests**

#### Configuration Options:
- **42 Login**: Your 42 username (supports hyphens: `mvigara-`)
- **Campus**: Madrid, Barcelona, France, or custom
- **GitHub Username**: For repository cloning
- **SSH Setup**: Choose automatic SSH key generation (recommended)

You'll be inside a Ubuntu 22.04 container with all 42 tools ready!

## 🛠️ What's Included

### Development Tools
- **GCC** with 42 compilation flags (-Wall -Wextra -Werror)
- **GDB** configured for thread debugging
- **Valgrind** with Helgrind for race condition detection
- **Make** for project building
- **Git** for version control

### 42-Specific Tools
- **Norminette v3**: Official 42 code style checker
- **42 Header**: Automatic header insertion (F1 in Vim)
- **42 Code formatting**: VS Code extension for automatic formatting

### Shell & Environment
- **Zsh** with Oh My Zsh (modern shell experience)
- **Vim** configured with 42 settings
- **Custom aliases**: `norm`, `42header`, `gcc42`, `valgrind-full`

### VS Code Integration
- Pre-configured workspace settings
- 42-specific extensions installed
- Debugging configurations for C projects
- Tasks for building, testing, and norminette checking

## 📖 Usage Guide

### Basic Commands Inside Container
```bash
# Check norminette on files
norm *.c

# Compile with 42 flags
gcc42 -o program file.c

# Debug with GDB
gdb ./program

# Check for race conditions
valgrind --tool=helgrind ./program

# Insert 42 header in Vim
vim file.c
# Press F1 to insert header
```

### Working with Projects
```bash
# Your host files are mounted at /home/student/workspace
cd /home/student/workspace

# Example: philosophers project
cd philosophers
make
./philo 4 800 200 200

# Debug philosophers
gdb ./philo
(gdb) run 4 800 200 200
```

### Testing the Environment
```bash
# Run included tests
./scripts/test.sh

# This will verify:
# - All tools are installed
# - Compilation works
# - Norminette is functional
# - Threading works correctly
```

### Working with Git Repositories

#### Quick Clone (Recommended)
```bash
# Clone any of your repositories quickly
./quick_clone.sh philosophers
./quick_clone.sh libft
./quick_clone.sh ft_printf
```

#### Manual Git Operations
```bash
# Start environment
./scripts/run.sh

# Inside container - Git is already configured!
git clone git@github.com:yourusername/philosophers.git
cd philosophers
make
norm *.c
./philo 4 800 200 200
```

#### SSH Key Management

**🔑 SSH keys are portable across computers!**

- **First time**: SSH keys are generated and saved to `.ssh-backup/`
- **Future uses**: Keys are automatically restored from backup
- **New computer**: Just clone this repo and run - SSH keys work immediately!

```bash
# SSH keys are automatically backed up to:
# /your-project/.ssh-backup/id_ed25519
# /your-project/.ssh-backup/id_ed25519.pub

# On any new computer:
git clone https://github.com/yourusername/42-docker-environment.git
cd 42-docker-environment
./scripts/run.sh
# SSH keys are automatically restored!
```

**⚠️ First-time SSH Setup:**

If you chose SSH during installation, you'll need to add your public key to GitHub once:

1. The installer shows your SSH public key
2. Go to: https://github.com/settings/ssh/new
3. Title: "42 Docker Environment"
4. Paste your key and save
5. Done! Works everywhere now.

## 💻 VS Code Integration

### Setup
1. Install **Remote - Containers** extension in VS Code
2. Open project folder: `code .`
3. VS Code will detect the container configuration
4. Click "Reopen in Container" when prompted

### Features
- **IntelliSense** for C/C++
- **Integrated debugging** with GDB
- **Norminette checking** in real-time
- **42 Header insertion** with shortcuts
- **Built-in tasks** for common operations

### Keyboard Shortcuts
- `F1`: Insert 42 header
- `Ctrl+Shift+P` → "Tasks: Run Task" → Choose:
  - Build in Docker
  - Run Norminette
  - Run Valgrind

## 📁 Project Structure

```
42-docker-environment/
├── 📄 README.md
├── 🐳 Dockerfile                 # Container definition
├── 🐳 docker-compose.yml         # Container orchestration
├── ⚙️ .env.example               # Environment variables template
├── 📁 scripts/
│   ├── 🔨 build.sh              # Build container
│   ├── 🚀 run.sh                # Start development environment
│   ├── 🧪 test.sh               # Run environment tests
│   └── 📦 install.sh            # Complete setup script
├── 📁 vscode/
│   ├── 🔧 settings.json         # VS Code workspace settings
│   ├── 🎯 tasks.json            # Build and test tasks
│   ├── 🐛 launch.json           # Debug configurations
│   └── 📦 extensions.json       # Recommended extensions
├── 📁 dotfiles/
│   ├── 📝 .vimrc                # Vim configuration
│   ├── 🐚 .zshrc                # Zsh shell configuration
│   └── 🐛 .gdbinit              # GDB debugging settings
└── 📁 test-files/
    ├── 🧪 test_environment.c    # Environment validation
    └── 📄 Makefile              # Test compilation
```

## 🔧 Customization

### Campus-Specific Configuration
Edit `.env` for your specific campus:

```bash
# 42 Madrid
MAIL42=yourlogin@student.42madrid.com

# 42 Barcelona  
MAIL42=yourlogin@student.42barcelona.com

# 42 France
MAIL42=yourlogin@student.42.fr

# Other campuses: check your intranet email format
```

### Custom Aliases
Add to `dotfiles/.zshrc`:
```bash
alias myproject="cd /home/student/workspace/my-project"
alias buildall="make && norm *.c"
```

## 🚨 Troubleshooting

### Docker Issues
```bash
# Docker not running
sudo systemctl start docker  # Linux
# Or start Docker Desktop application

# Permission denied
sudo usermod -aG docker $USER
# Then logout and login again

# Container won't start
docker system prune  # Clean up
./scripts/build.sh   # Rebuild
```

### VS Code Remote Container Issues
```bash
# Reset container
docker-compose down
docker system prune
./scripts/build.sh

# Reinstall Remote-Containers extension
# Reload VS Code window
```

### Vim Configuration Issues
```bash
# If you get vim encoding errors, run inside container:
./fix_vimrc.sh

# Or manually fix:
sed -i 's/listchars=tab:>-,trail:·/listchars=tab:>-,trail:./' ~/.vimrc
```

### Norminette Issues
```bash
# Inside container, verify installation
norminette --version

# Test with sample file
norminette test-files/test_environment.c
```

## 📚 Essential Commands Cheat Sheet

```bash
# Container Management
./scripts/install.sh            # Complete setup (run once)
./quick_clone.sh <repo>         # Quick clone GitHub repos
./scripts/run.sh                # Start environment  
./scripts/test.sh               # Test environment
./scripts/build.sh              # Rebuild environment (if needed)
docker-compose down             # Stop all containers

# Inside Container - Development
norm file.c                     # Check norminette
gcc42 -o prog file.c           # Compile with 42 flags
gdb ./prog                     # Debug program
valgrind-full ./prog           # Memory check
42header                       # Open vim with header

# Inside Container - Project Building
make                           # Build project
make clean                     # Clean objects
make fclean                    # Full clean
make re                        # Rebuild

# Git Workflow (from host or container)
git add .
git commit -m "message"
git push origin main
```

## 🤝 Contributing

Found a bug or want to improve the environment? Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **42 School** for the amazing curriculum
- **42 Madrid** for the reference environment
- The **42 Community** for sharing knowledge and tools

---

**Ready to code like you're at 42 Madrid, from anywhere! 🚀**

*If you find this helpful, please ⭐ star the repository!*
