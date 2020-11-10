# Requirements
Install the dependencies by typing the following in the julia package REPL

- add ZonalFlow (to use the [ZonalFlow](https://github.com/gvn22/ZonalFlow.jl) package)
- add Revise (for simultaneous package development)
- add Plots (for plotting figures)
- add PyPlot (plotting format)
- add JLD2 (for saving solution data)
- add YAML (for reading parameters)
- add FFTW (for Fourier transforms)
- add Logging
- add TerminalLogger (for logging solution progress in the terminal)

# Run
- Run the `solve.jl` script interactively in `Atom` using `Juno`.
- Or run on the terminal using `julia solve.jl`.

# Precompile
- Build using `./build.sh`, then copy the test.yml to input.yml and set your own parameters.
- Run using `./run.sh`
