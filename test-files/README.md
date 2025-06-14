# Test Files

This directory contains test files to verify that the 42 School development environment is working correctly.

## Files

- **test_environment.c**: A C program that tests basic functionality including:
  - Thread creation and management
  - Race condition scenarios (for testing Valgrind/Helgrind)
  - Basic I/O operations
  - Compliance with 42 norminette standards

- **Makefile**: Build system for the test program with various targets:
  - `make` - Compile the test program
  - `make test` - Run the test program
  - `make norm` - Check norminette compliance
  - `make valgrind` - Run memory leak detection
  - `make helgrind` - Run race condition detection
  - `make fulltest` - Run all tests

## Usage

```bash
# Inside the Docker container
cd test-files

# Compile and run basic test
make test

# Check norminette compliance
make norm

# Run memory checks
make valgrind

# Check for race conditions
make helgrind

# Run all tests
make fulltest
```

## Expected Behavior

The test program should:
1. ✅ Compile without errors using 42 flags
2. ✅ Run successfully and display test results
3. ✅ Pass norminette checks (if properly formatted)
4. ✅ Show some race conditions when run with Helgrind (this is intentional)
5. ✅ Complete all operations without crashes

This validates that the environment has all necessary tools properly configured.
