classdef covid < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure  matlab.ui.Figure
        UIAxes                  matlab.ui.control.UIAxes
        CountryListBoxLabel     matlab.ui.control.Label
        CountryListBox          matlab.ui.control.ListBox
        StatesListBoxLabel      matlab.ui.control.Label
        StatesListBox           matlab.ui.control.ListBox
        DatatoPlotButtonGroup   matlab.ui.container.ButtonGroup
        CasesButton             matlab.ui.control.RadioButton
        DeathButton             matlab.ui.control.RadioButton
        BothButton              matlab.ui.control.RadioButton
        OptionButtonGroup       matlab.ui.container.ButtonGroup
        CumulativeButton        matlab.ui.control.RadioButton
        DailyButton             matlab.ui.control.RadioButton
        AveragedofdaysLabel_2   matlab.ui.control.Label
        AveragedofdaysSlider    matlab.ui.control.Slider
        StartDateLabel          matlab.ui.control.Label
        StartDateDatePicker     matlab.ui.control.DatePicker
        EndDateDatePickerLabel  matlab.ui.control.Label
        EndDateDatePicker       matlab.ui.control.DatePicker
    end

    
    properties (Access = private)
        GClass      GrandClass  % GrandClass property that stores everything (main)
        GlobalData  GrandClass  % Stores only global values
        Clist       string      % List of Countries
        CaseAverage  double     % average cases
        DeathAverage double     % average deaths
        PlotDate    datetime    % dates to be plotted (in datetime)
        PlotDatenum             % same as above. in Datenum format
        PlotState   StateClass  % current state instance to be plotted
        CurrCases   double      % cases to be plotted (cumulative or daily)
        CurrDeath   double      % death to be plotted (cumulative or daily)
        CurrDatatoPlot  string  % cases or death or both
        CurrOption   string     % cumulative or daily
        
%         To do
%         Both case doesnt work right now
%         Give orange colour to death plot
        
    end
    
    methods (Access = private)        
        function init(app)
            load covid_data.mat covid_data;
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
            app.GlobalData = GrandClass(t);
            app.GClass = [app.GlobalData;cvec];
            app.Clist = clist;
            app.CountryListBox.Items = app.Clist;
            app.CountryListBox.ItemsData = 1:length(app.CountryListBox.Items);
            app.CountryListBox.Value = 1;
            app.CurrDatatoPlot = app.DatatoPlotButtonGroup.SelectedObject.Text;
            app.CurrOption = app.OptionButtonGroup.SelectedObject.Text;
            app.refreshStatesListBox(1)
        end
        
        function refreshStatesListBox(app,value)
            % refreshes states list box after country is changed
            app.StatesListBox.Items = app.GClass(value).slist;
            app.StatesListBox.ItemsData = 1:length(app.StatesListBox.Items);
            app.StatesListBox.Value = 1;
            app.plotgraph();
        end
        
        function computeAverage(app,slidervalue)
            i = app.CountryListBox.Value;
            j = app.StatesListBox.Value;
            app.PlotState = app.GClass(i).States(j);
            
            switch app.CurrOption
                case "Daily"
                    app.CurrCases = app.PlotState.dailycases;
                    app.CurrDeath = app.PlotState.dailydeath;
                case "Cumulative"
                    app.CurrCases = app.PlotState.cases;
                    app.CurrDeath = app.PlotState.death;
            end
            app.CaseAverage = movmean(app.CurrCases,slidervalue);
            app.DeathAverage = movmean(app.CurrDeath,slidervalue);
        end
        
        function plotgraph(app,slidervalue)
            % plots graph with updated details when called
            if nargin<2
                slidervalue = app.AveragedofdaysSlider.Value;
            end
            app.computeAverage(slidervalue);
            app.PlotDatenum = datenum(app.PlotState.date,'mm/dd/yy');
            app.PlotDate = datetime(app.PlotDatenum,'ConvertFrom','datenum');
            cla(app.UIAxes,"reset");
            switch app.CurrDatatoPlot
                case "Cases"
