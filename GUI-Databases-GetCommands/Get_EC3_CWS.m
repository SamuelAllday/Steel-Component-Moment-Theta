function [Fs_wc_Rd, k1, RepStr] = Get_EC3_CWS (ConType, Joint, Axis, SingleRow, ColSec, StiffenerC, fyC, Ac, hc, bcf, hb, tbf, tcf, tcw, rc, beta, tstiffC, tdp, fyP, z, gamma_M0, RepStr)

%% EC3 1-8, Cl. 6.2.6.1 and 6.3.2

if Axis=="Major" && Joint ~= "Splice" && ColSec ~= "Rigid" && beta~=0
    if ConType=="EEP"; ds   = hb-tbf; end
    if ConType=="FEP" && SingleRow=="Yes"; ds   = z(1); end
    if ConType=="FEP" && SingleRow=="No";  ds   = (z(1)+z(2))/2; end
    bs   = hc-2*rc-2*tcf;
    Avc  = Ac-(2*bcf*tcf)+(tcw+2*rc)*tcf; % Shear area of the column section
    if tdp~=0; Avc=Avc+bs*tcw; end 
    Vwp_Rd = 0.9 * Avc * fyC /sqrt(3)/gamma_M0; % [N]  Eqn. 6.7  - The 0.9 factor accounts for the longitudinal stresses acting in the column
    
    if StiffenerC =="Both"
        Mpl_fc_Rd  = bcf*tcf^2/4*fyC;
        Mpl_st_Rd  = (bcf-tcw)*tstiffC^2/4*fyP;
        Vwp_add_Rd = min([4*Mpl_fc_Rd/ds    2*(Mpl_fc_Rd+Mpl_st_Rd)/ds]); % [kN] Eqn. 6.7
        Vwp_Rd     = Vwp_Rd + Vwp_add_Rd;
    end
    
    Fs_wc_Rd = Vwp_Rd *(10^-3)/ beta;     % [kN]
    k1       = 0.38*Avc / (beta*ds);      % [mm]
else
    Fs_wc_Rd = Inf;
    k1       = Inf;
end

% report string
RepStr{end+1}= ['- Column Web in Shear (CWS):'];
RepStr{end+1}='---------------------------------------------------------------';
if Axis=="Major" && Joint ~= "Splice" && ColSec ~= "Rigid" && beta~=0.0
RepStr{end+1}= ['     fyC = ', num2str(round(fyC)),' MPa'];
RepStr{end+1}= ['']; 
RepStr{end+1}= ['      ds = hb-tbf = ', num2str(round(ds)),' mm'];
RepStr{end+1}= [''];      
if tdp==0.0
RepStr{end+1}= [' Shear area of the column section:'];
RepStr{end+1}= ['    Avc  = Ac - 2*bcf*tcf + (tcw+2*rc)*tcf = ', num2str(round(Avc)),' mm2'];
else
RepStr{end+1}= [' Shear area of the column section considering doubler plates per Cl 6.2.6.1(6):'];
RepStr{end+1}= ['      bs = hc - 2*rc - 2*tcf = ', num2str(round(bs)),' mm']; 
RepStr{end+1}= [''];       
RepStr{end+1}= ['    Avc  = Ac - 2*bcf*tcf + (tcw+2*r_c)*tcf + bs*tcw = ', num2str(round(Avc)),' mm2'];
end
RepStr{end+1}= [''];
RepStr{end+1}= [' Web shear resistance (Eqn. 6.7):'];
RepStr{end+1}= ['    Vwp_Rd = 0.9 * Avc * fyC /sqrt(3)/gamma_M0'];
RepStr{end+1}= ['           = ', num2str(round(Vwp_Rd/1000)),' kN'];
RepStr{end+1}= [''];
if StiffenerC =="Both"
RepStr{end+1}= [' Additional shear resistance for stiffened columns:'];
RepStr{end+1}= ['    Mpl_fc_Rd  = bcf*tcf^2/4*fyC'];
RepStr{end+1}= ['               = ', num2str(round(Mpl_fc_Rd/10^6)),' kN.m'];
RepStr{end+1}= ['    Mpl_st_Rd  = (bcf-tcw)*tstiff^2/4*fyP'];
RepStr{end+1}= ['               = ', num2str(round(Mpl_st_Rd/10^6)),' kN.m'];
RepStr{end+1}= ['    Vwp_add_Rd = min {4*Mpl_fc_Rd/ds  ,  2*(Mpl_fc_Rd+Mpl_st_Rd)/ds}'];
RepStr{end+1}= ['               = ', num2str(round(Vwp_add_Rd/1000)),' kN'];
RepStr{end+1}= ['        Vwp_Rd = Vwp_Rd + Vwp_add_Rd'];
RepStr{end+1}= ['               = ', num2str(round(Vwp_Rd)),' kN'];
RepStr{end+1}= [''];
end
RepStr{end+1}= ['                  --> Fs_wc_Rd = Vwp_Rd/ beta'];
RepStr{end+1}= ['                               = ', num2str(round(Fs_wc_Rd)), ' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k1 = 0.38*Avc / (beta*ds)'];
RepStr{end+1}= ['                         = ', num2str(round(k1*10)/10)];
else
RepStr{end+1}= ['                  --> Fs_wc_Rd = Inf'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k1 = Inf'];
end
RepStr{end+1}='';
RepStr{end+1}='---------------------------------------------------------------';
