function [rule] = ...
    separateAndConqure01(rulesSeparate, classLabel, rules0)
   
     
newRules = [];
rule = [];

[rows, cols] = size(rulesSeparate);

if rows == 0
    newRules = [];

else

    % -- find max accuracy and its index    
    [maxConfIndex, maxConf] = indexMax(rulesSeparate);

    % -- only one maximum confidence rule
    maxConfRule = rulesSeparate(maxConfIndex,:);

    if maxConf >= 100
        % -- insert to CARs  
        rule = maxConfRule;

    else
        % -- try add another item to make 100% confidence for a rule
        % -- ignore min support

        % -- loop in Rules
        for i = 1 : rows

            isSameItem = false;

            % -- ignore same rule's index and only the same class            
            if i ~= maxConfIndex & maxConfRule{2} == rulesSeparate{i,2}

                % *** wait for check -- to do list : check first item for  2 itemsset rules

                if length(rulesSeparate{i,1}) > 1 

                    checkIndex = length(rulesSeparate{i,1}) - 1;
                    maxConfRuleHead = maxConfRule{1}(1,1:checkIndex);
                    rules1Head = rulesSeparate{i,1}(1,1:checkIndex);
                    checkNum = intersect(maxConfRuleHead,rules1Head);

                    if length(checkNum) == checkIndex
                        isTheSameItem = true;
                    end
                else
                    if maxConfRule{1} == rulesSeparate{i,1}               
                        isSameItem = true;
                    end            
                end % check first item for  2 itemsset rules

                % -- merge rules
                if isSameItem == false 
                    % -- rule1 TIDs
                    rule1Set = intersect(maxConfRule{3},rulesSeparate{i,3});
                    rule1Support = length(rule1Set);  

                    % -- union rules antecedent
                    ruleAntecedent = union(maxConfRule{1},rulesSeparate{i,1});

                    % -- Class Set & confidence
                        targetClass = findClass(maxConfRule{2},classLabel);
                        classSet = targetClass{1,2};    

                    if ~isempty(classSet) & rule1Support > 0

                        rule0Set = rules0{ruleAntecedent(1),2};
                        if length(ruleAntecedent) > 1

                            % -- intersect all of TIDs from rules0 {all
                            % classes
                            
                            for k=2:length(ruleAntecedent)
                                % -- rules0 TIDs , use to find a rule's confidence
%                                 rule0Set = intersect(rule0Set, rules0{rulesSeparate{i,1}(k),2});
                                rule0Set = intersect(rule0Set, rules0{ruleAntecedent(k),2});
                            end
                            
                        end
                        
                        conf = rule1Support / length(rule0Set)*100;
                        
                        % -- intersect rule & class , cal confidence
%                         resultSet = intersect(rule1Set, classSet);                     

                        % -- intersect all of TIDs                        
                        temp = [];
                        temp{1} = ruleAntecedent;                 
                        temp{2} = rulesSeparate{i,2};
                        temp{3} = rule1Set;    
                        temp{4} = rule1Support;                        
                        temp{5} = conf;

                        % -- separate-&-conqure
                        newRules = [newRules; temp];

                    end % -- ~isempty(classSet) & rule1Support > 0

                end % -- merge rules ~isSameItem 
            end  % -- ignore same index and only the same class  

        end % -- loop in Rules

        % -- recursion
        rule = separateAndConqure01(newRules, classLabel, rules0);

    end % -- if maxConf == 100

end % -- if rows == 0