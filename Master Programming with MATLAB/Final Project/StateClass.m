classdef StateClass < CountryClass
    properties (Access = public)
        Statename   string
    end
    methods
        function obj = StateClass(cname,sname,cases,death,date)
            arguments
                cname = "DefC";
                sname = "DefS";
                cases = [];
                death = [];
                date = [];
            end
            
            obj@CountryClass(cname,cases,death,date);            
            obj.Statename = sname;           
        end
        function printname(obj)
            fprintf("%s - %s\n",obj.Countryname,obj.Statename)
        end
               
    end
end
