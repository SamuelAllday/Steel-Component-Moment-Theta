function write_nodes(fid, modelData)
% write_nodes
% Nodes, fixities, stiff vertical bars, beam element 900

    d        = modelData.d;
    tf       = modelData.tf;
    hcf      = modelData.hcf;
    Lb       = modelData.Lb;

    Ebeam    = modelData.Ebeam;
    Abeam    = modelData.Abeam;
    Ibeam    = modelData.Ibeam;

    A_STIFF  = modelData.A_STIFF;
    I_STIFF  = modelData.I_STIFF;

    ht       = modelData.ht;    % vector of y's for tension rows
    nt       = numel(ht);

    fprintf(fid,'# === Nodes === (all zeroLength endpoints co-located at x=0)\n');
    fprintf(fid,'node 10 0.0  0.0\n');
    fprintf(fid,'node 20 0.0  0.0\n');
    fprintf(fid,'node 30 0.0  0.0\n');
    fprintf(fid,'node 40 %.10g 0.0\n', Lb);  % beam tip

    % Bottom flange chain y = -hcf
    fprintf(fid,'node 11 0.0 %.10g\n', -hcf);
    fprintf(fid,'node 12 0.0 %.10g\n', -hcf);
    fprintf(fid,'node 13 0.0 %.10g\n', -hcf);

    % Top flange pair y = +hcf
    fprintf(fid,'node 21 0.0 %.10g\n', +hcf);
    fprintf(fid,'node 22 0.0 %.10g\n', +hcf);

    % Tension row ends (left S2 and right S3 ends)
    for r = 1:nt
        fprintf(fid,'node %d 0.0 %.10g\n', 200+r, ht(r));  % left side/station2
        fprintf(fid,'node %d 0.0 %.10g\n', 300+r, ht(r));  % right side/station3
    end
    fprintf(fid,'\n');

    fprintf(fid,'# === Fixities ===\n');
    fprintf(fid,'fix 10 1 1 1\n');   % base fully fixed
    fprintf(fid,'fix 20 0 1 0\n');   % station2
    fprintf(fid,'fix 30 0 1 0\n');   % station3
    fprintf(fid,'fix 40 0 0 0\n');   % beam tip transl free, rot free
    fprintf(fid,'\n');

    fprintf(fid,'# === Very-stiff vertical bars (nonzero length via Δy) ===\n');
    fprintf(fid,'geomTransf Linear 1\n');
    fprintf(fid,'set AStiff %.10g\n', A_STIFF);
    fprintf(fid,'set EStiff %.10g\n', Ebeam);
    fprintf(fid,'set IStiff %.10g\n', I_STIFF);

    % "columns" tying base(10) to flange nodes (11,21 etc.), matching your script IDs
    fprintf(fid,'element elasticBeamColumn 7001 10 11 $AStiff $EStiff $IStiff 1\n');
    fprintf(fid,'element elasticBeamColumn 7002 10 21 $AStiff $EStiff $IStiff 1\n');
    fprintf(fid,'element elasticBeamColumn 7191 20 12 $AStiff $EStiff $IStiff 1\n');
    fprintf(fid,'element elasticBeamColumn 7190 20 22 $AStiff $EStiff $IStiff 1\n');
    fprintf(fid,'element elasticBeamColumn 7390 30 13 $AStiff $EStiff $IStiff 1\n');

    for r = 1:nt
        fprintf(fid,'element elasticBeamColumn %d 20 %d $AStiff $EStiff $IStiff 1\n', ...
            7100+r, 200+r);
    end
    for r = 1:nt
        fprintf(fid,'element elasticBeamColumn %d 30 %d $AStiff $EStiff $IStiff 1\n', ...
            7300+r, 300+r);
    end

    % beam along x from node30 to node40 (element 900)
    fprintf(fid,'element elasticBeamColumn 900 30 40 %.10g %.10g %.10g 1\n', ...
        Abeam, Ebeam, Ibeam);

    fprintf(fid,'\n');
end
