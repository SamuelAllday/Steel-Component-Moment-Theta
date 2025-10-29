# Steel Component Moment-Theta

MATLAB + OpenSees pipeline to generate a moment–rotation (M–θ) backbone for semi-rigid steel beam-to-column joints using a spring-row representation of the Eurocode 3 component method.

## How to run
1. Open MATLAB in this folder.
2. Run `Steel_Component_Moment_Theta`.
   - This runs a displacement sweep on the beam tip (node 40),
   - Calls OpenSees for each step,
   - Extracts joint rotation (node 30 RZ) and connection moment (support shear * span),
   - Enforces sign convention (downward deflection → positive),
   - Plots M–θ in kN·m vs mrad.

## Key scripts
- `Steel_Component_Moment_Theta.m` – driver / orchestrator
- `read_input_params.m` – geometry, springs, analysis settings
- `pre_calc.m` – derived geometry
- `build_tcl.m` – assembles .tcl model for each load case
  - `write_nodes.m`
  - `write_materials.m`
  - `write_springs.m`
  - `write_analysis_block.m`
- `run_opensees_once.m` – runs OpenSees and captures output
- `read_results.m` – parses OpenSees results into θ and M
- `plot_M_theta.m` – plots M–θ backbone
- `opensees_bin_guess.m` – locates OpenSees binary on system
