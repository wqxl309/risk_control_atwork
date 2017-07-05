function[result]=montecarlo_run(num,mu,sigma,delta,simtype,maxlen,netvals,positions,step,type,startlevel,func)

result = zeros(num,5);
parfor dumi=1:num
    [mret,vol,maxdd,ups,downs]=func(mu,sigma,delta,simtype,maxlen,netvals,positions,step,type,startlevel);
    result(dumi,:) = [mret,vol,maxdd,ups,downs];
end