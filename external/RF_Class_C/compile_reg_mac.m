% ********************************************************************
% * mex File compiling code for Random Forest (for linux)
% * mex interface to Andy Liaw et al.'s C code (used in R package randomForest)
% * Added by Abhishek Jaiantilal ( abhishek.jaiantilal@colorado.edu )
% * License: GPLv2
% * Version: 0.02 
% ********************************************************************/

function compile_reg_mac

    % execute this function in the src directory, and it will generate two
    % *.mexmaci64 files, that you have to move to the folder above

    %Matlab mex requires optimization to be all set in the mexopts.sh(or
    %.bat) file. So set it there not here
    cd('src');
    
    mex mex_ClassificationRF_train.cpp reg_RF.cpp cokus.cpp -output mexRF_train -DMATLAB 
    mex mex_ClassificationRF_predict.cpp reg_RF.cpp cokus.cpp -output mexRF_predict -DMATLAB 

    fprintf('Mex compiled\n')
    
    cd('..');

end