%                     hold(app.UIAxes,"off")
%                     bar(app.UIAxes,app.PlotDate,app.CurrCases); hold(app.UIAxes,"on")
%                     title(app.UIAxes,sprintf("%s (%s) & %d day mean",app.PlotState.Countryname,app.PlotState.Statename,round(slidervalue)))
%                     grid(app.UIAxes,"on")
%                     y_label = sprintf("%s %s",app.CurrOption,app.CurrDatatoPlot);              
%                     ylabel(app.UIAxes,y_label)
%                     xlabel(app.UIAxes,"Timeline")
% %                     datetick(app.UIAxes,'x','dd/mm')
%                     plot(app.UIAxes,app.PlotDate,app.CaseAverage,'LineStyle','-','LineWidth',2,'Color','black');
%                     hold(app.UIAxes,"off")
                    hold(app.UIAxes,"off");
                    bar(app.UIAxes,app.PlotDate,app.CaseAverage,'FaceColor','#0072BD');
                    title(app.UIAxes,sprintf("%s %s of %s (%s) - %2.1f day(s) mean",app.CurrOption,app.CurrDatatoPlot,...
                        app.PlotState.Countryname,app.PlotState.Statename,round(slidervalue,1)));
                    grid(app.UIAxes,"on");
                    ylabel(app.UIAxes,sprintf("%s %s",app.CurrOption,app.CurrDatatoPlot));
                    xlabel(app.UIAxes,"Timeline")
                    % try datetick later
                    
                case "Death"
                    hold(app.UIAxes,"off");
                    bar(app.UIAxes,app.PlotDate,app.DeathAverage,'FaceColor','#D95319');
                    title(app.UIAxes,sprintf("%s Deaths of %s (%s) - %2.1f day(s) mean",app.CurrOption,...
                        app.PlotState.Countryname,app.PlotState.Statename,round(slidervalue,1)));
                    grid(app.UIAxes,"on");
                    ylabel(app.UIAxes,sprintf("%s Deaths",app.CurrOption));
                    xlabel(app.UIAxes,"Timeline")
                    
                case "Both"
                    hold(app.UIAxes,"off");
                    yyaxis(app.UIAxes,"left")   % left side
                    plot1 = bar(app.UIAxes,app.PlotDate,app.CaseAverage,'FaceColor','#0072BD');
                    hold(app.UIAxes,"on");
                    grid(app.UIAxes,"on");
                    ylabel(app.UIAxes,sprintf("%s Cases",app.CurrOption));
                    
                    yyaxis(app.UIAxes,"right")   % right side
                    plot2 = plot(app.UIAxes,app.PlotDate,app.DeathAverage,'Color','#D95319','LineWidth',2);
                    hold(app.UIAxes,"off");
                    ylabel(app.UIAxes,sprintf("%s Deaths",app.CurrOption));
                    xlabel(app.UIAxes,"Timeline");
                    title(app.UIAxes,sprintf("%s Cases and Deaths of %s (%s) - %2.1f day(s) mean",app.CurrOption,...
                        app.PlotState.Countryname,app.PlotState.Statename,round(slidervalue,1)));
            end
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc;
            init(app);  % initialisation
        end

        % Value changed function: StatesListBox
        function StatesListBoxValueChanged(app, event)
%             value = app.StatesListBox.Value;         
            app.plotgraph();
        end

        % Value changed function: CountryListBox
        function CountryListBoxValueChanged(app, event)
            value = app.CountryListBox.Value;
            app.refreshStatesListBox(value);
