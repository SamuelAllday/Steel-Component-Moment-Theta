function exe = opensees_bin_guess()
% opensees_bin_guess
% Tries some common paths. Same logic you had, just standalone.

    exe = getenv('OPENSEES_BIN');
    if ~isempty(exe)
        if isfile(exe)
            return;
        end
    end

    cands = { ...
        fullfile(getenv('HOME'),'Applications','OpenSees','bin','OpenSees'), ...
        '/opt/homebrew/bin/OpenSees', ...
        '/usr/local/bin/OpenSees', ...
        'OpenSees' };

    for i=1:numel(cands)
        if isfile(cands{i}) || ~isempty(which(cands{i}))
            exe = cands{i};
            return;
        end
    end

    error('OpenSees binary not found. Set OPENSEES_BIN or edit opensees_bin_guess().');
end
