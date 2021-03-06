function Out = RHMC(L, current_q, mu, Sigma )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
q=current_q;
 p=normrnd(0,1,1,length(q));
 current_p = p;
 l=0.95;
% Make a half step for momentum at the beginning
  h = abs(normrnd(0,l/power(length(q),1/4)));
  p = p - h* (grad_U(q, mu, Sigma))'/ 2;
% Alternate steps for position and momentum
for i=1:L
    % Make a full step for position
    h = abs(normrnd(0,l/power(length(q),1/4)));
    q = q + h* p;
    % make a full step for momentum, except at end of trajectory
    if i~=L
        p = p - h* (grad_U(q, mu, Sigma))';
    end
end
 % Make a half step momentum in the end
 h = abs(normrnd(0,l/power(length(q),1/4)));
 p = p - (h/2)* (grad_U(q, mu, Sigma))';
 p=-p;
 % Evaluate potential and kinetic energy at start and end of trajectory
 
 current_U=U(current_q, mu, Sigma);
 current_K=sum(current_p.^2)/2;
 proposed_U=U(q, mu, Sigma);
 proposed_K=sum(p.^2)/2;
 
 if (rand(1) < exp(current_U-proposed_U+current_K-proposed_K))
     Out=q;
 else
     Out= current_q;
 end


end

