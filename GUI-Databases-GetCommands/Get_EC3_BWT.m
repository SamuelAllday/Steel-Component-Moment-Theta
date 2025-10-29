function [Ft_wb_Rd, k8, RepStr] = Get_EC3_BWT (tbw, fyB, beff_t_wb, gamma_M0, RepStr)

%% EC3 1-8, Cl. 6.2.6.8

Ft_wb_Rd= tbw* fyB* beff_t_wb * (10^-3)/ gamma_M0;
k8 = Inf;

% report string
% RepStr{end+1}= ['- Beam Web in Tension (BWT):'];
% RepStr{end+1}= ['-------------------------------------'];
% RepStr{end+1}= ['     beff_t_wb = ', num2str(round(beff_t_wb)),' mm'];
% RepStr{end+1}= ['']; 
% RepStr{end+1}= ['     fyB       = ', num2str(round(fyB)),' MPa'];
% RepStr{end+1}= ['']; 
% RepStr{end+1}= ['                  --> Ft_wb_Rd = tbw* fyB* beff_t_wb / gamma_M0'];
% RepStr{end+1}= ['                               = ', num2str(round(Ft_wb_Rd)), ' kN'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> k8  = Inf'];
% RepStr{end+1}='---------------------------------------------------------------';
% RepStr{end+1}='---------------------------------------------------------------';
% RepStr{end+1}= [''];