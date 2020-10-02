classdef GlobalClass
    properties (Access = public)
        cases         double    % cumulative cases vector
        death         double    % cumulative death vector
        date          string    % date vector
        dailycases    double    % daily cases vector
        dailydeath    double    % daily death vector
    end
    methods 
        function obj = GlobalClass(cases,death,date)
            obj.cases = cases;
            obj.death = death;
            obj.date = date;
        end
        function obj = insertval(obj,newval,loc)
            % insert newval at the end of a location
            switch loc
                case 'cases'
                    obj.cases = [obj.cases newval];
                case 'death'
                    obj.death = [obj.death newval];
                case 'date'
                    obj.date = [obj.date newval]; % try preallocation
                otherwise
                    error("Unknown input");
            end
%             obj = ComputeDailyCasesandDeath(obj); 
%             above method takes long time when done after each insertion
        end
        function obj = ComputeDailyCasesandDeath(obj)
            obj.dailycases = obj.cases;
            obj.dailydeath = obj.death;
            for i = length(obj.dailycases):-1:1
                % daily cases and death have the same length
            if i==1
                break
            end
            obj.dailycases(i) = double(uint64(obj.dailycases(i) - obj.dailycases(i-1)));
            obj.dailydeath(i) = double(uint64(obj.dailydeath(i) - obj.dailydeath(i-1)));            
            end
        end
    end
end
