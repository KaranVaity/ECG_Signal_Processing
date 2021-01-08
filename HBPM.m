% Run this script to directly find BPM without generating waveforms

%Make sure samples folder is in same folder as the script and samples folder
%contains all the patients folders.
%Make sure Filter.slx Model is in the same folder as the script.
%change the p_no variable to select different patient's ecg signal.
%use ctrl+shift+Enter to run current section.


%% Read the ECG signal from the samples folder
%change patient_no (1-10)
clear;
patient_no = 10;
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
N = length(t);
sim('Filter',t);
%% Wavelet transform
[c,l] = wavedec(sig_high,4,'sym4');
ap = appcoef(c,l,'sym4');
[cd1,cd2,cd3,cd4] = detcoef(c,l,[1 2 3 4]);
%% Reconstruct the signal with only D3 D4;
c_filt = cat(1,zeros(size(ap)),cd4,cd3,zeros(size(cd2)),zeros(size(cd1)));
y = waverec(c_filt,l,'sym4');

%% Peak detection
y_peak = abs(y).^2;
avg = mean(y_peak);
[Rpeaks,locs] = findpeaks(y_peak,t,'MinPeakHeight',8*avg,'MinPeakDistance',0.3);
nohb = length(locs);
hbpm = nohb*60/t(N);
fprintf('\nBPM = %f\n',hbpm);