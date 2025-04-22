_Author: Eduardo B. Scheffer_

# Intro to High-Performance Computing in Finance

## 📚 Table of Contents

1. [Overview](#1-overview)  
2. [Code Conventions](#2-code-conventions)  
3. [Notes](#3-notes)  
4. [Requirements](#4-requirements)  
    - [4.1. Intel oneAPI (Primary)](#41-intel-oneapi-primary)  
      - [4.1.1. Download and Install Make](#411-download-and-install-make)  
      - [4.1.2. Install Intel oneAPI](#412-install-intel-oneapi)  
      - [4.1.3. Open VS Code](#413-open-vs-code)  
    - [4.2. GCC / MSYS2 (Optional, Secondary)](#42-gcc--msys2-optional-secondary)  
5. [Build & Run (Intel)](#5-build--run-intel)  
    - [5.1. Full Project Build](#51-full-project-build)  
    - [5.2. Single File Build](#52-single-file-build)  
    - [5.3. Run the Program](#53-run-the-program)  
    - [5.4. Clean the Build](#54-clean-the-build)  
6. [Build and Run on Midway3](#6-buld-and-run-on-midway3)  
    - [6.1. Prerequisites](#61-prerequisites)  
    - [6.2. Steps to Connect to Midway3](#62-steps-to-connect-to-midway3)  
    - [6.3. Accessing Demo Code](#63-accessing-demo-code)  
    - [6.4. Requesting a Compute Node](#64-requesting-a-compute-node)  
    - [6.5. Building a C++ Program](#65-building-a-c-program)  
    - [6.6. Compile a C++ Program](#66-compile-a-c-program)  
    - [6.7. Running a C++ Program](#67-running-a-c-program)  
    - [6.8. Running a Python Program](#68-running-a-python-program)  
    - [6.9. Export Zip File from Midway3](#69-export-zip-file-from-midway3)  
7. [Using Cython](#7-using-cython)  
    - [7.1. Variables and Functions](#71-variables-and-functions)  
    - [7.2. Steps to use Cython](#72-steps-to-use-cython)  
    - [7.3. Compiling and Running Cython Code](#73-compiling-and-running-cython-code)  
    - [7.4. `setup.py` for Cython](#74-setuppy-for-cython)  
8. [CUDA](#9-CUDA)
    - [8.1. CUDA on Midway3](#91-cuda-on-midway3)  
    - [8.2. CUDA on Windows](#92-cuda-on-windows)  
    - [8.3. Check Availability](#93-check-availability)  
    - [8.4. Compile CUDA Code](#94-compile-cuda-code)  
    - [8.5. Run CUDA Code](#95-run-cuda-code)
9. [Profiling Code](#8-profiling-code)  
    - [9.1. VTune (C++) on Midway3](#81-vtune-c-on-midway3)  
    - [9.2. VTune (C++) on Windows](#82-vtune-c-on-windows)  
    - [9.3. CProfile (Python)](#83-cprofile-python)  
    - [9.4. Line Profiler (Python)](#84-line-profiler-python)  
   - [9.5. Nsight (CUDA)](#85-nsight-cuda)
10. [Compressing Files](#10-compressing-files)  
11. [Further Resources](#11-further-resources)  

---

## 1. Overview

Project setup using the **Intel C++ Compiler** (primary) and **VS Code**.  
Supports both full-project builds and isolated file builds with smart folder mirroring.

> **Note**: If you still need `g++`, see the section below on using GCC.  
> By default, we now use Intel oneAPI compilers (`icpx`).

---

## 2. Code Conventions

| Element       | Style                  |
|---------------|------------------------|
| **Class**     | `MyClass` (PascalCase) |
| **Enum**      | `ENUM_VALUE` (ALL_CAPS)|
| **Function**  | `do_something()`       |
| **Variable**  | `some_variable`        |
| **Struct**    | `MyStruct`             |
| **Typedef**   | `Alias_t`              |

---

## 3. Notes

- Object files, executables, and dependency files are placed in `build/`
- Header dependencies are automatically tracked via `.d` files (`-MMD -MP`)
- The `make active` target mirrors your `src/` folder structure for clean builds
- `make run` is a shortcut to run the default executable after building

---

## 4. Requirements

### 4.1. Intel oneAPI (Primary)

#### 4.1.1. Download and Install Make

1. Download [Windows Native Make](https://sourceforge.net/projects/ezwinports/files/): `make-4.4.1-without-guile-w32-bin.zip` 

2. Extract the files and save it into a clean folder, for example:
`C:\tools\make\` or `C:\Program Files\Make`

3. Add the `make` folder above to the system environment variable PATH:
  - Right-click on **This PC** → **Properties** → **Advanced system settings** → **Environment Variables**.
  - Add the MSYS2 path to the `Path` variable:
    ```
    C:\Program Files\Make
    ```

4. Make sure there is no other folder for `make` in your PATH (For example, the if you previously installed `make` using MSYS, these variables might cause problems when compiling with Intel: `C:\msys64\mingw64\bin` or `C:\msys64\usr\bin`)

#### 4.1.2. Install Intel oneAPI

1. Install [Intel oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html)

2. After installing, create a `.bat` file to correctly initialize the Intel + MSVC environment:

  ```bash
  @echo off
  :: Set the Visual Studio install location
  set "VS2022INSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"

  :: FIRST: initialize Visual Studio build environment
  call "%VS2022INSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

  :: THEN: initialize Intel oneAPI environment
  call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat" --force

  :: Start interactive shell
  cmd
  ```
4. Save this file as:
  ```bash
  %USERPROFILE%\dev-tools\intel-vs2022-env.bat
  ```

#### 4.1.3. Open VS Code
5. Then, launch VS Code **from any terminal**, click on:
  ```bash
  intel-vs2022-env.bat
  ```
  Navigate to your repo folder:
  ```bash
  cd (your-repo-folder)
  ```
  Open VS Code:
  ```bash
  code .
  ```

6. You can verify the Intel compiler by:
   ```bash
   which icpx
   icpx --version
   ```

---

### 4.2. GCC / MSYS2 (Optional, Secondary)

If you prefer using MSYS with `g++`:

1. Download [MSYS2](https://www.msys2.org) with:
  ```bash
  pacman -Syu
  pacman -S mingw-w64-x86_64-gcc make gdb zip
  ```

2. Add the VS Code bin folder to the MSYS2 shell's PATH to use the `code` command through the MSYS2 **MINGW64** shell:
  ```bash
  echo 'export PATH="$PATH:/c/Users/(your-username)/AppData/Local/Programs/Microsoft VS Code/bin"' >> ~/.bashrc
  source ~/.bashrc
  ```

- 3. Save MSYS2 shell's PATH to the system environment variable:
  - Right-click on **This PC** → **Properties** → **Advanced system settings** → **Environment Variables**.
  - Add the MSYS2 path to the `Path` variable:
    ```
    C:\msys64\mingw64\bin
    C:\msys64\mingw64\bin
    ```

- Close and reopen the MSYS2 shell to apply the PATH changes.

- Launch a **MSYS2 MINGW64** shell, then open VS Code through the shell:
  ```bash
  cd (your-repo-folder)
  code .
  ```
- Switch your Makefile back to `Makefile_gcc` (archived version).

---

## 5. Build & Run (Intel)

This project uses a **`Makefile`** configured for the Intel compiler (`icpx`).

The Makefile supports multiple build modes, depending on the level of vectorization and optimization.
- `debug` - Basic debug mode (-O0)
- `dev` - Development mode with vectorization (-O1)
- `release` - Release mode with higher optimizations and optimizations (-O2 -axCORE-AVX2 -ffast-math)
- `fast` - Fastest mode with full vectorization and optimizations (-O3 -xHost -ffast-math)

The Makefile also builds in C++20 and support OpenMP, TBB and MKL.

### 5.1. Full Project Build

Builds all `.cpp` under `src/` into one executable.

- VS Code: (either task)
  - `Ctrl+Shift+B` → "🛠️ Build Entire Project (debug)"
  - `Ctrl+Shift+B` → "🛠️ Build Entire Project (release)"
  - `Ctrl+Shift+B` → "🛠️ Build Entire Project (fast)"

- Terminal: (either command)
  ```bash
  make all MODE=debug
  make all MODE=release
  make all MODE=fast
  ```

### 5.2. Single File Build

> Builds **one** file via `make active`.

- VS Code: (either task)
  - `Ctrl+Shift+B` → "🛠️ Build Active File (debug)"
  - `Ctrl+Shift+B` → "🛠️ Build Active File (dev)"
  - `Ctrl+Shift+B` → "🛠️ Build Active File (release)"
  - `Ctrl+Shift+B` → "🛠️ Build Active File (fast)"

- Terminal: (either command)
    ```bash
    make active SINGLE_SRC=src/assignment_a.cpp MODE=debug
    make active SINGLE_SRC=src/assignment_a.cpp MODE=dev
    make active SINGLE_SRC=src/assignment_a.cpp MODE=release
    make active SINGLE_SRC=src/assignment_a.cpp MODE=fast
    ```
Output appears in `build/assignment_a.exe`.

### 5.3. Run the Program

After building, the following command runs the final executable.

```bash
.\build\project.exe
.\build\assignment_f.exe
```

If the final executable is `project.exe`, you can also run by:
```bash
make run
```

### 5.4. Clean the Build

To remove compiled files and build artifacts:

```bash
make clean
```

---

## 6. Buld and Run on Midway3

Midway is the resource from Research Computing Center (RCC) at the University of Chicago.


The figure below shows a schematic diagram of Midway:
![Midway3 Schematic Diagram](./assets/midway3_rcc.png)


### 6.1. Prerequisites
- VS Code installed
- Access to Midway (UChicago RCC)
- Duo 2FA set up for your RCC account

### 6.2. Steps to Connect to Midway3

#### Step 1: Install the Remote Development Extension Pack

1. Open **VS Code**
2. Go to the **Extensions** view (`Ctrl+Shift+X`)
3. Search for `"Remote Development"`
4. Install the extension pack by Microsoft. It includes:
   - Remote - SSH
   - Remote - WSL
   - Remote - Containers



#### Step 2: Add Remote Host in VS Code

1. Open the Command Palette (`F1` or `Ctrl+Shift+P`)
2. Run:  
   ```
   Remote-SSH: Add New SSH Host...
   ```
3. Enter:  
   ```
   ssh eduardoscheffer@midway3.rcc.uchicago.edu
   ```
4. When prompted, choose to save the config to:
   ```
   C:\Users\eduar\.ssh\config
   ```

#### Step 3: Update the SSH Config File (Optional Alias)

Open the file `C:\Users\eduar\.ssh\config` and update it for clarity:

```ini
Host midway
    HostName midway3.rcc.uchicago.edu
    User eduardoscheffer
```

This allows you to use `midway` as a shortcut instead of the full hostname.


#### Step 4: Connect via Remote - SSH

1. Open the Command Palette (`F1` or `Ctrl+Shift+P`)
2. Run:  
   ```
   Remote-SSH: Connect to Host...
   ```
3. Choose `midway` from the list (or the full hostname)
4. Select **Linux** when prompted for the platform
5. You will be prompted for your password and then Duo 2FA (push, call, or SMS)

#### Notes
- You will be asked for your password and Duo authentication **every time you connect**


### 6.3. Accessing Demo Code

#### Step 1: Copy and Extract the Demo Code

Weekly demo code is available at:
```bash
/project2/finm32950/chanaka/
```

For this example, we’ll use `L1Demo.tar`. To copy it to your home directory, run:

```bash
cp /project2/finm32950/chanaka/L4Demo.tar .
```

Then extract it and check contents:
```bash
tar -xvf L4Demo.tar
ls -F
```

Navigate to the demo folder:

```bash
cd L1Demo/Profiling
ls
```


### 6.4. Requesting a Compute Node

Midway3 uses a job scheduling system, so you should not run compute-heavy code on the login node. To run your program interactively, you must request a compute node using the `sinteractive` command. For example, to request a node for 30 minutes with 24 cores under the `finm32950` account:

```bash
sinteractive --time=00:30:00 --cpus-per-task=24 --account=finm32950
```

To check if you received the correct number of CPUs:

```bash
nproc
```

This opens an interactive session on a compute node where you can compile and run your code as needed. It's recommended to request short sessions to increase your chances of getting a node quickly.

More details can be found in the Midway3 user guide:  
[https://rcc-uchicago.github.io/user-guide/](https://rcc-uchicago.github.io/user-guide/)

---

### 6.5. Building a C++ Program

1. Load the Intel Compiler and, if using, the MKL module:
```bash
module load intel/2022.0
module use /software/intel/oneapi_hpc_2022.1/modulefiles
module load mkl/latest
```

2. Navigate to the current folder.

### 6.6. Compile a C++ Program

#### 6.6.1 Build Directly (Intel Compiler via Terminal)
```bash
icc -std=c++17 -o (file_name) (file_name).cpp
```

The following **flags** are commonly used:
- `-std=c++17` - Use C++17 standard
- `-qopenmp` - Enable OpenMP support
- `-qtbb` - Enable Intel TBB support
- `-qmkl` - Enable Intel MKL support
- `-lpthread` - Link with pthreads

Additionally, for **vectorization** and **optimizations**:
- `-O0` - No optimizations (debug mode)
- `-O1` - Enable basic optimizations
- `-O2` - Enable more optimizations
- `-O3` - Enable high-level optimizations
- `-xHost` - Optimize for the host architecture
- `-ltbb` - Link with Intel TBB

To add a vectorization support, use:
`-qopt-report=max -qopt-report-file=assignment_1.txt`

A complete example for compiling with all the flags:

```bash
icc -std=c++17 -qopenmp -qtbb -qmkl -O3 -xHost -ltbb -o -qopt-report=max -qopt-report-file=assignment_1.txt assignment_1.exe assignment_1.cpp
```

To check compiler options:
```bash
icc -help
```

#### 6.6.2 Build Indirectly (Intel Compiler via Makefile)

To build the program using the Makefile, you can follow the same steps as explained previously, as long as the directory structure is the same and you have the same Makefile in the Midway3 directory.


### 6.7. Running a C++ Program
1. After compiling, run the program:
```bash
./assignment_1.exe
```


### 6.8. Running a Python Program

1. Before the first time after login, load the Python module:

```bash
module load python
```

2. Run the Python program:
```bash
python3 your_script.py
```

### 6.9. Export Zip File from Midway3
```bash
tar -czvf folder_name.tar.gz file_name_1.cpp file_name_1.exe file_name_2.cpp file_name_2.exe README.md
```
or, for an entire directory:
```bash
tar -czvf Assignment2-eduardoscheffer.tar.gz *
```

---

## 7. Using Cython

- Cython is a superset of the Python language that additionally supports calling C functions and declaring C types on variables and class attributes.
- It provides C-Extensions for Python: to use the compiler to generate efficient C code from Cython code, which can be used in regular Python programs.
- Allow us to use static C types (to improve performance).

**Documentation**: [Cython Docs](https://cython.readthedocs.io/en/latest/index.html)

#### 7.1. Variables and Functions:

- Cython supports all C data types:
  - char, short, int, long, float, double
  - signed and unsigned types
  - bool is supported using: bint
  - pointers


- To declare *C variables*, use `cdef`:
  ```cython
  cdef int my_variable = 0
  ```

- **Python functions**:
  - Are defined using `def` (as usual).

- **C functions**:
  - Are defined using `cpdef`.
  - Can take Python objects or arguments declared as C types.
  - Can return Python objects or arguments declared as C types

- Arguments of a C or Python function can have C data types.
- Python and C functions can call each other.
- Only Python functions can be called from outside the module by interpreted Python code.
  - Any functions that you want to “export” from your Cython module must be declared as Python functions using def.

### 7.2. Steps to use Cython

1. Write Python code in a .py file (as usual).
2. Create a `.pyx` file with the same name, and add Cython code.
3. Create a `setup.py` [script](https://pythonhosted.org/an_example_pypi_project/setuptools.html) to compile the Cython code using C/C++ compiler.


### 7.3. Compiling and Running Cython Code

#### Step 1. Activate Conda environment:
```bash
conda activate your_env_name
```

#### Step 2. To compile the Cython code, run:

Cython uses the standard MSVC compiler to compile the code. To compile the code, run the following command in the terminal:

```bash
python setup.py build_ext --inplace
```

Alternatively, if you want to save the compiled files in a different folder, you can adjust the `setup.py` (see code below) and run:

```bash
python setup.py build_ext --build-lib build
```

#### Step 3. Import the Cython module in your Python code:

After compiling the Cython file (which generates an intermediate C file and a file with `.pyd` extension), you can import the module in your main `.py` script.
```python
import script_name
```

Or, if you generated the build in a different folder:
```python
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "build"))

import julia_calc
```

#### Step 4. Running the Python program:
After compiling the Cython code, run the Python program normally (usually within a Conda environment):

```bash
python src/your_script.py
```


### 7.4 setup.py for Cython

#### 7.4.1. Simple example for building in the same folder as the source code:
```python
from setuptools import Extension, setup
from Cython.Build import cythonize
import numpy

extensions = [Extension("julia3", ["julia_calc.pyx"],
                               include_dirs=[numpy.get_include()],
                               extra_compile_args=['-fopenmp'],
                               extra_link_args=['-lgomp'])]
setup(
      name="Julia with OpenMP",
      ext_modules = cythonize(extensions)
)
```

#### 7.4.2. Example for building in a different folder:
```python
from setuptools import Extension, setup
from Cython.Build import cythonize
import os
import numpy

# Define paths
SRC_DIR = "src"
BUILD_DIR = "build"

# Make sure the build directory exists
os.makedirs(BUILD_DIR, exist_ok=True)
extra_compile_args = ['-fopenmp']
extra_link_args = ['-lgomp']

extensions = [
    Extension(
        name="julia_calc",
        sources=[os.path.join(SRC_DIR, "julia_calc.pyx")],
                               include_dirs=[numpy.get_include()],
                               extra_compile_args=extra_compile_args,
                               extra_link_args=extra_link_args
    )
]
setup(
    name="Julia with Cython 1",
    ext_modules=cythonize(extensions, build_dir=BUILD_DIR, compiler_directives={"language_level": "3"})
)
```

For additional flags, check the section below.

#### 7.4.3. Additional flags for Intel Compiler

```python
MKLROOT = r"C:/PROGRA~2/Intel/oneAPI/mkl/latest"
COMPILER_LIB_DIR = r"C:/PROGRA~2/Intel/oneAPI/compiler/latest/lib"

MKL_INCLUDE = os.path.join(MKLROOT, "include")
MKL_LIBS = [
    os.path.join(MKLROOT, "lib", "mkl_intel_lp64_dll.lib"),
    os.path.join(MKLROOT, "lib", "mkl_tbb_thread_dll.lib"),
    os.path.join(MKLROOT, "lib", "mkl_core_dll.lib"),
    os.path.join(COMPILER_LIB_DIR, "libiomp5md.lib"),
]

# --------------- MSVC Flags ---------------
# /std:c++20  : C++20
# /EHsc       : Enable C++ exceptions (needed often with C++ and MSVC)
# /Zi         : Debug symbols
# /O2         : Enable speed optimizations
# /fp:fast    : Fast floating-point optimizations
# /arch:AVX2  : Enable AVX2 instructions
# /openmp     : Enable OpenMP
# /MD         : Link against the DLL run-time
extra_compile_args = [
    "/std:c++20",
    "/EHsc",
    "/Zi",
    "/O2",
    "/fp:fast",
    "/arch:AVX2",
    '/openmp',
    f"/I{MKL_INCLUDE}",  # /I for include directory
]

# These .lib files get passed to the linker; /openmp to enable OpenMP linking
extra_link_args = MKL_LIBS + [
]
```

For more info, check the [User Guide](https://cython.readthedocs.io/en/latest/src/userguide/source_files_and_compilation.html#compilation) and [Setup scripts](https://docs.python.org/3.11/distutils/setupscript.html).

---

## 8. CUDA

### 8.1. CUDA on Midway3

To run CUDA on Midway3, you need to request a GPU compute node:
```bash
sinteractive --partition=gpu --gres=gpu:1 --time=0:15:00 --account=finm32950
```
Then, load the CUDA module:
```bash
module load cuda/11.7
```

### 8.2. CUDA on Windows

#### 8.1.2. Install CUDA Toolkit
To install CUDA toolkit on Windows/Linux, follow the instructions on the [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) page.

### 8.3. Check Availability

To check if CUDA is available, run:
```bash
nvcc --version
```

Also, check GPU availability:
```bash
nvidia-smi
```

### 8.4. Compile CUDA Code

To compile CUDA code, use the `nvcc` compiler. For example:
```bash
nvcc my_program.cu -o my_program
```


### 8.5. Run CUDA Code

To run the compiled CUDA program, use (in Linux):
```bash
./my_program
```
or (in Windows):
```bash
my_program.exe
```


## 9. Profiling Code

### 9.1. VTune (C++) on Midway3

1. Go to the folder where your executable is located:
```bash
cd Profiling/
```

2. Run the VTune Profiler:
```bash
./run_vtune
```

---

### 9.2. VTune (C++) on Windows

If you are analyzing a C++ program that uses MKL, you should use the Makefile command:
```bash
make vtune
``` 

If not, you can either do the same or open the VTune GUI directly.

Once open, select the project and load the .exe.

---

### 9.3. CProfile (Python)

Shows total time and cumulative time for each function, as well as number of calls. It helps identify bottlenecks in Python code.

To profile a Python program using CProfile, you can run via:
- Terminal:
  ```bash
  python -m cProfile -s cumulative src/sample_program.py
  ```
- VS Code task:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "🩺 Profile Active File (cProfile)"

One drawback of the CProfile is that it does not khow the most expensive lines. For that, we need Line Profiler.

---

### 9.4. Line Profiler (Python)

The line profiler shows how much time spend by each line of code. It **very useful to identify expensive lines of code** in a CPU-bound program.

To install Line Profiler:
```bash
pip install line_profiler
```

To check the arguments:
```bash
kernprof --help
```

Before running it, make sure your code has `@profile` decorators on the functions you want to profile. DOn't forget to comment it after profiling.

To profile a Python program using Line Profiler, you can run via:
- Terminal:
```bash
kernprof -l -v src/sample_program.py
```

- VS Code task:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "🩺 Profile Active File (cProfile)"

---


### 9.5 Nsight (CUDA)

Check the [NVIDIA Nsight](https://developer.nvidia.com/nsight-compute) documentation for more details.

## 10. Compressing Files

From the project root folder, run:
```bash
mkdir _zip
powershell Compress-Archive -Path setup.py,src/julia.py,src/julia_calc.pyx -DestinationPath _zip/assignment_g-eduardoscheffer.zip
```
If in Linux, using `tar`:
```bash
tar -czvf ../assignment3_contents.tar.gz src build README.md
---

## 11. Further Resources

- [Intel oneAPI Docs](https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html)
- [VTune Profiler Guide](https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler.html)
- [GNU Make manual](https://www.gnu.org/software/make/manual/make.html)
- [CUDA Programming Guide](https://docs.nvidia.com/CUDA/CUDA-c-programming-guide/index.html)
- [CUDA Math Functions](http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#mathematical-functions-appendix)
- [Intel MKL](https://www.intel.com/content/www/us/en/docs/onemkl/developer-reference-c/2024-1/overview.html)
- [Intel TBB](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onetbb-documentation.html)

