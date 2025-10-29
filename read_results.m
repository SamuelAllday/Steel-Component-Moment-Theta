function res = read_results(workDir, modelData)
% read_results
% Pulls joint rotation and connection moment estimated as support shear * span.
% NOTE: signs are NOT altered here. The driver will interpret signs.

    resultsDir = fullfile(workDir, modelData.resultsDirName);

    % --- joint_summary.out ---
    summaryFile = fullfile(resultsDir,'joint_summary.out');
    if ~isfile(summaryFile)
        error('Missing %s. Analysis may have failed.', summaryFile);
    end
    raw = fileread(summaryFile);
    nums = sscanf(raw,'%f'); % ux30 uy30 rz30 Fx30 Fy30 M30
    if numel(nums) < 6
        error('joint_summary.out malformed.');
    end

    rz30 = nums(3); % rotation at node 30 [rad], OpenSees sign (clockwise negative)
    % Fy30 = nums(5); % vertical reaction at node 30 [N], unused here

    % --- beam900_force_local.txt ---
    beamForceFile = fullfile(resultsDir,'beam900_force_local.txt');
    if ~isfile(beamForceFile)
        error('Missing %s.', beamForceFile);
    end
    bf = readmatrix(beamForceFile,'FileType','text');
    if isempty(bf)
        error('beam900_force_local.txt has no data.');
    end

    % Last row = converged step
    Vj = bf(end,5);  % shear at node40 [N]

    % Support-based connection moment
    Lb = modelData.Lb;       % mm
    M_support = Vj * Lb;     % Nmm (OpenSees sign convention)

    % Pack raw (unflipped) results
    res.theta_joint  = rz30;        % rad
    res.M_support    = M_support;   % Nmm
    res.Vj           = Vj;          % N  (debug)
end
