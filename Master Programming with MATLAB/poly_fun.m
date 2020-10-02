function fh = poly_fun(p)
    n = length(p);
    function polynomial = poly(x,deg,t)
      
      if nargin == 1
          deg = n-1;
          t = flip(p); 
%           flip is being used since it was assumed that 
%           initially the elements of p were in decreasing degree while 
%           they are in fact increasing
      end
      temp = x.^deg.*t(1);
      if deg==0
          polynomial = temp;
      else
          polynomial = temp + poly(x,deg-1,t(2:end));
      end
      
    end
fh = @poly;
end