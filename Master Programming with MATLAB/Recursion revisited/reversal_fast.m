% function result = reversal_fast(vec,f,l)
% persistent v indf indl n count
% 
% if nargin==1
%     v = vec;
%     indf = 1;
%     indl = length(vec);
%     n = uint64(length(v));
%     n = double(n/2);
%     count = 1;
% else
%     temp = v(indf);
%     v(indf) = v(indl);
%     v(indl) = temp;
%     count = count + 1;
%     if indf == n
%         result = v;
%         disp(count)
%         return
%     end
%     indf = indf+1;
%     indl = indl-1;
% end
% 
% result = reversal_fast(v,indf,indl);
% 
% end

function result = reversal_fast(vec)
persistent count
if isempty(count)
    count = 0;
end
count = count+1;
if isscalar(vec)
    result = vec;
else    
    first = vec(1);
    rest = vec(2:end);
    result = [reversal_fast(rest) first];
end
disp(count)
end

