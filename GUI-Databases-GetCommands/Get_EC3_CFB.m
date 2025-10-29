function [Ft_CFB, Ft_cf_Rd, k4, Mode_CFB, RepStr] = Get_EC3_CFB (Joint, Axis, tf, tbp, fy, m, n, n1, n2, nBoltperRow, nBolts, Ft_Rd, leff1, leff2, gamma_M0, As, Lgrip, dwasher, Prying, RepStr)

alternative=1;
ew=(dwasher)/4;
if Prying~="default"; Lgrip=0; end

%% EC3 1-8, Cl. 6.2.6.4 and 6.3.2

Lb_limit = 8.8*m^3*As/leff1/tf^3;

if Joint ~= "Splice" &&  Axis=="Major"
    Mpl_1_Rd = leff1 * (0.25*tf^2*fy/gamma_M0) *(10^-3); % [kN.mm]
    Mpl_2_Rd = leff2 * (0.25*tf^2*fy/gamma_M0) *(10^-3); % [kN.mm]
    Mbp_Rd   = leff1 * (0.25*tbp^2*fy/gamma_M0) *(10^-3); % [kN.mm]
    
    if Lgrip <= Lb_limit % (i.e., with prying force)
        Ft_cf_Rd(1) =  4*Mpl_1_Rd/m  + 2*Mbp_Rd/m;           % Mode 1: Total yielding of the flange, see EC3-1-8 Table 6.2
        if alternative==1; Ft_cf_Rd(1) =  (8*n-2*ew)*Mpl_1_Rd/(2*m*n - ew * (m+n));    end       % Mode 1: alternative method, see EC3-1-8 Table 6.2
        Ft_cf_Rd(2) = (2*Mpl_2_Rd + nBolts*Ft_Rd*n)/(m+n);   % Mode 2: Bolt failure with yielding of the flange, see EC3-1-8 Table 6.2
    else
        Ft_cf_Rd(1) =  2*Mpl_1_Rd/m;                         % Mode 1: Total yielding of the flange, see EC3-1-8 Table 6.2
        Ft_cf_Rd(2) =  2*Mpl_1_Rd/m;                         % Mode 2: Bolt failure with yielding of the flange, see EC3-1-8 Table 6.2
    end
    Ft_cf_Rd(3) =                     nBolts*Ft_Rd;          % Mode 3: Bolt failure, see EC3-1-8 Table 6.2
    
    % Demonceau et al (2010)
    if nBoltperRow==4
        Ft_cf_Rd_p  = (2*Mpl_1_Rd + nBolts*Ft_Rd/2*(n1^2+2*n2^2+2*n1*n2)/n)/(m+n);
        Ft_cf_Rd_np = (2*Mpl_1_Rd + nBolts*Ft_Rd/2*n1)/(m+n1);                         
        Ft_cf_Rd(2) = min([Ft_cf_Rd_p Ft_cf_Rd_np]);
    end
    
    [Ft_CFB, Mode_CFB]  = min(Ft_cf_Rd);
    k4      = 0.9 * min([leff1 leff2]) * tf^3 / m^3;
else
    Ft_cf_Rd(1:3)=NaN;
    Ft_CFB = Inf;
    k4     = Inf;
    Mode_CFB=NaN;
end

% report string
% RepStr{end+1}= ['- Column Flange in Bending (CFB):'];
% RepStr{end+1}= ['-------------------------------------'];
% if Joint ~= "Splice"
% RepStr{end+1}= ['    Mpl_fc_Rd1 = leff1 * (0.25*tcf^2*fyC/gamma_M0)'];
% RepStr{end+1}= ['               = ', num2str(round(Mpl_fc_Rd1)),' kN.mm'];
% RepStr{end+1}= ['    Mpl_fc_Rd2 = leff2 * (0.25*tcf^2*fyC/gamma_M0)'];
% RepStr{end+1}= ['               = ', num2str(round(Mpl_fc_Rd2)),' kN.mm'];
% if tbp~=0
% RepStr{end+1}= ['    Mbp_Rd     = leff1 * (0.25*tbp^2*fyC/gamma_M0)'];
% RepStr{end+1}= ['               = ', num2str(round(Mbp_Rd)),' kN.mm'];    
% end
% RepStr{end+1}= [''];
% RepStr{end+1}= [' Mode 1: Total yielding of the flange'];
% if tbp~=0
% RepStr{end+1}= ['    Ft_cf_Rd1 = (4*Mpl_fc_Rd1 + 2*Mbp_Rd)/ m'];
% RepStr{end+1}= ['              = ', num2str(round(Ft_cf_Rd(1))),' kN'];
% else
% RepStr{end+1}= ['    Ft_cf_Rd1 = 4*Mpl_fc_Rd1 / m'];
% RepStr{end+1}= ['              = ', num2str(round(Ft_cf_Rd(1))),' kN'];    
% end
% RepStr{end+1}= [''];
% RepStr{end+1}= [' Mode 2: Bolt failure with yielding of the flange'];
% RepStr{end+1}= ['    Ft_cf_Rd2 = (2*Mpl_fc_Rd2 + nBolts*Ft_Rd*n) / (m+n)'];
% RepStr{end+1}= ['              = ', num2str(round(Ft_cf_Rd(2))),' kN'];
% RepStr{end+1}= [''];
% RepStr{end+1}= [' Mode 3: Bolt failure'];
% RepStr{end+1}= ['    Ft_cf_Rd3 = nBoltperRow*Ft_Rd'];
% RepStr{end+1}= ['              = ', num2str(round(Ft_cf_Rd(3))),' kN'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> Ft_cf_Rd = min{Ft_cf_Rd1 , Ft_cf_Rd2 , Ft_cf_Rd3}'];
% RepStr{end+1}= ['                               = ', num2str(round(Ft_CFB)),' kN'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> k4 = 0.9 * min{leff1 , leff2} * tcf^3 / m^3'];
% RepStr{end+1}= ['                         = ', num2str(round(k4)), ' mm'];
% else
% RepStr{end+1}= ['                  --> Ft_cf_Rd = Inf'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> k4 = Inf'];
% end
% RepStr{end+1}='---------------------------------------------------------------';
% RepStr{end+1}='---------------------------------------------------------------';
