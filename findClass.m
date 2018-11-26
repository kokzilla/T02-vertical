function [class] = findClass(target, classLabel)
    [rows, ~] = size(classLabel);
    
    found = false;
    i = 0;
    while i<= rows && found == false
        i = i+1;
        
        if classLabel{i,1} == target
            class = classLabel(i,:);
            found = true;
        end
    end
