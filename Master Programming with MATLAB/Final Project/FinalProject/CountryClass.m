classdef CountryClass < GlobalClass
    properties (Access = public)
        Countryname string
    end
    methods 
        function obj = CountryClass(cname,cases,death,date)
            obj@GlobalClass(cases,death,date);
            obj.Countryname = cname;
        end
        
    end
end
