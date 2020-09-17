% script for generating images for the second experiment (with joystick):
% only square and triangle are presented, without cross
% 50% - square is closer to the cross, 50% - triangle

% number of unique images of each type
n = 32;

% initialize matrix for all x, y coordinates of triangle and square
x_square = zeros(1,n*2);
y_square = zeros(1,n*2);
x_triangle = zeros(1,n*2);
y_triangle = zeros(1,n*2);

% initialize vector of distances between square and triangle in all images
ObjectDist = zeros(1,n*2);

% intervals of x,y changes for the square locations from -0.25 to 0.25, (0,0) - the middle of the screen
percentX_square = [-25:-15, 15:25];
percentY_square = [-25:-15, 15:25];

triangle = [0 1]; % 0 - triangle is further from the cross, 1 - closer to the cross
j = 0;
% get all x,y coordinates of objects
for trianglei = triangle
    switch trianglei
        case 0, ratDist = 1.5;  % ratio of distance between the cross and triangle
        case 1, ratDist = 1/1.5;
    end
    for imagei = 1:n
        % x,y coordinates of the square
        square_X = percentX_square(randperm(length(percentX_square),1))/100;
        square_Y = percentY_square(randperm(length(percentY_square),1))/100;
        
        % distance between cross(0,0) and square
        CrSq_distance = sqrt((square_X-0)^2+(square_Y-0)^2);
        
        % distance between cross and possible triangle location (radius of a circle around the cross)
        CrTr_distance = ratDist*CrSq_distance;
        
        % equation of the circle around the cross - all possible x,y coordinates of the triangle
        t = linspace(1,360);
        x_triangleAll=0+CrTr_distance*cos(t/180*pi);
        y_triangleAll=0+CrTr_distance*sin(t/180*pi);
        
        SqTr_angle = 0;
        while rad2deg(SqTr_angle) < 60
            % choose one random position
            id = randperm(length(x_triangleAll),1);
            triangle_X = x_triangleAll(id);
            triangle_Y = y_triangleAll(id);
            % distance between square and triangle
            SqTr_distance = sqrt((square_X-triangle_X)^2+(square_Y-triangle_Y)^2);
            % angle between square and triangle
            SqTr_angle = acos((CrTr_distance^2+CrSq_distance^2-SqTr_distance^2)/(2*CrTr_distance*CrSq_distance));
        end
        
        ObjectDist(imagei+j) = SqTr_distance;
        x_triangle(imagei+j)=triangle_X;
        y_triangle(imagei+j)=triangle_Y;
        
        x_square(imagei+j) = square_X;
        y_square(imagei+j) = square_Y;
    end
    j=j+n;
end
%% draw objects and save images
same = 1;  % 1 - the same objects (circles), 0 - different (square and triangle)
for imagei = 1:2*n
    % plot square and triangle
    figure(1), clf
    h1=plot(x_square(imagei),y_square(imagei));
    hold on
    h2=plot(x_triangle(imagei),y_triangle(imagei));
    if same == 1
        properties1 = {'Marker','LineWidth','MarkerSize','MarkerEdgeColor','MarkerFaceColor'};
        values1 = {'o',1,11,[0.3 0.3 0.3],[0.3 0.3 0.3]};
        properties2 = properties1;
        values2 = values1;
    else
        properties1 = {'Color','Marker','LineWidth','MarkerSize'};
        values1 = {'k','s',1,13};
        properties2 = {'Color','Marker','LineWidth','MarkerSize'};
        values2 = {'k','^',1,13};
    end
    set(h1,properties1,values1)
    set(h2,properties2,values2)
    axis([-0.5 0.5 -0.5 0.5]);
    axis square;
    set(gca,'xtick',[],'ytick',[],'Xcolor','none','Ycolor','none') % remove axes
    % save images
    if same == 0
        if imagei<=n
            print(gcf,[num2str(imagei) '_Sq2Cr.png'],'-dpng','-r300');
        else
            print(gcf,[num2str(imagei) '_Tr2Cr.png'],'-dpng','-r300');
        end
    else
        print(gcf,[num2str(imagei) '_circles.png'],'-dpng','-r300');
    end
end
%% export coordinates of objects in xls table
minObjectDist = zeros(1,n*2);
minObjectDist(1) = min(ObjectDist);
output = num2cell([x_square' y_square' x_triangle' y_triangle']);
typeImag = cell(2*n,1);
if same == 0
    for k = 1 : n
        typeImag{k} = [num2str(k) '_Sq2Cr.png'];
    end
    for k = n+1:2*n
        typeImag{k} = [num2str(k) '_Tr2Cr.png'];
    end
else
    for k = 1:2*n
        typeImag{k} = [num2str(k) '_circles.png'];
    end
end
variableNames = {'x_square', 'y_square', 'x_triangle', 'y_triangle', 'image name', 'min distance between objects'};
xlsfilename = ['TrSqCoordinates2_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.xls'];           
xlswrite(xlsfilename,[variableNames; output, typeImag, num2cell(minObjectDist')]); % write to xls file
