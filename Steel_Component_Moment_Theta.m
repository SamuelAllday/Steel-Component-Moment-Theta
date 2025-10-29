function Steel_Component_Moment_Theta()
% Steel_Component_Moment_Theta.m
% Master driver: builds, runs, reads, and plots the moment-rotation curve
% using support shear * span as the connection moment measure.
%
% Sign convention for plotting:
%   Downward tip displacement = positive rotation & positive moment.
%   -> We enforce that by multiplying results by signFactor = -1.

    % ---------- 1. Read inputs & pre-calcs ----------
    inp       = read_input_params();
    modelData = pre_calc(inp);

    % Tip displacement sweep in mm (magnitudes 0 -> DeltaTipMax).
    % We'll always push DOWN in the Tcl (negative increment), so "down" is what we care about.
    DeltaTips = linspace(0, modelData.DeltaTipMax, modelData.nCases); % e.g. [0 ... 5]

    % This factor encodes our sign convention:
    % In the raw OpenSees results, downward tip load gives negative theta and negative moment.
    % We want those to plot positive. So signFactor = -1.
    signFactor = -1.0;

    allTheta_plot = zeros(size(DeltaTips));  % rad (signed for plotting)
    allM_plot     = zeros(size(DeltaTips));  % Nmm (signed for plotting)

    for k = 1:numel(DeltaTips)
        DeltaTip = DeltaTips(k);

        % ---------- 2. Working directory for this case ----------
        workDir = fullfile(modelData.baseDir, sprintf('case_%03d', k));
        if ~exist(workDir,'dir'), mkdir(workDir); end
        if ~exist(fullfile(workDir,'results'),'dir')
            mkdir(fullfile(workDir,'results'));
        end

        % ---------- 3. Build Tcl model for this displacement target ----------
        tclPath = build_tcl(modelData, DeltaTip, workDir);

        % ---------- 4. Run OpenSees ----------
        [status, out] = run_opensees_once(tclPath, workDir); %#ok<NASGU>
        if status ~= 0
            warning('OpenSees returned nonzero status for case %d. Check console output.', k);
        end

        % ---------- 5. Read results ----------
        res = read_results(workDir, modelData);
        theta_raw = res.theta_joint;    % rad (likely negative for downward case)
        M_raw     = res.M_support;      % Nmm (likely negative for downward case)

        % Apply sign convention
        allTheta_plot(k) = signFactor * theta_raw;
        allM_plot(k)     = signFactor * M_raw;
    end

    % ---------- 6. Plot single backbone ----------
    figure;
    plot_M_theta(allTheta_plot, allM_plot, 'Support shear × span');

    legend('Support shear × span', 'Location', 'best');
    xlabel('Rotation \theta (mrad)');
    ylabel('Moment (kN·m)');
    title('Connection Moment–Rotation Backbone (Downward tip displacement = +ve)');
    grid on;

end
