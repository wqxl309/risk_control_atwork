function[simrets]=simrets_gen(mu,sigma,delta,simtype,shape)

randvars = randn(shape);
if strcmp(simtype,'BM')
    simmu = mu/delta;
    simsigma = sigma/delta;
    simrets = max(simmu*delta + simsigma*randvars*sqrt(delta),-1);
elseif strcmp(simtype,'GBM')
    simmu = 1/delta*log((mu+1)/sqrt(1+sigma^2/(mu+1)^2));
    simsigma = sqrt(1/delta*log(1+sigma^2/(mu+1)^2));
    simrets = exp(simmu*delta+simsigma*randvars*sqrt(delta))-1;
else
    error('must specify simtype')
end