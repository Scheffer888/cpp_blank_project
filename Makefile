# Compiler and build settings
CXX       = g++
CXXFLAGS  = -Wall -Wextra -std=c++17 -g -O0 -MMD -MP

# Directories
SRC_DIR   = src
BUILD_DIR = build

# Executable target
TARGET    = $(BUILD_DIR)/main.exe

# Source and Object Files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

# Default rule: build entire project
all: $(TARGET)
	@echo "✅ Build complete: $(TARGET)"

# Just printing debug info
$(info 🔍 SRCS: $(SRCS))
$(info 🔍 OBJS: $(OBJS))

# Link object files into final executable
$(TARGET): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "🔗 Linked into: $@"

# Compile each .cpp → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "🛠️ Compiling: $< → $@"
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Single-file build target
active:
ifndef SINGLE_SRC
	$(error ❌ SINGLE_SRC not provided. Use: make active SINGLE_SRC=path/to/file.cpp)
endif
	@mkdir -p $(BUILD_DIR)
	@echo "📄 Compiling single file: $(SINGLE_SRC)"
	@unix_path=$$(cygpath "$(SINGLE_SRC)"); \
	 filename=$$(basename $$unix_path); \
	 name=$${filename%.*}; \
	 out=$(BUILD_DIR)/$$name.exe; \
	 $(CXX) $(CXXFLAGS) $$unix_path -o $$out; \
	 echo "✅ Built: $$out"


# Include header dependencies (.d files)
-include $(DEPS)

# Clean up generated outputs
clean:
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.exe

.PHONY: all clean active
