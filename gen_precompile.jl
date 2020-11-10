using ZonalFlow
using Plots
using Logging
using TerminalLoggers
global_logger(TerminalLogger())

lx = 4.0*Float64(pi);
ly = 2.0*Float64(pi);
nx = 3;
ny = 3;

Ω = 2.0*Float64(pi)
θ = 0.0
β = 2.0*Ω*cos(θ)
Ξ = 0.2*Ω
τ = 20.0/Ω
Δθ = 0.2
dt = 0.001
t_end = 200.0
savefreq = 5

Λ = 1

ζ0 = ic_pert_eqm(lx,ly,nx,ny,Ξ,jw=Δθ);

@time sol1 = nl(lx,ly,nx,ny,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,savefreq=savefreq);
@time sol2 = gql(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,dt=dt,ic=ζ0,t_end=t_end,savefreq=savefreq);
@time sol3 = gce2(lx,ly,nx,ny,Λ,Ξ,β,τ,jw=Δθ,ic=ζ0,dt=dt,t_end=t_end,poscheck=false,savefreq=savefreq);

zones = reshape(["$i" for i = 0:1:nx-1],1,nx);

P1,O1 = zonalenergy(lx,ly,nx,ny,sol1.u);

A1 = meanvorticity(lx,ly,nx,ny,sol1.u)
A3 = meanvorticity(lx,ly,nx,ny,Λ,sol3.u)
U1 = inversefourier(nx,ny,sol1.u)
U3 = inversefourier(nx,ny,Λ,sol3.u)

plot(sol1.t,P1,xaxis=("Time"),yscale=:log10,yaxis=("Energy in Zonal Mode",(1e-9,1e3)),labels=zones,palette=:tab10,legend=:outerright,linewidth=2);

xx = LinRange(-lx/2,lx/2,2*nx-1);
yy = LinRange(-ly/2,ly/2,2*ny-1);
plot(xx,yy,U1[:,:,end],st=:contourf,color=:bwr,xaxis="x",yaxis="y");
