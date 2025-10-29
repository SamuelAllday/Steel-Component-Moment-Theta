function conn = build_connection_springs_from_gui(guiData)
% build_connection_springs_from_gui
% Assemble per-row tension chains and compression chain from EC3 GET_* funcs.
% NEW RULE: All tension mechanisms exist on EVERY bolt row; their total
% stiffness is split equally across nrow.

    % -------------------------
    % Basic vars from GUI/temp
    % -------------------------
    if ~isfield(guiData,'ConType'), guiData.ConType = "EEP"; end
    ConType = upper(string(guiData.ConType));

    if ~isfield(guiData,'nrow') || guiData.nrow < 1
        error('guiData.nrow is missing or invalid.');
    end
    nrow = guiData.nrow;

    % -------------------------
    % Row heights ht(r)
    % -------------------------
    % Prefer true bolt-row y-coordinates from the GUI. If not present, compute
    % placeholders (keeps pipeline running; replace once temp.mat provides rows).
    if isfield(guiData,'rowY_raw_mm')
        ht_mm = guiData.rowY_raw_mm(:);
    elseif isfield(guiData,'ht_row_mm')
        ht_mm = guiData.ht_row_mm(:);
    else
        % TEMP fallback: equally spaced rows above the joint centre
        % (this will be replaced by a function pulling from temp.mat geometry)
        ht_mm = linspace(50, 300, nrow).';
    end

    % -------------------------
    % Component stiffness (N/mm)
    % Convert your (Force[kN], kX[mm]) to linearised stiffness:
    %     K ≈ (F * 1000) / kX
    % For any kX == Inf (rigid), use a very large stiffness.
    % -------------------------
    K_BIG = 1.0e12;   % N/mm, used when EC3 returns k = Inf

    RepStr = {};

    % ---- BOLT tension ----
    % Needs: fub, As, L_bolt, Preload, gamma_M2, gamma_M7
    [Ft_Rd_BOLT, k10, ~] = Get_EC3_BOLT( ...
        guiData.fub, guiData.As, guiData.L_bolt, guiData.Preload, ...
        guiData.gamma_M2, guiData.gamma_M7, RepStr);
    K_bolt_total = (Ft_Rd_BOLT*1000) / k10;   % N/mm

    % ---- End-plate bending (EPB) ----
    % Needs: many EP geometry params; you’ve provided the function already.
    [Ft_EPB, ~, k5, ~, ~] = Get_EC3_EPB( ...
        guiData.tep, guiData.fyP, ...
        guiData.m_ep, guiData.n_ep, guiData.n1_ep, guiData.n2_ep, ...
        guiData.nBoltperRow, guiData.nBoltsTotal, Ft_Rd_BOLT, ...
        guiData.leff1_EP, guiData.leff2_EP, guiData.gamma_M0, ...
        guiData.As, guiData.Lgrip, guiData.dwasher, guiData.Prying, RepStr);
    K_epb_total = (Ft_EPB*1000) / k5;

    % ---- Column flange bending (CFB) ----
    [Ft_CFB, ~, k4, ~, ~] = Get_EC3_CFB( ...
        guiData.JointType, guiData.Axis, ...
        guiData.tcf, guiData.tbp, guiData.fyC, ...
        guiData.m_cf, guiData.n_cf, guiData.n1_cf, guiData.n2_cf, ...
        guiData.nBoltperRow, guiData.nBoltsTotal, Ft_Rd_BOLT, ...
        guiData.leff1_CF, guiData.leff2_CF, guiData.gamma_M0, ...
        guiData.As, guiData.Lgrip, guiData.dwasher, guiData.Prying, RepStr);
    K_cfb_total = (Ft_CFB*1000) / k4;

    % ---- Column web in transverse tension (CWT) ----
    [Ft_wc_Rd, k3, ~] = Get_EC3_CWT( ...
        guiData.JointType, guiData.Axis, guiData.Ac, guiData.dwc, ...
        guiData.bcf, guiData.tcf, guiData.tcw, guiData.rc, guiData.beta, ...
        guiData.beff_t_cw, guiData.gamma_M0, RepStr);
    K_cwt_total = (Ft_wc_Rd*1000) / k3;

    % ---- Beam web in tension (BWT) ----
    [Ft_wb_Rd, k8, ~] = Get_EC3_BWT( ...
        guiData.tbw, guiData.fyB, guiData.beff_t_wb, guiData.gamma_M0, RepStr);
    if isinf(k8)
        K_bwt_total = K_BIG;
    else
        K_bwt_total = (Ft_wb_Rd*1000) / k8;
    end

    % -------------------------
    % Compression chain
    % -------------------------
    % ---- Column web compression (CWC) ----
    [Fc_cw_Rd, k2, ~] = Get_EC3_CWC( ...
        guiData.JointType, guiData.Axis, guiData.ColSec, guiData.StiffenerC, ...
        guiData.DP, guiData.NcNy, guiData.E, guiData.fyC, guiData.Ac, ...
        guiData.hc, guiData.dwc, guiData.bcf, guiData.rc, guiData.tbf, ...
        guiData.tweld, guiData.tcf, guiData.tcw, guiData.s, guiData.sp, ...
        guiData.beta, guiData.gamma_M0, guiData.gamma_M1, RepStr);
    K_cwc = (Fc_cw_Rd*1000) / k2;

    % ---- Column web shear (CWS) ----
    [Fs_wc_Rd, k1, ~] = Get_EC3_CWS( ...
        ConType, guiData.JointType, guiData.Axis, guiData.SingleRow, ...
        guiData.ColSec, guiData.StiffenerC, guiData.fyC, guiData.Ac, ...
        guiData.hc, guiData.bcf, guiData.hb, guiData.tbf, guiData.tcf, ...
        guiData.tcw, guiData.rc, guiData.beta, guiData.tstiffC, ...
        guiData.tdp, guiData.fyP, guiData.z, guiData.gamma_M0, RepStr);
    K_cws = (Fs_wc_Rd*1000) / k1;

    % ---- Beam flange compression block (BFC) ----
    [Fc_BFC, k7, ~] = Get_EC3_BFC(guiData.Mc_Rd, guiData.hb, guiData.tbf, RepStr);
    if isinf(k7)
        K_bfc = K_BIG;
    else
        K_bfc = (Fc_BFC*1000) / k7;
    end

    % -------------------------
    % Split tension stiffness across ALL rows (your rule)
    % -------------------------
    K_bolt_share = K_bolt_total / nrow;
    K_epb_share  = K_epb_total  / nrow;
    K_cfb_share  = K_cfb_total  / nrow;
    K_cwt_share  = K_cwt_total  / nrow;
    K_bwt_share  = K_bwt_total  / nrow;

    % Order is fixed for plotting & consistency:
    % [BOLT, EPB, CFB, CWT/CWB, BWT]
    baseChain = [K_bolt_share, K_epb_share, K_cfb_share, K_cwt_share, K_bwt_share];

    Kt_cell = cell(nrow,1);
    for r = 1:nrow
        chain_here = baseChain;
        % Trim trailing zeros (if any mechanism deemed absent)
        lastNZ = find(chain_here > 0, 1, 'last');
        if isempty(lastNZ), lastNZ = 1; end
        Kt_cell{r} = chain_here(1:lastNZ);
    end

    % Compression series: [CWC, CWS, BFC]
    Kc_vec = [K_cwc, K_cws, K_bfc];

    % -------------------------
    % Return
    % -------------------------
    conn.ConType = ConType;
    conn.ht_mm   = ht_mm(:);
    conn.Kt_cell = Kt_cell;
    conn.Kc_vec  = Kc_vec;
end
