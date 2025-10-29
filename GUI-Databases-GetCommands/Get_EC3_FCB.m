
function [Ft_FCB, Ft_cleat_Rd, k6, RepStr] = Get_EC3_FCB (tf, fy, m, n, n1, n2, nBolts, Ft_Rd, La, gamma_M0, As, Lgrip, dwasherEX, RepStr)

alternative=0;
ew=dwasherEX/4;

% Flange cleat in bending
% EC3 1-8, Figure 6.12 and 6.13 and clause 6.2.6.6

if gap <= 0.4*tf
    m    = stc - tf - 0.8*rA;
    emin = etc;
else
    m    = stc - 0.5*tf;
    emin = etc;
end

leff = La/2;

Lb_limit = 8.8*m^3*As/leff/tf^3;

Mpl_p = leff * (0.25*tf^2*fy/gamma_M0) *(10^-3); % [kN.mm]


if Lgrip <= Lb_limit % (i.e., with prying force)
    Ft_ep_Rd(1) =  4*Mpl_1_p/m;                            % Mode 1: Total yielding of the flange
    if alternative==1; Ft_cf_Rd(1) =  (8*n-2*ew)*Mpl_1_p/(2*m*n - ew * (m+n));    end       % Mode 1: alternative method, see EC3-1-8 Table 6.2
    Ft_ep_Rd(2) = (2*Mpl_2_p + nBolts*Ft_Rd*n) / (m+n);  % Mode 2: Bolt failure with yielding of the flange
else
    Ft_ep_Rd(1) =  2*Mpl_1_p/m;                            % Mode 1: Total yielding of the flange, see EC3-1-8 Table 6.2
    Ft_ep_Rd(2) =  2*Mpl_1_p/m;                            % Mode 2: Bolt failure with yielding of the flange, see EC3-1-8 Table 6.2
end
Ft_ep_Rd(3) =                     nBolts*Ft_Rd;                % Mode 3: Bolt failure

% Demonceau et al (2010)
if nBolts==4
    Ft_ep_Rd_p  = (2*Mpl_2_p + nBolts*Ft_Rd/2*(n1^2+2*n2^2+2*n1*n2)/(n1+n2))/(m+n1+n2);
    Ft_ep_Rd_np = (2*Mpl_2_p + nBolts*Ft_Rd/2*n1)/(m+n1);                         
    Ft_ep_Rd(2) = min([Ft_ep_Rd_p Ft_ep_Rd_np]);
end
    
Ft_EPB = min(Ft_ep_Rd);

k6     = 0.9 * leff * tf^3 / m^3;

