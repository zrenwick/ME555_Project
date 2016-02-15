function v = nthperm(v, n)
% NTHPERM   Efficiently return the Nth lexicographic permutation of V
% usage: v = nthperm(v, n)
%
% For example, the 2nd lexicographic permutation of 1:4 is [1 2 4 3], 
% and can be calculated with: NTHPERM(1:4, 2);
%
% Note, permutations are 1-indexed, so setting N = 1 will result in no 
% change to V.  Otherwise V is permuted in place into the desired Nth 
% permutation.
%
% IMPORTANT: V is assumed to be sorted.  This WILL NOT return the 
% correct permutation if input V is not sorted.  For example, this 
% cannot be used to get the 10th permutation by starting from the 5th
% permutation and asking for the 5th permutation after that.  You must
% start with the 1st permutation.
%
% (The upside is that if you have a different definition of "sorted" 
% then this will give the correct Nth permutation according to the 
% implied comparator.  For example, if you start with V in reverse
% sorted order, then this will give Nth permutations assuming an 
% inverted lexicographic comparator.)
%
% The input V is expected to be a vector.  If any other shape is
% input, the data are permuted as though they were a single long vector,
% column-wise (i.e. along dim 1 first, then dim 2, etc.).
%
% Any numeric type can be used in V.
%
%
% If speed is critical, a Mex version is also supplied in nthperm.cpp;
% compile with 'mex nthperm.cpp'.  On my system, this is about 10 
% times faster.  If many sequential permutations are desired, use my 
% NEXTPERMS Mex function instead.
%
% The Matlab version uses uint64 internally for the value N and the
% factorial radix lookup table.  This type has max value ~18e18.  The C++
% version uses unsigned long long, which is guaranteed to be at least
% uint64.  (And in practice I believe that is usually what it is.)  This is
% preferable to doubles as doubles cannot distinguish values 1 apart at
% greater than about 1e16.

% Version 0.3
% Peter H. Li 30-DEC-2013
% As required by MatLab Central FileExchange, licensed under the FreeBSD License


len = numel(v);
if len < 2, return; end

% Switch to 0-indexed, convert to uint64 if not already
n = uint64(n) - 1;
if n < 0
    error('nthperm:prhs', 'Second argument must be positive');
end

% Build factorial lookup table
fact = cumprodany(uint64(1:len));

% Initial wrap-around in case n > len!
n = mod(n, fact(len));

% Factorial radix rebasing and permuting of v in-place
for i = 1:len-1
    if n == 0, break; end
    d = idivide(n, fact(len-i));
    n = n - d*fact(len-i);
    v(i:i+d) = circshiftall(v(i:i+d), 1);
end


function v = circshiftall(v, n)
% CIRCSHIFTALL  Circshift arbitrary shaped data as if column vector
% usage: v = circshiftall(v, n)
%
% Matlab's builtin CIRCSHIFT only works column-wise.  This simple wrap
% allow shifting any arbitrary shaped data V, treating the whole V as
% a single column.

s = size(v);
v = circshift(v(:), n);
v = reshape(v, s);


function c = cumprodany(v)
% COMPRODANY  Simple copy of CUMPROD that works for any numeric type
c = zeros(size(v), class(v));
if isempty(v), return; end

c(1) = v(1);
for i = 2:numel(v)
  c(i) = c(i-1) * v(i);
end
