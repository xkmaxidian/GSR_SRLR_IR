function [out] = GST(s, y, p, T)
tao = (2*y*(1-p))^(1/(2-p)) + y*p*(2*y*(1-p))^((p-1)/(2-p));

if abs(s) <= tao
    out = 0;
else
    a = abs(s);
    for t=1:T
        a = abs(s)-y*p*a^(p-1);
    end
    out = sign(s)*a;
end

end

