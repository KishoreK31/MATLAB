function result = palindrome(vec)

if length(vec)<=3
    if vec(1)==vec(end)
        result = true;
    else
        result = false;
    end
else
    if vec(1)==vec(end)
        x = palindrome(vec(2:end-1));
        result = true && x;
    else
        result = false;
    end
    
end

    