function M = LucasKanadeAffine(It, It1)
%% CV Spring 2016 - Cole Gulino
% Get the u,v that minimizes the squared error of the images
% Inputs: 
%   It:                 Image frame at t
%   It1:                Image frame at t + 1
% Outputs:
%   M:                  3x3 Matrix specifying the affine warp
%                       M = [1+a    b   c]
%                           [d     1+e  f]
%                           [0      0   1]
%% Preallocate the vectors and set constants
p = [0 0 0 0 0 0]'; % [a b c d e f] % first guess of p
iter = 0; % Initialize iterator
max_iter = 10000000; % Max number of iterations
th = 0.00000001; % threshold
% X = meshgrid(1:1:size(It,2),1);
% X = repmat(X, size(It,1),1);
% Y = meshgrid(1:1:size(It,1),1)';
% Y = repmat(Y, 1,size(It,2));
%% Main loop
while(iter < max_iter)
    % Warp It1
    M = [1+p(1), p(2), p(3);
         p(4), 1+p(5), p(6);
         0, 0, 1];
    It1_w = warpH(It1, M, [size(It1,1), size(It1,2)]);
    % Get the warp gradient
    [Ix, Iy] = imgradientxy(It1_w); % Gradient
    [row, col] = find(~It1_w);
    for i = 1:size(row,1)
        Ix(row(i), col(i)) = 0;
        Iy(row(i), col(i)) = 0;
    end
    % Computer the error image
    It1_w = reshape(It1_w, [size(It1_w,1)*size(It1_w,2), 1]); % vectorize
    It = reshape(It, [size(It,1)*size(It,2), 1]); % vectorize
    diff_im = It1_w - It; % Difference image
    % Get the warp gradient
    Ix = reshape(Ix, [size(Ix,1)*size(Ix,2),1]); % vectorize
    Iy = reshape(Iy, [size(Iy,1)*size(Iy,2),1]); % vectorize
    % Compute the steepest descent images 
    X = meshgrid(1:size(It1,2),1); % X values
    X = repmat(X, size(It1,1),1);
    X = reshape(X, [size(X,1)*size(X,2),1]);
    Y = meshgrid(1:size(It1,1),1)'; % Y values
    Y = repmat(Y, 1, size(It1,2));
    Y = reshape(Y, [size(Y,1)*size(Y,2),1]);
    save('XYs.mat', 'X', 'Y');
    steep_des = [X.*Ix, Y.*Ix, Ix, X.*Iy, Y.*Iy, Iy];
    % Compute the Hessian
    H = steep_des'*steep_des;
    % Compute steepest descent parameter updates
    steep_param = steep_des'*(diff_im);
    % compute change in p
    del_p = H \ steep_param;
    % Update the parameters
    p = p + del_p;
    % Check to see if change in u and v have reached the threshold
    if(abs(del_p(1))< th && abs(del_p(2))<th && abs(del_p(3))<th && abs(del_p(4))<th && abs(del_p(5))<th && abs(del_p(6))<th)
        break;
    end
    iter = iter + 1;
end
%% Return M
p = -p;
M = [1+p(1), p(2), p(3);
     p(4), 1+p(5), p(6);
     0, 0, 1];
end

