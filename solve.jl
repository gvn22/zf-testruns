using Revise
using ZonalFlow
using YAML,JLD2

using Logging: global_logger
using TerminalLoggers: TerminalLogger
global_logger(TerminalLogger())

include("loadparams.jl")
mkpath(dn);

ζ0 = ic_pert_eqm(lx,ly,nx,ny,Ξ,jw=Δθ); # one ic for all

@time sol_nl = nl(lx,ly,nx,ny,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,savefreq=savefreq);
@save dn*"nl.jld2" sol_nl

@time sol_ql = gql(lx,ly,nx,ny,0,Ξ,β,τ,jw=Δθ,dt=dt,ic=ζ0,t_end=t_end,savefreq=savefreq);
@save dn*"ql.jld2" sol_ql

@time sol_ce2,info_ce2 = ce2(lx,ly,nx,ny,Ξ,β,τ,jw=Δθ,dt=dt,icnl=true,saveinfo=true,ic=ζ0,t_end=t_end,savefreq=savefreq);
@save dn*"ce2.jld2" sol_ce2 info_ce2

for Λ in [1,2,3]
    @time sol_gql,info_gql = gql(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,dt=dt,ic=ζ0,t_end=t_end,saveinfo=true,saveinfofreq=saveinfofreq,savefreq=savefreq);
    @save dn*"gql_$Λ.jld2" sol_gql info_gql

    if Λ < 4 && Λ > 0
        @time sol_gce2,info_gce2 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,poscheck=true,poscheckfreq=poscheckfreq,saveinfo=true,saveinfofreq=saveinfofreq,savefreq=savefreq);
    else
        @time sol_gce2,info_gce2 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,poscheck=false,saveinfo=true,saveinfofreq=saveinfofreq,savefreq=savefreq);
    end
    @save dn*"gce2_$Λ.jld2" sol_gce2 info_gce2
end
