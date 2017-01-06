function [estimate,nbias,sigma,descriptor]=mutual_information(x,y,descriptor,approach,base)
%INFORMATION   Estimates the mutual information of two stationary signals with
%              independent pairs of samples using various approaches.
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH) or
%   [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH,BASE)
%
%   ESTIMATE     : The mutual information estimate
%   NBIAS        : The N-bias of the estimate
%   SIGMA        : The standard error of the estimate
%   DESCRIPTOR   : The descriptor of the histogram, see also HISTOGRAM2
%
%   X,Y          : The time series to be analyzed, both row vectors
%   DESCRIPTOR   : Where DESCRIPTOR=[LOWERBOUNDX,UPPERBOUNDX,NCELLX;
%                                    LOWERBOUNDY,UPPERBOUNDY,NCELLY]
%     LOWERBOUND?: Lowerbound of the histogram in ? direction
%     UPPERBOUND?: Upperbound of the histogram in ? direction
%     NCELL?     : The number of cells of the histogram  in ? direction 
%   APPROACH     : The method used, one of the following ones :
%     'unbiased' : The unbiased estimate (default)
%     'mmse'     : The minimum mean square error estimate
%     'biased'   : The biased estimate
%   BASE         : The base of the logarithm; default e
%
%   See also: http://www.cs.rug.nl/~rudy/matlab/

%   R. Moddemeijer 
%   Copyright (c) by R. Moddemeijer
%   $Revision: 1.1 $  $Date: 2001/02/05 08:59:36 $

    if nargin <1
       disp('Usage: [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y)')
       disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR)')
       disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH)')
       disp('       [ESTIMATE,NBIAS,SIGMA,DESCRIPTOR] = INFORMATION(X,Y,DESCRIPTOR,APPROACH,BASE)')
       disp('Where: DESCRIPTOR = [LOWERBOUNDX,UPPERBOUNDX,NCELLX;')
       disp('                     LOWERBOUNDY,UPPERBOUNDY,NCELLY]')
       return
    end

    % Some initial tests on the input arguments

    [NRowX,NColX]=size(x);

    if NRowX~=1
      error('Invalid dimension of X');
    end;

    [NRowY,NColY]=size(y);

    if NRowY~=1
      error('Invalid dimension of Y');
    end;

    if NColX~=NColY
      error('Unequal length of X and Y');
    end;

    if nargin>5
      error('Too many arguments');
    end;

    if nargin==2
      [h,descriptor]=histogram2(x,y);
    end;

    if nargin>=3
      [h,descriptor]=histogram2(x,y,descriptor);
    end;

    if nargin<4
      approach='unbiased';
    end;

    if nargin<5
      base=exp(1);
    end;

    lowerboundx=descriptor(1,1);
    upperboundx=descriptor(1,2);
    ncellx=descriptor(1,3);
    lowerboundy=descriptor(2,1);
    upperboundy=descriptor(2,2);
    ncelly=descriptor(2,3);

    estimate=0;
    sigma=0;
    count=0;

    % determine row and column sums

    hy=sum(h);
    hx=sum(h');

    for nx=1:ncellx
      for ny=1:ncelly
        if h(nx,ny)~=0 
          logf=log(h(nx,ny)/hx(nx)/hy(ny));
        else
          logf=0;
        end;
        count=count+h(nx,ny);
        estimate=estimate+h(nx,ny)*logf;
        sigma=sigma+h(nx,ny)*logf^2;
      end;
    end;

    % biased estimate

    estimate=estimate/count;
    sigma   =sqrt( (sigma/count-estimate^2)/(count-1) );
    estimate=estimate+log(count);
    nbias   =(ncellx-1)*(ncelly-1)/(2*count);

    % conversion to unbiased estimate

    if approach(1)=='u'
      estimate=estimate-nbias;
      nbias=0;
    end;

    % conversion to minimum mse estimate

    if approach(1)=='m'
      estimate=estimate-nbias;
      nbias=0;
      lambda=estimate^2/(estimate^2+sigma^2);
      nbias   =(1-lambda)*estimate;
      estimate=lambda*estimate;
      sigma   =lambda*sigma;
    end;

    % base transformation

    estimate=estimate/log(base);
    nbias   =nbias   /log(base);
    sigma   =sigma   /log(base);

end


function [result,descriptor]=histogram2(x,y,descriptor)
%HISTOGRAM2 Computes the two dimensional frequency histogram of two
%           row vectors x and y.
%   [RESULT,DESCRIPTOR] = HISTOGRAM2(X,Y) or
%   [RESULT,DESCRIPTOR] = HISTOGRAM2(X,Y,DESCRIPTOR) or
%where
%   DESCRIPTOR = [LOWERX,UPPERX,NCELLX;
%                 LOWERY,UPPERY,NCELLY]
%
%   RESULT       : A matrix vector containing the histogram
%   DESCRIPTOR   : The used descriptor
%
%   X,Y          : The row vectors to be analyzed
%   DESCRIPTOR   : The descriptor of the histogram
%     LOWER?     : The lowerbound of the ? dimension of the histogram
%     UPPER?     : The upperbound of the ? dimension of the histogram
%     NCELL?     : The number of cells of the ? dimension of the histogram
%
%   See also: http://www.cs.rug.nl/~rudy/matlab/

%   R. Moddemeijer 
%   Copyright (c) by R. Moddemeijer
%   $Revision: 1.2 $  $Date: 2001/02/05 09:54:29 $

if nargin <1
   disp('Usage: RESULT = HISTOGRAM2(X,Y)')
   disp('       RESULT = HISTOGRAM2(X,Y,DESCRIPTOR)')
   disp('Where: DESCRIPTOR = [LOWERX,UPPERX,NCELLX;')
   disp('                     LOWERY,UPPERY,NCELLY]')
   return
end

% Some initial tests on the input arguments

[NRowX,NColX]=size(x);

if NRowX~=1
  error('Invalid dimension of X');
end;

[NRowY,NColY]=size(y);

if NRowY~=1
  error('Invalid dimension of Y');
end;

if NColX~=NColY
  error('Unequal length of X and Y');
end;

if nargin>3
  error('Too many arguments');
end;

if nargin==2
  minx=min(x);
  maxx=max(x);
  deltax=(maxx-minx)/(length(x)-1);
  ncellx=ceil(length(x)^(1/3));
  miny=min(y);
  maxy=max(y);
  deltay=(maxy-miny)/(length(y)-1);
  ncelly=ncellx;
  descriptor=[minx-deltax/2,maxx+deltax/2,ncellx;miny-deltay/2,maxy+deltay/2,ncelly];
end;

lowerx=descriptor(1,1);
upperx=descriptor(1,2);
ncellx=descriptor(1,3);
lowery=descriptor(2,1);
uppery=descriptor(2,2);
ncelly=descriptor(2,3);

if ncellx<1 
  error('Invalid number of cells in X dimension')
end;

if ncelly<1 
  error('Invalid number of cells in Y dimension')
end;

if upperx<=lowerx
  error('Invalid bounds in X dimension')
end;

if uppery<=lowery
  error('Invalid bounds in Y dimension')
end;

result(1:ncellx,1:ncelly)=0;

xx=round( (x-lowerx)/(upperx-lowerx)*ncellx + 1/2 );
yy=round( (y-lowery)/(uppery-lowery)*ncelly + 1/2 );
for n=1:NColX
  indexx=xx(n);
  indexy=yy(n);
  if indexx >= 1 & indexx <= ncellx & indexy >= 1 & indexy <= ncelly
    result(indexx,indexy)=result(indexx,indexy)+1;
  end;
end;
end