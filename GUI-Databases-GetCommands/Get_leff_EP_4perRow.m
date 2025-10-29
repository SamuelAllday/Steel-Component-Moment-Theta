function [leff_cp, leff_nc] = Get_leff_EP_4perRow (BoltRow_StubParameters_EP)

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
m1          = BoltRow_StubParameters_EP(1,15);
e1          = BoltRow_StubParameters_EP(1,16);
e2          = BoltRow_StubParameters_EP(1,17);

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

if ExteriorRow==1
    
    % Circular Pattern
    leff1 = 4 * pi * mx;
    leff2 = pi * mx + w + 2 * e1;
    leff3 = 2 * (pi * mx + e1);
    leff4 = pi * mx + w + 2 * (e1 + e2);

    leff_cp = min ([leff1 leff2 leff3 leff4]);

    % Non-Circular Pattern
    leff5 = 8 * mx + 2.5 * ex;
    leff6 = 0.5 * (2 * e1 + 2 * e2 + w);
    leff7 = 2 * mx + 0.625 * ex + e1 + 0.5 * w;
    leff8 = 4 * mx + 1.250 * ex + e1;
    leff9 = 2 * mx + 0.625 * ex + (e1 + e2);

    leff_nc = min ([leff5 leff6 leff7 leff8 leff9]);

else

    % Circular Pattern
    leff_cp = 4 * pi * m1;

    % Non-Circular Pattern
    leff_nc = alpha * m1;

end