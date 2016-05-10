function [u, v] = LucasKanadeWTC(T, It1, rect)
%% CV Spring 2016 - Cole Gulino
% Get the u,v that minimizes the squared error of the images
% Inputs: 
%   T:                  Template for original image
%   It1:                Image frame at t + 1
%   rect:               4x1 vector [x1,y1,x2,y2] of corners of rectangle on
%                       It where (x1,y1) is top-left corner and (x2,y2) is
%                       the bottom-right corner.
% Outputs:
%   u:                  template offset in x
%   v:                  template offset in y
%% Preallocate the vectors and set constants
warp_jacobian = [1 0; 0 1]; % Warp Jacobian
u = 0; % Initial guess for u
v = 0; % Initial guess for v
iter = 0; % Initialize iterator
max_iter = 100000000; % Max number of iterations
th = 0.0000001; % threshold
X = meshgrid(rect(1):rect(3),1); % Meshgrid of column values for rectangle
Y = meshgrid(rect(2):rect(4),1); % Meshgrid of row values for rectangle
%% Main loop
while(iter < max_iter)
    % Warp It1
    It1_w = imtranslate(It1, [u,v], 'FillValues', 0);
    % Computer the error image
    It1_rect = It1_w(Y,X); % Rt+1
    It1_rect = reshape(It1_rect, [size(It1_rect,1)*size(It1_rect,2),1]); % vectorize
    T = reshape(T, [size(T,1)*size(T,2),1]); % vectorize
    diff_im = It1_rect - T; % Difference image
    % Get the warp gradient
    [Ix, Iy] = gradient(It1_w); % Gradient
    Ix = Ix(Y,X); % Get derivative wrt x of rectangle
    Iy = Iy(Y,X); % Get derivative wrt y of rectangle
    Ix = reshape(Ix, [size(Ix,1)*size(Ix,2),1]); % vectorize
    Iy = reshape(Iy, [size(Iy,1)*size(Iy,2),1]); % vectoriz
    del_I = [Ix Iy]; % Gradient of the rectangle of warped image
    % Compute the Hessian
    H = (del_I*warp_jacobian)'*(del_I*warp_jacobian);
    % Compute steepest descent parameter updates
    steep_param = (del_I*warp_jacobian)'*(diff_im);
    % compute change in p
    del_p = H \ steep_param;
    del_u = del_p(1); % Get u component
    del_v = del_p(2); % Get v component
    % Update the parameters
    u = u + del_u;
    v = v + del_v;
    % Check to see if change in u and v have reached the threshold
    if(abs(del_u) < th && abs(del_v) < th)
        break;
    end
    iter = iter + 1;
end
%% Return u and v
if(u < 0)
    u = -round(abs(u));
else
    u = round(u);
end
if(v < 0)
    v = -round(abs(v));
else
    v = round(v);
end
u = - u;
v = - v;