function e = detectZeroCrossings(im, sigma, width)
    % define a laplacian of gaussian filter
    h = fspecial('log', width, sigma);

    % filter image
    b = imfilter(im, h, 'replicate');

    [m,n] = size(b);

    % The output edge map
    e = false(m,n);

    rr = 2:m-1; cc=2:n-1;

    thresh = 0.1;

    % Look for the zero crossings
    [rx,cx] = find( b(rr,cc) == 0 & b(rr,cc+1) > 0 ...
        & abs( b(rr,cc)-b(rr,cc+1) ) > thresh );   % [- +]
    e((rx+1) + cx*m) = true;
    [rx,cx] = find( b(rr,cc-1) > 0 & b(rr,cc) == 0 ...
        & abs( b(rr,cc-1)-b(rr,cc) ) > thresh );   % [+ -]
    e((rx+1) + cx*m) = true;
    [rx,cx] = find( b(rr,cc) == 0 & b(rr+1,cc) > 0 ...
        & abs( b(rr,cc)-b(rr+1,cc) ) > thresh);   % [- +]'
    e((rx+1) + cx*m) = true;
    [rx,cx] = find( b(rr-1,cc) > 0 & b(rr,cc) == 0 ...
        & abs( b(rr-1,cc)-b(rr,cc) ) > thresh);   % [+ -]'
    e((rx+1) + cx*m) = true;
end

