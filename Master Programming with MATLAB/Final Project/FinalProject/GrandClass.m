classdef GrandClass
    properties (Access = public)
        Countryname string
        States      StateClass
        slist       string      %list of states
    end
    methods
        function obj = GrandClass(sclass)
            arguments
                sclass StateClass
            end
            obj.Countryname = sclass.Countryname;
            obj.States = sclass;
            obj = ComputeStatesList(obj);
        end
        function obj = addState(obj,newState)
            arguments
                obj      GrandClass
                newState StateClass
            end
            obj.States = [obj.States; newState];
            obj = ComputeStatesList(obj);
        end
        function obj = ComputeStatesList(obj)
            obj.slist = [];
            for i = 1:length(obj.States)
                obj.slist = [obj.slist; obj.States(i).Statename];
            end
        end
    end
end
