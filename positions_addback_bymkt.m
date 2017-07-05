function[meanret,volatility,maxdd,up_chgs,down_chgs]=positions_addback_bymkt(mu,sigma,delta,simtype,maxlen,netvals,positions,step,type,startlevel)
% 在市场收益率为BM的情况下，计算仓位加回到1所需的时间
% 如果期间净值重新出发风控规则，则需减仓

totlevels = length(netvals);
curr_net_level = max(startlevel-1,1);
pre_netval = netvals(startlevel);
position = positions(curr_net_level);

timelen = 1;
%maxnet = pre_netval;
maxnet = 1;
netrets = zeros(maxlen,1);
drawdowns = zeros(maxlen,1);
mktrets = simrets_gen(mu,sigma,delta,simtype,[maxlen,1]);
mktnets = cumprod(1+mktrets);
mktmark = 1;
up_chgs = 0;
down_chgs = 0;
while timelen<= maxlen
    mktret = mktrets(timelen);
    netret = position*mktret;
    netrets(timelen) = netret;
    netval = pre_netval*(1+netret);
    if netval > maxnet
        maxnet = netval;
    end
    drawdowns(timelen) = netval/maxnet-1;
    % 先判断是否触发风控
    netpos = find(netval<=netvals);
    if ~isempty(netpos)
        netlevel = netpos(1)-1;
        if netlevel==0
            netlevel = 1;   % 如果跌破最大回撤也只减到此前的最小仓位
        end
    else
        netlevel = totlevels;
    end
    if netlevel < curr_net_level   % 触发了新的风控,需要调仓
        curr_net_level = netlevel;
        mktmark = mktnets(timelen);   % 调仓后更新市场净值标准
        down_chgs = down_chgs+1;
    else  % 再判断是否可以加回仓位
        % 确认当前仓位所处的档位,有可能1天的涨跌幅突破多个档位
        % 上调根据市场收益情况，以及上一档位情况 max(上一档位，市场涨幅水平)
        if strcmp(type,'bynet')
            mktchg = mktnets(timelen)-mktmark;
        elseif strcmp(type,'bypct')
            mktchg = mktnets(timelen)/mktmark - 1;
        else
            error('Must specify the type of adding step');
        end
        mktaddlevels = floor(mktchg/step);
        if mktaddlevels >0 && curr_net_level<totlevels  % 市场收益(据上次调仓时)达到加仓标准,且目前不是最高仓位（已达到最高仓位就不用再加了）
            targetlevel = min(totlevels,curr_net_level+mktaddlevels);
            if netval > netvals(targetlevel)  % 需要净值达到以上（否则会立即又减仓）
                curr_net_level = targetlevel;
                mktmark = mktnets(timelen);   % 调仓后更新市场净值标准
                up_chgs = up_chgs+1;
            end
        end
    end
    position = positions(curr_net_level);
    pre_netval = netval;
    timelen = timelen+1;
end
meanret = mean(netrets);
volatility = std(netrets);
maxdd = min(min(drawdowns),netvals(startlevel)-1);



