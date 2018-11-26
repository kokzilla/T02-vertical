clear all;

% sourceArray = load('data\weather.txt'); 
% minSupPercent = 20;
% minConf = 50; % -- percentage

%--- minsup=20 minconf=80 ; 3+1 rules

% sourceArray = load('data\contact-lenses.txt');

% ---minsup=10 minconf=50 8 rules (95%)

% sourceArray = load('data\balance.txt');


% sourceArray = load('data\iris.data');

% sourceArray = load('data\pimaIndians.num');

% sourceArray = load('data\lymphography.txt');

% sourceArray = load('data\tic-tac-toe.txt');

% sourceArray = load('data\zoo.txt');


% sourceName = 'data\contact-lenses.txt';
% sourceName = 'data\lymphography.txt';
% sourceName = 'data\iris.data';
sourceName = 'data\tic-tac-toe.txt';
% sourceName = 'data\zoo.txt';
% sourceName = 'data\weather.txt';

sourceArray = load(sourceName);

minSupPercent = 2;
minConf = 50; % -- percentage


% sorttype = 2; % -- sort type 1=sup, 2=csc, 3=cardinality(ASC)+conf+sup

[totalRowNums,totalColNums] = size(sourceArray);
minSup = ceil(totalRowNums * minSupPercent/100);  % -- times


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
[hitCount, confusionMatrix, accuracy, precision,recall,f1] = evaluate2(CARs, sourceArray, defaultClass, classLabel);
[carRow, carCol] = size(CARs);
disp(" Source : " + sourceName );
disp(" Devired Rules : " + (carRow+1));
disp(" Accuracy : " +  accuracy);
disp(" Precision : " +  precision); 
disp(" Recall : " +  recall); 
disp(" F-measure : " +  f1); 





