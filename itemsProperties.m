%% -- find column number which values is located
% --- Item's properties  1:value 2:atrribute number

function result = itemsProperties(source)

[totalRowNums,totalColNums] = size(source);

items = unique(source(:,1:totalColNums-1));
for item=1:totalColNums-1
    unq = unique(source(:,item));
    for q=1:length(unq)
        items(unq(q),2) = item;
    end
end

result = items;