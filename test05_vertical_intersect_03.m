clear all;
sourceArray = load("data\weather.txt"); % minsup=10 minconf=80 6 rules

[totalRowNums,totalColNums] = size(sourceArray);

minSupPercent = 10;

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

[rules1, CARs, rulesAll, rules0, classLabel] = setRules1_2(rules0, CARs, rulesAll,  ...
                            classLabel, itemNums, classNums, minSup, minConf);

%% -- find another rules in 'rules1' array

% -- get max confidence item
maxConfID = indexMax(rules1);

rules2=[];
k = 1;
CARsTmp = [];

[rows, cols] = size(rules1);
for i=1:rows
    
    % -- derive rule from not 100% confidence rules (Max conf in any round)
    if rules1{maxConfID,1} ~= rules1{i,1} & ...  % -- not same item
            rules1{maxConfID,2} == rules1{i,2}   % --  same class
        
        rule1Set = intersect(rules1{maxConfID,3},rules1{i,3});
        rule0Set = intersect(rules0{rules1{maxConfID,1},2},rules0{rules1{i,1},2});
        
        resultSet = intersect(rule1Set, rule0Set);
        
        if length(rule0Set)> 0 & length(rule1Set) > minSup
            
            temp = [];
            temp{1} = union(rules1{maxConfID,1},rules1{i,1});                 
            temp{2} = rules1{i,2};
            temp{3} = rule1Set;    
            temp{4} = length(rule1Set);

            temp{5} = length(resultSet)/ length(rule0Set)*100;
            
            if temp{5} == 100 
               CARsTmp = [CARsTmp; temp];
    
            else 
                rules2{k,1} = temp{1};
                rules2{k,2} = temp{2};
                rules2{k,3} = temp{3};  
                rules2{k,4} = temp{4};
                rules2{k,5} = temp{5};

                k = k+1;
            end
        end
        
    end
end

[classLabel, rules0, rules1] = updateRules1(rules0, rules1, CARsTmp, classLabel ,minSup, minConf);

CARs = [CARs; CARsTmp];
%% -- 2 rules items
% 
% rules2 = []; % -- 2 rulestimes
% [rules2, CARs, rulesAll, rulesWeak] = setRules2(rules1, rules0, CARs, rulesAll, TIDs ...
%     , classLabel, itemNums, classNums, minConf, minSup, rulesWeak);