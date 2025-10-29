% Input:
% -------
% Individual        Whether this is an individual bolt row or part of a group [Yes/No]
% EndRow            Whether this is an end bolt row or interior one [Yes/No]
% StiffenerC        Whether stiffened column [No/Both/Comp]
% Next2Stiffener    Whether the bolt row is next to a stiffener column [No/Both/Comp]
% p:                Bolt row pitch

function [leff_cp, leff_nc] = Get_leff_CF (BoltRow_StubParameters_CF)
Individual      = BoltRow_StubParameters_CF(1,1);
EndRow          = BoltRow_StubParameters_CF(1,2);
EndRowLoc       = BoltRow_StubParameters_CF(1,3);
StiffenedC      = BoltRow_StubParameters_CF(1,4);
Next2Stiffener  = BoltRow_StubParameters_CF(1,5);
m               = BoltRow_StubParameters_CF(1,6);
m2              = BoltRow_StubParameters_CF(1,7);
e               = BoltRow_StubParameters_CF(1,8);
e1              = BoltRow_StubParameters_CF(1,9);
p               = BoltRow_StubParameters_CF(1,10);
pavg            = BoltRow_StubParameters_CF(1,11);

load('EC3Part1-8_Alpha.mat');

% Individual bolt row in tension
lambda1 = m /(m+e);
lambda2 = m2/(m+e);
for i=2:9
    evalc(strcat('L2i  =L2tag',num2str(i)));
    evalc(strcat('L2i_1=L2tag',num2str(i-1)));
    yi  =interp1(L1,L2i  ,lambda1);
    yi_1=interp1(L1,L2i_1,lambda1);
    if lambda2 <= interp1(L1,L2tag1  ,lambda1)
        alpha=8;
        break;
    end
    if lambda2 >= interp1(L1,L2tag9  ,lambda1)
        alpha=4.45;
        break;
    end
    if lambda2 > yi_1 && lambda2 < yi
        alpha=tag(i-1) + (lambda2-yi_1)/(yi-yi_1) * (tag(i-1)-tag(i));
        break;
    end
end


if StiffenedC ==0
    if Individual==1
        if EndRow==1
            leff_cp = min([2*pi()*m      pi()*m+2*e1]);
            leff_nc = min([4*m+1.25*e    2*m+0.625*e+e1]);
        else
            leff_cp = 2*pi()*m;
            leff_nc = 4*m+1.25*e;
        end
    else
        if EndRowLoc==1 || EndRowLoc==3 
            leff_cp  = min([pi()*m+p         ]);   %2*e1+p]);
            leff_nc  = min([2*m+0.625*e+0.5*p]);   %e1+0.5*p]);
        else
            leff_cp  = 2*pavg;
            leff_nc  = pavg;
        end
    end
end


if StiffenedC ==1
    if Individual==1
        if EndRow==1 && Next2Stiffener==1
            leff_cp = min([2*pi()*m      pi()*m+2*e1]);
            leff_nc = e1+alpha*m-(2*m+0.625*e);
        elseif Next2Stiffener==1
            leff_cp = 2*pi()*m;
            leff_nc = alpha*m;
        elseif EndRow==1 && Next2Stiffener==0
            leff_cp = min([2*pi()*m      pi()*m+2*e1]);
            leff_nc = min([4*m+1.25*e    2*m+0.625*e+e1]);
        elseif EndRow==0 && Next2Stiffener==0
            leff_cp = 2*pi()*m;
            leff_nc = 4*m+1.25*e;
        end
    else
        if EndRow==1 && Next2Stiffener==1
            leff_cp = Inf;
            leff_nc = Inf;
        elseif Next2Stiffener==1
            leff_cp = pi()*m+p;
            leff_nc = 0.5*p+alpha*m-(2*m+0.625*e);
        elseif EndRow==1 && Next2Stiffener==0
            leff_cp = min([pi()*m+p      2*e1+p]);
            leff_nc = min([2*m+0.625*e+0.5*p    e1+0.5*p]);
        elseif EndRow==0 && Next2Stiffener==0
            leff_cp = 2*p;
            leff_nc = p;
        end
    end
end
