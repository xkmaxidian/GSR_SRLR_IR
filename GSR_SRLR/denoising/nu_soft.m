function [out] = nu_soft(S, tau)
[W, H] = size(S);
out = zeros(H, H);
for i=1:min(W, H)
    if S(i,i) > sqrt(tau)
        out(i,i) = 1 - tau/(S(i,i)*S(i,i));
    else
       	out(i,i) = 0;
    end
end

