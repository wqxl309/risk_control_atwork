function[solutions,best_solutions]=optimized_solutions(maxdd,steps,poschanges,rmin,type,postype,mktdd)
stepnum = length(steps);
posnum = length(poschanges);
titles = {'step','poschg','chgnum','mktchg','mktchg_per_time'};
solutions = zeros(stepnum*posnum,length(titles));

count = 1;
for dums=1:stepnum
    step = steps(dums);
    for dump=1:posnum
        poschg = poschanges(dump);
        [mktrets,positions] = mktreturns_calc(maxdd,step,poschg,rmin,type,postype);
        solutions(count,1:end-1) = [step,poschg,length(mktrets)-1,1-prod(1+mktrets(positions>0))];
        solutions(count,end) = solutions(count,end-1)/solutions(count,end-2);
        count = count+1;
    end
end
solutions = solutions(solutions(:,end-1)>=mktdd,:);
bestpos = find(solutions(:,end)==max(solutions(:,end)),1);
solutions = array2table(solutions,'VariableNames',titles);
best_solutions = solutions(bestpos,:);