% theorys.m
%
% The calculation of the theory value of the throughput
%
% Input arguments
%   no	: protocol number   1 : Pure ALOHA
%   g   : offered traffic (scalar or vector)
%
% Output argument
%   ts  : the theory value of the throughput (scalar or vector)
%


function [ts] = theorys(no,g)

if no                                              % Pure ALOHA
    ts = g .* exp(-2*g);
end

end

%%%%%%%%%%%%%%%%%%%%%% end of file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
