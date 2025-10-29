function [Ft_CWB, k21, RepStr] = Get_EC3_daLima_CWB (Joint, Axis, DP, tdp, fyC, hc, rc, tcw, dnut, g, p, nTension, RepStr)

if Axis=="Minor" && Joint == "Cantilever"

    if DP=="One"; tcw=tcw*tdp; end 
    if DP=="Two"; tcw=tcw*2*tdp; end 
    
dm=dnut;
    
L = hc-1.5*rc;
b = g+0.9*dm;
c = p+0.9*dm;
a = L - b;
bm= max(0, L*(1-0.82*tcw^2/c^2*(1+sqrt(1+2.8*c^2/tcw/L))^2));
x0= L*((tcw/L)^0.6667+0.23*c/L*(tcw/L)^0.3333)*((b-bm)/(L-bm));

if b <= bm
   x=0; 
else
   x=-a+sqrt(a^2-(1.5*a*c)+(sqrt(3)*tcw/2)*(pi()*sqrt(L*(a+x0))+4*c));
end

beta  = b/L;
alpha = c/L;
k1 = 1.50; 
k2 = 1.63;
theta = 35 - 10*beta;
Leff= c + (L - b)*sind(theta);

if (b+c)/L >=0.5
   k=1.0; 
else
   k=0.7+0.6*(b+c)/L;
end

if hc/(L-b) >=0.7 &&  hc/(L-b) <=1
   rho=1.0; 
elseif hc/(L-b) >=1 &&  hc/(L-b) <=10
   rho=hc/(L-b);
end


mpl = 0.25*tcw^2*fyC;
vpl = tcw*fyC/sqrt(3);

F_local_flexure = 4*pi()*mpl/(1-b/L)*(sqrt(1-b/L)+2*c/pi()/L);
F_local_punch   = nTension*pi()*dm*vpl;
F_local_comb    = 4*mpl*( (pi()*sqrt(L*(a+x))+2*c)/(a+x) + (1.5*c*x+x^2)/(tcw*sqrt(3)*(a+x))  );
F_local         = min(F_local_punch, k*F_local_comb);
F_global         =k*F_local_comb/2 + mpl*(2*b/hc+pi()+2*rho);

Ft_CWB = min(F_local, F_global)* (10^-3);

%k21=2*tcw^3*Leff/((a/2)^3+2*1.3*a/2*tcw^3);
k21=16*tcw^3/L^2*(alpha+(1-beta)*tand(theta))/( (1-beta)^3 +( (10.4*(k1-k2*beta)/(L/tcw)^2)));

else    
    Ft_CWB    = Inf;
    k21       = Inf;
end

if Axis=="Minor" && Joint == "Cruciform"
% report string
RepStr{end+1}= ['- Column Web in Bending (CWB):'];
RepStr{end+1}='---------------------------------------------------------------';
if Axis=="Minor" && Joint == "Cantilever"
RepStr{end+1}= [''];
RepStr{end+1}= ['    F_local_flexure = ', num2str(round(F_local_flexure* (10^-3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    F_local_punch   = ', num2str(round(F_local_punch* (10^-3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    F_local_comb    = ', num2str(round(F_local_comb* (10^-3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    F_local = min{F_local_punch, k*F_local_comb}'];
RepStr{end+1}= ['            = ', num2str(round(F_local* (10^-3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['    F_global        = ', num2str(round(F_global* (10^-3))),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> Ft_CWB = min{Fc_CEB_local, Fc_CEB_global}'];
RepStr{end+1}= ['                             = ', num2str(round(Ft_CWB)),' kN'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k21 = ', num2str(round(k21)),' mm'];
else
RepStr{end+1}= ['                  --> Ft_CWB = Inf'];
RepStr{end+1}= [''];
RepStr{end+1}= ['                  --> k21 = Inf'];
end
RepStr{end+1}= [''];
RepStr{end+1}='---------------------------------------------------------------';
end