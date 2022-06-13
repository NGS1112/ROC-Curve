%File:      ROC_Curve_main.m
%Author:    Nicholas Shinn
%Date:      03/03/2022
%Details:   Program to perform the features discussed in EX03 of 
%           Principles of Data Mining.

function ROC_Curve_main(filename)
%ROC_Curve_main: function to generate an ROC curve for a given dataset
%                by comparing thresholds against their respective false 
%                positive and true positive rates
%
%Arguments: filename - data file to be used to generate the ROC curve

%Reads the data from the training file
matrixedData = readmatrix(filename);

for index = 1:6
    values = matrixedData( :, [index 9]);
    normalized_values = (round(values( :, 1) / 2) * 2)';
    
    best_threshold = Inf;
    best_rate = -Inf;
    best_false_rate = Inf;
    best_true_rate = -Inf;
    false_positive_rates = [];
    true_positive_rates = [];
    
    for threshold = normalized_values
        %Seperate the data entries into left and right groups based on
        %threshold
        left = values( values(:, 1) <= threshold, :);
        right = values( values(:, 1) > threshold, : );
        
        false_positives = sum(left(:, 2) == 1);
        false_positive_rate = sum(false_positives./sum(values(:, 2) == 1));
        false_positive_rates(end+1) = false_positive_rate;
        
        true_positives = sum(left(:, 2) == -1);
        true_positive_rate = sum(true_positives./sum(values(:, 2) == -1));
        true_positive_rates(end+1) = true_positive_rate;
        
        
        if( false_positive_rate <= best_false_rate && true_positive_rate >= best_true_rate )
            best_false_rate = false_positive_rate;
            best_true_rate = true_positive_rate;
            best_threshold = threshold;
        end
    
    end
    %Create the base figure, displaying feature threshold False Alarm
    %Rate versus True Positive Rate
    [false_positive_rates, sorted_order] = sort(false_positive_rates);
    true_positive_rates = true_positive_rates(sorted_order);
    figure(index);
    plot(false_positive_rates, true_positive_rates, '--or');
    %Insert the calculated best threshold, marking it for visibility
    hold on;
    plot(best_false_rate, best_true_rate, '--wd');
    set(gca, 'color', 'k');
    hold off;
    %Sets up the legend and labels
    legend('\color{red} Feature Thresholds', '\color{white} Best Feature Threshold', 'Location', 'southeast');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    title('Rates at Different Thresholds');
end
end

