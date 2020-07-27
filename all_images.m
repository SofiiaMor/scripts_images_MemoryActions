% script for generating all images (2D scenes)

% number of unique images of each type
n = 16;

% X and Y coordinates of a cross 
x_cross = 0.5;
y_cross = 0.5;

% parametrs of arc
a = pi/4; % start of arc in radians
b = 3*pi/4; % end of arc in radians
h = 0.5; k = 0.35;  %(h,k) is the center of the circle
r = 0.6; % radius

% define an arc
t = linspace(a,b);
x = r*cos(t) + h;
y = r*sin(t) + k;

% initialize matrix for all x, y coordinates of triangle and square
x_square = zeros(1,n*4);
y_square = zeros(1,n*4);
x_triangle = zeros(1,n*4);
y_triangle = zeros(1,n*4);

triangle = [0 1 2 3]; % 0 - triangle is further from the cross, closer to the border,
% 1- it is closer to the cross, futher from the border,
% 2 - it is closer to the the cross, closer to the border,
% 3 - it is further from the cross, futher from the border

j = 0;
for trianglei = triangle
    for imagei = 1:n
        
        % x,y coordinates of the triangle and the square calling the function
        [triangle_X, triangle_Y, square_X,square_Y]=find_XY_triangle(x_cross,y_cross,x,y,trianglei);
        x_triangle(imagei+j)=triangle_X;
        y_triangle(imagei+j)=triangle_Y;
      
        x_square(imagei+j) = square_X;
        y_square(imagei+j) = square_Y;
    end
    j=j+n;
end

border = [0 1]; % 0 - without border, 1 - with border
for borderi = border
    if borderi == 0
        for imagei = 1:4*n
            % plot cross, square and triangle
            figure(1), clf
            plot(x_cross, y_cross, '+k','LineWidth', 1, 'MarkerSize',10)
            hold on
            plot(x_square(imagei),y_square(imagei), 'ks', 'LineWidth', 1,'MarkerSize',13)
            hold on
            plot(x_triangle(imagei),y_triangle(imagei), 'k^','LineWidth', 1, 'MarkerSize',13);
            axis([0 1 0 1]);
            axis square;
            set(gca,'xtick',[],'ytick',[],'Xcolor','none','Ycolor','none') % remove axes
            
            % save image
            if imagei<=n
                print(gcf,['A_' num2str(imagei) '_Sq2Cr_Tr2Br.png'],'-dpng','-r300');
            elseif imagei>n && imagei<=2*n
                print(gcf,['A_' num2str(imagei) '_Tr2Cr_Sq2Br.png'],'-dpng','-r300');
            elseif imagei>2*n && imagei<=3*n
                print(gcf,['A_' num2str(imagei) '_Tr2Cr_Tr2Br.png'],'-dpng','-r300');
            elseif imagei>3*n
                print(gcf,['A_' num2str(imagei) '_Sq2Cr_Sq2Br.png'],'-dpng','-r300');
            end
        end
    else
        for imagei = 1:4*n
            % plot cross, square,triangle and border
            figure(1), clf
            plot(x_cross, y_cross, '+k','LineWidth', 1, 'MarkerSize',10)
            hold on
            plot(x_square(imagei),y_square(imagei), 'ks', 'LineWidth', 1,'MarkerSize',13)
            hold on
            plot(x_triangle(imagei),y_triangle(imagei), 'k^','LineWidth', 1, 'MarkerSize',13);
            hold on
            plot(x, y, 'k')
            axis([0 1 0 1]);
            axis square;
            set(gca,'xtick',[],'ytick',[],'Xcolor','none','Ycolor','none') % remove axes
            
            % save image
            if imagei<=n
                print(gcf,['B_' num2str(imagei) '_Sq2Cr_Tr2Br.png'],'-dpng','-r300');
            elseif imagei>n && imagei<=2*n
                print(gcf,['B_' num2str(imagei) '_Tr2Cr_Sq2Br.png'],'-dpng','-r300');
            elseif imagei>2*n && imagei<=3*n
                print(gcf,['B_' num2str(imagei) '_Tr2Cr_Tr2Br.png'],'-dpng','-r300');
            elseif imagei>3*n
                print(gcf,['B_' num2str(imagei) '_Sq2Cr_Sq2Br.png'],'-dpng','-r300');
            end
        end
    end
end

%% export all x,y coordinates of the tringle and square in xls file

% normalize relative to the middle of the screen (0,0) in Psychopy
allXY = [x_square' y_square' x_triangle' y_triangle']-0.5;

output = num2cell([(1:4*n)' allXY]);
typeImag = cell(4*n,1);
typeImag(1:n)={'Sq2Cr_Tr2Br'};
typeImag(n+1:2*n)={'Tr2Cr_Sq2Br'};
typeImag(2*n+1:3*n)={'Tr2Cr_Tr2Br'};
typeImag(3*n+1:end)={'Sq2Cr_Sq2Br'};

variableNames = {'n image', 'x_square', 'y_square', 'x_triangle', 'y_triangle', 'image type'};
xlsfilename = ['TrSqCoordinates_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.xls'];           
xlswrite(xlsfilename,[variableNames; output, typeImag]); % write to xls file
