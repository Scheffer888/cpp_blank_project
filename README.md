# Intro to High-Performance Computing in Finance

Repository for the **Intro to High-Performance Computing in Finance** course.

## Overview

Project setup using **g++**, **Makefile**, and **VS Code**.  
Supports both full-project builds and isolated file builds with smart folder mirroring.

---

## Requirements

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

- Open VS Code through the MSYS2 **MINGW64** shell:
  ```bash
  cd (your-repo-folder)
  code .
  ```

---

## Build & Run Local

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

Midway3 uses a job scheduling system, so you should not run compute-heavy code on the login node. To run your program interactively, you must request a compute node using the `sinteractive` command. For example, to request a node for 1 hour under the `finm32950` account:

```bash
sinteractive --time=1:0:0 --account=finm32950
```

This opens an interactive session on a compute node where you can compile and run your code as needed. It's recommended to request short sessions to increase your chances of getting a node quickly.

More details can be found in the Midway3 user guide:  
[https://rcc-uchicago.github.io/user-guide/](https://rcc-uchicago.github.io/user-guide/)



### Accessing and Building the Demo Code

#### Step 1: Copy and Extract the Demo Code

Weekly demo code is available at:
```
/project2/finm32950/chanaka/
```

For this example, we’ll use `L1Demo.tar`. To copy it to your home directory, run:

```bash
cp /project2/finm32950/chanaka/L1Demo.tar .
```

Then extract it:

```bash
tar -xvf L1Demo.tar
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


#### Step 2: Load Required Software (Intel Compiler)

This demo uses the Intel C++ compiler (`icc`). Before compiling, load the appropriate module:

```bash
module load intel/2022.0
```

Then compile the program:

```bash
icc -std=c++11 -o bs1 bs1.cpp
```

To check compiler options:

```bash
icc -help
```


#### Step 3: Alternative Build Using Makefile

A `Makefile` is also provided in the `L1Demo/Profiling/` directory. Makefiles are useful for organizing builds with multiple files or flags.

To build the program using the Makefile, if there is only one main() function in the directory among all files, simply run the following on the directory containing the .cpp files:

```bash
make
```

Else, if there are many .cpp files, each with its own main() function, use `cd` to go to the directory where `./src` folder is located, copy the custom `Makefile` there, and then run:

```bash
make active SINGLE_SRC=src/(filename).cpp
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
g++ -O3 -mavx2 -mfma ./src/class_vectorization_1.cpp -o ./build/class_vectorization_auto.exe
```

### Check Auto-Vectorization Decisions (Inline Report)

Add `-fopt-info-vec-optimized` to see which loops were vectorized:

```bash
g++ -O3 -mavx2 -mfma -fopt-info-vec-optimized ./src/class_vectorization_1.cpp -o ./build/class_vectorization_1.exe
```

### Save Vectorization Report to File

Redirect vectorization info into a log file for later review:

```bash
g++ -O3 -mavx2 -mfma -fopt-info-vec-optimized=./build/vector_report.txt ./src/class_vectorization_1.cpp -o ./build/class_vectorization_1.exe
```

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
make active SINGLE_SRC=src/class_vectorization_1.cpp MODE=fast
```

Generates:
```
build/class_vectorization_1_vector_report.txt
```

This will generate the vectorization report for all files in the project.

You can also run this from the VS Code build task:  
**`Build Active File (fast)`**
