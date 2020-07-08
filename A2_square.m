% condition A2(no border, which object is closer to the cross, response by a button)
% square is closer to the cross

% number of images of this type
n = 32;

% interval of x,y changes of axes for the triangle and square locations in % of x, y length
percentX_square = [15, 45];
percentY_square = [40, 54];

percentX_triangle = [55, 85];

% X and Y coordinates of cross
x_cross = 0.5;
y_cross = 0.3;

for imagei = 1:n
   
    figure(1), clf
    
    % plotting cross
    plot(x_cross, y_cross, '+k','LineWidth', 1, 'MarkerSize',10)
    axis([0 1 0 1]);
    axis square;
    
    % to get info about axes
    xAxis = get(gca,'xlim');
    yAxis = get(gca,'ylim');
    xlength = diff(xAxis);
    ylength = diff(yAxis);
    
    % X and Y coordinates of square
    x_square = randi(percentX_square)/100*xlength+xAxis(1);
    y_square = randi(percentY_square)/100*ylength+yAxis(1);
    
    % distance between cross and square
    CrSq_distance = sqrt((x_square-x_cross)^2+(y_square-y_cross)^2);
    % distance between cross and triangle
    CrTr_distance = 1.5*CrSq_distance;
    
    % X and Y coordinates of triangle
    x_triangle = randi(percentX_triangle)/100*xlength+xAxis(1);
    y_triangle = sqrt(CrTr_distance^2-(x_triangle-x_cross)^2)+y_cross;
    
    if ~isreal(y_triangle)    % if y_triangle occasionaly is complex number, try another x
        while ~isreal(y_triangle)
            x_triangle = randi(percentX_triangle)/100*xlength+xAxis(1);
            y_triangle = sqrt(CrTr_distance^2-(x_triangle-x_cross)^2)+y_cross;
        end
    end
    
    % plot square and triangle
    hold on
    plot(x_square,y_square, 'ks', 'LineWidth', 1,'MarkerSize',13)
    hold on
    plot(x_triangle,y_triangle, 'k^','LineWidth', 1, 'MarkerSize',13);
    set(gca,'xtick',[],'ytick',[],'Xcolor','none','Ycolor','none') % remove axes
    
    % save image
    print(gcf,['A2_' num2str(imagei) '_square.png'],'-dpng','-r300');
end
