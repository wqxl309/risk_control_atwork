function[mktrets,addnet]=backreturns_calc(step,positions,netvals,type)
%　计算将仓位补回最高所需的市场收益
% 假设 ： 当前仓位为positions(end) 对应的仓位
%         当前产品净值为netvals(end)对应的
% 每当净值达到 netval的某个值+step即可将仓位增加一档
% 当仓位增加到最高（positions(1)）时即停止
if step<=0
   error('step 必须大于0！') 
end
if strcmp(type,'bynet')
    tp = 1;
elseif strcmp(type,'bypct')
    tp = 2;
end
len = length(positions);
currnet = netvals(1);
mktrets = zeros(1,len);
addnet = zeros(1,len);
for dumi=1:len
    currpos = positions(dumi);
    if dumi==len
        targetnet = 1;
    else
        if tp==1
            targetnet = netvals(dumi)+step;
        elseif tp==2
            targetnet = netvals(dumi)*(1+step);
        end
    end
    mktrets(dumi) = (targetnet/currnet-1)/currpos;
    addnet(dumi) = targetnet;
    currnet = targetnet;
end