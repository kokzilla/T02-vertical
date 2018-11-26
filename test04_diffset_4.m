clear all;
sourceArray = load("data\weather.txt"); % minsup=2 minconf=100 6 rules
% (100%) sorttype 1
% sourceArray = load("data\credit_card.txt"); % minsup=2 minconf=60 7 rules (100%) sorttype 3
% sourceArray = load("data\contact-lenses.txt"); % minsup=2 minconf=90 8 rules (95%)

% sourceArray = load("data\balance.txt"); % minsup=2% minconf=50 16 rules 78%)
%                                       % minsup=20 minconf=55 57 rules 86%)
%                                       % minsup=18 minconf=50 64 rules
%                                       91%) sorttype 2
%                                       % minsup=5 minconf=70 216 rules 89%)
% sourceArray = load("data\pimaIndians.num"); % minsup= minconf= 10 rules (96%)


[totalRowNums,totalColNums] = size(sourceArray);

minSupPercent = 2;

minSup = ceil(totalRowNums * minSupPercent/100);  % -- times
% minSup = 18;
minConf = 50; % -- percentage
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
itemNums = length(rules0) - classNums;

%  -- find class label data
classLabel = setClass(rules0, TIDs, classUnique, classNums, itemNums);
% - 1  class number
% - 2 set
% - 3 diffset

%% -- find diffset of items
tic
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

[rules1, CARs, rulesAll, rulesWeak] = setRules1(rules0, CARs, rulesAll, TIDs ...
                            , classLabel, itemNums, classNums, minConf, minSup, rulesWeak);

%% -- 2 rules items

rules2 = []; % -- 2 rulestimes
[rules2, CARs, rulesAll, rulesWeak] = setRules2(rules1, rules0, CARs, rulesAll, TIDs ...
    , classLabel, itemNums, classNums, minConf, minSup, rulesWeak);

%% -- 3 rules items

rules3 = []; % -- 3 rulestimes
[rules3, CARs, rulesAll] = setRules3(rules2, rules0,CARs, rulesAll, TIDs, classLabel, itemNums, classNums, minConf, minSup);

%% -- Rules Raning
% CARsSorted = sortRulesInsertion(CARs);
% CARsSorted = sortRulesInsertionCSC(CARs);
% CARsSorted = sortRulesInsertionCardinalFirst (CARs);
CARsSorted = sortRulesInsertion(CARs,sorttype);

%% -- Rules Pruning
[model, CARsSorted] = pruningRules(CARsSorted, sourceArray);

toc

%% --  Evaluate

hitCount = evaluate(model, sourceArray);

hitCount/totalRowNums

%% -- Classify
% test = [1     6    11    16 ];
% 
% [rowsCARsSorted, colsCARsSorted] = size(model);
% 
% 
% %     -- loop CARs
%     hit = false;
%     j = 1;
%     while hit==false & j <= rowsCARsSorted
%         
%         rule = model{j,1};
%         
%         if length(intersect(rule,test)) == length(rule) 
%             
%             hit = true;
%             
%             model{j,2}
%             
%             
%         end        
%         j = j+1;
%     end






