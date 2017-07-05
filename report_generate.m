function[results]=report_generate(output,periods,alphas,plots)

rets = output(:,1);
vols = output(:,2);
maxdds = output(:,3);
ups = output(:,4);
downs = output(:,5);
chgs = ups+downs;

annret = rets*periods;
annvol = vols*sqrt(periods);
sharpe = annret./annvol;
calmar = -annret./maxdds;

mannret = mean(annret);
mannvol = mean(annvol);
mmaxdds = mean(maxdds);
msharpe = mean(sharpe);
mcalmar = mean(calmar);
mups = mean(ups);
mdowns = mean(downs);
mchgs = mean(chgs);
%　worst case
wannret = min(annret);
wannvol = max(annvol);
wmaxdds = min(maxdds);
wsharpe = min(sharpe);
wcalmar = min(calmar);
wups = max(ups);
wdowns = max(downs);
wchgs = max(chgs);

sorted_alphas = sort(alphas);
allen = length(alphas);
results = zeros(8,2+2*allen);
results(:,1) = [mannret;mannvol;mmaxdds;msharpe;mcalmar;mups;mdowns;mchgs];
results(:,2) = [wannret;wannvol;wmaxdds;wsharpe;wcalmar;wups;wdowns;wchgs];
for dumi=1:allen
    alpha = alphas(dumi);
    VaR1 = calc_VaR(alpha,annret,2);
    VaR2 = calc_VaR(alpha,annvol,2);
    VaR3 = calc_VaR(alpha,maxdds,2);
    VaR4 = calc_VaR(alpha,sharpe,2);
    VaR5 = calc_VaR(alpha,calmar,2);
    VaR6 = calc_VaR(alpha,ups,2);
    VaR7 = calc_VaR(alpha,downs,2);
    VaR8 = calc_VaR(alpha,chgs,2);
    pos = find(sorted_alphas==alpha);
    results(:,[2+pos,end-pos+1]) = [VaR1;VaR2;VaR3;VaR4;VaR5;VaR6;VaR7;VaR8;];
end

if plots   % 暂时画alphas最后一个
    alpha = alphas(end);
    subplot('331');
    distribution_plot(annret,mannret,VaR1,alpha,'年化收益率',1); 
    subplot('332');
    distribution_plot(annvol,mannvol,VaR2,alpha,'年化波动率',1);
    subplot('333');
    distribution_plot(maxdds,mmaxdds,VaR3,alpha,'最大回撤',1);
    subplot('334');
    distribution_plot(sharpe,msharpe,VaR4,alpha,'夏普比率',0);
    subplot('335');
    distribution_plot(calmar,mcalmar,VaR5,alpha,'卡玛比率',0);
    subplot('336');
    distribution_plot(ups,mups,VaR6,alpha,'上调整次数',0);
    subplot('337');
    distribution_plot(downs,mdowns,VaR7,alpha,'下调整次数',0);
    subplot('338');
    distribution_plot(chgs,mchgs,VaR8,alpha,'总调整次数',0);
end
