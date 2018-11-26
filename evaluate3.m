function [confusionMatrix, accuracy, precision, recall,f1] = evaluate3(model, testSet, defaultClass, classLabel)

testData = testSet;


[rows, cols] = size(classLabel);
confusionMatrix = zeros(rows,rows);

[rowsCARsSorted, colsCARsSorted] = size(model);

[rowsData, cols] = size(testData);


% -- default class index
defaultClassIndex = findClassIndex(defaultClass,classLabel);
for i= 1 : rowsData
    
    instance = testData(i,1:cols-1);
    instanceClass = testData(i,cols);
    instanceClassIndex = findClassIndex(instanceClass,classLabel);
    
    %-- loop CARs
    hit = false;
    j = 1;
    while hit==false & j <= rowsCARsSorted
        
        rule = model{j,1};
        ruleClass = model{j,2};
        ruleClassIndex = findClassIndex(ruleClass,classLabel);
        
        % -- match antecedent
        if length(intersect(rule,instance)) == length(rule) 
            
            hit = true;
            
            % -- compare class
            if instanceClass == ruleClass                
                
                % -- insert to matrix instanceclassIndex = actual , rule = predict 
                confusionMatrix(instanceClassIndex,ruleClassIndex) = ...
                    confusionMatrix(instanceClassIndex,ruleClassIndex) + 1;
            else 
                
                
                % -- missed classify
%                 disp("#"+ i + " matched rule#" + j + " false " );
            end
        end    
        j = j+1;
    end
    % -- use default Class
    if hit==false
         
        confusionMatrix(instanceClassIndex,defaultClassIndex) = ...
                confusionMatrix(instanceClassIndex,defaultClassIndex) + 1;       
    end
end

[rows, cols] = size(confusionMatrix);

accuracy = 0;
precision = 0;
recall =0;
f1 = 0;
FP = 0;
TP = 0;
FN = 0;
for i=1 : rows
    % -- Accuracy    
    TP = confusionMatrix(i,i);
    accuracy = accuracy + TP;
    
    % -- Loop for Precision, Recall
    FP = 0;
    FN = 0;
    for j=1 : cols
        % -- FN
        if i ~= j 
            FN = FN + confusionMatrix(i,j);
        end
        
        % -- FP
        if i ~= j 
            FP = FP + confusionMatrix(j,i);
        end
    end
    
    % -- Calculate for Precision
    class_precision = 0;
    if TP+FP > 0 
        class_precision = (TP / (TP+FP));
        precision = precision + class_precision;
    end
    
    % -- Calculate for Recall
    class_recall = 0;
    if TP+FN > 0
        class_recall = TP / (TP+FN);
        recall = recall + (TP / (TP+FN));
    end
    
    if class_precision+class_recall > 0        
        class_f1 = 2 * class_precision * class_recall/(class_precision+class_recall);    
        f1 = f1 + class_f1;
    end
    
end

accuracy = accuracy / rowsData;
precision = precision / rows;
recall = recall / cols;
f1 = f1/ rows;