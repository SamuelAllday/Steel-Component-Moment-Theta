function modelData = pre_calc(inp)
% pre_calc
% Adds derived geometric info, reference datum, IDs, etc.

    modelData = inp;

    % half-distance from compression flange to tension flange
    % same as in your script:
    modelData.hcf = 0.5*(inp.d - inp.tf);  % mm

    % for clarity keep node naming convention same as your Tcl:
    % 10,20,30 are stations down the stack (all x=0)
    % 40 is the beam tip at x = Lb
    % etc. We don't actually assemble here, just store:
    modelData.nodeIDs.base    = 10;
    modelData.nodeIDs.stat2   = 20;
    modelData.nodeIDs.stat3   = 30;
    modelData.nodeIDs.tip     = 40;

    % pass through:
    modelData.resultsDirName = 'results';

end
