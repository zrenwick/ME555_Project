function [L, x, y] = cen_shift(X, x, y)
%XSHIFT Summary of this function goes here
%   Detailed explanation goes here
    L = X(1:2);
    xc = X(3:4);
    x = x-xc(1);
    y = y-xc(2);
end

