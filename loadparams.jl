params = YAML.load_file("input.yml"; dicttype=Dict{Symbol,Any})

lx = 4.0*Float64(pi);
ly = 2.0*Float64(pi);
nx = params[:nx];
ny = params[:ny];

Λ = params[:Λ];

Ω = 2.0*Float64(pi);
θ = params[:θ];
β = 2.0*Ω*cos(θ);
Ξ = params[:Ξ]*Ω;
τ = params[:τ]/Ω;
Δθ = params[:Δθ];

dt = params[:dt];
t_end = params[:t_end];
savefreq = params[:savefreq];
poscheckfreq = params[:poscheckfreq];
saveinfofreq = params[:saveinfofreq];

dn = params[:dn];
