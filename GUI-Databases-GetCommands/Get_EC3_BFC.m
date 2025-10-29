function [Fc_BFC, k7, RepStr] = Get_EC3_BFC (Mc_Rd, hb, tbf, RepStr)

%% EC3 1-8, Cl. 6.2.6.7 and 6.3.2 

Fc_BFC = Mc_Rd  * (10^-3) / (hb-tbf);  % [kN]
k7 = Inf;

% report string
RepStr{end+1}= ['- Beam Flange in Compression (BFC):'];
RepStr{end+1}='---------------------------------------------------------------';
RepStr{end+1}= ['                  --> Fc_BFC = Mc_Rd / (hb-tbf)'];
RepStr{end+1}= ['                             = ', num2str(round(Fc_BFC)), ' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k7  = Inf'];
RepStr{end+1}= [''];
RepStr{end+1}='---------------------------------------------------------------';
RepStr{end+1}= [''];