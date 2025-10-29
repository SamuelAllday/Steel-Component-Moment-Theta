function [springCurves, Mhist] = read_local_springs(workDir, modelData)
% Reads per-step spring deformations and beam moment history
% without relying on modelData.compSegNames.

    res = fullfile(workDir, modelData.resultsDirName);

    % --- Moment history from beam element 900 ---
    fBeam = fullfile(res,'beam900_force_local_hist.txt');
    if isfile(fBeam)
        B = readmatrix(fBeam,'FileType','text');    % [Ni Vi Mi Nj Vj Mj] per step
        if ~isempty(B) && size(B,2) >= 3
            Mhist = B(:,3);                         % Mi at node 30 (Nmm)
        else
            Mhist = [];
        end
    else
        Mhist = [];
    end

    % --- Determine number of compression segments (CWC–CWS–BFC) ---
    if isfield(modelData,'Kc')
        Nc = numel(modelData.Kc);
    elseif isfield(modelData,'comp_K')
        Nc = numel(modelData.comp_K);
    else
        Nc = 0;
    end

    % --- Prepare output containers ---
    nrows = numel(modelData.Kt);
    outCount = nrows + (Nc > 0);
    springCurves = repmat(struct('label','','segment',[]), outCount, 1);

    idx = 0;

    % --- Compression block first (if present) ---
    if Nc > 0
        idx = idx + 1;
        crow.label = 'Compression block (CWC–CWS–BFC)';
        crow.segment = struct('delta',[]);
        for i = 1:Nc
            f = fullfile(res, sprintf('crow_%02d_defo.txt', i));
            if isfile(f)
                D = readmatrix(f,'FileType','text');   % zeroLength deformation: col1 = ΔUx
                if ~isempty(D)
                    crow.segment(i).delta = abs(D(:,1));  % plot compression as positive
                else
                    crow.segment(i).delta = [];
                end
            else
                crow.segment(i).delta = [];
            end
        end
        springCurves(idx) = crow;
    end

    % --- Tension rows: one entry per row, segments along chain ---
    for r = 1:nrows
        idx = idx + 1;
        row.label = sprintf('Row %d (tension chain)', r);
        C = numel(modelData.Kt{r});
        row.segment = struct('delta',[]);
        for j = 1:C
            f = fullfile(res, sprintf('trow_%02d_%02d_defo.txt', r, j));
            if isfile(f)
                D = readmatrix(f,'FileType','text');
                if ~isempty(D)
                    row.segment(j).delta = D(:,1);  % ΔUx (mm)
                else
                    row.segment(j).delta = [];
                end
            else
                row.segment(j).delta = [];
            end
        end
        springCurves(idx) = row;
    end
end
