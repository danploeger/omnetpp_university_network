
%Format Data Vector, we want only the second column of data
[Z,S]=size(Poisson);
P=Poisson(1:Z,2);
%Create distribution from data
p_est=fitdist(P,'Poisson',0.05);
