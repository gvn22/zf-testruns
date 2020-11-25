using Revise
using ZonalFlow
using Plots: plot,plot!,savefig,pyplot,plot_color,get_color_palette
using YAML,JLD2
using FFTW,LinearAlgebra

include("loadparams.jl")
mkpath(dn)
pyplot();

zones = reshape(["$i" for i = 0:1:nx-1],1,nx);

ζ0 = ic_pert_eqm(lx,ly,nx,ny,Ξ,jw=Δθ); # one ic for all

@time sol_ql = gql(lx,ly,nx,ny,0,Ξ,β,τ,jw=Δθ,dt=dt,ic=ζ0,t_end=t_end,savefreq=savefreq);
@time sol_ce2_pc,info_ce2_pc = ce2(lx,ly,nx,ny,Ξ,β,τ,jw=Δθ,dt=dt,icnl=true,saveinfo=true,saveinfofreq=saveinfofreq,ic=ζ0,t_end=t_end,savefreq=savefreq);
@time sol_ce2_um,info_ce2_um = ce2(lx,ly,nx,ny,Ξ,β,τ,jw=Δθ,dt=dt,icnl=false,saveinfo=true,saveinfofreq=saveinfofreq,ic=ζ0,t_end=t_end,savefreq=savefreq);

P,O = zonalenergy(lx,ly,nx,ny,sol_ql.u);
_p = plot(sol_ql.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"QL_em.png");

P,O = zonalenergy(lx,ly,nx,ny,sol_ce2_pc.u);
_p = plot(sol_ce2_pc.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"CE2_em.png");

ranks_pc = [x[1] for x in info_ce2_pc.saveval]
ranks_um = [x[1] for x in info_ce2_um.saveval]

_p = plot(info_ce2_pc.t,ranks_pc,ylabel="Rank",xlabel="t",label="Product IC")
_p = plot!(info_ce2_um.t,ranks_um,ylabel="Rank",xlabel="t",label="Unity IC")
savefig(_p,dn*"CE2_ranks_tau2.png");

evals_pc = [x[2] for x in info_ce2_pc.saveval]
evals_um = [x[2] for x in info_ce2_um.saveval]
_q = plot(info_ce2_pc.t,map(x->x[end],eigvals_nlinit),label="λ0: NL init")
_q = plot!(info_ce2_pc.t,map(x->x[206],eigvals_nlinit),yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ1: NL init")
_q = plot!(info_ce2_pc.t,map(x->x[205],eigvals_nlinit),yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ2: NL init")
_q = plot!(info_ce2_pc.t,map(x->x[204],eigvals_nlinit),yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ3: NL init")
