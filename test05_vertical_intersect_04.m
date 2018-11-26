clear all;
% sourceArray = load('data\weather.txt'); 
% minSupPercent = 10;
% minConf = 50; % -- percentage

% minsup=20 minconf=80 ; 3+1 rules

% sourceArray = load('data\contact-lenses.txt');
% minSupPercent = 10;
% minConf = 50; % -- percentage
% minsup=10 minconf=50 8 rules (95%)

sourceArray = load('data\balance.txt');
minSupPercent = 10;
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

adHoc=[];
while terminate == false
    CARsTmp = [];
    % -- find max accuracy and its index    
    [maxConfIndex, maxConf] = indexMax(rules1);


    if maxConf == 100
        % -- insert to CARs
        maxConfRule = rules1(maxConfIndex,:);
        
        CARs = [CARs; maxConfRule];   
        CARsTmp = [CARsTmp; maxConfRule];
        
    elseif maxConf >= minConf
        % -- try add another item to make 100% confidence for a rule

        [rows, cols] = size(rules1);
        [rowsMaxConf, cols] = size(maxConfIndex);
        i = 0;
        conf = 0;
        
        while i < rows & conf < 100        
            i = i+1;            
            
            j=0;
            while j < rowsMaxConf & conf < 100
                % -- derive rule from not 100% confidence rules (Max conf in any round)
                j = j+1;
                maxConfRule = rules1(maxConfIndex(j),:);
                
                % *** wait for check -- to do list : check first item for  2 itemsset rules
                isTheSameItem = false;
                if length(rules1{i,1}) > 1 
                    
                    checkIndex = length(rules1{i,1}) - 1;
                    maxConfRuleHead = maxConfRule{1}(1,1:checkIndex);
                    rules1Head = rules1{i,1}(1,1:checkIndex);
                    checkNum = intersect(maxConfRuleHead,rules1Head);
                    if length(checkNum) == checkIndex
                        isTheSameItem = true;
                    end
                else
                    if maxConfRule{1} == rules1{i,1}               
                        isTheSameItem = true;
                    end
                end
                
                
                if ~isTheSameItem & ...  % -- not same item
                    maxConfRule{2} == rules1{i,2}   % --  same class
                       
                    
                    % -- rule1 TIDs
                    rule1Set = intersect(maxConfRule{3},rules1{i,3});
                    rule1Support = length(rule1Set);
                    
                    
                    
                    % -- union rules antecedent
                    ruleAntecedent = union(maxConfRule{1},rules1{i,1});
                    
                    % -- Class Set & confidence
                    targetClass = findClass(maxConfRule{2},classLabel);
                    classSet = targetClass{1,2};                    
                    
                    if ~isempty(classSet) & rule1Support >= minSup
                    
                        % -- intersect rule & class , cal confidence
                        resultSet = intersect(rule1Set, classSet); 
                    
                    % -- intersect all of TIDs
%                     rowsRuleAntecedent = length(ruleAntecedent);
%                     rule0Set = rules0{ruleAntecedent(1),2};
%                     for k=2:rowsRuleAntecedent
%                         
%                         % -- rules0 TIDs , use to find a rule's confidence
%                         rule0Set = intersect(rule0Set, rules0{ruleAntecedent(k),2});
%                     end

%                     resultSet = intersect(rule1Set, rule0Set); 
%                     resultSupport = length(rule1Set);
                    
%                     if ~isempty(rule0Set) & resultSupport > minSup
                        
                        temp = [];
                        temp{1} = ruleAntecedent;                 
                        temp{2} = rules1{i,2};
                        temp{3} = rule1Set;    
                        temp{4} = rule1Support;                        
                        
                        conf = rule1Support / length(resultSet)*100;
                        temp{5} = conf;
                        
                        if conf == 100 
                            CARsTmp = [CARsTmp; temp];
                            CARs = [CARs; temp];      
                            
                        elseif conf >= minConf
                            rules1 = [rules1; temp];  
                        end
                    end                    
                end                
            end                   
        end
    end
    
    [CARsTmpRows, CARsTmpCols] = size(CARsTmp);
    
    if CARsTmpRows > 0
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

[hitCount, confusionMatrix] = evaluate2(CARs, sourceArray, defaultClass, classLabel);

hitCount/totalRowNums    
    
    



