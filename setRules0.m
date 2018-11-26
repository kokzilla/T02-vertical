function result = setRules0(sourceArray, TIDs)

[totalRowNums,totalColNums] = size(sourceArray);

rules0 = [];
% -- rules0's information
% -- 1 : item
% -- 2 : TIDs
% -- 3 : diffSet

for col=1:totalColNums
    
    % -- find items in column
    unqItem = unique(sourceArray(:,col));    
    
    for item=1:length(unqItem)
        
        % -- find transaction ids 
        rules0{unqItem(item), 1} = unqItem(item);        
        
        % -- sets
        [tmp,rules1] = find(sourceArray==unqItem(item));
        rules0{unqItem(item), 2} = tmp;
        
        % -- diffsets
        rules0{unqItem(item), 3} = setdiff(TIDs,tmp);
        
        % -- support 
        rules0{unqItem(item), 4} = totalRowNums - length(rules0{unqItem(item), 3});
    end
end

result = rules0;