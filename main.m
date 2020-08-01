clear all

[Traffic1, S1, Delay1] = saloha(0);
[Traffic2, S2, Delay2] = saloha(1);
S = Traffic1.*exp(-Traffic1);                                               % theoritical throughput

plot(Traffic1, S1, ':bo', Traffic1, S, '-r', Traffic2, S2, '--g>')
tittle('Throughput of Slotted ALOHA system')
xlabel('Traffic(Simulation result)')
ylabel('Throughput')
legend('result without capture effect', 'theory capture effect', 'result with capture effect')

figure
plot(Traffic1, Delay1, ':bo', Traffic2, Delay2, '--g>')
tittle('Average Delay time of Slotted ALOHA system')
xlabel('Traffic(Simulation result)')
ylabel('Average Delay time(Packet)')
legend('result without capture effect', 'result with capture effect')