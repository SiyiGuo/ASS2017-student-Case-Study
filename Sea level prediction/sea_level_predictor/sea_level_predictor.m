%This program is based on the Data cleaned by Raymond.
%The unit is in millimeter
%This function returns three matrix:
%predictor:The predicted mean sea_level from 2016 to 2021
%risk_times: For how many times is the sea likely to rise above the average
%altitude of a given zone;if it is predicted that no storms can cause the
%submerging then the difference between the predicted maximum sea level and
%the average altitude in a given zone is returned
%safety index:If a given zone is predicted to be submerged in next five
%years the index is equal to 0;if not then the proportion with the maximum
%difference(safest zone) is returned
%safety_another_index fliter out the more dangerous area(safety index<0.1)

function [predictor,safety_index,risk_times,safety_another_index]=sea_level_predictor(cycle_len);
cycle_len=60;
filename='complete data set.csv';
mean_matrix=zeros(20,300/cycle_len);
N=xlsread(filename,'C2:KP21');
for i = 1:20
    for j = 1:cycle_len:300
        sum=0;
        for k=1:cycle_len
            sum=sum+N(i,j+k-1);
        end
        mean_matrix(i,(j+59)/cycle_len)=sum/cycle_len;
    end
end
predictor=zeros(20,1);
fitmodel=fit([1:300/cycle_len]',mean_matrix(1,:)','poly1');
predictor(1,1)=fitmodel(300/cycle_len+1);
for l=2:20
    fitmodel=fit([1:300/cycle_len]',mean_matrix(l,:)','poly1');
    predictor(l,1)=fitmodel(300/cycle_len+1);
end

filename='akua-island-student-data.xlsx';
M=xlsread(filename,1,'K7:K26');
M=M*1000;
risk_times=zeros(20,2);
highest_surge=zeros(20,1);
for i = 1:20
    surges=[];
 
    for j = 2:299
        if N(i,j)>mean_matrix(i,(cycle_len-rem(j,cycle_len)+j)/cycle_len)
            
            %any sea_level above the average sea level in that five year
            %period is deemed as big tide
            surges=[surges N(i,j)-min(N(i,j-1:j+1))];
            %the surge is defined as N(i,j)-min(N(i,j-1:j+1))
            if (predictor(i,1)+N(i,j)-min(N(i,j-1:j+1)))>M(i,1)
                %what if such a storm appears during 2016 and 2021?
                risk_times(i,1)=risk_times(i,1)+1; 
            end
        end
    end
    %treat the sea_level as a constant during 2016-2021 whcih equals to our
    %formly predicted value
    risk_times(i,2)=M(i,1)-(predictor(i,1)+max(surges));
    safety_index=zeros(20,1);
end
max_safety=0;
for i = 1:20
    if risk_times(i,2)<0
        risk_times(i,3)=0;
    end
    if risk_times(i,2)>0
        if risk_times(i,2)>max_safety
            max_safety=risk_times(i,2);
            safety_index(i,1)=1;
            %flag to show that it is reasonable to calculate the safety
            %index of this region
        end
    end
end
for m = 1:20
    if risk_times(m,2)>0
        safety_index(m,1)=risk_times(m,2)/max_safety;
    end
end
safety_another_index=safety_index;
for x= 1:20
    if safety_index(x,1)<0.1
        safety_another_index(x,1)=0;
    end
end
disp(risk_times)
disp(max_safety)
disp(safety_index)
disp(safety_another_index)
end




            
            
        
