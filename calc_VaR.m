function[VaR]=calc_VaR(alpha,values,sides)

num = length(values);
pos1 = ceil(num*alpha);
sorted_vals = sort(values);

if sides==1
    VaR = sorted_vals(pos1);
elseif sides==2
    pos2 = ceil(num*(1-alpha));
    VaR = [sorted_vals(pos1),sorted_vals(pos2)];
else
    error('sides must be either 1 or 2 !')
end