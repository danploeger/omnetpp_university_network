function [s_2,zValue,ci_lower,ci_higher,y_m] = confint(m,samplevec)
%Function to calculate the Confidence Interval for Avg. Throughput

%Calculate the sample mean estimate y_m
y_m=0;
for i=1:m
y_m=y_m+samplevec(i);
end

y_m=y_m/m;

%Computing Sample Variance S^2 used to estimate the population
%parameter: avg.throughput.
s_2=0;
for i=1:m
s_2=s_2 + (samplevec(i)-y_m)^2;
end
s_2=s_2*(1/(m-1)); %Why (m-1) ? 


%Confidence Interval(CI) 

zValue=1.96; 
ci_lower =y_m-zValue *sqrt(s_2)/sqrt(m);
ci_higher=y_m + zValue *sqrt(s_2)/sqrt(m);

end