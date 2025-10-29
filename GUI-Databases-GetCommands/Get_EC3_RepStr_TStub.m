function [RepStr] = Get_EC3_RepStr_TStub(RepStr,portion)

load('temp.mat');

if portion=='Intro'
    
    %% Report string
    RepStr{1}    = ['---------------------------------------------------------------------------------'];
    RepStr{end+1}= ['----------------- EC3 1-8 Component Method Computation Summary ------------------'];
    RepStr{end+1}= ['---------------------------------------------------------------------------------'];
    if exist('ID')
    RepStr{end+1}= [''];
    RepStr{end+1}= ['Specimen: ',char(ID),'  by ',char(Researcher),' (',num2str(Year),')'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['---------------------------------------------------------------------------------'];
    end
    RepStr{end+1}= [''];
    RepStr{end+1}= ['- Specimen Basic Geometric:'];
    RepStr{end+1}= ['---------------------------'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    Type   = ',char(Type)];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    Plate  = ',num2str(round(bf)),' x ',num2str(round(Lf)),' x ',num2str(round(tf))];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    Web   = ',num2str(round(Lw)),' x ',num2str(round(tw))];
    RepStr{end+1}= [''];
    if Type == "Rolled"
    RepStr{end+1}= ['    r   = ',num2str(round(r)),' mm'];
    RepStr{end+1}= [''];
    else
    RepStr{end+1}= ['    tweld   = ',num2str(round(tweld)),' mm'];
    RepStr{end+1}= [''];
    end
    if Symmetry == "Single"
    RepStr{end+1}= ['    t_base  = ',num2str(round(tbase)),' mm'];
    RepStr{end+1}= [''];
    end
    RepStr{end+1}= ['    No. rows = ',num2str(round(nrow))'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    No. bolt per row = ',num2str(round(ncol))'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    db     = ',num2str(round(d_b)),' mm, Grade ',char(GradeBolt)];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    p      = ',num2str(round(p)),' mm,  pitch between bolt rows'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    g      = ',num2str(round(g)),' mm,  pitch between bolt columns'];

    RepStr{end+1}= [''];
    RepStr{end+1}=['---------------------------------------------------------------------------------'];
    RepStr{end+1}=['---------------------------------------------------------------------------------'];
    RepStr{end+1}=['---------------------------------------------------------------------------------'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['- T-Stub Basic Dimensions:'];
    RepStr{end+1}= ['--------------------------'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    m = (g-tw)/2 - 0.8*r = ',num2str(round(m)),' mm,  as per Fig. 6.8 '];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    e = (bf-g)/2 = ',num2str(round(e)),' mm'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    n = min{emin , 1.25*m} = ',num2str(round(n)),' mm'];
    RepStr{end+1}= [''];
    RepStr{end+1}= ['    emin = ',num2str(round(e)),' mm'];
    RepStr{end+1}= [''];
    if contains(Type,"Welded")
    RepStr{end+1}= ['    Built-up section,  s = sqrt(2)*tweld = ',num2str(round(s)),' mm'];
    else
    RepStr{end+1}= ['    Hot-rolled section,  s = r = ',num2str(round(s)),' mm'];
    end
    RepStr{end+1}= [''];

    RepStr{end+1}= ['    All partial safety factors are taken equal to 1.0'];
    RepStr{end+1}= '';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';

else

    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='';
    if ColSec~="NA" && ColSec~="None" && ColSec ~= "Rigid"
    RepStr{end+1}='               T-stub effective length for the Column Flange';
    RepStr{end+1}='                  leff_cp    leff_nc    leff1    leff2';
    RepStr{end+1}='             --------------------------------------------------';
    for i=1:size(Store_leff_CF,1)
    if i<=nrow
    RepStr{end+1}= ['      row #',num2str(i),'   :    ',num2str(round(Store_leff_CF(i,1))),'        ',num2str(round(Store_leff_CF(i,2))),'       ',num2str(round(Store_leff_CF(i,3))),'      ',num2str(round(Store_leff_CF(i,4))),' mm'];
    elseif i==nrow+1
    RepStr{end+1}= ['      row 1+2  :    ',num2str(round(Store_leff_CF(i,1))),'        ',num2str(round(Store_leff_CF(i,2))),'       ',num2str(round(Store_leff_CF(i,3))),'      ',num2str(round(Store_leff_CF(i,4))),' mm'];    
    elseif i==nrow+2
    RepStr{end+1}= ['      row 2+3  :    ',num2str(round(Store_leff_CF(i,1))),'        ',num2str(round(Store_leff_CF(i,2))),'       ',num2str(round(Store_leff_CF(i,3))),'      ',num2str(round(Store_leff_CF(i,4))),' mm'];    
    elseif i==nrow+3
    RepStr{end+1}= ['      row 1+2+3:    ',num2str(round(Store_leff_CF(i,1))),'        ',num2str(round(Store_leff_CF(i,2))),'       ',num2str(round(Store_leff_CF(i,3))),'      ',num2str(round(Store_leff_CF(i,4))),' mm'];    
    end
    end
    end
    RepStr{end+1}='';
    RepStr{end+1}='                T-stub effective length for the End-Plate';
    RepStr{end+1}='                  leff_cp    leff_nc    leff1    leff2';
    RepStr{end+1}='             --------------------------------------------------';
    for i=1:size(Store_leff_EP,1)
    if i<=nrow
    RepStr{end+1}= ['      row #',num2str(i),'   :    ',num2str(round(Store_leff_EP(i,1))),'        ',num2str(round(Store_leff_EP(i,2))),'       ',num2str(round(Store_leff_EP(i,3))),'      ',num2str(round(Store_leff_EP(i,4))),' mm'];
    elseif i==nrow+1
    RepStr{end+1}= ['      row 1+2  :    ',num2str(round(Store_leff_EP(i,1))),'        ',num2str(round(Store_leff_EP(i,2))),'       ',num2str(round(Store_leff_EP(i,3))),'      ',num2str(round(Store_leff_EP(i,4))),' mm'];    
    elseif i==nrow+2
    RepStr{end+1}= ['      row 2+3  :    ',num2str(round(Store_leff_EP(i,1))),'        ',num2str(round(Store_leff_EP(i,2))),'       ',num2str(round(Store_leff_EP(i,3))),'      ',num2str(round(Store_leff_EP(i,4))),' mm'];    
    elseif i==nrow+3
    RepStr{end+1}= ['      row 1+2+3:    ',num2str(round(Store_leff_EP(i,1))),'        ',num2str(round(Store_leff_EP(i,2))),'       ',num2str(round(Store_leff_EP(i,3))),'      ',num2str(round(Store_leff_EP(i,4))),' mm'];    
    end
    end
    RepStr{end+1}= '';
    if ColSec~="NA" && ColSec~="None" && ColSec ~= "Rigid"
    RepStr{end+1}='---------------------------------------------------------------';
    RepStr{end+1}='';
    RepStr{end+1}='                   Force Reistance for Column Flange Bending';
    RepStr{end+1}='                  Mode 1     Mode 2     Mode 3        Minimum        Mode';
    RepStr{end+1}='                -----------------------------------------------------------';
    for i=1:size(Store_Ft_cf_Rd,1)
    if i<=nrow
    RepStr{end+1}=['     Ft_row #',num2str(i),'   : ',num2str(round(Store_Ft_cf_Rd(i,1))),'        ',num2str(round(Store_Ft_cf_Rd(i,2))),'        ',num2str(round(Store_Ft_cf_Rd(i,3))),'          ',num2str(round(Store_Ft_cf_Rd(i,4))),' kN','          ',num2str(round(Store_Mode_CFB(i,1)))];
    elseif i==nrow+1
    RepStr{end+1}=['     Ft_row 1+2  : ',num2str(round(Store_Ft_cf_Rd(i,1))),'        ',num2str(round(Store_Ft_cf_Rd(i,2))),'        ',num2str(round(Store_Ft_cf_Rd(i,3))),'          ',num2str(round(Store_Ft_cf_Rd(i,4))),' kN'];
    elseif i==nrow+2
    RepStr{end+1}=['     Ft_row 2+3  : ',num2str(round(Store_Ft_cf_Rd(i,1))),'        ',num2str(round(Store_Ft_cf_Rd(i,2))),'        ',num2str(round(Store_Ft_cf_Rd(i,3))),'          ',num2str(round(Store_Ft_cf_Rd(i,4))),' kN'];
    elseif i==nrow+3
    RepStr{end+1}=['     Ft_row 1+2+3: ',num2str(round(Store_Ft_cf_Rd(i,1))),'        ',num2str(round(Store_Ft_cf_Rd(i,2))),'        ',num2str(round(Store_Ft_cf_Rd(i,3))),'          ',num2str(round(Store_Ft_cf_Rd(i,4))),' kN'];
    end
    end
    RepStr{end+1}=['     Deformation mode: ',num2str(round(Store_Mode_CFB(1,1)))];
    RepStr{end+1}=[''];
    end
    RepStr{end+1}='---------------------------------------------------------------';
    RepStr{end+1}='';
    RepStr{end+1}='                     Force Reistance for End-Plate Bending';
    RepStr{end+1}='                  Mode 1     Mode 2     Mode 3        Minimum        Mode';
    RepStr{end+1}='                -----------------------------------------------------------';
    for i=1:size(Store_Ft_ep_Rd,1)
    if i<=nrow
    RepStr{end+1}=['     Ft_row #',num2str(i),'   : ',num2str(round(Store_Ft_ep_Rd(i,1))),'        ',num2str(round(Store_Ft_ep_Rd(i,2))),'        ',num2str(round(Store_Ft_ep_Rd(i,3))),'          ',num2str(round(Store_Ft_ep_Rd(i,4))),' kN','          ',num2str(round(Store_Mode_EPB(i,1)))];
    elseif i==nrow+1
    RepStr{end+1}=['     Ft_row 1+2  : ',num2str(round(Store_Ft_ep_Rd(i,1))),'        ',num2str(round(Store_Ft_ep_Rd(i,2))),'        ',num2str(round(Store_Ft_ep_Rd(i,3))),'          ',num2str(round(Store_Ft_ep_Rd(i,4))),' kN'];
    elseif i==nrow+2
    RepStr{end+1}=['     Ft_row 2+3  : ',num2str(round(Store_Ft_ep_Rd(i,1))),'        ',num2str(round(Store_Ft_ep_Rd(i,2))),'        ',num2str(round(Store_Ft_ep_Rd(i,3))),'          ',num2str(round(Store_Ft_ep_Rd(i,4))),' kN'];
    elseif i==nrow+3
    RepStr{end+1}=['     Ft_row 1+2+3: ',num2str(round(Store_Ft_ep_Rd(i,1))),'        ',num2str(round(Store_Ft_ep_Rd(i,2))),'        ',num2str(round(Store_Ft_ep_Rd(i,3))),'          ',num2str(round(Store_Ft_ep_Rd(i,4))),' kN'];
    end
    end
    RepStr{end+1}=['     Deformation mode: ',num2str(round(Store_Mode_EPB(1,1)))];
    RepStr{end+1}=[''];
    RepStr{end+1}='---------------------------------------------------------------';
    RepStr{end+1}='';
    RepStr{end+1}='                   CWT   CFB   EPB   BWT        Minimum';
    RepStr{end+1}='                 ----------------------------------------';
    for i=1:size(Store_leff_CF,1)
    if i<=nrow
    RepStr{end+1}=['     Ft_row #',num2str(i),'   : ',num2str(round(Ft_row(i,1))),'   ',num2str(round(Ft_row(i,2))),'   ',num2str(round(Ft_row(i,3))),'   ',num2str(round(Ft_row(i,4))),'       ',num2str(round(Ft_row_min(i))),' kN'];
    elseif i==nrow+1
    RepStr{end+1}=['     Ft_row 1+2  : ',             num2str(round(Ft_row(i,1))),'   ',num2str(round(Ft_row(i,2))),'   ',num2str(round(Ft_row(i,3))),'   ',num2str(round(Ft_row(i,4))),'       ',num2str(round(Ft_row_min(i))),' kN'];
    elseif i==nrow+2
    RepStr{end+1}=['     Ft_row 2+3  : ',             num2str(round(Ft_row(i,1))),'   ',num2str(round(Ft_row(i,2))),'   ',num2str(round(Ft_row(i,3))),'   ',num2str(round(Ft_row(i,4))),'       ',num2str(round(Ft_row_min(i))),' kN'];
    elseif i==nrow+3
    RepStr{end+1}=['     Ft_row 1+2+3: ',             num2str(round(Ft_row(i,1))),'   ',num2str(round(Ft_row(i,2))),'   ',num2str(round(Ft_row(i,3))),'   ',num2str(round(Ft_row(i,4))),'       ',num2str(round(Ft_row_min(i))),' kN'];
    end
    end
    RepStr{end+1}=[''];
    RepStr{end+1}=['                  CWT   CFB   EPB   BWT   BOLT'];
    RepStr{end+1}=['                  k3    k4    k5    k8    k10'];
    RepStr{end+1}=['                ----------------------------------'];
    for i=1:size(Store_leff_CF,1)
    if i<=nrow
    RepStr{end+1}=['     k_row #',num2str(i),'   : ',num2str(round(k_r(i,1)*10)/10),'   ',num2str(round(k_r(i,2)*10)/10),'   ',num2str(round(k_r(i,3)*10)/10),'   ',num2str(round(k_r(i,4)*10)/10),'   ',num2str(round(k_r(i,5)*10)/10),' mm'];
    elseif i==nrow+1
    RepStr{end+1}=['     k_row 1+2  : ',             num2str(round(k_r(i,1)*10)/10),'   ',num2str(round(k_r(i,2)*10)/10),'   ',num2str(round(k_r(i,3)*10)/10),'   ',num2str(round(k_r(i,4)*10)/10),' mm'];
    elseif i==nrow+2
    RepStr{end+1}=['     k_row 2+3  : ',             num2str(round(k_r(i,1)*10)/10),'   ',num2str(round(k_r(i,2)*10)/10),'   ',num2str(round(k_r(i,3)*10)/10),'   ',num2str(round(k_r(i,4)*10)/10),' mm'];
    elseif i==nrow+3
    RepStr{end+1}=['     k_row 1+2+3: ',             num2str(round(k_r(i,1)*10)/10),'   ',num2str(round(k_r(i,2)*10)/10),'   ',num2str(round(k_r(i,3)*10)/10),'   ',num2str(round(k_r(i,4)*10)/10),' mm'];
    end
    end
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}=[''];
    RepStr{end+1}=['                    Global Modes Resistances'];
    if Axis == "Major"
    RepStr{end+1}=['                  CWS   CWC   BFC       Minimum'];
    RepStr{end+1}=['                ----------------------------------'];
    RepStr{end+1}=['Fglobal:          ',num2str(round(Fs_CWS)),'   ',num2str(round(Fc_CWC)),'   ',num2str(round(Fc_BFC)),'       ',num2str(round(Fglobal_min)),' kN'];
    elseif Axis == "Minor" && Joint == "Cantilever"
    RepStr{end+1}=['                  CWS   CWC   CWB   BFC       Minimum'];
    RepStr{end+1}=['                ----------------------------------------'];
    RepStr{end+1}=['Fglobal:          ',num2str(round(Fs_CWS)),'   ',num2str(round(Fc_CWC)),'   ',num2str(round(Ft_CWB)),'   ',num2str(round(Fc_BFC)),'       ',num2str(round(Fglobal_min)),' kN'];
    end
    RepStr{end+1}=[''];
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='';
    RepStr{end+1}=['     Final Bolt Rows Resistances (after considering global modes)'];
    RepStr{end+1}=['    -------------------------------------------------------------'];
    RepStr{end+1}=['                       Ftr_Rd [kN]       z [mm]'];
    for i=1:nrow
    RepStr{end+1}=['           row #',num2str(i),':        ',num2str(round(Ftr_Rd(i,1))),'             ',num2str(round(z(i)))];
    end
    RepStr{end+1}='';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='';
    RepStr{end+1}=['                         Final Predicted Quantities'];
    RepStr{end+1}=['                       -------------------------------'];
    RepStr{end+1}=['- Plastic Moment Resistance, Mp_Rd'];                                                                  
    RepStr{end+1}=['']; 
    RepStr{end+1}=['  Mp_Rd =  sum (Ftr_Rd * z) = ',num2str(round(Mp_Rd)),' kN.m'];                                                                  
    RepStr{end+1}=['']; 
    RepStr{end+1}=['  Controling damage mode: ',char(labelM(1,MpModeIndex))];                                                                  
    RepStr{end+1}=['']; 
    RepStr{end+1}=['- Elastic Rotational Stiffeness, Sj_ini (see Table 6.10)'];                                                                  
    RepStr{end+1}=['']; 

    if nTrow == 1
    if Joint=="Cantilever" && Axis =="Major"
    RepStr{end+1}=['                        CWS    CWC    CWT    CFB    EPB    BOLT']; 
    RepStr{end+1}=['  Sj_ini =  E * z1^2 / (1/k1 + 1/k2 + 1/k3 + 1/k4 + 1/k5 + 1/k10) = ',num2str(round(Sj_ini)),' kN.m/rad']; 
    elseif Joint=="Cruciform"
    RepStr{end+1}=['                               CWC    CWT    CFB    EPB    BOLT']; 
    RepStr{end+1}=['  Sj_ini =  E * z1^2 / (       1/k2 + 1/k3 + 1/k4 + 1/k5 + 1/k10) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=='Cruciform' && contains(Setup,'Asym')
    RepStr{end+1}=['                        CWS    CWC    CWT    CFB    EPB    BOLT']; 
    RepStr{end+1}=['  Sj_ini =  E * z1^2 / (1/k1 + 1/k2 + 1/k3 + 1/k4 + 1/k5 + 1/k10) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=="Splice"
    RepStr{end+1}=['                                                    EPB    BOLT']; 
    RepStr{end+1}=['  Sj_ini =  E * z1^2 / (                            2/k5 + 1/k10) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=="Cantilever" && Axis =="Minor"
    RepStr{end+1}=['                        CWS    CWC    CWT    CFB    EPB    BOLT    CWB']; 
    RepStr{end+1}=['  Sj_ini =  E * z1^2 / (1/k1 + 1/k2 + 1/k3 + 1/k4 + 1/k5 + 1/k10 + 1/k21) = ',num2str(round(Sj_ini)),' kN.m/rad']; 
    end
    end
    
    if nTrow > 1
    RepStr{end+1}=['                 CWT    CFB    EPB       z']; 
    for i=1:nTrow
    RepStr{end+1}=['      k_r #',num2str(i),':    ',num2str(round(k_row(i,1)*10)/10),'   ',num2str(round(k_row(i,2)*10)/10),'   ',num2str(round(k_row(i,3)*10)/10),'     ',num2str(round(z(i)))];
    end
    RepStr{end+1}=['']; 
    RepStr{end+1}=['         E = ',num2str(round(E)),' MPa'];
    RepStr{end+1}=['      z_eq = ',num2str(round(z_eq)),' mm'];
    RepStr{end+1}=['      k_eq = ',num2str(round(k_eq*10)/10),' mm'];
    RepStr{end+1}=[''];
    if Joint=="Cantilever" && Axis =="Major"
    RepStr{end+1}=['                          CWS    CWC    Equivelant']; 
    RepStr{end+1}=['  Sj_ini =  E * z_eq^2 / (1/k1 + 1/k2 + 1/k_eq) = ',num2str(round(Sj_ini)),' kN.m/rad']; 
    elseif Joint=="Cruciform"
    RepStr{end+1}=['                                 CWC    Equivelant']; 
    RepStr{end+1}=['  Sj_ini =  E * z_eq^2 / (       1/k2 + 1/k_eq) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=="Cruciform" && contains(Setup,'Asym')
    RepStr{end+1}=['                          CWS    CWC    Equivelant']; 
    RepStr{end+1}=['  Sj_ini =  E * z_eq^2 / (1/k1 + 1/k2 + 1/k_eq) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=="Splice"
    RepStr{end+1}=['                                        Equivelant']; 
    RepStr{end+1}=['  Sj_ini =  E * z_eq^2 / (              1/k_eq) = ',num2str(round(Sj_ini)),' kN.m/rad'];
    elseif Joint=="Cantilever" && Axis =="Minor"
    RepStr{end+1}=['                          CWS    CWC    CWB     Equivelant']; 
    RepStr{end+1}=['  Sj_ini =  E * z_eq^2 / (1/k1 + 1/k2 + 1/k21 + 1/k_eq) = ',num2str(round(Sj_ini)),' kN.m/rad']; 
    end
    end
    RepStr{end+1}=['']; 
    RepStr{end+1}=['  Controling damage mode: ',char(labelK(1,KeModeIndex))];   
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='**********************************************************************************';
    RepStr{end+1}='';
    
end