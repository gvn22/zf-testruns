using Revise
using ZonalFlow
using YAML,JLD2
using Plots: plot,plot!,savefig,pyplot

using Logging: global_logger
using TerminalLoggers: TerminalLogger
global_logger(TerminalLogger())

include("loadparams.jl")
mkpath(dn);

ζ0 = ic_pert_eqm(lx,ly,nx,ny,Ξ,jw=Δθ); # one ic for all

@time sol_gce2,info_gce2 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,icnl=true,ic=ζ0,dt=0.001,t_end=t_end,saveinfo=true,saveinfofreq=20,poscheck=false,poscheckfreq=5,savefreq=savefreq);
@save dn*"gce2_$Λ"*"_nlinit.jld2" sol_gce2 info_gce2

@time sol_gce2,info_gce2 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,icnl=false,ic=ζ0,dt=dt,t_end=t_end,saveinfo=true,saveinfofreq=20,poscheck=false,poscheckfreq=10,savefreq=savefreq);
@save dn*"gce2_$Λ"*"_unity.jld2" sol_gce2 info_gce2

pyplot();
zones = reshape(["$i" for i = 0:1:nx-1],1,nx);
P,O = zonalenergy(lx,ly,nx,ny,Λ,sol_gce2.u);
_p = plot(sol_gce2.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",),labels=zones,palette=:tab10,legend=:outerright)

@load dn*"gce2_$Λ"*"_nlinit.jld2" sol_gce2 info_gce2
ranks_nlinit = [x[1] for x in info_gce2.saveval]
_p = plot(info_gce2.t,ranks_nlinit,ylabel="Rank",xlabel="t",label="NL init")

@load dn*"gce2_$Λ"*"_unity.jld2" sol_gce2 info_gce2
plot!(info_gce2.t,ranks_unity,yaxis=("Rank"),xaxis=("t"),label="Unit matrix")
savefig(_p,dn*"GCE2_$Λ"*"_rank.png");

@load dn*"gce2_$Λ"*"_nlinit.jld2" sol_gce2 info_gce2
eigvals_nlinit = [x[2] for x in info_gce2.saveval]
_q = plot(info_gce2.t,map(x->x[end],eigvals_nlinit),color=:blue,label="λ0: NL init")
_q = plot!(info_gce2.t,map(x->x[114],eigvals_nlinit),color=:red,yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ1: NL init")
_q = plot!(info_gce2.t,map(x->x[113],eigvals_nlinit),color=:green,yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ2: NL init")

@load dn*"gce2_$Λ"*"_unity.jld2" sol_gce2 info_gce2
eigvals_unity = [x[2] for x in info_gce2.saveval]
_q = plot!(info_gce2.t,map(x->x[end],eigvals_unity),color=:blue,line=:dash,label="λ0: Unity init")
_q = plot!(info_gce2.t,map(x->x[114],eigvals_unity),color=:red,line=:dash,yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ1: Unity init")
_q = plot!(info_gce2.t,map(x->x[113],eigvals_nlinit),color=:green,yscale=:log10,yaxis=("Eigenvalues",(1e-9,1e3)),xlabel="t",label="λ2: Unity init")
savefig(_q,dn*"GCE2_$Λ"*"_eigvals.png");

angles = (180.0/ly)*LinRange(-ly/2,ly/2,2*ny-1);
A0 = meanvorticity(lx,ly,nx,ny,sol_gql.t,sol_gql.u)
A1 = meanvorticity(lx,ly,nx,ny,sol_gce2.t,sol_gce2.u)

plot(angles,A0[end,:],xaxis="θ",yaxis="<ζ>",label="Time-averaged GQL(1)")
plot!(angles,A1[end,:],xaxis="θ",yaxis="<ζ>",label="Time-averaged GCE2(1)")
