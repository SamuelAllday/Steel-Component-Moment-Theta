function [beta] = Get_EC3_beta(Joint, Setup)

% EC3 1-8, Cl. 5.3(7) - Table 5.4 (Beta dependant on joint configuration and balanced moment application; basically, Beta = V_column / F_beam)

if Joint=="Cantilever"
    beta = 1;
elseif Joint=="Cruciform" && contains(Setup,"Asym")
    beta = 2;
else
    beta = 0;
end