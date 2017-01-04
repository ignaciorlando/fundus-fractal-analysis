function [n_cap, n_inf, n_corr, r] = boxcount(c,varargin)
%BOXCOUNT  Box-Counting of a D-dimensional array (with D=1,2,3).
%   [N, R] = BOXCOUNT(C), where C is a D-dimensional array (with D=1,2,3),
%   counts the number N of D-dimensional boxes of size R needed to cover
%   the nonzero elements of C. The box sizes are powers of two, i.e., 
%   R = 1, 2, 4 ... 2^P, where P is the smallest integer such that
%   MAX(SIZE(C)) <= 2^P. If the sizes of C over each dimension are smaller
%   than 2^P, C is padded with zeros to size 2^P over each dimension (e.g.,
%   a 320-by-200 image is padded to 512-by-512). The output vectors N and R
%   are of size P+1. For a RGB color image (m-by-n-by-3 array), a summation
%   over the 3 RGB planes is done first.
%
%   The Box-counting method is useful to determine fractal properties of a
%   1D segment, a 2D image or a 3D array. If C is a fractal set, with
%   fractal dimension DF < D, then N scales as R^(-DF). DF is known as the
%   Minkowski-Bouligand dimension, or Kolmogorov capacity, or Kolmogorov
%   dimension, or simply box-counting dimension.
%
%   F. Moisy
%   Revision: 2.10,  Date: 2008/07/09

% History:
% 2006/11/22: v2.00, joined into a single file boxcountn (n=1,2,3).
% 2008/07/09: v2.10, minor improvements
% 2017/02/01: v3.00, by José Ignacio Orlando (CONICET, Argentina), support
% for information and correlation dimension

% control input argument
error(nargchk(1,2,nargin));

% check for true color image (m-by-n-by-3 array)
if ndims(c)==3
    if size(c,3)==3 && size(c,1)>=8 && size(c,2)>=8
        c = sum(c,3);
    end
end

warning off
c = logical(squeeze(c));
warning on

dim = ndims(c); % dim is 2 for a vector or a matrix, 3 for a cube

% transpose the vector to a 1-by-n vector
if length(c)==numel(c)
    dim=1;
    if size(c,1)~=1   
        c = c';
    end   
end

width = max(size(c));    % largest size of the box
p = log(width)/log(2);   % nbre of generations

% remap the array if the sizes are not all equal,
% or if they are not power of two
% (this slows down the computation!)
if p~=round(p) || any(size(c)~=width)
    % get the highest power of 2
    p = ceil(p);
    % compute the new width
    width = 2^p;
    % generate the new image
    mz = zeros(width, width);
    % put current image in the very corner of the new image
    mz(1:size(c,1), 1:size(c,2)) = c;
    % reassign to c, c_inf and c_cor
    c = mz;
    c_inf = mz;
    c_cor = mz;
else
    c_inf = c;
    c_cor = c;
end

% pre-allocate arrays for box counting
n_cap=zeros(1,p+1); % pre-allocate the number of box of size r
n_inf=zeros(1,p); % pre-allocate the number of box of size r
n_cor=zeros(1,p); % pre-allocate the number of box of size r


%------------------- 2D boxcount ---------------------%

% n_cap for r=0 will be the total amount of pixels in the segmentation
n_cap(p+1) = sum(c(:));
% n_inf must be undefined when r=0
M = sum(c(:));

% we will iterate from the smallest grid size to the highest one
for g=(p-1):-1:0
    
    % current grid size
    siz = 2^(p-g);
    % size in each direction
    siz2 = round(siz/2);
    
    % initialize current_n_inf in 0
    current_n_inf = zeros(size(c_inf));
    % initialize current_n_inf in 0
    current_n_corr = zeros(size(c_inf));

    % for each box
    for i=1:siz:(width-siz+1)
        for j=1:siz:(width-siz+1)
            
            % count if there is something inside the box
            c(i,j) = ( c(i,j) || c(i+siz2,j) || c(i,j+siz2) || c(i+siz2,j+siz2) );
            
            % sum-up all positive responses and accumulate them in the new
            % grid
            c_inf(i,j) = ( c_inf(i,j) + c_inf(i+siz2,j) + c_inf(i,j+siz2) + c_inf(i+siz2,j+siz2) );
            % divide current value by the mass of the box to get p_i
            p_i = c_inf(i,j) / M;
            % compute the entropy
            if p_i ~= 0
                current_n_inf(i,j) = p_i * log(p_i);
            end
            % compute the squared probability for correlation dimension 
            current_n_corr(i,j) = p_i^2;
            
        end
    end
    
    % assign n_cap
    n_cap(g+1) = sum(sum(c(1:siz:(width-siz+1),1:siz:(width-siz+1))));
    % assign n_inf
    n_inf(g+1) = - sum(sum(current_n_inf(1:siz:(width-siz+1),1:siz:(width-siz+1))));
    % assign n_inf
    n_corr(g+1) = sum(sum(current_n_corr(1:siz:(width-siz+1),1:siz:(width-siz+1))));
    
end

% reorganize n_cap
n_cap = n_cap(end:-1:1);
% reorganize n_inf
n_inf = n_inf(end:-1:1);
% reorganize n_corr
n_corr = n_corr(end:-1:1);

r = 2.^(0:p); % box size (1, 2, 4, 8...)

if nargout==0
    clear r n_cap n_inf
end
