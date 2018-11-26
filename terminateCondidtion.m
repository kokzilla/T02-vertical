function terminate = terminateCondidtion(rules1, classLabel ,minSup)

    % -- check instance exists
    [rows, cols] =size(rules1);
    terminate = true;
    
    if rows > 0 
        
        % -- check exists instances
        [rowsClass, cols] =size(classLabel);
        i = 0;
        rowsExists = false;
        while (i <= rowsClass & rowsExists == false)
            i = i+1;

            if ~isempty(classLabel{i, 2})
                rowsExists = true;
            end       
        end

        if rowsExists == true 

            terminate = true;



            % -- at least 1 rule pass min sup 
            i = 0;
            while i<=rows & terminate == true
                i = i+1;
                if rules1{i,4} >= minSup
                    terminate = false;
                end
            end
        else
            terminate = false;
        end
    end

    
   