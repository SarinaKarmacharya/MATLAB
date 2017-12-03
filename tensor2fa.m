function [fa, T_] = tensor2fa(T)
  T_ = trace(T)/3;
  fa = sqrt(3/2) * norm((T - T_*eye(3)),'fro') / norm(T,'fro');
end
