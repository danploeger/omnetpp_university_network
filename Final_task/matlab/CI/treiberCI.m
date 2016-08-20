%Berechnet fuer alle Means von 10 runs das Confidence interval
%Das Confidence level wird über den zWert aus der Student-T Distribution angegeben

%Die funktion confint benötigt die mean-werte der einzelnen runs als zeilenvektor 1x[Anzahl Samples] 
%und  die Anzahl der User für die Ausgabe. 
%Ausgabe: Größe des Confidence Intervals mit Confidence Level 90% und 99.9%
%Das Confidence Interval dient dazu zu bewerten, mit welcher Wahrscheinlichkeit der tatsächliche
%Populationsparameter ( hier Mittelwert der Samples) im berechneten Confidence Interval liegt, wenn das Experiment 
%wiederholt wird. 
%Man kann also eine Aussage darüber treffen, wo beispielsweise die Packetverlustrate in Zukunft im Mittel liegen wird. 
%Input: confint2(x,user)
%   x: zeilenvektor means der einzelnen runs
%user: Useranzahl fuer die Ausgabe    

[lower1,upper1] = confint2(X35oncsv_2,35)

semilogx([1 1], [lower1 upper1], 'r')
legend('x')
title('Confidence Interval for 10 runs ,Estimated Parameter is:')
ylabel('Lower/Upper Bound')