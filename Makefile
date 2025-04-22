# ================================================================
# Intel oneAPI + CUDA Makefile (Windows, icpx host, nvcc device)
# ================================================================
#   • MODE ?= debug | dev | release | fast
#   • CUDA=true  …build .cu files and link with cudart
#   • SINGLE_SRC=path/to/foo.{cpp,cu} + active target unchanged
# ================================================================

########################## user‑tunable ###########################
MODE ?= debug
CUDA_DEFAULT ?= false
USE_CUDA := $(or $(CUDA_DEFAULT),$(USE_CUDA))
CUDA_ARCH ?= sm_60

# ---------- tools ----------
CXX     = icpx # Intel compiler command
NVCC    = nvcc

# ---------- oneAPI paths ----------
COMPILER_LIB_DIR ?= C:/PROGRA~2/Intel/oneAPI/compiler/latest/lib
MKLROOT          ?= C:/PROGRA~2/Intel/oneAPI/mkl/latest

MKL_INCLUDE = -I"$(MKLROOT)/include"

# Directly reference the four import‐libs you saw under lib/intel64:
MKL_LIBS = \
    "$(MKLROOT)/lib/mkl_intel_lp64_dll.lib"    \
    "$(MKLROOT)/lib/mkl_tbb_thread_dll.lib"    \
    "$(MKLROOT)/lib/mkl_core_dll.lib"          \
    "$(COMPILER_LIB_DIR)/libiomp5md.lib"

# ---------- project layout ----------
SRC_DIR   = src
BUILD_DIR = build
TARGET    = $(BUILD_DIR)/project.exe

# ---------- source -> object lists ----------
CPP_SRCS := $(wildcard $(SRC_DIR)/*.cpp)
CPP_OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(CPP_SRCS))

ifeq ($(USE_CUDA),true)                     # only gather .cu files when wanted
CUDA_SRCS := $(wildcard $(SRC_DIR)/*.cu)
CUDA_OBJS := $(patsubst $(SRC_DIR)/%.cu,$(BUILD_DIR)/%.o,$(CUDA_SRCS))
else
CUDA_SRCS :=
CUDA_OBJS :=
endif

OBJS := $(CPP_OBJS) $(CUDA_OBJS)
DEPS := $(OBJS:.o=.d)

# Single‐file naming logic
SINGLE_BASE   := $(basename $(notdir $(SINGLE_SRC)))
SINGLE_OBJ    := $(BUILD_DIR)/$(SINGLE_BASE).o
SINGLE_EXE    := $(BUILD_DIR)/$(SINGLE_BASE).exe
SINGLE_VREPORT:= $(BUILD_DIR)/$(SINGLE_BASE)_vector_report.txt


# ---------- base host flags ----------
# -std=c++20: modern C++ standard
# -Wall -Wextra: warnings
# -MMD -MP: dependency tracking
# -g: produce debugging symbols (helpful for VTune)
# -qopenmp: enable OpenMP
# -qtbb: enable Intel TBB
BASE_FLAGS = -std=c++20 -Wall -Wextra -MMD -MP -g -qopenmp -qtbb $(MKL_INCLUDE)

# ---------- optimization by mode ----------
ifeq ($(MODE),debug)
  HOST_OPT   = -O0
  NVCC_OPT = -O0 -G
else ifeq ($(MODE),dev)
  HOST_OPT   = -O1
  NVCC_OPT = -O1
else ifeq ($(MODE),release)
  HOST_OPT   = -O2 -axCORE-AVX2 -ffast-math
  NVCC_OPT = -O3
else ifeq ($(MODE),fast)
  HOST_OPT   = -O3 -xHost -ffast-math
  NVCC_OPT = -O3 --use_fast_math
else
  $(error Unknown MODE: $(MODE))
endif

HOST_FLAGS  = $(BASE_FLAGS) $(HOST_OPT)

# Vectorization report flags only for dev+release+fast
VEC_REPORT = -qopt-report=max -qopt-report-phase=vec -qopt-report-file=$(SINGLE_VREPORT)

# ---------- NVCC flags (only used when CUDA=true) ----------
NVCC_INCLUDE   := /I$(MKLROOT_SHORT)/include

NVCC_HOST_FLAGS := \
    /std:c++20 \
    /EHsc \
	/Zi \
    /openmp \
    /MD \
	/nologo \
    $(NVCC_INCLUDE)

NVCCFLAGS = \
  -std=c++20 \
  -arch=$(CUDA_ARCH) \
  $(NVCC_OPT) \
  $(patsubst %,-Xcompiler %,$(NVCC_HOST_FLAGS))


# ==========================
# Rules
# ==========================
all: $(TARGET)
	@echo "Compiling entire project: MODE=$(MODE), USE_CUDA=$(USE_CUDA)"
	
# ----------- link object files into final .exe --------------
# If USE_CUDA is on: link via nvcc; else link via icpx (original path)
ifeq ($(USE_CUDA),true)
$(TARGET): $(OBJS)
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@echo "Linking with nvcc (cudart + MKL/TBB)…"
	@$(NVCC) $^ -o $@ $(MKL_LIBS) -lcudart
else
$(TARGET): $(OBJS)
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@echo "Linking with icpx…"
	@$(CXX) $(HOST_FLAGS) $^ -o $@ $(MKL_LIBS)
endif

# ---------- host compilation (.cpp → .o)--------------
# Compile each .cpp → .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@echo "[HOST] $<"
ifeq ($(filter $(MODE),dev release fast),$(MODE))
	@$(CXX) $(HOST_FLAGS) $(VEC_REPORT) -c $< -o $@
else
	@$(CXX) $(HOST_FLAGS) -c $< -o $@
endif

# ---------- device compilation (.cu → .o) --------------
ifeq ($(USE_CUDA),true)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cu
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
	@echo "[USE_CUDA] $<"
	@$(NVCC) $(NVCCFLAGS) -dc $< -o $@
endif

# ==========================
# Single-file build target
# ==========================
active:
	@echo "Compiling single file. MODE=$(MODE), USE_CUDA=$(USE_CUDA)"
ifndef SINGLE_SRC
	$(error SINGLE_SRC not provided. Use: make active SINGLE_SRC=path/to/file.cpp)
endif
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"
ifeq ($(USE_CUDA),true)
	$(NVCC) $(NVCCFLAGS) -o $(SINGLE_EXE) $(SINGLE_SRC) $(MKL_LIBS) -lcudart 1>nul
	@echo "Built: $(SINGLE_EXE)"
else
ifeq ($(filter $(MODE),dev release fast),$(MODE))
	$(CXX) $(HOST_FLAGS) $(VEC_REPORT) -c $(SINGLE_SRC) -o $(SINGLE_OBJ)
else
	$(CXX) $(HOST_FLAGS) -c $(SINGLE_SRC) -o $(SINGLE_OBJ)
endif
	$(CXX) $(HOST_FLAGS) $(SINGLE_OBJ) -o $(SINGLE_EXE) $(MKL_LIBS)
	@echo "Built: $(SINGLE_EXE)"
endif

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
