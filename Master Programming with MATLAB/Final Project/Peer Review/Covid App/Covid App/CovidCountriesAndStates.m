classdef CovidCountriesAndStates 
    properties (Access = public)
        Country
        States
        DataCumulative
        DataDaily
        DataDeathCumu
        DataDeathDaily
        CountryRowNumber
    end  
    
    methods
        function obj = CovidCountriesAndStates(Country, States, DataCumulative, DataDaily, DataDeathCumu, DataDeathDaily, CountryRowNumber)
            if nargin == 1
                States = [];
                DataCumulative = [];
                DataDaily = [];
                DataDeathCumu = [];
                DataDeathDaily = [];
                CountryRowNumber = 0;
            end
            
            obj.Country = Country;
            obj.States = States;
            obj.DataCumulative = DataCumulative;
            obj.DataDaily = DataDaily;
            obj.DataDeathCumu = DataDeathCumu;
            obj.DataDeathDaily = DataDeathDaily;
            obj.CountryRowNumber = CountryRowNumber;
            
        end
     
    end
end
