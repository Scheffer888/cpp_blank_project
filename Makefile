# Build mode: choose one of [debug | dev | release | fast]
MODE ?= debug

# Compiler and build settings
CXX       = g++
BASE_FLAGS  = -Wall -Wextra -std=c++17 -MMD -MP

# Dynamic vectorization report flag (default is empty)
VEC_REPORT :=
ifeq ($(MODE),dev)
    VEC_REPORT = -fopt-info-vec-optimized=$(BUILD_DIR)/project_vector_report.txt
else ifeq ($(MODE),release)
    VEC_REPORT = -fopt-info-vec-optimized=$(BUILD_DIR)/project_vector_report.txt
else ifeq ($(MODE),fast)
    VEC_REPORT = -fopt-info-vec-optimized=$(BUILD_DIR)/project_vector_report.txt
endif

# Set the optimization level and flags based on the selected mode
ifeq ($(MODE),debug)
    CXXFLAGS = $(BASE_FLAGS) -g -O0
else ifeq ($(MODE),dev)
    CXXFLAGS = $(BASE_FLAGS) -O1
else ifeq ($(MODE),release)
    CXXFLAGS = $(BASE_FLAGS) -O2
else ifeq ($(MODE),fast)
    CXXFLAGS = $(BASE_FLAGS) -O3 -march=native
else
    $(error ❌ Unknown MODE: $(MODE))
endif

# Directories
SRC_DIR   = src
BUILD_DIR = build

# Executable target
TARGET    = $(BUILD_DIR)/project.exe

# Source and Object Files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

# Default rule: build entire project
all: $(TARGET)
	@echo "✅ Build complete: $(TARGET)"

# Just printing info
$(info 🛠️ Build mode: $(MODE))
# $(info 🔍 SRCS: $(SRCS))
# $(info 🔍 OBJS: $(OBJS))

# Link object files into final executable
$(TARGET): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@
	@echo "🔗 Linked into: $@"

# Compile each .cpp → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "🛠️ Compiling: $< → $@"
	@mkdir -p $(BUILD_DIR)
ifeq ($(filter $(MODE),dev release fast),$(MODE))
	$(CXX) $(CXXFLAGS) -fopt-info-vec-optimized=$(BUILD_DIR)/project_vector_report.txt -c $< -o $@
else
	$(CXX) $(CXXFLAGS) -c $< -o $@
endif

# Single-file build target
active:
ifndef SINGLE_SRC
	$(error ❌ SINGLE_SRC not provided. Use: make active SINGLE_SRC=path/to/file.cpp)
endif
	@mkdir -p $(BUILD_DIR)
	@echo "📄 Compiling single file: $(SINGLE_SRC)"
	@unix_src=$$( \
		case "$(OS)" in \
			Windows_NT) cygpath "$(SINGLE_SRC)" ;; \
			*) echo "$(SINGLE_SRC)" ;; \
		esac); \
	 filename=$$(basename $$unix_src); \
	 name=$${filename%.*}; \
	 vec_report="$(BUILD_DIR)/$${name}_vector_report.txt"; \
	 out=$(BUILD_DIR)/$$name.exe; \
	 echo "🧠 Vector report: $$vec_report"; \
	 $(CXX) $(CXXFLAGS) -fopt-info-vec-optimized=$$vec_report $$unix_src -o $$out; \
	 echo "✅ Built: $$out"

# Include header dependencies (.d files)
-include $(DEPS)

# Clean up generated outputs
clean:
	rm -rf $(BUILD_DIR)
	@echo "🧹 Cleaned build directory"

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean active
