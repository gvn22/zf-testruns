using Revise
using ZonalFlow
using YAML,JLD2

using Logging: global_logger
using TerminalLoggers: TerminalLogger
global_logger(TerminalLogger())

include("loadparams.jl")
mkpath(dn);

ζ0 = ic_pert_eqm(lx,ly,nx,ny,Ξ,jw=Δθ); # one ic for all

@time sol_gce2 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,poscheck=true,poscheckfreq=10.0,savefreq=savefreq);
@save dn*"gce2_$Λ.jld2" sol_gce2
