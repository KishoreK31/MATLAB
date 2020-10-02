function result = rev1(vec)
if length(vec)==2
    result = [vec(2) vec(1)];
else    
    first = vec(1);
    second = vec(2);
    rest = vec(3:end);
    result = [reversal(rest) second  first];
end
end
