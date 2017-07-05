function[]=distribution_plot(vars,mvars,VaR,alpha,titlename,percentage)
if percentage
    per = '\%';
    multi = 100;
else
    per = '';
    multi = 1;
end
alphaR = 1-alpha;
histnum=500;
N = hist(vars,histnum);
hist(vars,histnum);
line([mvars,mvars],[0,max(N)],'linewidth',2,'color','r');
line([VaR(1),VaR(1)],[0,max(N)],'linewidth',2,'color','g');
line([VaR(2),VaR(2)],[0,max(N)],'linewidth',2,'color','y');
title(titlename);
str1 = strcat('mean=',num2str(mvars*multi,'%.2f'),per);
str2 = strcat('VaR_{',num2str(alpha),'}=',num2str(VaR(1)*multi,'%.2f'),per);
str3 = strcat('VaR_{',num2str(alphaR),'}=',num2str(VaR(2)*multi,'%.2f'),per);
xlabel(strcat('$',str1,'\hspace{0.2cm}',str2,'\hspace{0.2cm}',str3,'$'),'Interpreter','LaTex');