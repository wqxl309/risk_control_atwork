function[]=plots_generate()

alphaR = 1-alpha;
if plots
    histnum=500;
    subplot('221');
    N = hist(annret,histnum);
    hist(annret,histnum);
    line([mannret,mannret],[0,max(N)],'linewidth',2,'color','r');
    line([VaR1(1),VaR1(1)],[0,max(N)],'linewidth',2,'color','g');
    line([VaR1(2),VaR1(2)],[0,max(N)],'linewidth',2,'color','y');
    title('年化收益率');
    str1 = strcat('mean=',num2str(mannret*100,'%.2f'),'\%');
    str2 = strcat('VaR_{',num2str(alpha),'}=',num2str(VaR1(1)*100,'%.2f'),'\%');
    str3 = strcat('VaR_{',num2str(alphaR),'}=',num2str(VaR1(2)*100,'%.2f'),'\%');
    xlabel(strcat('$',str1,'\hspace{0.2cm}',str2,'\hspace{0.2cm}',str3,'$'),'Interpreter','LaTex');
    
    subplot('222');
    N = hist(maxdds,histnum);
    hist(maxdds,histnum);
    line([mmaxdds,mmaxdds],[0,max(N)],'linewidth',2,'color','r');
    line([VaR2(1),VaR2(1)],[0,max(N)],'linewidth',2,'color','g');
    line([VaR2(2),VaR2(2)],[0,max(N)],'linewidth',2,'color','y');
    title('最大回撤');
    str1 = strcat('mean=',num2str(mmaxdds*100,'%.2f'),'\%');
    str2 = strcat('VaR_{',num2str(alpha),'}=',num2str(VaR2(1)*100,'%.2f'),'\%');
    str3 = strcat('VaR_{',num2str(alphaR),'}=',num2str(VaR2(2)*100,'%.2f'),'\%');
    xlabel(strcat('$',str1,'\hspace{0.2cm}',str2,'\hspace{0.2cm}',str3,'$'),'Interpreter','LaTex');
    
    subplot('223');
    N = hist(sharpe,histnum);
    hist(sharpe,histnum);
    line([msharpe,msharpe],[0,max(N)],'linewidth',2,'color','r');
    line([VaR3(1),VaR3(1)],[0,max(N)],'linewidth',2,'color','g');
    line([VaR3(2),VaR3(2)],[0,max(N)],'linewidth',2,'color','y');
    title('夏普比率');
    str1 = strcat('mean=',num2str(msharpe,'%.2f'));
    str2 = strcat('VaR_{',num2str(alpha),'}=',num2str(VaR3(1),'%.2f'));
    str3 = strcat('VaR_{',num2str(alphaR),'}=',num2str(VaR3(2),'%.2f'));
    xlabel(strcat('$',str1,'\hspace{0.2cm}',str2,'\hspace{0.2cm}',str3,'$'),'Interpreter','LaTex');
    
    subplot('224');
    N = hist(calmar,histnum);
    hist(calmar,histnum);
    line([mcalmar,mcalmar],[0,max(N)],'linewidth',2,'color','r');
    line([VaR4(1),VaR4(1)],[0,max(N)],'linewidth',2,'color','g');
    line([VaR4(2),VaR4(2)],[0,max(N)],'linewidth',2,'color','y');
    title('calmar比率');
    str1 = strcat('mean=',num2str(mcalmar,'%.2f'));
    str2 = strcat('VaR_{',num2str(alpha),'}=',num2str(VaR4(1),'%.2f'));
    str3 = strcat('VaR_{',num2str(alphaR),'}=',num2str(VaR4(2),'%.2f'));
    xlabel(strcat('$',str1,'\hspace{0.2cm}',str2,'\hspace{0.2cm}',str3,'$'),'Interpreter','LaTex');
end
