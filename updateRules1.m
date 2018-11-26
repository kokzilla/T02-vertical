function [classLabel, rules0, rulesTemp ] = updateRules1(rules0, rules1,...
    newRules, classLabel, minSup, minConf)


    [rules1Rows , cols] = size(rules1);
    [rules0Rows , cols] = size(rules0);
    [classNums , cols] = size(classLabel);
    
    % -- Delete Instance
    [rows, cols] = size(newRules);
    
    rulesTemp = [];
    
    for i=1:rows
        % -- TIDs
        sets = newRules{i,3};
        
        % -- delete rows of class associated with rules
        for j=1: classNums
%             if rules1{j,2} == classLabel{j,1}
                classLabel{j,2} = setdiff(classLabel{j,2},sets);   
%             end
        end
        
        % -- delete rows of itemassociated with rules
        for j=1: rules0Rows
            rules0{j,2} = setdiff(rules0{j,2},sets); 
        end
        
        % -- delete rows of itemassociated with rules divide by class        
        for j=1: rules1Rows

            rules1{j,3} = setdiff(rules1{j,3},sets);   

            % -- update support                
            rules1{j,4} = length(rules1{j,3});

            % -- update confidence
            if ~isempty(length(rules0{rules1{j,1},2}))
                % ***-- to do list , confidence of morethan 1-itemset rules
                
                rowsRuleAntecedent = length(rules1{j,1});
                if rowsRuleAntecedent > 1
                    
                    % -- intersect all of TIDs
                    
                    rule0Set = rules0{rules1{j,1}(1),2};
                    for k=2:rowsRuleAntecedent
                        
                        % -- rules0 TIDs , use to find a rule's confidence
                        rule0Set = intersect(rule0Set, rules0{rules1{j,1}(k),2});
                    end 
                    
                    rules1{j,5} = rules1{j,4}/ length(rule0Set)* 100;
                else
                    rules1{j,5} = rules1{j,4}/ length(rules0{rules1{j,1},2})* 100;
                end
                
                
            else
                rules1{j,5} = 0;
            end                    
        end
    end
    
    k = 1;
    for j=1:rules1Rows
        % -- all rules have to passed minimum support
        if rules1{j,4} >= minSup
            rulesTemp{k,1} = rules1{j,1};
            rulesTemp{k,2} = rules1{j,2};
            rulesTemp{k,3} = rules1{j,3};    
            rulesTemp{k,4} = rules1{j,4}; 
            rulesTemp{k,5} = rules1{j,5};    

            k = k+1;
        end
    end
    
    
