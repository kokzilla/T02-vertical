function [totalRules, accuracy, precision, recall, f1] = ...
    vertical_v01(sourceArray, testSet, minSup, minConf, printFoldDetails)


[totalRowNums,totalColNums] = size(sourceArray);

%% -- find column number which values is located
% --- Item's properties  1:value 2:atrribute number

items = itemsProperties(sourceArray);

%% -- find column number which values is located

% -- TIDs
TIDs = 1:totalRowNums;

rules0 = setRules0(sourceArray,TIDs);
% -- rules0's information
% -- 1 : item
% -- 2 : TIDs
% -- 3 : diffSet

%% -- unique class label
classUnique = unique(sourceArray(:,end));
classNums = length(classUnique);


%  -- find class label data
[classLabel,rules0] = setClass(rules0, TIDs, classUnique, classNums);
itemNums = length(rules0);
% - 1  class number
% - 2 set
% - 3 diffset

%% -- find diffset of items

% -- item separated by classes
rules1 = []; % -- Single rule items (passed min support)
rulesAll = [];
rulesWeak = [];
CARs = [];
% col -- describtion -- 
%   1   item value
%   2   class
%   3   TID (diffset)
%   4   support count
%   5   confidence

[rules1, CARs, rulesAll, rules0, classLabel] = setRules1_2(rules0, CARs, rulesAll,  ...
                            classLabel, itemNums, classNums, minSup, minConf);
                        
%% -- find another rules in 'rules1' array

% -- check terminate condition 
% --, test instance = 0 or no one rule passed minsup

terminate = terminateCondidtion(rules1, classLabel,minSup);
while terminate == false
   CARsTmp = [];
   rule = separateAndConqure01(rules1, classLabel, rules0);
   
   if ~isempty(rule)
    CARs = [CARs; rule];   
    CARsTmp = [CARsTmp; rule];
   
    [CARsTmpRows, CARsTmpCols] = size(CARsTmp);
    
    
    % -- delte instance which associate with 100% conf rule , update suppport , conf
    [classLabel, rules0, rules1] = updateRules1(rules0, rules1, CARsTmp, classLabel ,minSup, minConf);

        % -- check terminate condition
        terminate = terminateCondidtion(rules1, classLabel, minSup);
    else
        terminate = true;
    end
end

%% -- crate default rules
[rows, cols] =size(classLabel);   
maxInstance = length(classLabel{1,2});
defaultClass = classLabel{1,1};
i = 1;

while i < rows 
    i = i+1;
    if maxInstance < length(classLabel{i,2})
        maxInstance = length(classLabel{i,2});
        defaultClass = classLabel{i,1};
    end
end

%% --  Evaluate
accuracy = 0;
[ confusionMatrix, accuracy, precision,recall,f1] = evaluate3(CARs, testSet, defaultClass, classLabel);
[carRow, carCol] = size(CARs);
totalRules = (carRow+1);

if printFoldDetails 
    
    disp(" Devired Rules : " + totalRules);
    disp(" Accuracy : " +  accuracy);
    disp(" Precision : " +  precision); 
    disp(" Recall : " +  recall); 
    disp(" F-measure : " +  f1); 
end