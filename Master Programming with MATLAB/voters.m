function db = voters(orig_db,varargin)

n = nargin-1;   %total varargin inputs

if rem(n,2)~=0|n==0    %check for odd and no varargin
     db = orig_db;
     return
end

for i = 1:n/2   %check for varargin data types
    %check if odd arguments are string or char
if (~ischar(varargin{2*i-1})&~isstring(varargin{2*i-1}))
     db = orig_db;
     return
end
    %check if even arguments are integers
if isnumeric(varargin{2*i})
    if fix(varargin{2*i})~=varargin{2*i}
        db = orig_db;
        return
    end
else
     db = orig_db;
     return
end
end

db = orig_db;
blank = struct("Name",[],"ID",[]);

for i = 1:n/2
    temp = setfield(blank,"Name",string(varargin{2*i-1}));
    temp = setfield(temp,"ID",varargin{2*i});
    db = [db, temp];
end


