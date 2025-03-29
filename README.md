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
  pacman -S mingw-w64-x86_64-gcc make gdb
  ```

- VS Code with the **C/C++ Extension** from Microsoft

- Open VS Code through the MSYS2 **MINGW64** shell:
  ```bash
  cd (your-repo-folder)
  code .
  ```

---

## Build & Run

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

After building, run:

```bash
make run
```

This will run the final executable (e.g., `build/main.exe`).

Or run manually:

```bash
./build/main.exe
```

---

### 📄 Build a Single File (Standalone Mode)

> Builds a single file using the `make active` target.

- VS Code:
  - `Ctrl+Shift+B` → "C/C++: Build active file with Makefile"

- Terminal:
  ```bash
  make active SINGLE_SRC=src/assignment_a.cpp
  ```

Output is placed in `build/<filename>.exe`

---

## 🧹 Clean the Build

To remove compiled files and build artifacts:

- VS Code:
  - Run task: "Clean Build Directory"

- Terminal:
  ```bash
  make clean
  ```

---

## Code Conventions

| Element       | Style                  |
|---------------|------------------------|
| **Class**     | `MyClass` (PascalCase) |
| **Enum**      | `ENUM_VALUE` (ALL_CAPS)|
| **Function**  | `do_something()`       |
| **Variable**  | `some_variable`        |
| **Struct**    | `MyStruct`             |
| **Typedef**   | `Alias_t`              |

---

## Notes

- Object files, executables, and dependency files are placed in `build/`
- Header dependencies are automatically tracked via `.d` files (`-MMD -MP`)
- The `make active` target mirrors your `src/` folder structure for clean builds
- `make run` is a shortcut to run the default executable after building

---

## Submission Tip

Before compressing your project:

```bash
make clean
zip -r project_name.zip src Makefile README.md
```

Make sure `build/` is **not** included in the zip.

---
