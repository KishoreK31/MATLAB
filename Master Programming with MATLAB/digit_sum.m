function result = digit_sum(num)
x = rem(num,10);
if x==num
    result = x;
else
    result = x + digit_sum((num-x)/10);
end
