classdef countryNode < handle
    properties 
        label
        stateArrayLabels
        stateValues
        stateValuesCumulative
    end
    methods
        function country = countryNode()
            country.label = '';
            country.stateArrayLabels = [];
            country.stateValues = []; %all the data for all the states
            country.stateValuesCumulative = []; % all the
                % data cumulative for all the states 
        end
    end
end