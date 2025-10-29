function [status, out] = run_opensees_once(tclPath, workDir)
% run_opensees_once
% Calls OpenSees on the given Tcl file and returns status + console text.

    exe = opensees_bin_guess();

    % run OpenSees in that folder, like your cmd = sprintf('cd ...')
    cmd = sprintf('cd "%s"; "%s" "%s"', workDir, exe, tclPath);
    [status, out] = system(cmd);
end
