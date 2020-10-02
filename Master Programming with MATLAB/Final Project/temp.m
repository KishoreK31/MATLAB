clc;clear;
load covid_data.mat;
[r, c] = size(covid_data);
ovec = repmat(StateClass,r-1,1); % objects vector

for j = 1:c
    for i = 2:r
        if j == 1 || j == 2 % executed for first two columns
            switch j
                case 1
                    ovec(i-1).Countryname = covid_data{i,j};
                case 2
                    if covid_data{i,j} == ""
                        ovec(i-1).Statename = "All";
                    else
                        ovec(i-1).Statename = covid_data{i,j};
                    end
            end
            continue;
        end
        % executed from 3rd column onwards
        curr_date = covid_data{1,j};
        cases = covid_data{i,j}(1);
        death = covid_data{i,j}(2);
        ovec(i-1) = insertval(ovec(i-1),curr_date,'date');
        ovec(i-1) = insertval(ovec(i-1),cases,'cases');
        ovec(i-1) = insertval(ovec(i-1),death,'death');
        
    end
end
% Compute Daily Cases and Deaths
for i = 1:length(ovec)
    ovec(i) = ComputeDailyCasesandDeath(ovec(i));
end
clist = "Global"; % countries list
cvec = [];
for i = 1:length(ovec)
    loc = find(clist==ovec(i).Countryname,1); % location of country name
    if isempty(loc)
        clist = [clist; ovec(i).Countryname];
        cvec = [cvec; GrandClass(ovec(i))];
    else
        cvec(loc-1) = addState(cvec(loc-1),ovec(i));
    end
end

t = StateClass("Global","All",0,0); % temporary variable
t.date = cvec(1).States(1).date; % whole database has the same data entries
for i=1:length(cvec)
    t.cases = t.cases + cvec(i).States(1).cases;
    t.death = t.death + cvec(i).States(1).death;
end