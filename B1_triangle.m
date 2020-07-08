% condition B1(border present, which object is closer to the cross, response by moving a mouse) 
% triangle is closer to the cross

% number of images of this type 
n = 32;

% interval of x,y changes of axes for the triangle and square locations in % of x, y length
percentX_square = [15, 45]; 

percentX_triangle = [55, 85];
percentY_triangle = [40, 54];

for imagei = 1:n
    
    % draw arc
    figure(1), clf
    
    % parametrs of arc
    a = pi/4; % start of arc in radians
    b = 3*pi/4; % end of arc in radians
    h = 9; k = -4;  %(h,k) is the center of the circle
    r = 3; % radius
    
    % plot an arc
    t = linspace(a,b);
    x = r*cos(t) + h;
    y = r*sin(t) + k;
    plot(x,y, 'k')
    axis([h-r h+r k-r-1 k+r+1])
    axis square;
    
    % to get info about axes
    xAxis = get(gca,'xlim');
    yAxis = get(gca,'ylim');
    xlength = diff(xAxis);
    ylength = diff(yAxis);
    
    % X and Y coordinates of cross and triangle
    x_cross = 0.5*xlength+xAxis(1);
    y_cross = 0.3*ylength+yAxis(1);
    
    x_triangle = randi(percentX_triangle)/100*xlength+xAxis(1);
    y_triangle = randi(percentY_triangle)/100*ylength+yAxis(1);
    
    % distance between cross and triangle
    CrTr_distance = sqrt((x_triangle-x_cross)^2+(y_triangle-y_cross)^2);
    % distance between cross and square
    CrSq_distance = 1.5*CrTr_distance;
    
    % X and Y coordinates of square
    x_square = randi(percentX_square)/100*xlength+xAxis(1);
    y_square = sqrt(CrSq_distance^2-(x_square-x_cross)^2)+y_cross;
    
    if ~isreal(y_square)    % if y_square occasionaly is complex number, try another x
        while ~isreal(y_square) 
        x_square = randi(percentX_square)/100*xlength+xAxis(1);
        y_square = sqrt(CrSq_distance^2-(x_square-x_cross)^2)+y_cross;
        end
    end
     
    % plot cross, square and triangle
    hold on
    plot(x_cross, y_cross, '+k','LineWidth', 1, 'MarkerSize',10)
    hold on
    plot(x_square,y_square, 'ks', 'LineWidth', 1,'MarkerSize',13)
    hold on
    plot(x_triangle,y_triangle, 'k^','LineWidth', 1, 'MarkerSize',13);
    set(gca,'xtick',[],'ytick',[],'Xcolor','none','Ycolor','none') % remove axes

    % save image
    print(gcf,['B1_' num2str(imagei) '_triangle.png'],'-dpng','-r300');
end