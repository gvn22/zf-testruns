#!/bin/bash
if [ -f $1 ]; then
  julia -Jsys.dylib $1
else
  julia -Jsys.dylib solve.jl
fi
