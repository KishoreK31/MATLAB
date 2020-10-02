function [f b] = fibo_trace(n,a)
persistent vec count
    if isempty(count)
        count = 1
    else
        count = count + 1;
    end
  
    if isempty(a) && count>1
        vec = n;
        count = 1;
    else
        vec = [vec n];
    end
   
    if n<=2
        f = 1;
    else
        f = fibo_trace(n-2,vec) + fibo_trace(n-1,vec);
    end
    b = vec;
end
