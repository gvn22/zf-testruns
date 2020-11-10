#!/bin/bash
julia --startup-file=no --trace-compile=precompile.jl gen_precompile.jl
julia --startup-file=no --output-o sys.o -J"/Applications/Julia-1.5.app/Contents/Resources/julia/lib/julia/sys.dylib" gen_sysimage.jl
gcc -shared -o sys.dylib -Wl,-all_load sys.o -L"/Applications/Julia-1.5.app/Contents/Resources/julia/lib" -ljulia
