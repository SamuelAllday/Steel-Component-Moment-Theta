function Steel_Component_Moment_Theta()
% Steel_Component_Moment_Theta
% Runs a displacement sweep on the beam tip, generates/executes an OpenSees
% model for each step, extracts:
%   - global joint rotation θ
%   - global joint moment M
%   - per-spring deformation histories
% and produces:
%   1) Moment–rotation backbone (global connection response)
%   2) Moment vs extension for each component spring segment
clear all; close all; clc;
    % ------------------------------------------------------------------
    % 1. Read input parameters and run pre-calculations
    % ------------------------------------------------------------------
    inp = read_input_params();
    modelData = pre_calc(inp);

    % ------------------------------------------------------------------
    % 2. Build list of target tip displacements (mm)
    %    One OpenSees analysis per target
    % ------------------------------------------------------------------
    DeltaTips = linspace(0, modelData.DeltaTipMax, modelData.nCases);

    allTheta_plot = zeros(size(DeltaTips));
    allM_plot     = zeros(size(DeltaTips));

    lastSpringCurves = [];
    lastMhist        = [];

    % ------------------------------------------------------------------
    % 3. Loop over displacement targets
    % ------------------------------------------------------------------
    for k = 1:numel(DeltaTips)
        DeltaTip = DeltaTips(k);

        % working directory for this case
        workDir = fullfile(modelData.baseDir, sprintf('case_%03d', k));
        if ~exist(workDir,'dir'), mkdir(workDir); end
        if ~exist(fullfile(workDir,'results'),'dir')
            mkdir(fullfile(workDir,'results'));
        end

        % 3a. build Tcl model for this displacement
        tclPath = build_tcl(modelData, DeltaTip, workDir);

        % 3b. run OpenSees
        [status, out] = run_opensees_once(tclPath, workDir); %#ok<NASGU>
        if status ~= 0
            warning('OpenSees returned nonzero status for case %d.', k);
        end

        % 3c. read global θ and M for this case
        res = read_results(workDir, modelData);
        theta_raw = res.theta_joint;    % rad
        M_raw     = res.M_support;      % Nmm

        % sign convention: downward tip displacement -> positive θ and M
        signFactor = -1.0;
        allTheta_plot(k) = signFactor * theta_raw;
        allM_plot(k)     = signFactor * M_raw;

        % 3d. read per-spring deformation history + global moment history
        [sprCurves, Mhist] = read_local_springs(workDir, modelData);
        lastSpringCurves   = sprCurves;
        lastMhist          = signFactor * Mhist; % apply same sign convention to moment
    end

    % ------------------------------------------------------------------
    % 4. Global moment–rotation plot
    % ------------------------------------------------------------------
    figure;
    plot_M_theta(allTheta_plot, allM_plot, 'Support shear × span');
    legend('Support shear × span','Location','best');
    xlabel('Rotation \theta (mrad)');
    ylabel('Moment (kN·m)');
    title('Connection Moment–Rotation Backbone (downward tip = +ve)');
    grid on;

    % ------------------------------------------------------------------
    % 5. Per-spring response: global moment vs local extension
    % ------------------------------------------------------------------
    plot_spring_vs_moment(lastSpringCurves, lastMhist);

end
