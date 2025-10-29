function [Fc_cw_Rd, ksr, RepStr] = Get_EC3_LRT (Joint, Axis, ColSec, StiffenerC, DP, NcNy, Arebar, E, fyC, Ac, hc, dwc, bcf, rc, tbf, tweld, tcf, tcw, s, sp,  beta, gamma_M0, gamma_M1, RepStr)

%% Eurocode 4 (Table A.1)
% Longitudinal steel reinforcement in tension

% Asr is the cross-sectional area of the longitudinal reinforcenlent in row r within the effective width of the concrete flange detennined for the cross-section at the connection according to 5.4.1.2;

if Axis=="Major" && Joint == "Cantilever" && beta==1.0 % Single-sided (beta ~ 1.0)
    
    ksr = Asr/3.6/hc;
    
elseif Axis=="Major" && Joint ~= "Cantilever" && beta==0.0 % Double-sided and symmetric loading M_Ed,1=M_Ed,2  (beta ~ 0.0)

    ksr = Asr/0.5/hc;

elseif Axis=="Major" && Joint ~= "Cantilever" && beta==2.0 % Double-sided and asymmetric loading M_Ed,1=M_Ed,2   (beta ~ 2.0)

    Kbeta = beta * (4.3*beta^2 - 8.9*beta + 7.2);
    ksr = Asr/hc/(0.5*(1+beta)+Kbeta);
    
else
    ksr      = Inf;
end


% report string
RepStr{end+1}= ['- Longitudinal Steel Reinforcement in Tension (LRT):'];
RepStr{end+1}= ['----------------------------------------------------'];

