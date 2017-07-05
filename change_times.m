function[num,reminder]=change_times(maxdd,step,rmin,type)
% 计算从风控介入后，在给定的最大回撤目标与调整步长的情况下，
% 需要调仓的次数，reminder 为余数
% type 为步长采取净值变动方式 还是 收益率变动方式
% 如果 maxdd <= rmin， 则返回 0 
if rmin > maxdd
    error('风控介入需在创最大回撤之前');
end
if strcmp(type,'bynet')
    range = max(maxdd-rmin,0);
    num = floor(range/step);
    reminder = range - num*step;
elseif strcmp(type,'bypct')
    range = min((1-maxdd)/(1-rmin),1);
    num = floor(log(range)/log(1-step));
    reminder = 1-range/((1-step)^num);
end