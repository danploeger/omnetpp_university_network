%Todo
%conf interval for each vector of samples.
%funktionsaufruf ->sammeln der daten. Plot in matlab.


%calculate CI for each scenario (10,100,1000)
for i=1:3
[upperi,loweri]=confint(m,sample_vector_scenario_i);
end




%noch nicht angepasster plot
colordef black;
%semilogy(1:10,upper1,'r-',...
 %        1:step_JAC,resvec_JAC,'m-.',...
  %       1:step_GSV,resvec_GSV,'c-',...
   %      1:step_GSR,resvec_GSR,'b-.',...
   %      1:m,cond(full(A))*eps*ones(m,1),'w')