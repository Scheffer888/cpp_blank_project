# ================================================================
# Makefile for Intel Compiler (icpx) on Windows
# ================================================================

# Build mode: choose one of [debug | dev | release | fast]
MODE ?= debug

# Intel compiler command
CXX = icpx

# Paths for Intel MKL (assuming oneAPI environment is set)
COMPILER_LIB_DIR ?= C:/PROGRA~2/Intel/oneAPI/compiler/latest/lib
MKLROOT          ?= C:/PROGRA~2/Intel/oneAPI/mkl/latest

MKL_INCLUDE = -I"$(MKLROOT)/include"

# Directly reference the four import‐libs you saw under lib/intel64:
MKL_LIBS = \
    "$(MKLROOT)/lib/mkl_intel_lp64_dll.lib"    \
    "$(MKLROOT)/lib/mkl_tbb_thread_dll.lib"    \
    "$(MKLROOT)/lib/mkl_core_dll.lib"          \
    "$(COMPILER_LIB_DIR)/libiomp5md.lib"

# Base compile flags
# -std=c++20: modern C++ standard
# -Wall -Wextra: warnings
# -MMD -MP: dependency tracking
# -g: produce debugging symbols (helpful for VTune)
# -qopenmp: enable OpenMP
# -qtbb: enable Intel TBB
BASE_FLAGS = -std=c++20 -Wall -Wextra -MMD -MP -g -qopenmp -qtbb $(MKL_INCLUDE)

# Vectorization report flags
VEC_REPORT = -qopt-report=max -qopt-report-phase=vec -qopt-report-file=$(BUILD_DIR)/project_vector_report.txt

# ===========================
# Optimization by Mode
# ===========================
ifeq ($(MODE),debug)
    CXXFLAGS = $(BASE_FLAGS) -O0
else ifeq ($(MODE),dev)
    CXXFLAGS = $(BASE_FLAGS) -O1
else ifeq ($(MODE),release)
    CXXFLAGS = $(BASE_FLAGS) -O2 -axCORE-AVX2 -ffast-math
else ifeq ($(MODE),fast)
	CXXFLAGS = $(BASE_FLAGS) -O3 -xHost -ffast-math
else
    $(error Unknown MODE: $(MODE))
endif

# Directories
SRC_DIR   = src
BUILD_DIR = build

# Main target
TARGET    = $(BUILD_DIR)/project.exe

# Source/Object Files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

# ==========================
# Single‐file naming logic
# ==========================

# Given SINGLE_SRC=path/to/foo.cpp, 
#   SINGLE_BASE = foo
#   SINGLE_OBJ  = build/foo.o
#   SINGLE_EXE  = build/foo.exe
#   SINGLE_VRPT = build/foo_vector_report.txt
SINGLE_BASE   := $(basename $(notdir $(SINGLE_SRC)))
SINGLE_OBJ    := $(BUILD_DIR)/$(SINGLE_BASE).o
SINGLE_EXE    := $(BUILD_DIR)/$(SINGLE_BASE).exe
SINGLE_VREPORT:= $(BUILD_DIR)/$(SINGLE_BASE)_vector_report.txt

# ==========================
# Rules
# ==========================
all: $(TARGET)
	@echo "Build complete: $(TARGET)"

$(info Using Intel Compiler. Build mode: $(MODE))

# Link object files into final .exe
$(TARGET): $(OBJS)
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@$(CXX) $(CXXFLAGS) $^ -o $@ $(MKL_LIBS)
	@echo "Linked into: $@"

# Compile each .cpp → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "Compiling: $< --> $@"
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
ifeq ($(filter $(MODE),dev release fast),$(MODE))
	@$(CXX) $(CXXFLAGS) $(VEC_REPORT) -c $< -o $@
else
	@$(CXX) $(CXXFLAGS) -c $< -o $@
endif

# Single-file build target
active:
ifndef SINGLE_SRC
	$(error SINGLE_SRC not provided. Use: make active SINGLE_SRC=path/to/file.cpp)
endif
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@echo "Compiling single file: $(SINGLE_SRC)"
	@$(CXX) $(CXXFLAGS) -qopt-report=max -qopt-report-phase=vec \
	      -qopt-report-file=$(SINGLE_VREPORT) \
	      -c $(SINGLE_SRC) -o $(SINGLE_OBJ)
	@$(CXX) $(CXXFLAGS) $(SINGLE_OBJ) -o $(SINGLE_EXE) $(MKL_LIBS)
	@echo "Built: $(SINGLE_EXE)"

# Clean build artifacts
clean:
	@if exist "$(BUILD_DIR)" rmdir /S /Q "$(BUILD_DIR)"
	@echo "Cleaned build directory"

# Run the final executable
run: $(TARGET)
	@echo "Running $(TARGET)"
	$(TARGET)

-include $(DEPS)

vtune:
	@echo Preparing VTune runtime environment...
	@copy /Y "C:\\Program Files (x86)\\Intel\\oneAPI\\mkl\\latest\\bin\\mkl_core.2.dll" "$(BUILD_DIR)" || echo Failed to copy mkl_core.2.dll
	@copy /Y "C:\\Program Files (x86)\\Intel\\oneAPI\\mkl\\latest\\bin\\mkl_tbb_thread.2.dll" "$(BUILD_DIR)" || echo Failed to copy mkl_tbb_thread.2.dll
	@echo Launching VTune GUI...
	@cmd.exe /C start "" "C:\\Program Files (x86)\\Intel\\oneAPI\\vtune\\latest\\bin64\\vtune-gui.exe"


.PHONY: all clean active run
