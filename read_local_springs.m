function [springCurves, Mhist] = read_local_springs(workDir, modelData)
% read_local_springs
% Reads per-spring deformation histories and the global moment history.
%
% OUTPUT:
%   springCurves(r).label
%   springCurves(r).segment(j).delta   [nSteps x 1] axial deformation history (mm)
%
%   springCurves(1)  -> compression row (bottom block)
%   springCurves(2+) -> tension rows
%
%   Mhist [nSteps x 1] global joint moment history in Nmm
%         computed as tip shear * span
%
% NOTE:
%   Compression row springs shorten under compression. We flip the sign so
%   compression is plotted as a positive "closing" extension.

    resultsDir = fullfile(workDir, modelData.resultsDirName);

    springCurves = struct;

    % --------------------------------------------------
    % Compression / shear chain (index 1)
    % --------------------------------------------------
    mc = numel(modelData.Kc);
    springCurves(1).label = 'compression_row';
    for i = 1:mc
        dfile = fullfile(resultsDir, sprintf('crow_%02d_defo.txt',  i));

        Di = [];
        if isfile(dfile)
            Di = readmatrix(dfile,'FileType','text'); % [nSteps x ?]
        end

        % zeroLength "deformation" gives relative DOF deformation:
        % [ux uy rz ...] at i-end rel. to j-end
        % We want axial deformation along DOF 1 => column 1
        if ~isempty(Di)
            axialDefo = Di(:,1); % mm
        else
            axialDefo = [];
        end

        % Flip sign so compression closure shows as positive extension
        axialDefo_plot = -axialDefo;

        springCurves(1).segment(i).delta = axialDefo_plot;
    end

    % --------------------------------------------------
    % Tension rows (index 2..end)
    % --------------------------------------------------
    nrows = numel(modelData.Kt);
    for r = 1:nrows
        springCurves(r+1).label = sprintf('tension_row_%d', r);

        C = numel(modelData.Kt{r});
        for j = 1:C
            dfile = fullfile(resultsDir, sprintf('trow_%02d_%02d_defo.txt',  r, j));

            Di = [];
            if isfile(dfile)
                Di = readmatrix(dfile,'FileType','text'); % [nSteps x ?]
            end

            if ~isempty(Di)
                axialDefo = Di(:,1); % mm
            else
                axialDefo = [];
            end

            % Keep sign for tension rows (positive extension in tension)
            springCurves(r+1).segment(j).delta = axialDefo;
        end
    end

    % --------------------------------------------------
    % Global moment history (Mhist)
    % --------------------------------------------------
    % We use beam900_force_local.txt recorded in write_springs.m:
    % recorder Element -file results/beam900_force_local.txt -ele 900 localForce
    %
    % For a 2D elasticBeamColumn, localForce reports:
    % [Ni Vi Mi Nj Vj Mj]
    %
    % Node 40 is the j-end. Take Vj (col 5) as tip shear.
    % Then M = Vj * Lb.
    %
    % Units:
    %   Vj in N
    %   Lb in mm
    %   Mhist in Nmm
    beamForceFile = fullfile(resultsDir,'beam900_force_local.txt');
    Mhist = [];
    if isfile(beamForceFile)
        bf = readmatrix(beamForceFile,'FileType','text'); % [nSteps x 6]
        if ~isempty(bf)
            Vj_hist = bf(:,5);        % N
            Lb      = modelData.Lb;   % mm
            Mhist   = Vj_hist .* Lb;  % Nmm
        end
    end
end
