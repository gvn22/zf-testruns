Base.init_depot_path()
Base.init_load_path()
# Base.reinit_stdio()

using ZonalFlow,DiffEqBase
using Plots
using YAML,JLD2
using FFTW
using TerminalLoggers

@eval Module() begin
    for (pkgid, mod) in Base.loaded_modules
        if !(pkgid.name in ("Main", "Core", "Base"))
            eval(@__MODULE__, :(const $(Symbol(mod)) = $mod))
        end
    end
    for statement in readlines("precompile.jl")
        try
            Base.include_string(@__MODULE__, statement)
        catch
            # See julia issue #28808
            @info "failed to compile statement: $statement"
        end
    end
end # module

empty!(LOAD_PATH)
empty!(DEPOT_PATH)
