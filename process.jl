using Revise
using ZonalFlow
using Plots: plot,plot!,savefig,pyplot,plot_color,get_color_palette
using YAML,JLD2
using FFTW

include("loadparams.jl")
pyplot();
zones = reshape(["$i" for i = 0:1:nx-1],1,nx);

@load dn*"nl.jld2" sol_nl
@load dn*"ql.jld2" sol_ql

P,O = zonalenergy(lx,ly,nx,ny,sol_nl.u);
_p = plot(sol_nl.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"NL_em.png");

P,O = zonalenergy(lx,ly,nx,ny,sol_ql.u);
_p = plot(sol_ql.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"QL_em.png");

@load dn*"gql_$Λ.jld2" sol_gql
@load dn*"gce2_$Λ.jld2" sol_gce2 info_gce2

P,O = zonalenergy(lx,ly,nx,ny,sol_gql.u);
_p = plot(sol_gql.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"GQL_"*"$Λ"*"_em.png");

P,O = zonalenergy(lx,ly,nx,ny,Λ,sol_gce2.u);
_p = plot(sol_gce2.t,P,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright)
savefig(_p,dn*"GCE2_"*"$Λ"*"_em.png");

## Hövmoller data: mean vorticity
angles = (180.0/ly)*LinRange(-ly/2,ly/2,2*ny-1);
Ajet = real(ifft(ifftshift(ic_eqm(lx,ly,nx,ny,Ξ,jw=Δθ)[:,1])));

A_nl = meanvorticity(lx,ly,nx,ny,sol_nl.t,sol_nl.u);
A_ql = meanvorticity(lx,ly,nx,ny,sol_ql.t,sol_ql.u);
A_gql = meanvorticity(lx,ly,nx,ny,sol_gql.t,sol_gql.u);
A_gce2 = meanvorticity(lx,ly,nx,ny,sol_gce2.t,sol_gce2.u);

colours = get_color_palette(:auto, plot_color(:white));
# plot(angles,Ajet,xaxis="θ",yaxis="<ζ>",color=:black,label="Jet");
_zt = plot(angles,A_nl[end,:],xaxis="θ",yaxis="<ζ>",color=:black,label="NL");
_zt = plot!(_zt,angles,A_ql[end,:],xaxis="θ",yaxis="<ζ>",color=:black,line=:dash,label="QL/CE2");
_zt = plot!(_zt,angles,A_gql[end,:],legend=:bottomright,xaxis="θ",yaxis="<ζ>",color=colours[1],label="GQL($Λ)")
_zt = plot!(_zt,angles,A_gce2[40,:],legend=:bottomright,xaxis="θ",yaxis="<ζ>",color=colours[2],label="GCE2($Λ)")
savefig(_zt,dn*"zt_$Λ"*"_tavg.png");

## Spatial vorticity
xx = LinRange(-lx/2,lx/2,2*nx-1);
yy = LinRange(-ly/2,ly/2,2*ny-1);

U = inversefourier(nx,ny,sol_nl.u);
_u = plot(xx,yy,U[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"NL_z_end.png");

U = inversefourier(nx,ny,sol_ql.u);
_u = plot(xx,yy,U[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"QL_z_end.png");

U = inversefourier(nx,ny,sol_gql.u);
_u = plot(xx,yy,U[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"GQL_"*"$Λ"*"_z_end.png");

U = inversefourier(nx,ny,Λ,sol_gce2.u);
_u = plot(xx,yy,U[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"GCE2_"*"$Λ"*"_z_end.png");
