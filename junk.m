function [x,ali] = junk(n)
if(n==0)
x = 1;
else
    ali = n+1;
    x = junk(n-1)*n;
end 

end