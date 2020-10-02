function result = grader(stu,ref,varargin)
n = nargin-2;
results_stu = cell(n,1);
results_ref = cell(n,1);
for i = 1:n
    results_stu{i} = stu(varargin{i});
    results_ref{i} = ref(varargin{i});
end
result = true;
temp = [];
for i = 1:n
if isequal(results_stu{i},results_ref{i})
    temp = [temp; true];
else
    temp = [temp; false];
end
end

for i=1:length(temp)
    result = result&temp(i);
end

