# TaskFarmer Makefile

# Tell make that these are phony targets.
.PHONY: all clean install uninstall

# Default C compiler (assuming Open MPI).
CC := mpicc

# Default installation directory.
PREFIX := /usr/local
SRC_DIR := .
BUILD_DIR := ./build

PREFIX_ABS = $(abspath $(PREFIX))
SRC_DIR_ABS = $(abspath $(SRC_DIR))
BUILD_DIR_ABS = $(abspath $(BUILD_DIR))

# Default install command
INSTALL := install

# Flags for install command for executable.
IFLAGS_EXEC := -m 0755

# Flags for install command for non-executable files.
IFLAGS := -m 0644

# Build the taskfarmer executable.
all: $(BUILD_DIR_ABS)/src/taskfarmer

$(BUILD_DIR_ABS)/src:
	mkdir -p $(BUILD_DIR_ABS)/src

$(BUILD_DIR_ABS)/src/taskfarmer: $(SRC_DIR_ABS)/src/taskfarmer.c | $(BUILD_DIR_ABS)/src
	$(CC) $< -o $@

# Remove the taskfarmer executable.
clean:
	rm -rf $(BUILD_DIR_ABS)/src

# Install the executable and man page.
install: all
	$(INSTALL) -d $(IFLAGS_EXEC) $(PREFIX)/bin
	$(INSTALL) -d $(IFLAGS_EXEC) $(PREFIX)/man
	$(INSTALL) -d $(IFLAGS_EXEC) $(PREFIX)/man/man1
	$(INSTALL) $(IFLAGS_EXEC) $(BUILD_DIR_ABS)/src/taskfarmer $(PREFIX)/bin
	$(INSTALL) $(IFLAGS) $(SRC_DIR_ABS)/man/taskfarmer.1 $(PREFIX)/man/man1
	gzip -9f $(PREFIX)/man/man1/taskfarmer.1

# Uninstall the executable and man page.
uninstall:
	rm -f $(PREFIX)/bin/taskfarmer
	rm -f $(PREFIX)/man/man1/taskfarmer.1.gz
