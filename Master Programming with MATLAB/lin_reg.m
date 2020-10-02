function [a b] = lin_reg(x,y)
    coeff = x';
    coeff = [coeff ones(length(coeff),1)];
    rhs = y';
    x = coeff\rhs;
    a = x(1);
    b = x(2);
end
