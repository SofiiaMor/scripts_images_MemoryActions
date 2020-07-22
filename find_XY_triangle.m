function [triangle_X, triangle_Y,square_X,square_Y]=find_XY_triangle(x_cross,y_cross,x,y,triangle)
% the function searches for x and y coordinates of the square and triangle according to known conditions and coordinates of the cross and arc

% % triangle = [0 1 2 3]; 
% % 0 - triangle is further from the cross, closer to the border,
% % 1 - it is closer to the cross, futher from the border,
% % 2 - it is closer to the the cross, closer to the border,
% % 3 - it is further from the cross, futher from the border

switch triangle
    case 0, ratDist1 = 1.5; ratDist2 = 1/1.5; % ratio of distances to the cross and to the border
    case 1, ratDist1 = 1/1.5; ratDist2 = 1.5;
    case 2, ratDist1 = 1/1.5; ratDist2 = 1/1.5;
    case 3, ratDist1 = 1.5; ratDist2 = 1.5;
end

% intervals of x,y changes for the square locations in % of x, y length
percentX_square = [25:40, 60:75];
percentY_square = [25:40, 60:75];

toggle = 1;

while toggle
    % x,y coordinates of the square
    square_X = percentX_square(randperm(length(percentX_square),1))/100;
    square_Y = percentY_square(randperm(length(percentY_square),1))/100;
    
    % distance between cross and square
    CrSq_distance = sqrt((square_X-x_cross)^2+(square_Y-y_cross)^2);
    
    % distance between cross and possible triangle location (radius of a circle around the cross)
    CrTr_distance = ratDist1*CrSq_distance;
    
    % distance between the square and arc
    BrSq_distance = min(sqrt((x-square_X).^2+(y-square_Y).^2));
    
    % distance between arc and possible triangle location
    BrTr_distance = BrSq_distance*ratDist2;
    
    % initialize matrix of points belonging circles around each point of the arc
    x_intr_circles = zeros(1, length(x)-1);
    y_intr_circles = zeros(1, length(x)-1);
    
    for ci = 1:length(x)-1  % for each point of the arc
        
        % intersection of 2 circles (around two neighbor points of the arc)
        [xout,yout] = circcirc(x(ci), y(ci),BrTr_distance, x(ci+1), y(ci+1),BrTr_distance);
        
        % take only the intersection point down the arc
        yout2 = yout(yout<y(ci));
        xout2 = xout(yout<y(ci));
        x_intr_circles(ci) = xout2;
        y_intr_circles(ci) = yout2;
    end
    
    % equation of the circle around the first point of the arc
    t = linspace(1,360);
    x_circle1=x(1)+BrTr_distance*cos(t/180*pi);
    y_circle1=y(1)+BrTr_distance*sin(t/180*pi);
    
    % equation of the circle around the last point of the arc
    x_circle_last=x(end)+BrTr_distance*cos(t/180*pi);
    y_circle_last=y(end)+BrTr_distance*sin(t/180*pi);
    
    % get only points of the circle around the first point of the arc down the arc
    x_circle1_points=x_circle1(x_circle1>=x_intr_circles(1)& y_circle1<=y_intr_circles(1));
    y_circle1_points=y_circle1(x_circle1>=x_intr_circles(1)& y_circle1<=y_intr_circles(1));
    
    % get only points of the circle around the last point of the arc down the arc
    x_circle_last_points=x_circle_last(x_circle_last<=x_intr_circles(end)& y_circle_last<=y_intr_circles(end));
    y_circle_last_points=y_circle_last(x_circle_last<=x_intr_circles(end)& y_circle_last<=y_intr_circles(end));
    
    % get all points together around the arc
    all_points_x = [x_circle_last_points x_intr_circles x_circle1_points];
    all_points_y = [y_circle_last_points y_intr_circles y_circle1_points];
    
    % distances between the cross and all points around the arc
    CrAll_points_distance = sqrt((all_points_x-x_cross).^2+(all_points_y-y_cross).^2);
    
    % min distances from the cross to the nearest 70 points
    [CrAll_points_distance_min, ind] = sort(CrAll_points_distance);
    CrAll_points_distance_min = CrAll_points_distance_min(1:70);
    ind = ind(1:70);
    
    % check if mean of that distances is approximately equall to radius of a circle around the cross - CrTr_distance)
    if mean(CrAll_points_distance_min)> CrTr_distance-0.05 && mean(CrAll_points_distance_min) < CrTr_distance+0.05
        toggle = 0;
    end
end

% coordinates of the triangle (random point from this set of 70 points with min distance to the cross)
ind2 = randi(numel(ind));
triangle_X = all_points_x(ind(ind2));
triangle_Y = all_points_y(ind(ind2));
end