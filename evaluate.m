function hitCount = evaluate(model, sourceArray, defaultClass)

testData = sourceArray;
hitCount = 0;

[rowsCARsSorted, colsCARsSorted] = size(model);

[rows, cols] = size(testData);
for i= 1 : rows
    
    instance = testData(i,1:cols-1);
    instanceClass = testData(i,cols);
    instanceClassIndex = find
    
    %-- loop CARs
    hit = false;
    j = 1;
    while hit==false & j <= rowsCARsSorted
        
        rule = model{j,1};
        ruleClass = model{j,2};
        
        % -- match antecedent
        if length(intersect(rule,instance)) == length(rule) 
            
            hit = true;
            
            % -- compare class
            if instanceClass == ruleClass                
                hitCount = hitCount + 1;
            else 
                
                
                % -- missed classify
%                 disp("#"+ i + " matched rule#" + j + " false " );
            end
        end    
        j = j+1;
    end
    % -- use default Class
    if hit==false
        if instanceClass == defaultClass                
                hitCount = hitCount + 1;
        else 
            % -- miss match
            i
        end 
    end
end