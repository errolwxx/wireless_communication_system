format long
clear
clc
disp('please wait...This requires a few seconds'),...
disp('                                         ')

SNR = .6:.1:20;                       % signal to noise ratio per bit
SNR_dB = 10*log10(SNR);               % signal to noise ratio per bit in dB
for M = [2 4 8 16 32 64];             % To find probablity of error for M orthogonal signals
    k = log2(M);                      % k is number of bits : M = 2^k
    i = 1;                            % i is a counter used to construct BER Matirx...see below

    disp((['The program is estimating the probability of error for M = ' num2str(M) ' ....Processing']))

    
    for j = .6:.1:20;                 % j is a counter equal to SNR per bit in the range from 0.6 to 20  
        SNR_sym = j*k;                % SNR per symbol equal to SNR per bit multiplied by Number of bits
                     
        eval(['v =inline(''(1./(sqrt(2*pi)).*(1-((1-0.5*erfc(t)./sqrt(2))).^(' num2str(M) '-1)).*exp(-.5*(t-sqrt(2*' num2str(SNR_sym) ')).^2))'',''t'');' ]);
                      
        w = quadl(v,-10000,10000,1e-12);
        BER(k,i) = w;                 % Construct probability of error Matrix with 6 rows, corresponding to M-signals
        i = i+1;                      % counter increaments
    end
    

    disp('      Completed       ')

end


semilogy(SNR_dB,BER)
ylim([1e-6 1e-1])
grid
xlabel('SNR per bit (dB)')
ylabel('Probability of error')
title('Probability of error for coherent detection of orthogonal M-FSK signals')
legend('2-FSK','4-FSK','8--FSK','18-FSK','32-FSK','64-FSK')
