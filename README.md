# ECG Signal Processing: Project Overview
* Developed a program in MATLAB/Simulink to determine the average heart rate of any unfiltered ECG signal
* Designed high pass and low pass filters in Simulink to remove noise from the sample
* Detected the R Peaks in the filtered signals by applying wavelet transforms in MATLAB and reconstructed the signal to isolate the R peaks.
* Applied a peak detecting algorithm to the reconstructed signal and determined the average heart rate of the sample

## Resources Used
**MATLAB Version:** 2014b   
**Simulink Version:** 8.4   
**WFDB Toolbox:** https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/   
**Physionet Database:** https://physionet.org/content/wctecgdb/1.0.1/   

## Usage
Clone the repository and download the WCT database from the physionet website and extract it in the project folder so that WCT folder is in the project directory. Also install the WFDB toolbox if other signals needs to analysed other that the those in samples folder. 

[dat_to_mat.m](./dat_to_mat.m):This is the script to change the WFDB signal into .mat format.  
[samples/](./samples/): contains different segments of the ECG signal of different patients in .mat format. 
[Filter.slx](./Filter.slx): contains the low pass and high pass filters for processing the signal.  
[MAIN.m](./MAIN.m): is the script to visualise the processing which occurs during the signal processing.  
[HBPM.m](./HBPM.m): directly computes the heartrate of a ny particular ecg signal which are in the samples folder.  
