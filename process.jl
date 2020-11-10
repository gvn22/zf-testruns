using ZonalFlow
using Plots
using YAML,JLD2
using FFTW

include("loadparams.jl")
mkpath(dn);

@load dn*"nl.jld2" sol1
@load dn*"gql_$Λ.jld2" sol2
@load dn*"gce2_$Λ.jld2" sol3

pyplot();
zones = reshape(["$i" for i = 0:1:nx-1],1,nx);

P1,O1 = zonalenergy(lx,ly,nx,ny,sol1.u);
_p = plot(sol1.t,P1,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright,linewidth=2);
savefig(_p,dn*"NL_em.png");

P2,O2 = zonalenergy(lx,ly,nx,ny,sol2.u);
_p = plot(sol2.t,P2,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright,linewidth=2);
savefig(_p,dn*"GQL_"*"$Λ"*"_em.png");

P3,O3 = zonalenergy(lx,ly,nx,ny,Λ,sol3.u);
_p = plot(sol3.t,P3,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright,linewidth=2);
savefig(_p,dn*"GCE2_"*"$Λ"*"_em.png");

## Hövmoller data: mean vorticity
angles = (180.0/ly)*LinRange(-ly/2,ly/2,2*ny-1);

A1 = meanvorticity(lx,ly,nx,ny,sol1.u);
A2 = meanvorticity(lx,ly,nx,ny,sol2.u);
A3 = meanvorticity(lx,ly,nx,ny,Λ,sol3.u);

Ajet = real(ifft(ifftshift(ic_eqm(lx,ly,nx,ny,Ξ,jw=Δθ)[:,1])));
plot(angles,Ajet,xaxis="θ",yaxis="<ζ>",color=:black,label="Jet");
plot!(angles,A1[end,:],xaxis="θ",yaxis="<ζ>",linewidth=2,label="NL");
plot!(angles,A2[end,:],xaxis="θ",yaxis="<ζ>",linewidth=2,label="GQL($Λ)");
_zt = plot!(angles,A3[end,:],legend=:bottomright,xaxis="θ",yaxis="<ζ>",linewidth=2,label="GCE2($Λ)");
savefig(_zt,dn*"zt_"*"$Λ"*".png");

## Spatial vorticity
xx = LinRange(-lx/2,lx/2,2*nx-1);
yy = LinRange(-ly/2,ly/2,2*ny-1);

U1 = inversefourier(nx,ny,sol1.u);
_u = plot(xx,yy,U1[:,:,begin],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"NL_z_init.png");
_u = plot(xx,yy,U1[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"NL_z_end.png");

U2 = inversefourier(nx,ny,sol2.u);
_u = plot(xx,yy,U2[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"GQL_"*"$Λ"*"_z_end.png");

U3 = inversefourier(nx,ny,Λ,sol3.u);
_u = plot(xx,yy,U3[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
savefig(_u,dn*"GCE2_"*"$Λ"*"_z_end.png");
