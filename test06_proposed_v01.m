clear all;

% sourceName = 'data\contact-lenses.txt';
sourceName = 'data\lymphography.txt';
% sourceName = 'data\iris.data';
% sourceName = 'data\tic-tac-toe.txt';
% sourceName = 'data\zoo.txt';
% sourceName = 'data\weather.txt';

sourceArray = load(sourceName);

minSupPercent = 2; % -- percentage
minConf = 50; % -- percentage
folds = 10;
printFoldDetails = true;

[rows, cols] = size(sourceArray);

rowsPerFold = floor(rows/folds);

minSup = ceil((rows-rowsPerFold) * minSupPercent/100);  % -- times

disp(" Source : " + sourceName );
avg_accuracy = 0;
avg_precision = 0;
avg_recall = 0;
avg_f1 = 0;

for foldIdx=1 : folds
    startIdx = 0;
    endIdx = 0;
    trainSet = [];
    testSet = [];
    
    % -- start index
    startIdx = ((foldIdx-1) * rowsPerFold) + 1;
    
    % -- end index , check end of source
    if foldIdx == folds 
        endIdx = rows;
    else
        endIdx = foldIdx * rowsPerFold;
    end
    
    for i=1 : rows
        temp = sourceArray(i,:);
       if foldIdx == 1 
           % --- use training set
           testSet = [testSet; temp];
           trainSet = [trainSet; temp];
       else
           if i >= startIdx && i <= endIdx
               % -- test set

               testSet = [testSet; temp];
           else
               % -- train set
               trainSet = [trainSet; temp];
           end
       end
%        trainSet = [trainSet; temp];
    end
    
    disp("Fold No. : " + foldIdx + " ------------------------ ");
    % -- call ac method
    [totalRules, accuracy, precision, recall, f1] = ...
        vertical_v01(trainSet, testSet, minSup, minConf,printFoldDetails);
    
    % -- print fold's result
    
    % -- accumulate result 
    avg_accuracy = avg_accuracy + accuracy;
    avg_precision = avg_precision + precision;
    avg_recall = avg_recall + recall;
    avg_f1 = avg_f1 + f1;
    
end

% -- print overall result
avg_accuracy = avg_accuracy / folds;
avg_precision = avg_precision / folds;
avg_recall = avg_recall / folds;
avg_f1 = avg_f1 / folds;
    
disp(" -------------- Average --------------- ");
disp("Average Accuracy : " +  avg_accuracy);
disp("Average Precision : " +  avg_precision);
disp("Average Recall : " +  avg_recall);
disp("Average F-measure : " +  avg_f1);



