
function v = fibor(n,v)
if nargin==1
    v = fibor(n-1,[1,1]);
elseif n>1
    v = fibor(n-1,[v,v(end-1)+v(end)]);
end
%v = v(end);
if n==0
    v = v(1);
end
end
 
    