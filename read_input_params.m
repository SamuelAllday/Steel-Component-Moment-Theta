function inp = read_input_params()
% read_input_params
% Hard-coded for now. Later this comes from GUI.

    % --- Geometry & section (mm, N) ---
    inp.d    = 500;
    inp.tf   = 20;
    inp.Lb   = 2000;      % beam length mm (node30 -> node40)
    % hcf will be computed in pre_calc

    % --- Beam section props ---
    inp.Ebeam = 210000;   % N/mm^2
    inp.Abeam = 5000;     % mm^2
    inp.Ibeam = 8e8;      % mm^4

    % --- 'Rigid' stubs that tie stations vertically ---
    inp.A_STIFF = 1.0e7;
    inp.I_STIFF = 1.0e10;

    % --- Aux materials for zeroLength ---
    inp.K_rigid   = 1.0e12;  % rigid for Ux & Uy
    inp.K_softRz  = 1.0e-6;  % tiny rotational keeper

    % --- Compression / shear chain at bottom flange ---
    % N/mm along Ux
    inp.Kc = [2.0e6, 3.0e6, 2.5e6];

    % --- Tension rows (ragged). Each row is series springs in Ux.
    inp.Kt = { [2.0e6, 3.0e6, 2.5e6], ...
               [3.2e6, 2.3e6, 2.6e6, 3.0e6], ...
               [4.2e6, 2.6e6, 5.6e6, 3.2e6] };

    % global y-positions for those rows (mm above joint centreline)
    inp.ht = [ +50; +300; +350 ];

    % --- Analysis control ---
    inp.nStepsPerCase = 10;     % number of load steps within OpenSees analysis
    inp.DeltaTipMax   = 5.0;    % final downward tip disp we want to reach (mm)
    inp.nCases        = 11;     % how many overall cases from 0 to DeltaTipMax

    % --- Paths ---
    inp.baseDir = '/Users/samuelallday/Documents/Y3/IP/ExampleScripts/Current Model';

end
