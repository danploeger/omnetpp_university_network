function [ci_lower,ci_higher] = confint2(mean,user)
%Function to calculate the Confidence Interval for Avg. Throughput

%Get samplesize
m=columns(mean);
%Calculate the sample mean estimate y_m (mean  of all means)
y_m=0;
for i=1:m
y_m=y_m+mean(i);
end

y_m=y_m/m;

%Computing Sample Variance S^2 used to estimate the population
%parameter: avg.throughput.
s_2=0;
for i=1:m
s_2=s_2 + (mean(i)-y_m)^2;
end
s_2=s_2*(1/(m-1)); % m-1 weil Student-T dist.  -> wir nehmen 10 samples fuer 90% (1-alpha)

%Confidence Interval(CI) 

zValue=1.833;    % mit 90%iger sicherheit liegt der echte paameter in zukunft im CI
ci_lower =y_m-zValue *sqrt(s_2)/sqrt(m);
ci_higher=y_m + zValue *sqrt(s_2)/sqrt(m);


zValue=4.781;    % mit 99.9%iger sicherheit liegt der echte parameter in zukunft im CI
ci2_lower =y_m-zValue *sqrt(s_2)/sqrt(m);
ci2_higher=y_m + zValue *sqrt(s_2)/sqrt(m);
x=ci2_higher -ci2_lower
printf("CI fuer 10 runs ,%d user und 99.9  confidence level : %d \n",user,(ci2_higher - ci2_lower))
printf("CI fuer 10 runs ,%d user und 90 confidence level : %d \n",user,ci_higher -ci_lower)

end