function result = reversal(vec)
if isscalar(vec)
    result = vec;
else    
    first = vec(1);
    rest = vec(2:end);
    result = [reversal(rest) first];
end
end
