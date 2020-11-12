#!/bin/bash
# File to generate precompile statements for
julia --startup-file=no --trace-compile=precompile.jl gen_precompile.jl

# Output of unsafe_string(Base.JLOptions().image_file) in julia
jpath="/Applications/Julia-1.5.app/Contents/Resources/julia/lib/julia/sys.dylib"
julia --startup-file=no -O3 --output-o sys.o -J$jpath gen_sysimage.jl

# Output of abspath(Sys.BINDIR, Base.LIBDIR) in julia
lpath="/Applications/Julia-1.5.app/Contents/Resources/julia/lib"
gcc -shared -o sys.dylib -Wl,-all_load sys.o -L$lpath -ljulia
