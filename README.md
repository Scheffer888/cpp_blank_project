# C++ Training Template

A minimal and flexible C++ project setup using **g++**, **Makefile**, and **VS Code**.  
Supports both full-project builds and isolated file builds with smart folder mirroring.

---

## Requirements

- [MSYS2](https://www.msys2.org) with:
  ```bash
  pacman -Syu
  pacman -S mingw-w64-x86_64-gcc make gdb
  ```
- VS Code with the **C/C++ Extension** from Microsoft

- Make sure to open VS code through mysys mingw64 shell:
  ``` bash
  cd (your repo)
  code .
  ```

---

## Build & Run (VS Code Tasks)

Press `Ctrl+Shift+B` or run **"Run Build Task…"** from the Command Palette and choose:

### Full Project Build
- **C/C++: Build entire project with Makefile**  
  → Uses the Makefile to build all `src/*.cpp` into `build/*.exe`

### Build a Single File (Standalone)
- **C/C++: Build active file with Makefile**  
  → Builds only the currently open `.cpp` file  
  → Output: `build/<subfolder>/<file>.exe` (mirrors source path)

---

## Run the Program

After building, you can:
```bash
cd build
./main.exe         # or any other .exe you built
```

Or debug using VS Code's **Run > Start Debugging (F5)** and select:

- `C/C++: Makefile build and debug entire project`
- `C/C++: Makefile build and debug active file`

---

## Clean the Build

From VS Code:
- Run the task: **Clean Build Directory**

Or manually from terminal:
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

- Object files and binaries are placed in the `build/` directory.
- The folder structure of `src/` is mirrored under `build/` for standalone builds.
- Header dependencies are automatically tracked via `.d` files (thanks to `-MMD -MP`).

---
