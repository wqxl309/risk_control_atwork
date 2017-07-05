clc;
clear;

%% dumy test

maxdd = 0.2;    % 目标最大回撤
rmin = 0.1;      % 风控介入水平
poschg = 1/3;    % 仓位变动比例
step = 0.05;      % 净值/净值收益率 变动步长
type = 'bynet';  % 'bypct' ; % bynet     % 净值变动方式 净值数值变动 或 净值收益率变动
postype = 'linear';  % 'exponential';  % linear  % 减仓方式，线性 或 指数

[mktrets,positions] = mktreturns_calc(maxdd,step,poschg,rmin,type,postype);
netvals = cumprod(1+mktrets.*positions);
mktcums = cumprod(1+mktrets);


%% option ranges
poschanges = 0.05*(1:10);
steps = 0.05*(1:10);

%% 百泉进取一号
type = 'bynet';
postype = 'exponential';
rmin = 0.2;
maxdd = 0.4;
mktdd = 0.7;

tic 

[solutions,best_solutions]=optimized_solutions(maxdd,steps,poschanges,rmin,type,postype,mktdd);

toc

step_best = table2array(best_solutions(1,1));
poschg_best = table2array(best_solutions(1,2));

[mktrets_best,positions_best] = mktreturns_calc(maxdd,step_best,poschg_best,rmin,type,postype);
netvals_best = cumprod(1+mktrets_best.*positions_best);
mktcums_best = cumprod(1+mktrets_best);


%% 百泉汇瑾一号
type = 'bynet';
postype = 'exponential';
rmin = 0.1;
maxdd = 0.2;
mktdd = 0.3;

tic 

[solutions,best_solutions]=optimized_solutions(maxdd,steps,poschanges,rmin,type,postype,mktdd);

toc

step_best = table2array(best_solutions(1,1));
poschg_best = table2array(best_solutions(1,2));

[mktrets_best,positions_best] = mktreturns_calc(maxdd,step_best,poschg_best,rmin,type,postype);
netvals_best = cumprod(1+mktrets_best.*positions_best);
mktcums_best = cumprod(1+mktrets_best);


%% 稳健型 Alpha
type = 'bynet';
postype = 'exponential';
rmin = 0.04;
maxdd = 0.08;
mktdd = 0.5;
openpct = 0.15;

tic 

[solutions,best_solutions]=optimized_solutions(maxdd/openpct,steps,poschanges,rmin/openpct,type,postype,mktdd);

toc


%%

size = 10;
temp = zeros(1,size);
for s = 1:size
    st = step/size*s;
    [m,a]=backreturns_calc(st,positions,netvals,type);
    temp(s)=(prod(1+m)-1)/(a(end)/netvals(end)-1);
end
plot(temp);





