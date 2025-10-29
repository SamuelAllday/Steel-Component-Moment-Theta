function write_analysis_block(fid, modelData, DeltaTip)
% write_analysis_block
% Writes loading, analysis procedure, DisplacementControl, summary output.
%
% We apply downward displacement at node 40 DOF 2.
% In your original script: negative is down. So we'll pass -DeltaTip.

    nSteps = modelData.nStepsPerCase;
    dU     = -DeltaTip / nSteps;   % increment per step (mm, negative downward)

    fprintf(fid,'# === Minimal reference load to satisfy DisplacementControl ===\n');
    fprintf(fid,'timeSeries Linear 101\n');
    fprintf(fid,'pattern Plain 1 101 {\n');
    fprintf(fid,'  load 40 0.0 -1.0 0.0\n');  % tiny downward load at tip
    fprintf(fid,'}\n\n');

    fprintf(fid,'# === Analysis ===\n');
    fprintf(fid,'constraints Plain\n');
    fprintf(fid,'numberer RCM\n');
    fprintf(fid,'system UmfPack\n');
    fprintf(fid,'test EnergyIncr 1.0e-8 50 0\n');
    fprintf(fid,'algorithm Newton\n');
    fprintf(fid,'set controlNode 40\n');
    fprintf(fid,'set controlDoF  2\n');
    fprintf(fid,'set dU %.10g\n', dU);
    fprintf(fid,'integrator DisplacementControl $controlNode $controlDoF $dU\n');
    fprintf(fid,'analysis Static\n');
    fprintf(fid,'set nSteps %d\n', nSteps);
    fprintf(fid,'set ok [analyze $nSteps]\n');

    % summary output block (joint_summary.out)
    fprintf(fid,'# --- Joint summary (ux uy rz Fx Fy Mz) ---\n');
    fprintf(fid,'set UX30 [lindex [nodeDisp 30] 0]\n');
    fprintf(fid,'set UY30 [lindex [nodeDisp 30] 1]\n');
    fprintf(fid,'set RZ30 [lindex [nodeDisp 30] 2]\n');
    fprintf(fid,'set R30  [nodeReaction 30]\n');
    fprintf(fid,'set Fx30 [lindex $R30 0]\n');
    fprintf(fid,'set Fy30 [lindex $R30 1]\n');
    fprintf(fid,'set M30 [lindex $R30 2]\n');
    fprintf(fid,'set fp [open "results/joint_summary.out" "w"]\n');
    fprintf(fid,'puts $fp [format "%%.12g %%.12g %%.12g %%.12g %%.12g %%.12g" $UX30 $UY30 $RZ30 $Fx30 $Fy30 $M30]\n');
    fprintf(fid,'flush $fp\n');
    fprintf(fid,'close $fp\n');
    fprintf(fid,'\n');

    fprintf(fid,'if {$ok != 0} { puts "ANALYSIS FAILED: $ok" } else { puts "ANALYSIS COMPLETE" }\n');

end
