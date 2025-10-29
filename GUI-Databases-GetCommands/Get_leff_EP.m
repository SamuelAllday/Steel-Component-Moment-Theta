
function [leff_cp, leff_nc] = Get_leff_EP (BoltRow_StubParameters_EP)
Individual  = BoltRow_StubParameters_EP(1,1);
EndRow      = BoltRow_StubParameters_EP(1,2);
EndRowLoc   = BoltRow_StubParameters_EP(1,3);
ExteriorRow = BoltRow_StubParameters_EP(1,4);
Next2Flange = BoltRow_StubParameters_EP(1,5);
m           = BoltRow_StubParameters_EP(1,6);
m2          = BoltRow_StubParameters_EP(1,7);
mx          = BoltRow_StubParameters_EP(1,8);
e           = BoltRow_StubParameters_EP(1,9);
ex          = BoltRow_StubParameters_EP(1,10);
p           = BoltRow_StubParameters_EP(1,11);
pavg        = BoltRow_StubParameters_EP(1,12);
w           = BoltRow_StubParameters_EP(1,13);
bep         = BoltRow_StubParameters_EP(1,14);

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
        alpha=tag(i-1) - (lambda2-yi_1)/(yi-yi_1) * (tag(i-1)-tag(i));
        break;
    end
end

%%
if ExteriorRow ==1
    if Individual==1
        leff_cp = min([2*pi()*mx      pi()*mx+w   pi()*mx+2*e]);
        leff_nc = min([4*mx+1.25*ex   e+2*mx+0.625*ex   0.5*bep   0.5*w+2*mx+0.625*ex]);
    else
        leff_cp = NaN;
        leff_nc = NaN;
    end
else
    if ExteriorRow ==0 && Next2Flange==1
        if Individual==1
            leff_cp = 2*pi()*m;
            leff_nc = alpha*m;
        else
            leff_cp = pi()*m+p;
            leff_nc = 0.5*p+alpha*m-(2*m+0.625*e);
        end
    elseif EndRow ==1
        if Individual==1
            leff_cp = 2*pi()*m;
            leff_nc = 4*m+1.25*e;
        else
            if EndRowLoc==2
                p=pavg;             
            end
            leff_cp = pi()*m+p;
            leff_nc = 2*m+0.625*e+0.5*p;
        end
    elseif EndRow ==0
        if Individual==1
            leff_cp = 2*pi()*m;
            leff_nc = 4*m+1.25*e;
        else
            if EndRowLoc==2
                p=pavg;             
            end
            leff_cp = 2*p;
            leff_nc = p;
        end
    end
end