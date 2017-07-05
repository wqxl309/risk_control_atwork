function[mktrets,positions]=mktreturns_calc(maxdd,step,poschg,rmin,type,postype)
% 计算在最大回撤、调整方式、调整步长，仓位调整比例恒定的情况下，对应市场收益变动情况
[N,~] = change_times(maxdd,step,rmin,type);
mktrets = zeros(1,N+2);
mktrets(1) = -rmin;

if strcmp(postype,'linear')
    positions = 1-poschg*(0:N+1);   % +2 为了给reminder部分留一个位置
    positions(positions<=0) = 0;
elseif strcmp(postype,'exponential')
    positions = (1-poschg).^(0:N+1);
end
holding=1;
prenet = 1;
for dumi = 1:N
    if strcmp(type,'bynet')
        dd = dumi*step+rmin;   % dd 为dumi 调仓后对应的产品回撤 dd_0 = rmin
    elseif strcmp(type,'bypct')
        dd = 1-(1-rmin)*(1-step)^dumi;
    end
    prenet = prenet*(1+positions(dumi)*mktrets(dumi));
    if positions(dumi+1)==0  % 已经调整至空仓
        mktrets(dumi+1) = -inf;
        holding = 0;
        break;
    else
        mktrets(dumi+1) = ((1-dd)/prenet-1)/positions(dumi+1);
    end
end
if holding
    prenet = prenet*(1+positions(N+1)*mktrets(N+1));
    if prenet == 1-maxdd   % 最大回撤可以被整除
        mktrets = mktrets(1:end-1);
        positions = positions(1:end-1);
    else        
        mktrets(N+2) = ((1-maxdd)/prenet-1)/positions(N+2);
    end
else
    mktrets(positions==0) = -1;
end
mktrets(mktrets<-1) = -1;
safepos = find(mktrets==-1,1);  % 已经减仓至绝对安全的地步就不必再减仓了
if ~isempty(safepos)
    positions = positions(1:safepos);
    mktrets = mktrets(1:safepos);
end

