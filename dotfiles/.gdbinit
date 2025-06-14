# GDB Configuration for 42 School
# =================================

# Auto-load safe path (required for debugging)
set auto-load safe-path /

# Pretty printing
set print pretty on
set print array on
set print array-indexes on
set print elements 0

# History settings
set history save on
set history size 10000
set history filename ~/.gdb_history

# Debugging display settings
set disassembly-flavor intel
set pagination off

# Default layout
# Uncomment the next line if you prefer TUI mode by default
# layout split

# Custom aliases and commands
define cls
    shell clear
end
document cls
Clear the screen
end

define threads
    info threads
end
document threads
List all threads
end

define stacks
    thread apply all bt
end
document stacks
Show backtrace for all threads
end

define locals
    info locals
end
document locals
Print local variables
end

define args
    info args
end
document args
Print function arguments
end

define registers
    info registers
end
document registers
Print processor registers
end

# 42 specific debugging helpers
define 42check
    printf "Checking for common 42 errors...\n"
    printf "Stack frame:\n"
    bt
    printf "\nLocal variables:\n"
    info locals
    printf "\nFunction arguments:\n"
    info args
end
document 42check
Quick debugging check for 42 projects
end

# Memory debugging helpers
define memcheck
    printf "Memory layout:\n"
    info proc mappings
end
document memcheck
Show memory layout
end

# Thread debugging helpers
define tinfo
    printf "Thread information:\n"
    info threads
    printf "\nCurrent thread stack:\n"
    bt
end
document tinfo
Show thread information and current stack
end

# Philosophers specific debugging
define philo_debug
    printf "Philosophers debugging info:\n"
    printf "All threads:\n"
    info threads
    printf "\nThread states:\n"
    thread apply all bt 5
end
document philo_debug
Debugging helper for philosophers project
end

# Enhanced thread switching
define t1
    thread 1
end
define t2
    thread 2
end
define t3
    thread 3
end
define t4
    thread 4
end
define t5
    thread 5
end

document t1
Switch to thread 1
end

# Print settings for better visibility
set print address on
set print symbol on
set print symbol-filename on

# Breakpoint settings
set breakpoint pending on

# Source code display
set listsize 20

# Custom startup message
printf "🐛 GDB configured for 42 School debugging\n"
printf "💡 Custom commands available:\n"
printf "   cls         - Clear screen\n"
printf "   threads     - List all threads\n"
printf "   stacks      - Show all thread stacks\n"
printf "   42check     - Quick 42 debugging check\n"
printf "   philo_debug - Philosophers debugging\n"
printf "   t1-t5       - Quick thread switching\n"
printf "\n"
