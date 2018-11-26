function [rules1, CARs, rulesAll, rules0, classLabel] = setRules1_2(rules0,...
    CARs, rulesAll,  classLabel, itemNums, classNums, minSup, minConf)

rules1 = [];
k = 1;

for i=1: itemNums
    for j=1:classNums

%         %-- intersect item and class 
        sets = intersect(rules0{i,2}, classLabel{j,2});
        
        % -- support
        supp = length(sets);
        
        if supp >= minSup
            temp = [];
            temp{1} = rules0{i,1};                 
            temp{2} = classLabel{j,1};
            temp{3} = sets;    
            temp{4} = supp;

            % -- cal rule confidence
            if ~isempty(rules0{i,2})
                conf =  supp/length(rules0{i,2}) * 100;
            else
                conf = 0;
            end
            temp{5} = conf;

            % -- if conf = 100 insert rules to CARs
            if conf == 100
                % -- insert to CARs            
                CARs = [CARs; temp];                   
            end

            rules1{k,1} = temp{1};
            rules1{k,2} = temp{2};
            rules1{k,3} = temp{3};    
            rules1{k,4} = temp{4}; 
            rules1{k,5} = temp{5};                     

            k = k+1;
        end
    end
        % -- if not conf = 100 insert to rules 1 wait for gen 2-rules
end    

%% -- Update support , confidence in rules1 and delete instance relate with 100% rules

[classLabel, rules0, rules1] = updateRules1(rules0, rules1, CARs, classLabel ,minSup, minConf);

