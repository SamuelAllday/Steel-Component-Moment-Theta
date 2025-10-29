function write_materials(fid, modelData)
% write_materials
% Writes uniaxialMaterial for each compression- and tension-row spring segment

    Kc = modelData.Kc;
    Kt = modelData.Kt;

    fprintf(fid,'# === Row spring materials ===\n');

    % Compression row materials 5101, 5102, ...
    mc = numel(Kc);
    for i = 1:mc
        fprintf(fid,'uniaxialMaterial Elastic %d %.10g\n', 5100+i, Kc(i));
    end

    % Tension rows materials 5200 + r*10 + j
    nt = numel(Kt);
    for r = 1:nt
        krow = Kt{r};
        C = numel(krow);
        for j = 1:C
            matID = 5200 + r*10 + j;
            fprintf(fid,'uniaxialMaterial Elastic %d %.10g\n', matID, krow(j));
        end
    end

    fprintf(fid,'\n');
end
