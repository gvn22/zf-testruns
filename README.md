# Requirements
Install the dependencies by typing the following in the julia package REPL

- add ZonalFlow (to use the [ZonalFlow](https://github.com/gvn22/ZonalFlow.jl) package)
- add Plots (for plotting figures)
- add PyPlot (plotting format)
- add JLD2 (for saving solution data)
- add FFTW (for Fourier transforms)
- add Logging
- add TerminalLogger (for logging solution progress in the terminal)

# Run
- Run the script interactively in `Atom` using `Juno`.
- Or run on the terminal using `julia solve.jl`.

# Precompile system image
In principle, you can create back the required functions into a system image and load `julia` using that system image. This is being worked at the moment.
