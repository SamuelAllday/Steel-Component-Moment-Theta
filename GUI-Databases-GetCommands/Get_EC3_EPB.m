
function [Ft_EPB, Ft_ep_Rd, k5, Mode_EPB, RepStr] = Get_EC3_EPB (tf, fy, m, n, n1, n2, nBoltperRow, nBolts, Ft_Rd, leff1, leff2, gamma_M0, As, Lgrip, dwasher, Prying, RepStr)

alternative=1;
ew=dwasher/4;
Faella_Model=0;

if Prying~="default"; Lgrip=0; end
    
%% EC3 1-8, Cl. 6.2.6.5 and 6.3.2

Lb_limit = 8.8*m^3*As/leff1/tf^3;

Mpl_1_p = leff1 * (0.25*tf^2*fy/gamma_M0) *(10^-3); % [kN.mm]
Mpl_2_p = leff2 * (0.25*tf^2*fy/gamma_M0) *(10^-3); % [kN.mm]

if Lgrip <= Lb_limit % (i.e., with prying force)
    Ft_ep_Rd(1) =  4*Mpl_1_p/m;                            % Mode 1: Total yielding of the flange
    if alternative==1; Ft_ep_Rd(1) =  (8*n-2*ew)*Mpl_1_p/(2*m*n - ew * (m+n));    end       % Mode 1: alternative method, see EC3-1-8 Table 6.2
    Ft_ep_Rd(2) = (2*Mpl_2_p + nBolts*Ft_Rd*n) / (m+n);  % Mode 2: Bolt failure with yielding of the flange
else
    Ft_ep_Rd(1) =  2*Mpl_1_p/m;                            % Mode 1: Total yielding of the flange, see EC3-1-8 Table 6.2
    Ft_ep_Rd(2) =  2*Mpl_1_p/m;                            % Mode 2: Bolt failure with yielding of the flange, see EC3-1-8 Table 6.2
end
Ft_ep_Rd(3) =                     nBolts*Ft_Rd;                % Mode 3: Bolt failure

% Demonceau et al (2010)
if nBoltperRow==4
    Ft_ep_Rd_p  = (2*Mpl_2_p + nBolts*Ft_Rd/2*(n1^2+2*n2^2+2*n1*n2)/(n1+n2))/(m+n1+n2);
    Ft_ep_Rd_np = (2*Mpl_2_p + nBolts*Ft_Rd/2*n1)/(m+n1);                         
    Ft_ep_Rd(2) = min([Ft_ep_Rd_p Ft_ep_Rd_np]);
end
    
[Ft_EPB, Mode_EPB] = min(Ft_ep_Rd);
k5     = 0.9 * min([leff1 leff2]) * tf^3 / m^3;

if Faella_Model==1
    epsyi  = 0.57 * (tf/(db*sqrt(m/db)))^-1.28;
    k5     = epsyi * 0.5 * min([dhead+2*m min([leff1 leff2])]) * tf^3 / m^3;
end

tstub="yes";
if tstub=="yes"
% report string
RepStr{end+1}= ['- End-Plate Bending (EPB):'];
RepStr{end+1}= ['------------------------------------'];
RepStr{end+1}= ['    Mpl_p1 = leff1_EP * (0.25*tep^2*fyP/gamma_M0)'];
RepStr{end+1}= ['           = ', num2str(round(Mpl_1_p)),' kN.m'];
RepStr{end+1}= ['    Mpl_p2 = leff2_EP * (0.25*tep^2*fyP/gamma_M0)'];
RepStr{end+1}= ['           = ', num2str(round(Mpl_2_p)),' kN.m'];
RepStr{end+1}= [''];
RepStr{end+1}= [' Mode 1: Total yielding of the flange'];
RepStr{end+1}= ['    Ft_ep_Rd1 = 4*Mpl_p1 / m'];
RepStr{end+1}= ['              = ', num2str(round(Ft_ep_Rd(1))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= [' Mode 2: Bolt failure with yielding of the flange'];
RepStr{end+1}= ['    Ft_ep_Rd2 = (2*Mpl_p2 + nBolts*Ft_Rd*np) / (m+np)'];
RepStr{end+1}= ['              = ', num2str(round(Ft_ep_Rd(2))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= [' Mode 3: Bolt failure'];
RepStr{end+1}= ['    Ft_ep_Rd3 = nBoltperRow*Ft_Rd'];
RepStr{end+1}= ['              = ', num2str(round(Ft_ep_Rd(3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> Ft_rp_Rd = min{Ft_ep_Rd1 , Ft_ep_Rd2 , Ft_ep_Rd3}'];
RepStr{end+1}= ['                               = ', num2str(round(min(Ft_EPB))),' kN  (Mode ',num2str(Mode_EPB),')'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k5 = 0.9 * min{leff1_EP , leff2_EP} * tep^3 / m^3'];
RepStr{end+1}= ['                         = ', num2str(round(k5)), ' mm'];
RepStr{end+1}='---------------------------------------------------------------';
RepStr{end+1}='---------------------------------------------------------------';
RepStr{end+1}= [''];
end