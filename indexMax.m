function [index, maxConf] = indexMax(rules1)

    [rows, cols] =size(rules1);
    
    index = 0;
    maxConf = 0;
    support = 0;
    
    for i=1:rows
        if maxConf < rules1{i,5}
            maxConf = rules1{i,5};
            support = rules1{i,4};
            index = i;
        elseif maxConf == rules1{i,5}
            if support < rules1{i,4}
                support = rules1{i,4};
                index = i;
            end
        end
    end
    