function [countryArray, dates] = loadData(covid)

    dateStringArray = covid(1,3:end);
    dateStringArray = string(dateStringArray);
    formatIn = 'mm/dd/yy';
    pivotYear = 2000;
    dates = zeros(1,length(dateStringArray));
    for i=1: length(dateStringArray)
           
           %pos = strlength(dates(i)) -2;
           %dates(i)=insertAfter(dates(i), pos,"20");
           dates(i) = datenum(dateStringArray(i), formatIn, pivotYear);
    end
    
    totalCountries = unique(covid(:,1)); % figure out the number of different countries
    
 
    countryArray = countryNode.empty(0,length( totalCountries)-1); % empty array of objects.
    i = 2;
    currentCountry = '';
    currentCountryIndex  = 0;
 
       
    while i <= length(covid(:,1) )
        if ~ strcmp(currentCountry,covid(i,1)) % we have a new country
            currentState = 1;
            currentCountry = covid(i,1);
            currentCountryIndex = currentCountryIndex +1;
            countryArray(currentCountryIndex).label =string(currentCountry);
            
            currentNumStates = sum( strcmp(currentCountry, covid(:,1)));      
            countryArray(currentCountryIndex).stateArrayLabels= string.empty(0,currentNumStates);
            countryArray(currentCountryIndex).stateValues= zeros(currentNumStates,length(dates));
            countryArray(currentCountryIndex).stateValuesCumulative = zeros(currentNumStates,length(dates));
         
        end
        
        % making sure the state is not empty
        if strcmp(string(covid(i,2)),"")
            
            countryArray(currentCountryIndex).stateArrayLabels(currentState) = "total";
        else
            
            countryArray(currentCountryIndex).stateArrayLabels(currentState)= covid(i,2);
        end
        
        %filling out the numbers per date 
        dateNumbers= covid(i,3:end); % extract the death and cases
        result = dateNumbers{1}; % transform into a 2D array of doubles.
            
        countryArray(currentCountryIndex).stateValues(currentState, 1,1) = result(1);
        countryArray(currentCountryIndex).stateValues(currentState, 1,2) = result(2);
        old = result;
        
        for j = 2:length(dateNumbers)
            result = dateNumbers{j}; % transform into a 2D array of doubles.
            % cumulative values
            countryArray(currentCountryIndex).stateValuesCumulative(currentState, j,1) = result(1); % cases
            countryArray(currentCountryIndex).stateValuesCumulative(currentState, j,2) = result(2);% deaths
            %daily values
            countryArray(currentCountryIndex).stateValues(currentState, j,1) = result(1) - old(1) ; %cases
            countryArray(currentCountryIndex).stateValues(currentState, j,2) = result(2)- old(2);%deaths
          
            old = result;
        end
        % going to the next iteration
        currentState = currentState + 1;
        
        i = i+1;
        
    end
  
end
        