function result = name_value_pairs(varargin)
n = nargin;
if rem(n,2)~=0|n==0   %check for odd and no arguments
    result=cell(0);
    return
end
for i = 1:2:n   %check if odd arguments are char
    if ~ischar(varargin{i})
        result = cell(0);
        return
    end
end
result = cell(n/2,2);
for i = 1:n/2
        result{i,1} = varargin{2*i-1};
        result{i,2} = varargin{2*i};
end
end
