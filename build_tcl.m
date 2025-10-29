function tclPath = build_tcl(modelData, DeltaTip, workDir)
% build_tcl
% Creates a Tcl file in workDir for this displacement target.

    resultsDir = fullfile(workDir, modelData.resultsDirName);
    if ~exist(resultsDir,'dir'), mkdir(resultsDir); end

    tclPath = fullfile(workDir,'ParametricJointModel.tcl');
    fid = fopen(tclPath,'w'); 
    if fid<=0
        error('Cannot open %s for writing.', tclPath);
    end

    % --- Header / model declaration ---
    fprintf(fid,'wipe\n');
    fprintf(fid,'model BasicBuilder -ndm 2 -ndf 3\n\n');

    fprintf(fid,'set hcf %.10g\n', modelData.hcf);
    fprintf(fid,'file mkdir %s\n', modelData.resultsDirName);

    % Global aux uniaxial materials shared by multiple elements (rigid trans, soft rot)
    fprintf(fid,'# Aux uniaxial materials\n');
    fprintf(fid,'uniaxialMaterial Elastic 99  %.10g   ;# rigid (Ux,Uy)\n', modelData.K_rigid);
    fprintf(fid,'uniaxialMaterial Elastic 11  %.10g   ;# very soft Rz keeper\n', modelData.K_softRz);
    fprintf(fid,'\n');

    % --- Nodes, boundary conds, beam elements, stiff columns ---
    write_nodes(fid, modelData);

    % --- Materials for compression and tension rows ---
    write_materials(fid, modelData);

    % --- Springs (zeroLength) + recorders for rows, flange couplers, beam etc. ---
    write_springs(fid, modelData);

    % --- Analysis block for this case (DisplacementControl to reach DeltaTip) ---
    write_analysis_block(fid, modelData, DeltaTip);

    fclose(fid);
end
