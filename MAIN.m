
%Make sure samples folder is in same folder as the script and samples folder
%contains all the patients folders.
%Make sure Filter.slx Model is in the same folder as the script.
%change the p_no variable to select different patient's ecg signal.
%use ctrl+shift+Enter to run current section.

%% Read the ECG signal from the samples folder
%change patient_no (1-10)
clear;
patient_no = 6;
fname = strcat('samples/patient',num2str(patient_no),'/');
files=dir([fname '/*.mat']);
n=size(files,1);
sig =[];
t = [];
for k=1:1:n
    load(strcat(fname,'/seg0',num2str(k)));
    sig = cat(1,sig,sig1);
    t = cat(1,t,tm1+((k-1)*10));
    if(k<n)
        t(end)=[];
        sig(end)=[];
    end
end
%% Plot the unfiltered signal

plot(t,sig);
title('Unfiltered Signal');
xlabel('Time(sec)');
ylabel('Voltage(mVolts)');
Fs = Fs1;
dt = 1/Fs;
N = size(t,1);
X = fftshift(fft(sig));
f = -Fs/2:Fs/N:Fs/2-Fs/N;

%% Filtered Signal

sim('Filter',t);
figure;
plot(t,sig_low);
title('Low Pass Filtered Signal');
xlabel('Time(sec)');
ylabel('Voltage(mVolts)');
X_low = fftshift(fft(sig_low));

%% HighPass Filtered Signal

figure;
plot(t,sig_high);
title('Filtered Signal');
xlabel('Time(sec)');
ylabel('Voltage(mVolts)');
X_high = fftshift(fft(sig_high));

%% Different Frequency Spectrum
figure;
ax(1) = subplot(3,1,1);
plot(f,abs(X)/N);
title('Frequency Spectrum of Unfiltered Signal');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
ax(2) = subplot(3,1,2);
plot(f,abs(X_low)/N);
title('Frequency Spectrum of Low Pass filtered Signal');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
ax(3) = subplot(3,1,3);
plot(f,abs(X_high)/N);
linkaxes(ax,'y');
title('Frequency Spectrum of Filtered Signal');
xlabel('Frequency(Hz)');
ylabel('Amplitude');


%% Wavelet transform

[c,l] = wavedec(sig_high,4,'sym4');
ap = appcoef(c,l,'sym4');
[cd1,cd2,cd3,cd4] = detcoef(c,l,[1 2 3 4]);
figure;
ax(1) = subplot(5,1,1);
plot(ap);
title('approximate coeff');
ax(2) = subplot(5,1,2);
plot(cd1);
title('detailed coeff d1');
ax(3) = subplot(5,1,3);
plot(cd2);
title('detailed coeff d2');
ax(4) = subplot(5,1,4);
plot(cd3);
title('detailed coeff d3');
ax(4) = subplot(5,1,5);
plot(cd4);
title('detailed coeff d4');

%% Reconstruct the signal with only D3 D4;
c_filt = cat(1,zeros(size(ap)),cd4,cd3,zeros(size(cd2)),zeros(size(cd1)));
y = waverec(c_filt,l,'sym4');
figure;
plot(t,y)

%% Peak detection
y_peak = abs(y).^2;
avg = mean(y_peak);
[Rpeaks,locs] = findpeaks(y_peak,t,'MinPeakHeight',8*avg,'MinPeakDistance',0.3);
nohb = length(locs);
hbpm = nohb*60/t(N);
fprintf('\nBPM = %f\n',hbpm);