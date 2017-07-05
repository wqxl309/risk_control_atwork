clear;
clc;
delete(gcp)
pool = parpool(4);

%%
delta = 1;
maxlen = 250;
mu = 0.1/maxlen; %0.2/maxlen; %0.08/100;
sigma = 0.05/sqrt(maxlen); %0.2/sqrt(maxlen); %0.02;
type ='bypct';
simtype = 'GBM';  % BM
startlevel = 2;
resize = 8*6;

%% market simulation
num = 50000;
shape = [num,maxlen];
alphas = [0.01,0.05];
start = 0.925;

simrets = simrets_gen(mu,sigma,delta,simtype,shape);
simnets = cumprod(1+simrets,2)*start;
mktrets = mean(simrets,2);
mktvols = std(simrets,0,2);
maxnets = ones(num,1);
mktdds = zeros(num,maxlen);
for dumi=1:maxlen
    idx = simnets(:,dumi)>maxnets;
    maxnets(idx,:) = simnets(idx,dumi);
    mktdds(:,dumi) = simnets(:,dumi)./maxnets-1;
end
mktdds = [start-ones(num,1) mktdds];
mktmaxdd = min(mktdds,[],2);
output_mkt = [mktrets,mktvols,mktmaxdd,zeros(num,2)];
report_mkt = reshape([report_generate(output_mkt,maxlen,alphas,1)]',resize,1);




%% ½øÈ¡ 

%netvals = [0.6,0.7,0.8];
%steplong = 0.025;
netvals = [0.9,0.925,0.95];
steplong = 5/1000;

positions1 = [0.36,0.6,1];
positions2 = [1/3,2/3,1];

alphas = [0.01,0.05];
len = 4;
num = 50000;
plots = 0;

output_jq1 = zeros(num,5,len);
output_jq2 = zeros(num,5,len);
output_jq3 = zeros(num,5,len);
output_jq4 = zeros(num,5,len);

list = [1:len 6 8];

report_jq1 = zeros(resize,length(list));
report_jq2 = zeros(resize,length(list));
report_jq3 = zeros(resize,length(list));
report_jq4 = zeros(resize,length(list));

for dums=1:length(list)
    step = list(dums)*steplong;
    tic
    
    result1 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions1,step,type,startlevel,@positions_addback_byself);
    result2 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions2,step,type,startlevel,@positions_addback_byself);
    result3 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions1,step,type,startlevel,@positions_addback_bymkt);
    result4 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions2,step,type,startlevel,@positions_addback_bymkt);
    
    output_jq1(:,:,dums) = result1;
    output_jq2(:,:,dums) = result2;
    output_jq3(:,:,dums) = result3;
    output_jq4(:,:,dums) = result4;
    
    report_jq1(:,dums) = reshape([report_generate(result1,maxlen,alphas,plots)]',resize,1);
    report_jq2(:,dums) = reshape([report_generate(result2,maxlen,alphas,plots)]',resize,1);
    report_jq3(:,dums) = reshape([report_generate(result3,maxlen,alphas,plots)]',resize,1);
    report_jq4(:,dums) = reshape([report_generate(result4,maxlen,alphas,plots)]',resize,1);
    
    toc
end
display('JQ finished');

%% 
assignin('base',strcat('output_jq1_',simtype,'_',type,'_',num2str(startlevel)),output_jq1);
assignin('base',strcat('output_jq2_',simtype,'_',type,'_',num2str(startlevel)),output_jq2);
assignin('base',strcat('output_jq3_',simtype,'_',type,'_',num2str(startlevel)),output_jq3);
assignin('base',strcat('output_jq4_',simtype,'_',type,'_',num2str(startlevel)),output_jq4);
save('output.mat',strcat('output_jq1_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_jq2_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_jq3_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_jq4_',simtype,'_',type,'_',num2str(startlevel)));



%% »ãèª
netvals = [0.8,0.85,0.9];
steplong = 0.0125;

positions1 = [0.25,0.5,1];
positions2 = [1/3,2/3,1];

alphas = [0.01,0.05];
len = 4;
num = 50000;
plots = 0;

output_hj1 = zeros(num,5,len);
output_hj2 = zeros(num,5,len);
output_hj3 = zeros(num,5,len);
output_hj4 = zeros(num,5,len);

list = [1:len 6 8];

report_hj1 = zeros(resize,length(list));
report_hj2 = zeros(resize,length(list));
report_hj3 = zeros(resize,length(list));
report_hj4 = zeros(resize,length(list));

for dums=1:length(list)
    step = list(dums)*steplong;
    tic
    
    result1 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions1,step,type,startlevel,@positions_addback_byself);
    result2 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions2,step,type,startlevel,@positions_addback_byself);
    result3 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions1,step,type,startlevel,@positions_addback_bymkt);
    result4 = montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions2,step,type,startlevel,@positions_addback_bymkt);
    
    output_hj1(:,:,dums) = result1;
    output_hj2(:,:,dums) = result2;
    output_hj3(:,:,dums) = result3;
    output_hj4(:,:,dums) = result4;
    
    report_hj1(:,dums) = reshape([report_generate(result1,maxlen,alphas,plots)]',resize,1);
    report_hj2(:,dums) = reshape([report_generate(result2,maxlen,alphas,plots)]',resize,1);
    report_hj3(:,dums) = reshape([report_generate(result3,maxlen,alphas,plots)]',resize,1);
    report_hj4(:,dums) = reshape([report_generate(result4,maxlen,alphas,plots)]',resize,1);
    
    toc
end
display('HJ finished');


%% 
assignin('base',strcat('output_hj1_',simtype,'_',type,'_',num2str(startlevel)),output_hj1);
assignin('base',strcat('output_hj2_',simtype,'_',type,'_',num2str(startlevel)),output_hj2);
assignin('base',strcat('output_hj3_',simtype,'_',type,'_',num2str(startlevel)),output_hj3);
assignin('base',strcat('output_hj4_',simtype,'_',type,'_',num2str(startlevel)),output_hj4);
save('output.mat',strcat('output_hj1_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_hj2_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_hj3_',simtype,'_',type,'_',num2str(startlevel)));
save('output.mat',strcat('output_hj4_',simtype,'_',type,'_',num2str(startlevel)));


%%
delete(pool);
