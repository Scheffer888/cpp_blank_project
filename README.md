# Intro to High-Performance Computing in Finance

Repository for the **Intro to High-Performance Computing in Finance** course.

## Overview

Project setup using the **Intel C++ Compiler** (primary) and **VS Code**.  
Supports both full-project builds and isolated file builds with smart folder mirroring.

> **Note**: If you still need `g++`, see the section below on using GCC.  
> By default, we now use Intel oneAPI compilers (`icpx`).

---

## Requirements

### Intel oneAPI (Primary)

1. [Intel oneAPI Base Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html)

2. After installing, create a `.bat` file to correctly initialize the Intel + MSVC environment:

   ```bat
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
3. Save this file as:
   ```bash
   %USERPROFILE%\dev-tools\intel-vs2022-env.bat
   ```

4. (Optional) Add it to your system PATH so you can call it from anywhere:
  ```bash
  setx PATH "%PATH%;%USERPROFILE%\dev-tools"
  ```

5. Then, launch VS Code **from any terminal**:
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

If you prefer the old `g++` flow:

- [MSYS2](https://www.msys2.org) with:
  ```bash
  pacman -Syu
  pacman -S mingw-w64-x86_64-gcc make gdb zip
  ```

- VS Code with the **C/C++ Extension** from Microsoft

- Add the VS Code bin folder to the MSYS2 shell's PATH to use the `code` command through the MSYS2 **MINGW64** shell:
  ```bash
  echo 'export PATH="$PATH:/c/Users/(your-username)/AppData/Local/Programs/Microsoft VS Code/bin"' >> ~/.bashrc
  source ~/.bashrc
  ```

- Close and reopen the MSYS2 shell to apply the PATH changes.

- Launch a **MSYS2 MINGW64** shell, then open VS Code through the shell:
  ```bash
  cd (your-repo-folder)
  code .
  ```
- Switch your Makefile back to `Makefile_gcc` (archived version).

---


---

## Build & Run (Intel)

This project uses a **new `Makefile`** configured for the Intel compiler (`icpx`).

### 🔧 Full Project Build

> Builds all `.cpp` under `src/` into one executable.

- VS Code:
  - `Ctrl+Shift+B` → "C/C++: Build entire project (Intel)"
- Terminal:
  ```bash
  make         # defaults to MODE=debug
  ```
  or specify a mode:
  ```bash
  make MODE=fast
  ```

### ▶️ Run the Program

After building:
```bash
make run
```
Runs the final executable (e.g., `build/project.exe`).

Alternatively, run manually:
```bash
./build/project.exe
```
(on Windows, `build\project.exe`)

### 📄 Build a Single File (Standalone)

> Builds **one** file via `make active`.

- VS Code:
  - `Ctrl+Shift+B` → "C/C++: Build active file (Intel)"
- Terminal:
  ```bash
  make active SINGLE_SRC=src/assignment_a.cpp
  ```

Output appears in `build/assignment_a.exe`.

### 🏎️ VTune Profiling

A new target `vtune` runs **Intel VTune Profiler** for hotspots analysis:

```bash
make vtune
```
Generates profiling results in `./vtune_results`.

### Clean the Build

To remove compiled files and build artifacts:

```bash
make clean
```


## Build & Run (GCC)

This project can also be built using **GCC** with a legacy `Makefile_gcc`.
If you ever need to revert to `g++`:

1. Rename `Makefile` (Intel) to something else, e.g. `Makefile_intel`.
2. Rename your old `Makefile_gcc` back to `Makefile`.

You can build and run the project using either **VS Code tasks** or **the terminal**.

### 🔧 Full Project Build

> Builds all `.cpp` files under `src/` and links into one executable.

- VS Code:
  - `Ctrl+Shift+B` → "C/C++: Build entire project with Makefile"
- Terminal:
  ```bash
  make
  ```

### ▶️ Run the Program

After building `make all`, run:

```bash
make run
```

This will run the final executable (e.g., `build/main.exe`).

Or run manually in Linux:
```bash
./build/main.exe
```

or, if on Windows: 
```bash	
build\assignment_b.exe
```


### 📄 Build a Single File (Standalone Mode)

> Builds a single file using the `make active` target.

- VS Code:
  - `Ctrl+Shift+B` → "C/C++: Build active file with Makefile"

- Terminal:
  ```bash
  make active SINGLE_SRC=src/assignment_a.cpp
  ```

Output is placed in `build/<filename>.exe`



### Clean the Build

To remove compiled files and build artifacts:

- VS Code:
  - Run task: "Clean Build Directory"

- Terminal:
  ```bash
  make clean
  ```



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



## Submission Tip

Before compressing your project:

```bash
make clean
zip -r project_name.zip src Makefile README.md
```

or 
```bash
make clean
zip -r assignment_b-eduardoscheffer.zip src/assignment_b.cpp src/utilities.h
```

Make sure `build/` is **not** included in the zip.

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

> See image reference: Step 1 - Install the Remote Development Extension Pack


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
- Using SSH keys does not bypass Duo on Midway unless explicitly enabled by RCC
- Once connected, VS Code will install its server component and keep the session active


### Running Code on a Compute Node

Midway3 uses a job scheduling system, so you should not run compute-heavy code on the login node. To run your program interactively, you must request a compute node using the `sinteractive` command. For example, to request a node for 2 hour with 24 cores under the `finm32950` account:

```bash
sinteractive --time=0:30:0 --ntasks=24 --account=finm32950
```

This opens an interactive session on a compute node where you can compile and run your code as needed. It's recommended to request short sessions to increase your chances of getting a node quickly.

More details can be found in the Midway3 user guide:  
[https://rcc-uchicago.github.io/user-guide/](https://rcc-uchicago.github.io/user-guide/)



### Accessing Demo Code

#### Step 1: Copy and Extract the Demo Code

Weekly demo code is available at:
```
/project2/finm32950/chanaka/
```

For this example, we’ll use `L1Demo.tar`. To copy it to your home directory, run:

```bash
cp /project2/finm32950/chanaka/L4Demo.tar .
```

Then extract it:

```bash
tar -xvf L4Demo.tar
```

Check the contents:

```bash
ls -F
```

Navigate to the demo folder:

```bash
cd L1Demo/Profiling
ls
```

The main program file for this example is `bs1.cpp`.

### Building the Program

*(Same steps as before, using Intel compilers. The only difference is that you load the `module load intel/2022.0` on Midway to get `icpc/icc`.)*

```bash
module load intel/2022.0
```

#### Directly (Intel Compiler)
Then compile the program:

```bash
icc -std=c++17 -o (file_name) (file_name).cpp
```
If you are using multithreading:
```bash
icc -std=c++17 -o assignment_a assignment_a.cpp -lpthread
```

To check compiler options:
```bash
icc -help
```


#### Indirectly (Intel Compiler via Makefile)

To build the program using the Makefile, if there is only one main() function in the directory among all files, simply run the following on the directory containing the .cpp files:

```bash
make
```

Else, if there are many .cpp files, each with its own main() function, use `cd` to go to the directory where `./src` folder is located, copy the custom `Makefile` there, and then run:

```bash
make active SINGLE_SRC=src/assignmente.cpp
```
To run, after building the program, you can execute it by running:

```bash
build/(file_name).exe
```

### Step 4: Running the Program

For Makefile basics, refer to this tutorial:  
[https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/](https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/)

And for the full GNU Make documentation:  
[https://www.gnu.org/software/make/manual/make.html](https://www.gnu.org/software/make/manual/make.html)

---

## 🚀 Vectorization Support

This project supports both **manual** and **automatic vectorization reporting** to help you understand and optimize your performance-critical code.

### Manual Vectorization Builds (Terminal)

To compile with **AVX2 and FMA** vectorization manually:

```bash
g++ -O3 -march=native ./src/class_vectorization_1.cpp -o ./build/class_vectorization_auto.exe
```

### Check Auto-Vectorization Decisions (Inline Report)

Add `-fopt-info-vec-optimized` to see which loops were vectorized:

```bash
icx -O3 -xHost -qopt-report=5 ./src/class_vectorization_1.cpp -o ./build/class_vectorization_1.exe
```

### Save Vectorization Report to File

Redirect vectorization info into a log file for later review:

```bash
icx -O3 -xHost -qopt-report=5 -qopt-report-file=./build/vector_report.txt ./src/class_vectorization_1.cpp -o ./build/class_vectorization_1.exe
```
You can change the `optimized` parameter to one of the following:
- `all` - 	Everything: successes, failures, diagnostics
- ``(nothing) - Successes + failures
- `missed` - Only loops that failed to vectorize
- `optimized` - 	Only loops that succeeded in being vectorized


---

## 🛠️ Vectorization via Makefile (Recommended)

The Makefile automatically generates **vectorization reports** when using the following modes:

| Build Mode | Optimization Level | Vectorization Report |
|------------|--------------------|-----------------------|
| `dev`      | `-O1`              | `./build/project_vector_report.txt` |
| `release`  | `-O2`              | `./build/project_vector_report.txt` |
| `fast`     | `-O3 -march=native -mavx2 -mfma` | `./build/project_vector_report.txt` |

For **entire project builds**, you can build with:

```bash
make all MODE=fast
```

For **active file builds**, the report is generated per file:

```bash
make active SINGLE_SRC=src/assignment_b.cpp MODE=fast
```

Generates:
```
build/class_vectorization_1_vector_report.txt
```

This will generate the vectorization report for all files in the project.

You can also run this from the VS Code build task:  
**`Build Active File (fast)`**


---

## Further Resources

- [Intel oneAPI Docs](https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html)
- [VTune Profiler Guide](https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler.html)
- [GNU Make manual](https://www.gnu.org/software/make/manual/make.html)