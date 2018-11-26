function [rules1, CARs, rulesAll, rulesWeak ,rules0] = setRules1(rules0,...
    CARs, rulesAll, TIDs, classLabel, itemNums, classNums, minConf, minSup, rulesWeak)

rules1 = [];
k = 1;
rulesWeak = [];

for j=1:classNums
    for i=1: itemNums
%         %-- intersect item and class 
        sets = intersect(rules0{i,2}, classLabel{j,2});
        
        % -- support
        supp = length(sets);

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
        else
%             rules1{k,1} = temp{1};
%             rules1{k,2} = temp{2};
%             rules1{k,3} = temp{3};    
%             rules1{k,4} = temp{4}; 
%             rules1{k,5} = temp{5};                     
% 
%             k = k+1;
        end
        % -- if not conf = 100 insert to rules 1 wait for gen 2-rules
    end
    % -- Delete Instance
[CARsRow, CARsCol] = size(CARs);
for m=1:CARsRow
    % -- TIDs
    sets = CARs{m,3};

    % -- delete rows of itemassociated with rules
    for x=1: itemNums
        rules0{x,2} = setdiff(rules0{x,2},sets);    
    end

    % -- delete rows of class associated with rules
    for x=1: classNums
        classLabel{x,2} = setdiff(classLabel{x,2},sets);    
    end
end

end


%% -- Update support and confidence
for j=1:classNums
    for i=1: itemNums
%         %-- intersect item and class 
        sets = intersect(rules0{i,2}, classLabel{j,2});
        
        % -- support
        supp = length(sets);

        rules1{k,1} = rules0{i,1}; 
        rules1{k,2} = classLabel{j,1};
        rules1{k,3} = sets;       
        rules1{k,4} = supp; 
        
        % -- cal rule confidence
        if ~isempty(rules0{i,2})
            conf =  supp/length(rules0{i,2}) * 100;
        else
            conf = 0;
        end
        rules1{k,5} = conf;                     

        k = k+1;
        
    end
end
