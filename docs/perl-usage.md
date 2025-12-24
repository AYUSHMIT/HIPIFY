# hipify-perl Usage

## Headers-only conversion

To convert only header-like files:

```bash
bin/hipconvertinplace-perl.sh --headers-only path/to/project
```

Header extensions considered: `.h`, `.hpp`, `.hh`, `.cuh`.

Default behavior processes both source and header files.
