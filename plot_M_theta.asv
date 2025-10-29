function plot_M_theta(thetaVec_rad, Mvec_Nmm, curveLabel)
% plot_M_theta
% Converts θ (rad) → mrad and M (N·mm) → kN·m, and plots the curve.

    % --- Unit conversions ---
    theta_mrad = thetaVec_rad * 1000.0;   % rad → mrad
    M_kNm      = Mvec_Nmm / 1.0e6;        % N·mm → kN·m

    % --- Plot ---
    plot(theta_mrad, M_kNm, 'o-', ...
        'DisplayName', curveLabel, ...
        'LineWidth', 1.5);

    grid on;
    xlabel('Rotation \theta (mrad)');
    ylabel('Moment (kN·m)');
end
