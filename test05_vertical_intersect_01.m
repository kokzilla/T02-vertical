clear all;
sourceArray = load("data\weather.txt"); % minsup=2 minconf=100 6 rules

[totalRowNums,totalColNums] = size(sourceArray);

minSupPercent = 2;

minSup = ceil(totalRowNums * minSupPercent/100);  % -- times
% minSup = 18;
minConf = 80; % -- percentage
sorttype = 2; % -- sort type 1=sup, 2=csc, 3=cardinality(ASC)+conf+sup

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

% [rules1, CARs, rulesAll, rulesWeak, rules0] = setRules1(rules0, CARs, rulesAll, TIDs ...
%                             , classLabel, itemNums, classNums, minConf, minSup, rulesWeak);
                        
%% -- 2 rules items
% 
% rules2 = []; % -- 2 rulestimes
% [rules2, CARs, rulesAll, rulesWeak] = setRules2(rules1, rules0, CARs, rulesAll, TIDs ...
%     , classLabel, itemNums, classNums, minConf, minSup, rulesWeak);