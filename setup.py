# setup.py

import os
from setuptools import Extension, setup
from Cython.Build import cythonize
import numpy as np

# --------------- Paths ---------------
SRC_DIR = "src"
BUILD_DIR = "build"
os.makedirs(BUILD_DIR, exist_ok=True)

# These paths assume oneAPI is installed in C:/Program Files (x86)/Intel/oneAPI
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

extensions = [
    Extension(
        name="julia_calc",
        sources=[os.path.join(SRC_DIR, "julia_calc.pyx")],
        include_dirs=[np.get_include()],
        language="c++",  # important to ensure we compile as C++ in MSVC
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
    )
]

setup(
    name="JuliaCalc (MSVC build)",
    ext_modules=cythonize(
        extensions,
        build_dir=BUILD_DIR,       # Where .c/.cpp intermediates go
        compiler_directives={
            "language_level": "3", # Python 3
        },
    )
)
