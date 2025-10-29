function write_springs(fid, modelData)
% write_springs
% zeroLength elements for:
%  - flange couplers (rigid in Ux,Uy; weak in Rz)
%  - compression chain at bottom flange
%  - tension rows
% also recorders

    hcf = modelData.hcf;
    Kc  = modelData.Kc;
    Kt  = modelData.Kt;
    ht  = modelData.ht;
    nt  = numel(ht);

    fprintf(fid,'# === Flange couplers via zeroLength (rigid Ux,Uy; soft Rz) ===\n');
    fprintf(fid,'element zeroLength 8001 21 22 -mat 99 99 11 -dir 1 2 3\n');
    fprintf(fid,'element zeroLength 8002 12 13 -mat 99 99 11 -dir 1 2 3\n');
    fprintf(fid,'\n');

    % --- Compression/shear chain @ y=-hcf ---
    fprintf(fid,'# === Compression/shear chain (11 -> ... -> 12) at y=-hcf ===\n');
    mc = numel(Kc);

    % intermediate nodes at y=-hcf
    for i = 2:mc
        nid = 1110 + (i-1);
        fprintf(fid,'node %d 0.0 %.10g\n', nid, -hcf);
        fprintf(fid,'fix %d 0 1 0\n', nid);
    end

    % zeroLength elements in series
    for i = 1:mc
        eleId = 1100 + i;
        if i==1
            nI = 11;
        else
            nI = 1110+(i-1);
        end
        if i==mc
            nJ = 12;
        else
            nJ = 1110+i;
        end
        matID = 5100+i;

        fprintf(fid,'element zeroLength %d %d %d -mat %d 99 11 -dir 1 2 3\n', ...
            eleId, nI, nJ, matID);

        fprintf(fid,'recorder Element -file results/crow_%02d_force.txt -ele %d force\n', ...
            i, eleId);
    end
    fprintf(fid,'\n');

    % --- Tension rows ---
    fprintf(fid,'# === Tension rows (series springs at y=ht(r)) ===\n');

    for r = 1:nt
        krow = Kt{r};
        C = numel(krow);

        % intermediate chain nodes for this row
        if C>1
            for j = 2:C
                nid = 22100 + r*10 + (j-1);
                fprintf(fid,'node %d 0.0 %.10g\n', nid, ht(r));
                fprintf(fid,'fix %d 0 1 0\n', nid);
            end
        end

        % now zeroLength elements for that row
        for j = 1:C
            eleId = 2200 + r*10 + j;
            if j==1
                nI = 200+r;
            else
                nI = 22100 + r*10 + (j-1);
            end
            if j==C
                nJ = 300+r;
            else
                nJ = 22100 + r*10 + j;
            end
            matID = 5200 + r*10 + j;

            fprintf(fid,'element zeroLength %d %d %d -mat %d 99 11 -dir 1 2 3\n', ...
                eleId, nI, nJ, matID);

            fprintf(fid,'recorder Element -file results/trow_%02d_%02d_force.txt -ele %d force\n', ...
                r, j, eleId);
        end
    end

    fprintf(fid,'\n');

    % Global recorders you had
    fprintf(fid,'# === Recorders ===\n');
    fprintf(fid,'recorder Node -file results/station3_rz.out    -node 30 -dof 3 disp\n');
    fprintf(fid,'recorder Node -file results/station3_ux.out    -node 30 -dof 1 disp\n');
    fprintf(fid,'recorder Element -file results/beam900_force_local.txt -ele 900 localForce\n');
    fprintf(fid,'recorder Node -file results/station3_react.out -time -node 30 -dof 1 2 3 reaction\n');
    fprintf(fid,'recorder Node -file results/node30_disp_time.out -time -node 30 -dof 1 2 3 disp\n');
    fprintf(fid,'\n');

end
