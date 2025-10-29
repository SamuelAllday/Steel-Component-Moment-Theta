function [Ft_Rd, k10, RepStr] = Get_EC3_BOLT (fub, As, L_bolt, Preload, gamma_M2, gamma_M7, RepStr)

%if Preload=="No"
    Ft_Rd = 0.9 * fub * As / gamma_M2 * (10^-3); % [kN]
%else
%    Ft_Rd = 0.7 * fub * As / gamma_M7 * (10^-3); % [kN]    
%end
k10     = 1.6 * As / L_bolt;

% report string
RepStr{end+1}= ['- Bolt in Tension (BOLT):'];
RepStr{end+1}='---------------------------------------------------------------';
RepStr{end+1}= ['     As       = ', num2str(round(As)),' mm2,   bolt stress area'];
RepStr{end+1}= ['     fub      = ', num2str(fub),' MPa,   bolt ultimate strength'];
RepStr{end+1}= ['     L_bolt   = ', num2str(round(L_bolt)),' mm,     bolt length'];
if Preload=="No"
RepStr{end+1}= ['     gamma_M2 = ', num2str(gamma_M2)];
RepStr{end+1}= ['     Bolt is considered not preloaded'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> Ft_Rd = 0.9 * fub * As / gamma_M2'];
RepStr{end+1}= ['                            = ', num2str(round(Ft_Rd)), ' kN'];
else
RepStr{end+1}= ['     gamma_M7 = ', num2str(gamma_M7)];
RepStr{end+1}= ['     Bolt is considered preloaded'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> Ft_Rd = 0.7 * fub * As / gamma_M7'];
RepStr{end+1}= ['                            = ', num2str(round(Ft_Rd)), ' kN'];
end
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k10 = 1.6 * As / L_bolt'];
RepStr{end+1}= ['                          = ', num2str(round(k10*10)/10), ' mm'];
RepStr{end+1}= [''];
RepStr{end+1}='---------------------------------------------------------------';
