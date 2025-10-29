function [Ft_wc_Rd, k3, RepStr] = Get_EC3_CWT (Joint, Axis, Ac, dwc, bcf, tcf, tcw, rc, beta, fyC, beff_t_cw, gamma_M0, RepStr)

%% EC3 1-8, Cl. 6.2.6.3 and 6.3.2

if Joint ~= "Splice" &&  Axis=="Major"
    Avc  = Ac - 2*bcf*tcf + (tcw+2*rc)*tcf;            % Shear area of the column section
    w1 = 1/sqrt(1+1.3*(beff_t_cw * tcw / Avc)^2);      % reduction factor that account for stress interaction
    w2 = 1/sqrt(1+5.2*(beff_t_cw * tcw / Avc)^2);      % reduction factor that account for stress interaction
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
    
    Ft_wc_Rd = w * beff_t_cw * tcw * fyC * (10^-3)/ gamma_M0;  % [kN]
    k3       = 0.7 * beff_t_cw * tcw / dwc;               % [mm]
else
    Ft_wc_Rd = Inf;
    k3       = Inf;
end

% report string
% RepStr{end+1}= ['- Column Web in Transverse Tension (CWT):'];
% RepStr{end+1}= ['-----------------------------------------'];
% if Joint ~= "Splice"
% RepStr{end+1}= ['    Avc   = Ac-(2*bc*tcf)+2*((tcw+2*r_c)*tcf*0.5)'];
% RepStr{end+1}= ['          = ', num2str(round(Avc)),' mm2'];
% RepStr{end+1}= ['      w1  = 1/sqrt(1+1.3*(beff_t_cw * tcw / Avc)^2)'];
% RepStr{end+1}= ['          = ', num2str(w1)];
% RepStr{end+1}= ['      w2  = 1/sqrt(1+5.2*(beff_t_cw * tcw / Avc)^2)'];
% RepStr{end+1}= ['          = ', num2str(w2)];
% if beta <=0.5
% RepStr{end+1}= ['      beta <= 0.5, therefore w = 1.0'];
% elseif beta > 0.5 && beta < 1.0
% RepStr{end+1}= ['      0.5 < beta < 1.0, therefore w = w1+2*(1-beta)*(1-w1)'];
% RepStr{end+1}= ['                                    = ', num2str(w)];
% elseif beta==1
% RepStr{end+1}= ['      beta = 0.5, therefore w = w1'];
% RepStr{end+1}= ['                              = ', num2str(w)];
% elseif beta > 1.0 && beta <2
% RepStr{end+1}= ['      0.5 < beta < 1.0, therefore w = w1+(beta-1)*(w2-w1)'];
% RepStr{end+1}= ['                                    = ', num2str(w)];
% elseif beta == 2.0
% RepStr{end+1}= ['      beta = 2.0, therefore w = w2'];
% RepStr{end+1}= ['                              = ', num2str(w)];
% end
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> Ft_wc_Rd = w * beff_t_cw * tcw * fyC / gamma_M0'];
% RepStr{end+1}= ['                               = ', num2str(round(Ft_wc_Rd)),' kN'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> k3 = 0.7 * beff_t_cw * tcw / dwc'];
% RepStr{end+1}= ['                         = ', num2str(round(k3)),' mm'];
% else
% RepStr{end+1}= ['                  --> Ft_wc_Rd = Inf'];
% RepStr{end+1}= [''];
% RepStr{end+1}= ['                  --> k3 = Inf'];
% end
% RepStr{end+1}='---------------------------------------------------------------';
% RepStr{end+1}='---------------------------------------------------------------';
