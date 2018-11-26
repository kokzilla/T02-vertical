function [classLabel, rules0] = setClass(rules0, TIDs, classUnique, classNums)

%  -- find class label data
classLabel = [];
% - 1  class number
% - 2 set
% - 3 diffset

itemNums = length(rules0) - classNums;

for i=1:classNums
     classLabel{i,1} = classUnique(i);
     
     % -- get intersect set
     classLabel{i,2} = rules0{itemNums + 1,2};
     
     classLabel{i,3} = setdiff(TIDs,classLabel{i,2});
         
     % -- delete class data from item data
     rules0(itemNums +1,:) = [];
end

