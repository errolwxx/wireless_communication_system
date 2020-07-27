% graph.m
%
% The function of drawing the graph of simulation result.
%
% Input argument
%   filename : name of the file which simulation result was stored.
%
% Output argument
%   nothing
%

function graph_edit(filename)

mtitle1 = {'Throughput of Pure ALOHA system'};              % definition of the title 
mtitle2 = {'Average Delay time of Pure ALOHA system'};      % definition of the title


fid      = fopen(filename,'r');
nul      = fscanf(fid,'%s',2);
protocol = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',2);
caputre  = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',2);
dtime    = fscanf(fid,'%f',1);
nul      = fscanf(fid,'%s',2);
brate    = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',2);
srate    = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',2);
plen     = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',1);
mnum     = fscanf(fid,'%d',1);
nul      = fscanf(fid,'%s',2);
mcn      = fscanf(fid,'%f',1);
nul      = fscanf(fid,'%s',2);
tcn      = fscanf(fid,'%f',1);
nul      = fscanf(fid,'%s',2);
spend    = fscanf(fid,'%d',1);

idx = 0;
while 1
    data0 = fscanf(fid,'%f',1);
    data1 = fscanf(fid,'%f',1);
    data2 = fscanf(fid,'%f',1);
    data3 = fscanf(fid,'%f',1);
    data4 = fscanf(fid,'%f',1);
    data5 = fscanf(fid,'%f',1);
    data6 = fscanf(fid,'%f',1);
    
    if feof(fid) == 1                                           % eof
        break
    end
    
    idx = idx + 1;
    
    tg(idx) = data0;                                            % offered traffic
    g(idx)  = data3 / data1;                                    % actual offered traffic
    s(idx)  = data2 / data1;                                    % actual throughput
    w(idx)  = data4 / spend * srate / plen;                     % average delay
end

fclose(fid);

ts = theorys(protocol,g);                                 % calculation of the throughput
% Pure ALOHA :
plot(g,s,'bo:',g,ts,'r-');                                     % normal graph
legend('result','theory');                                   % legend
grid on;


title(char(mtitle1(protocol)),'FontSize',16);                   % title
xlabel('Traffic(Simulation result)','FontSize',14);             % x axis label
ylabel('Throughput','FontSize',14);                             % y axis label

figure(2);                                                      % preparation of the new graph windos
% Pure ALOHA:
plot(g,w,'bo:');                                            % normal graph
legend('result');                                           % legend
grid on;

title(char(mtitle2(protocol)),'FontSize',16);                   % title
xlabel('Traffic(Simulation result)','FontSize',14);             % x axis label
ylabel('Average Delay time(packet)','FontSize',14);             % y axis label
 
%%%%%%%%%%%%%%%%%%%%%% end of file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
