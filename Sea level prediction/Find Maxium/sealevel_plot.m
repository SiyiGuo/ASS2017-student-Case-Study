%Programmer: Michael
%Created date: 5/3/2017

%read the excel data into a 20*300 matrix
filename='akua-island-student-data.xlsx'
N=xlsread(filename,2,'B11:KO30');
%replace non-integer value NaN(XXXX in excel data)
%with -99999 which will not influence the maxiumum value in one year
for i = 1:20
    for j= 1:300 %300 months /12 month(cycle length) = 25 years
        if isnan(N(i,j))
            N(i,j)=-99999;
        end
    end
end
%construct a 20*25 matrix max_matrix with each max_matrix(i,j) specifying
%the maximum value of sea level of zone i in the jth month from 1992.
%jth year actually mean jth month from 1992, and the maximum value 
%is chosen for each cycl_length, which defined below:

cycle_length=3;%12 can be changed to other length of period
                %should be in the factor of 300
max_matrix=zeros(20,300/cycle_length);

for i = 1:20 %from block 1 to block 20
    max=-99999;
    
    %the matrix for maxium value in each period
    B=zeros(1,300/cycle_length); 
    for j=1:300 %300 months /12 month(cycle length) = 25 years
        if N(i,j)>max %read from original data
            max=N(i,j);
        end
        if rem(j,cycle_length)==0; %if have go through the whole period
            B(j/cycle_length)=max;  %write in this periods maxium value
            max=-99999; %reset threashold value 
        end
    end
    
    %write in this zones's data, and move to calculate next zone
    max_matrix(i,:)=B; 
end

%plot graph according to the max_matrix
%if -99999 appears the data is invalid so I skip it here
for i=1:20
    v=[];
    for j=1:(300 / cycle_length) %300 month / 12month(cycle_length) = 25
        if max_matrix(i,j)~=-99999
            v=[v max_matrix(i,j)];
        end
    end
    
    figure
    x=1:length(v);
    plot(x,v, '-o');
    
    %some graph setting to makes them look easier
    block = strjoin({'block', num2str(i), 'with', num2str(cycle_length), 'month cycle_length'});
    title(block)
    ylabel('maxium value in each year')
    xlabel('cycles from 1992')
end

figure
for i=1:20
    v=[];
    for j=1:(300 / cycle_length) %300 month / 12month(cycle_length) = 25
        if max_matrix(i,j)~=-99999
            v=[v max_matrix(i,j)];
        end
    end
    
    x=1:length(v);
    plot(x,v, '-o');
   
    %some graph setting to makes them look easier
    hold on
end
title(strjoin({'all block in one graph','with', num2str(cycle_length), 'month cycle length'}))
ylabel('maxium value in each year')
xlabel('years from 1992')
legend('block 1','block 2','block 3','block 4','block 5','block 6', 'block 7','block 8','block 9','block 10','block 11','block 12','block 13','block 14','block 15','block 16','block 17','block 18','block 19','block 20')