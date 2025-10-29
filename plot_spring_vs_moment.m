function plot_spring_vs_moment(springCurves, Mhist)
% plot_spring_vs_moment
% For each spring group (compression row, each tension row):
%   Plot global joint moment vs that spring segment's axial extension.

    % Convert Nmm → kN·m
    Mhist_kNm = Mhist / 1.0e6;

    nrows_total = numel(springCurves);

    figure;
    for r = 1:nrows_total
        subplot(nrows_total,1,r); hold on;

        % Skip row if it has no segments field
        if ~isfield(springCurves(r), 'segment') || isempty(springCurves(r).segment)
            title(sprintf('Row: %s  |  (no segment data)', springCurves(r).label), ...
                'Interpreter','none');
            xlabel('Spring extension \delta (mm)');
            ylabel('Global moment M (kN·m)');
            grid on;
            continue
        end

        nseg = numel(springCurves(r).segment);

        for j = 1:nseg
            % Skip if no delta data
            if ~isfield(springCurves(r).segment(j),'delta') || isempty(springCurves(r).segment(j).delta)
                continue
            end

            d = springCurves(r).segment(j).delta; % mm
            if isempty(d) || isempty(Mhist_kNm)
                continue
            end

            % Align lengths
            nCommon = min(numel(d), numel(Mhist_kNm));
            d_plot = d(1:nCommon);
            M_plot = Mhist_kNm(1:nCommon);

            plot(d_plot, M_plot, 'LineWidth', 1.2, ...
                'DisplayName', sprintf('seg %d', j));
        end

        grid on;
        xlabel('Spring extension \delta (mm)');
        ylabel('Global moment M (kN·m)');
        title(sprintf('Row: %s  |  M vs \\delta', springCurves(r).label), ...
            'Interpreter','none');
        legend('Location','best');
    end
end
