function pos = Hough(im, Iedges)
    %returns the location of the vanishing point
    
    % get the gradient
    [~,grad_dir]=imgradient(im);
    grad_dir = - grad_dir;

    %Now find all the edge locations, and add their orientations (cos theta,sin theta). 
    %  row, col is  y,x
    [row, col] = find(Iedges);
    % Each edge is a 4-tuple:   (x, y, cos theta, sin theta)   
    edges = [col, row, zeros(length(row),1), zeros(length(row),1) ];
    for k = 1:length(row)
         edges(k,3) = cos(grad_dir(row(k),col(k))/180.0*pi);
         edges(k,4) = sin(grad_dir(row(k),col(k))/180.0*pi);
    end

    % Find the vanishing point
    [X,Y] = size(Iedges);
    count = zeros(X,Y); %zeros array

    % Apply voting
    for k = 1:length(row)
        theta = grad_dir(row(k),col(k))/180.0*pi;

        % horizontally
        if theta < 0.78 || theta > 2.36
            for x = 1:X
                rho = round((edges(k,1) * cos(theta)) + (edges(k,2) * sin(theta)));
                y = round((rho - cos(theta) * x)/ sin(theta)) ;

                if y < Y && y > 0
                    count(x, y) = count(x, y) + 1;
                end
            end
        else % vertically
            for y = 1:Y
                rho = round((edges(k,1) * cos(theta)) + (edges(k,2) * sin(theta)));
                x = round((rho - sin(theta) * y)/ cos(theta)) ;
                if x < X && x > 0
                    count(x, y) = count(x, y) + 1;
                end
            end
        end
    end

    % count
    [val, idx] = max(count);

    [val2, idx2]= max(val);

    pos = [idx(idx2) idx2];
end

