function [Fc_cw_Rd, k2, RepStr] = Get_EC3_CWC (Joint, Axis, ColSec, StiffenerC, DP, NcNy, E, fyC, Ac, hc, dwc, bcf, rc, tbf, tweld, tcf, tcw, s, sp,  beta, gamma_M0, gamma_M1, RepStr)

%% EC3 1-8,  Cl. 6.2.6.2 and 6.3.2

if Axis=="Major" && Joint ~= "Splice" && StiffenerC=="No" && ColSec ~= "Rigid"
    
    if DP=="One"; tcw=tcw*1.5; end 
    if DP=="Two"; tcw=tcw*2.0; end 
    Avc  = Ac-(2*bcf*tcf)+(tcw+2*rc)*tcf; % Shear area of the column section
    if DP~="No";   bs   = hc-2*rc-2*tcf; Avc=Avc+bs*tcw; end
    
    fcom_Ed=NcNy;
    if fcom_Ed<= 0.7*fyC
        kwc = 1.0;
    else
        kwc = min([1.0   1.7-fcom_Ed/fyC]); % reduction factor that accounts for increased risk of column web instability under high axial stress
    end
    
    beff_c_wc = tbf + 2*sqrt(2)*tweld + 5*(tcf+s) + sp; % Eqn 6.11
    
    lamdaP    = 0.932 * sqrt(beff_c_wc * dwc * fyC / E / tcw^2);
    
    % reduction factor the possible risk of instability in the web in the case of slender column sections
    if lamdaP<=0.72
        rho =1.0; 
    else
        rho =(lamdaP-0.2)/lamdaP^2;
    end
    
    w1 = 1/sqrt(1+1.3*(beff_c_wc * tcw / Avc)^2); % Table 6.3: reduction factor that account for interaction with shear
    w2 = 1/sqrt(1+5.2*(beff_c_wc * tcw / Avc)^2); % Table 6.3: reduction factor that account for interaction with shear
    if beta <=0.5
        w=1;
    elseif beta > 0.5 && beta < 1.0
        w=w1+2*(1-beta)*(1-w1);
    elseif beta==1
        w=w1;
    elseif beta > 1.0 && beta <2
        w=w1+(beta-1)*(w2-w1);
    elseif beta == 2.0
        w=w2;
    end
    
    Fc_cw_Rd = min([w*kwc*beff_c_wc*tcw*fyC/gamma_M0  w*kwc*rho*beff_c_wc*tcw*fyC/gamma_M1]) *(10^-3);  % [kN]
    k2       = 0.7 * beff_c_wc * tcw / dwc;                           % [mm]
else
    Fc_cw_Rd = Inf;
    k2       = Inf;
end


% report string
RepStr{end+1}= ['- Column Web in Transverse Compression (CWC):'];
RepStr{end+1}='---------------------------------------------------------------';
if Axis=="Major" && Joint ~= "Splice" && StiffenerC=="No" && ColSec ~= "Rigid"
if DP=="One"
RepStr{end+1}= ['    One doubler plate is used, take tcw = 1.5*tcw = ',num2str(tcw),' mm']; 
end
if DP=="Two"
RepStr{end+1}= ['    Two doubler plates are used, take tcw = 2.0*tcw = ',num2str(tcw),' mm']; 
end
RepStr{end+1}= [''];
RepStr{end+1}= ['    Avc       = Ac - 2*bc*tcf + (tcw+2*rc)*tcf'];
RepStr{end+1}= ['              = ', num2str(round(Avc)),' mm2'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    sp        = min{2*tep , tep+max{er-sqrt(2)*tweld,0}} = ',num2str(round(sp)),' mm'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    beff_c_wc = tbf + 2*sqrt(2)*tweld + 5*(tcf+s) + sp,    Eqn 6.12'];
RepStr{end+1}= ['              = ', num2str(round(beff_c_wc)),' mm'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    fcom_Ed   = Nc/Ny = ', num2str(round(NcNy)),',  compressive longitudinal stress in column'];
RepStr{end+1}= [''];
if fcom_Ed<= 0.7*fyC
RepStr{end+1}= ['    fcom_Ed   <= 0.7*fyC, therefore kwc = 1.0,   Cl. 6.2.6.2(2)'];
else
RepStr{end+1}= ['    fcom_Ed   >  0.7*fyC, therefore kwc = min{1.0 , 1.7-fcom_Ed/fyC},   Cl. 6.2.6.2(2)'];
RepStr{end+1}= ['                                        = ', num2str(round(kwc))];
end
RepStr{end+1}= [''];
RepStr{end+1}= ['   lamdaP = 0.932 * sqrt(beff_c_wc * dwc * fyC / E / tcw^2),    Eqn 6.13c'];
RepStr{end+1}= ['          = ', num2str(lamdaP)];
RepStr{end+1}= [''];
if lamdaP<=0.72
RepStr{end+1}= ['      lamdaP <= 0.72, therefore rho = 1.0,   see Eqn 6.13a'];
else
RepStr{end+1}= ['      lamdaP >  0.72, therefore rho = (lamdaP-0.2)/lamdaP^2,    Eqn 6.13b'];
RepStr{end+1}= ['                                    = ', num2str(rho)];
end
RepStr{end+1}= [''];
RepStr{end+1}= ['      w1 = 1/sqrt(1+1.3*(beff_c_cw * tcw / Avc)^2),  Avc based on Cl. 6.2.6.1(6)'];
RepStr{end+1}= ['         = ', num2str(w1)];
RepStr{end+1}= ['      w2 = 1/sqrt(1+5.2*(beff_c_cw * tcw / Avc)^2),  Avc based on Cl. 6.2.6.1(6)'];
RepStr{end+1}= ['         = ', num2str(w2)];
RepStr{end+1}= [''];
if beta <=0.5
RepStr{end+1}= ['      beta <= 0.5, therefore w = 1.0,    Table 6.3'];
elseif beta > 0.5 && beta < 1.0
RepStr{end+1}= ['      0.5 < beta < 1.0, therefore w = w1+2*(1-beta)*(1-w1),    Table 6.3'];
RepStr{end+1}= ['                                    = ', num2str(w)];
elseif beta==1
RepStr{end+1}= ['      beta = 1.0, therefore w = w1,    Table 6.3'];
RepStr{end+1}= ['                              = ', num2str(w)];
elseif beta > 1.0 && beta <2
RepStr{end+1}= ['      1.0 < beta < 2.0, therefore w = w1+(beta-1)*(w2-w1),    Table 6.3'];
RepStr{end+1}= ['                                    = ', num2str(w)];
elseif beta == 2.0
RepStr{end+1}= ['      beta = 2.0, therefore w = w2 = ', num2str(w),',    Table 6.3'];
end
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> Fc_cw_Rd = min{w*kwc*beff_c_wc*tcw*fyC/gamma_M0 , w*kwc*rho*beff_c_wc*tcw*fyC/gamma_M1}'];
RepStr{end+1}= ['                               = ', num2str(round(Fc_cw_Rd)),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k2 = 0.7 * beff_t_cw * tcw / dwc'];
RepStr{end+1}= ['                         = ', num2str(round(k2*10)/10),' mm'];
else
RepStr{end+1}= ['                  --> Fc_cw_Rd = Inf'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k2 = Inf'];
end
RepStr{end+1}= [''];
RepStr{end+1}='---------------------------------------------------------------';
