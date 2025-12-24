# HIPIFY Packaging Version

HIPIFY packages derive their version from `ROCM_VERSION` instead of LLVM.

## Usage

```bash
cmake -B build -S . -DROCM_VERSION=8.0.0
cmake --build build
(cd build && cpack -G TGZ)
```

This produces an artifact named like:

```
hipify-8.0.0-linux-x86_64.tar.gz
```

If `ROCM_VERSION` is not set, HIPIFY falls back to `PROJECT_VERSION` (or `0.0.0` with a warning).
