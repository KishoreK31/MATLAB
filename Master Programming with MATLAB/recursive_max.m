function m = recursive_max(vec)

a = vec(1);
b = vec(2:end);

if isscalar(b)
    if a>b
        m = a;
    else
        m = b;
    end
else
    x = recursive_max(b);
    if a>x
        m = a;
    else 
        m = x;
    end    
end