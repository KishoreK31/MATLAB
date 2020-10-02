function result = rev2(vec)
m = ceil(length(vec)/2);
if length(vec)==2
    result = [vec(2) vec(1)];
elseif isscalar(vec)
    result = vec;    
else    
    parta = vec(1:m);
    partb = vec(m+1:end);
    result = [rev2(partb) rev2(parta)];
end
end

% accepted to be final answer
% length(vec) == 2 part can be deleted