%             app.plotgraph(); % done inside refreshStatesListBox function      
        end

        % Value changing function: AveragedofdaysSlider
        function AveragedofdaysSliderValueChanging(app, event)
            changingValue = event.Value;
            app.plotgraph(changingValue);
        end

        % Selection changed function: OptionButtonGroup
        function OptionButtonGroupSelectionChanged(app, event)
            app.CurrOption = app.OptionButtonGroup.SelectedObject.Text;
            app.plotgraph();
        end

        % Selection changed function: DatatoPlotButtonGroup
        function DatatoPlotButtonGroupSelectionChanged(app, event)
            app.CurrDatatoPlot = app.DatatoPlotButtonGroup.SelectedObject.Text;
            app.plotgraph();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure and hide until all components are created
            app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure = uifigure('Visible', 'off');
            app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure.Position = [100 100 653 527];
            app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure.Name = 'COVID-19 Data Visualization (Source: John Hopkins University)';

            % Create UIAxes
            app.UIAxes = uiaxes(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [21 257 600 250];

            % Create CountryListBoxLabel
            app.CountryListBoxLabel = uilabel(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.CountryListBoxLabel.HorizontalAlignment = 'right';
            app.CountryListBoxLabel.Position = [30 151 51 22];
            app.CountryListBoxLabel.Text = 'Country:';

            % Create CountryListBox
            app.CountryListBox = uilistbox(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.CountryListBox.Items = {};
            app.CountryListBox.ValueChangedFcn = createCallbackFcn(app, @CountryListBoxValueChanged, true);
            app.CountryListBox.Position = [88 27 100 146];
            app.CountryListBox.Value = {};

            % Create StatesListBoxLabel
            app.StatesListBoxLabel = uilabel(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.StatesListBoxLabel.HorizontalAlignment = 'right';
            app.StatesListBoxLabel.Position = [201 151 43 22];
            app.StatesListBoxLabel.Text = 'States:';

            % Create StatesListBox
            app.StatesListBox = uilistbox(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.StatesListBox.Items = {};
            app.StatesListBox.ValueChangedFcn = createCallbackFcn(app, @StatesListBoxValueChanged, true);
            app.StatesListBox.Position = [251 27 100 146];
            app.StatesListBox.Value = {};

            % Create DatatoPlotButtonGroup
            app.DatatoPlotButtonGroup = uibuttongroup(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.DatatoPlotButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @DatatoPlotButtonGroupSelectionChanged, true);
            app.DatatoPlotButtonGroup.TitlePosition = 'centertop';
            app.DatatoPlotButtonGroup.Title = 'Data to Plot';
            app.DatatoPlotButtonGroup.Position = [391 57 100 95];

            % Create CasesButton
            app.CasesButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.CasesButton.Text = 'Cases';
            app.CasesButton.Position = [11 49 58 22];
            app.CasesButton.Value = true;

            % Create DeathButton
            app.DeathButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.DeathButton.Text = 'Death';
            app.DeathButton.Position = [11 27 65 22];

            % Create BothButton
            app.BothButton = uiradiobutton(app.DatatoPlotButtonGroup);
            app.BothButton.Text = 'Both';
            app.BothButton.Position = [11 5 65 22];

            % Create OptionButtonGroup
            app.OptionButtonGroup = uibuttongroup(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.OptionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @OptionButtonGroupSelectionChanged, true);
            app.OptionButtonGroup.TitlePosition = 'centertop';
            app.OptionButtonGroup.Title = 'Option';
            app.OptionButtonGroup.Position = [511 57 100 95];

            % Create CumulativeButton
            app.CumulativeButton = uiradiobutton(app.OptionButtonGroup);
            app.CumulativeButton.Text = 'Cumulative';
            app.CumulativeButton.Position = [11 48 82 22];
            app.CumulativeButton.Value = true;

            % Create DailyButton
            app.DailyButton = uiradiobutton(app.OptionButtonGroup);
            app.DailyButton.Text = 'Daily';
            app.DailyButton.Position = [11 26 65 22];

            % Create AveragedofdaysLabel_2
            app.AveragedofdaysLabel_2 = uilabel(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.AveragedofdaysLabel_2.Position = [322 198 58 29];
            app.AveragedofdaysLabel_2.Text = {'Averaged'; '# of days'};

            % Create AveragedofdaysSlider
            app.AveragedofdaysSlider = uislider(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.AveragedofdaysSlider.Limits = [1 15];
            app.AveragedofdaysSlider.ValueChangingFcn = createCallbackFcn(app, @AveragedofdaysSliderValueChanging, true);
            app.AveragedofdaysSlider.Position = [391 224 223 3];
            app.AveragedofdaysSlider.Value = 1;

            % Create StartDateLabel
            app.StartDateLabel = uilabel(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.StartDateLabel.HorizontalAlignment = 'right';
            app.StartDateLabel.Position = [19 226 63 22];
            app.StartDateLabel.Text = 'Start Date:';

            % Create StartDateDatePicker
            app.StartDateDatePicker = uidatepicker(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.StartDateDatePicker.Position = [97 226 150 22];
            app.StartDateDatePicker.Value = datetime([2020 1 22]);

            % Create EndDateDatePickerLabel
            app.EndDateDatePickerLabel = uilabel(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.EndDateDatePickerLabel.HorizontalAlignment = 'right';
            app.EndDateDatePickerLabel.Position = [23 194 59 22];
            app.EndDateDatePickerLabel.Text = 'End Date:';

            % Create EndDateDatePicker
            app.EndDateDatePicker = uidatepicker(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure);
            app.EndDateDatePicker.Position = [97 194 150 22];

            % Show the figure after all components are created
            app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = covid

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.COVID19DataVisualizationSourceJohnHopkinsUniversityUIFigure)
        end
    end
end