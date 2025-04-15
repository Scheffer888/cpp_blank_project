_Author: Eduardo B. Scheffer_

# Intro to High-Performance Computing in Finance

Repository for the **Intro to High-Performance Computing in Finance** course.

## Overview

Project setup using the **Intel C++ Compiler** (primary) and **VS Code**.  
Supports both full-project builds and isolated file builds with smart folder mirroring.

> **Note**: If you still need `g++`, see the section below on using GCC.  
> By default, we now use Intel oneAPI compilers (`icpx`).


## Code Conventions

| Element       | Style                  |
|---------------|------------------------|
| **Class**     | `MyClass` (PascalCase) |
| **Enum**      | `ENUM_VALUE` (ALL_CAPS)|
| **Function**  | `do_something()`       |
| **Variable**  | `some_variable`        |
| **Struct**    | `MyStruct`             |
| **Typedef**   | `Alias_t`              |


## Notes

- Object files, executables, and dependency files are placed in `build/`
- Header dependencies are automatically tracked via `.d` files (`-MMD -MP`)
- The `make active` target mirrors your `src/` folder structure for clean builds
- `make run` is a shortcut to run the default executable after building

---

## Requirements

### Intel oneAPI (Primary)

#### Download and Install Make

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

#### Install Intel oneAPI

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

#### Open VS Code
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

### GCC / MSYS2 (Optional, Secondary)

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

## Build & Run (Intel)

This project uses a **`Makefile`** configured for the Intel compiler (`icpx`).

The Makefile supports multiple build modes, depending on the level of vectorization and optimization.
- `debug` - Basic debug mode (-O0)
- `dev` - Development mode with vectorization (-O1)
- `release` - Release mode with higher optimizations and optimizations (-O2 -axCORE-AVX2 -ffast-math)
- `fast` - Fastest mode with full vectorization and optimizations (-O3 -xHost -ffast-math)

The Makefile also builds in C++20 and support OpenMP, TBB and MKL.

### 🔧 Full Project Build

> Builds all `.cpp` under `src/` into one executable.

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

### Single File Build

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

### ▶️ Run the Program

After building, the following command runs the final executable.

```bash
.\build\project.exe
.\build\assignment_f.exe
```

If the final executable is `project.exe`, you can also run by:
```bash
make run
```

### Clean the Build

To remove compiled files and build artifacts:

```bash
make clean
```

---

## Buld and Run on Midway3

### 🔌 Connect to Midway via SSH in VS Code

Midway is the resource from Research Computing Center (RCC) at the University of Chicago.


The figure below shows a schematic diagram of Midway:
![Midway3 Schematic Diagram](./assets/midway3_rcc.png)


#### Prerequisites
- VS Code installed
- Access to Midway (UChicago RCC)
- Duo 2FA set up for your RCC account


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

---

### Accessing Demo Code

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

---

### Requesting a Compute Node

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

### Building a C++ Program

1. Load the Intel Compiler and, if using, the MKL module:
```bash
module load intel/2022.0
module use /software/intel/oneapi_hpc_2022.1/modulefiles
module load mkl/latest
```

2. Navigate to the current folder.

### Compile a C++ Program
#### Directly (Intel Compiler via Terminal)
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

#### Indirectly (Intel Compiler via Makefile)

To build the program using the Makefile, you can follow the same steps as explained previously, as long as the directory structure is the same and you have the same Makefile in the Midway3 directory.

---

### Running a C++ Program
1. After compiling, run the program:
```bash
./assignment_1.exe
```

---

### Running a Python Program

1. Before the first time after login, load the Python module:

```bash
module load python
```

2. Run the Python program:
```bash
python3 your_script.py
```

---

### Export Zip File from Midway3
```bash
tar -czvf folder_name.tar.gz file_name_1.cpp file_name_1.exe file_name_2.cpp file_name_2.exe README.md
```
or, for an entire directory:
```bash
tar -czvf Assignment2-eduardoscheffer.tar.gz *
```

---

## Using Cython

- Cython is a superset of the Python language that additionally supports calling C functions and declaring C types on variables and class attributes.
- It provides C-Extensions for Python: to use the compiler to generate efficient C code from Cython code, which can be used in regular Python programs.
- Allow us to use static C types (to improve performance).

**Documentation**: [Cython Docs](https://cython.readthedocs.io/en/latest/index.html)

#### Variables and Functions:

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

### Steps to use Cython

1. Write Python code in a .py file (as usual).
2. Create a `.pyx` file with the same name, and add Cython code.
3. Create a `setup.py` [script](https://pythonhosted.org/an_example_pypi_project/setuptools.html) to compile the Cython code using C/C++ compiler.

#### Example of setup.py for Cython
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

For more info, check the [User Guide](https://cython.readthedocs.io/en/latest/src/userguide/source_files_and_compilation.html#compilation) and [Setup scripts](https://docs.python.org/3.11/distutils/setupscript.html).

---

### Compiling Cython Code

Activate Conda environment:
```bash
conda activate your_env_name
```

To compile the Cython code, run:
```bash
python setup.py build_ext --inplace
```

Altenrnatively, if you want to save the compiled files in a different folder, you can change the `setup.py` file to:
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

extensions = [
    Extension(
        name="julia_calc",
        sources=[os.path.join(SRC_DIR, "julia_calc.pyx")],
                               include_dirs=[numpy.get_include()],
                               extra_compile_args=['-fopenmp'],
                               extra_link_args=['-lgomp']
    )
]

setup(
    name="Julia with Cython 1",
    ext_modules=cythonize(extensions, build_dir=BUILD_DIR)
)

```
And compile with:
```bash
python setup.py build_ext --build-lib build
```

This step creates an intermediate C file and a file with pyd extension. 
After compiling the Cython file, we can use it in a regular Python script by importing the compiled module in your Python code:

```python
import script_name
```

However, if you saved the compiled files in a different folder, you need to add the path to the `sys.path`:

```python
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "build"))

import julia_calc
```

---
### Running Python with Cython

1. After compiling the Cython code, run the Python program (usually within a Conda environment):

```bash
python src/your_script.py
```

---

### Compressing Files

From the project root folder, run:
```bash
mkdir _zip
powershell Compress-Archive -Path setup.py,src/julia.py,src/julia_calc.pyx -DestinationPath _zip/assignment_g-eduardoscheffer.zip
```

---

## Profiling Code

### VTune (C++) on Midway3

1. Go to the folder where your executable is located:
```bash
cd Profiling/
```

2. Run the VTune Profiler:
```bash
./run_vtune
```

### VTune (C++) on Windows

If you are analyzing a C++ program that uses MKL, you should use the Makefile command:
```bash
make vtune
``` 

If not, you can either do the same or open the VTune GUI directly.

Once open, select the project and load the .exe.

---

### CProfile (Python)

Shows total time and cumulative time for each function, as well as number of calls. It helps identify bottlenecks in Python code.

To profile a Python program using CProfile, you can run via:
- Terminal:
  ```bash
  python -m cProfile -s cumulative src/sample_program.py
  ```
- VS Code task:
  - `Ctrl+Shift+P` → "Tasks: Run Task" → "🩺 Profile Active File (cProfile)"

One drawback of the CProfile is that it does not khow the most expensive lines. For that, we need Line Profiler.


### Line Profiler (Python)

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


## Further Resources

- [Intel oneAPI Docs](https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html)
- [VTune Profiler Guide](https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler.html)
- [GNU Make manual](https://www.gnu.org/software/make/manual/make.html)