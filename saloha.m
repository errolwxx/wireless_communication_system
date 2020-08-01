% Slotted-Aloha Protocol Simulation
function [Traffic,S,Delay]=saloha(capture)

% input
% capture: 0-not consider 1-consider

% output
% traffic; S: throughput; Delay: average delay

% define states
STANDBY    = 0;                                
TRANSMIT   = 1;
COLLISION  = 2;
TOTAL = 10000;


% define channel
brate = 128e3;                                                              % bit rate
Srate = 2*10^3;                                                             % symbol rate
Plen  = 7*8;                                                                % packet length
Ttime = Plen/Srate;
Dtime = 0.01;                                                               % normalized propagation delay
alfa  = 3;                                                                  % propagation loss
sigma = 6;                                                                  % SD of shadowing in db

% define AP
r   = 100;                                                                  % service area radius
bxy = [0, 0, 5];                                                            % position of AP
tcn = 8;                                                                    % capture ratio/lowest SNR in C/N form

% define terminals
Mnum  = 1000;                                                               % number of terminals
mcn   = 30;                                                                 % C/N at the access point when transmitted from area edge
mpow  = 10^(mcn/10) * sqrt(r^2+bxy(3)^2)^alfa;                              % signal power
h = 0;                                                                      % terminal height
mxy = [randsrc(2,Mnum,[-r:r]);randsrc(1,Mnum,[0:h])];                       % generate random positions
out = 'test.dat';

while 1
    d = sqrt(sum(mxy(1:2,:).^2));
    
    [tmp, indx] = find(d>r);
    if length(indx) == 0
        break
    end
    mxy(:,indx) = [randsrc(2, length(indx), [-r:r]);mxy(3, indx)];
end
distance = sqrt(sum(((ones(Mnum,1)*bxy).'-mxy).^2));                        % distance from terminal to AP
mrnd = randn(1,Mnum);                                                       % shadowing of every terminal
G = [0.1:0.1:1,1.2:0.2:4];                                                  % theoritical trafiic
for indx = 1 :length(G)
    
    % initialize
    Tint  = -Ttime / log(1-G(indx)/Mnum);                                   % expectation value of packets generation interval
    Rint  = Tint;                                                           % expectation value of packets resending interval
    Spnum = 0;
    Splen = 0;
    Tplen = 0;
    Wtime = 10*60;
    
    slot = Plen/Srate;                                                      % slot length
    mgtime = -Tint*log(1-rand(1,Mnum));                                     % generated time of first packet
    mtime = (fix(mgtime/slot)+1)*slot;                                      % sending time
    Mstate = zeros(1,Mnum);                                                 % terminal state
    Mplen(1:Mnum) = Plen;                                                   % packet length
    now_time     = min(mtime);
    
    % iterating simulation
    while 1    
        idx = find(mtime==-1&Mstate==TRANSMIT);                                 % ID of successed transmission

        if length(idx) > 0                              
            Spnum = Spnum + 1;
            Splen = Splen + Mplen(idx);
            Wtime = Wtime + now_time - mgtime(idx);
            Mstate(idx) = STANDBY;
            mgtime(idx) = now_time - Tint * log(1-rand);                        % time of next generation
            mtime(idx) = (fix(mgtime(idx)/slot)+1)*slot;                        % time of next sending
        end

        idx = find(mtime==now_time&Mstate==COLLISION);                                % ID of failed transmission
        if length(idx) > 0
            Mstate(idx) = STANDBY;
            mtime(idx) = now_time - Rint*log(1-rand(1,length(idx)));
            mtime(idx) = (fix(mtime(idx)/slot)+1)*slot;
        end

        idx = find(mtime==now_time);
        if length(idx) > 0
            Mstate(idx) = TRANSMIT;
            mtime(idx) = now_time + Mplen(idx)/Srate;                           % time of finishing packet transmission
            mtime(idx) = round(mtime(idx)/slot)*slot;
            Tplen = Tplen + sum(Mplen(idx));
        end
        
        if Spnum >= TOTAL
            break
        end

        
        idx = find(Mstate==TRANSMIT|Mstate==COLLISION);                     % terminals of transmit or collison
        if capture == 0                                                     % without capture effect
            if length(idx) > 1
                Mstate(idx) = COLLISION;                                    % collission if over 1 packets are sending
            end
        else
            if length(idx) > 1
                pow  = mpow * distance.^-alfa .* 10.^(sigma/10*mrnd(idx));  % calculate receiver power
                [maxp, no] = max(pow);
                if Mstate(idx(no)) == TRANSMIT
                    if length(idx) == 1
                        cn = 10 * log10(maxp);
                    else
                        cn = 10 * log10(maxp/(sum(pow)-maxp+1));
                    end
                    Mstate(idx) = COLLISION;
                    if cn >= tcn                                            % received power larger than capture ratio
                        Mstate(idx(no)) = TRANSMIT;                         % transmitting success
                    end
                else
                    Mstate(idx) = COLLISION;
                end
            end
        end
        now_time = min(mtime);                                               % time advance until the next state change time
    end
    
    
    Traffic(idnx) = Tplen / Srate / now_time;
    T = Traffic(indx)
    S(idnx) = Splen / Srate / now_time;
    Delay(idnx) = Wtime / TOTAL * Srate / plen;
    
end

                
                
                
                
                