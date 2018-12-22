% Create a movie from a series of plots
fig1 = figure;
fps= 2;
outfile = sprintf('%s','stoch_process.avi');
mov = avifile(outfile,'fps',fps,'quality',100);
numframes = 35;

set(fig1,'NextPlot','replacechildren');
for i=1:numframes
        fig_name = sprintf('stoch_step%d_unsorted.fig', i); % Replace with wanted names of figs
        step_name = sprintf('Step %d', i);
        fig1=openfig(fig_name);
        xlabel('Index');
        ylabel('Probability');
        title(step_name);
        winsize = get(fig1,'Position');
        winsize(1:2) = [0 0];
        pause(1);% put this plot in a movieframe
        % In case plot title and axes area are needed
        F = getframe(fig1,winsize);
        % For clean plot without title and axes
        %F = getframe;
        mov = addframe(mov,F);
        %pause(1);
        close all;
end
% save movie
 mov = close(mov);
