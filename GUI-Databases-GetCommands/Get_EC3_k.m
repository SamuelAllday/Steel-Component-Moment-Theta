
function [k3, k4, k5]=Get_EC3_k(leff_CF, leff_EP, mi, m_cf, tcw, tcf, tep, dwc)

k3     = 0.7 * leff_CF * tcw / dwc;        
k4     = 0.9 * leff_CF * tcf^3 / m_cf^3;
k5     = 0.9 * leff_EP * tep^3 / mi^3;
