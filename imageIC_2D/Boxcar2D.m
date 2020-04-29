xlen = 7.6;
ylen = 5.12;

pattern_shift_x = 0.25; % Do not exceed half of the pitch length

pitch = 1;
base_height = 0.25;
bump_height = 0.75;

numpixel_x = 192;
numpixel_y = 128;

fname = 'boxcar';

%=====================
nshift = round(pattern_shift_x/xlen * numpixel_x,0);
numpitch = round(pitch/xlen * numpixel_x,0);
numbaseheight = round(base_height/ylen * numpixel_y,0);
numbumpheight = round(bump_height/ylen * numpixel_y,0);
numrepeat = round(numpixel_x/(numpitch/2),0) + 1;

figleft = 0;
figbottom = 0;
figwidth = numpixel_x;
figheight = numpixel_y;

pattern_color = [1 1 1]; %white
blank_color = [0 0 0]; %black
fig = figure('Color',blank_color,'Position',[figleft, figbottom, figwidth, figheight]);
set(fig, 'PaperPositionMode', 'auto');
set(gcf, 'InvertHardCopy', 'off'); % setting 'grid color reset' off
axis off;
axis equal;
set(gca,'xlim',[0, figwidth]);
set(gca,'ylim',[0, figheight]);
set(gca,'position',[0 0 1 1]);
set(gca,'Color', blank_color);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);
hold on;
%draw shorter rectangle first
for i=0:numrepeat
    col = pattern_color;
    xLeft = 0 + i * numpitch/2 - nshift;
    yBottom = 0;
    width = numpitch/2;
    if (mod(i,2) == 0 )
        height = numbaseheight;
    else
        height = numbaseheight+numbumpheight;
    end
    rectangle('Position', [xLeft, yBottom, width, height], 'EdgeColor', col, 'FaceColor', col, 'LineWidth', 1);
end

saveas(fig,fullfile([fname, '.png']));

