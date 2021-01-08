clear;
for m=10:1:10
    fname1 = strcat('WCT/patient0',num2str(m),'/');
    files=dir([fname1 '/*.dat']);
    n=size(files,1);
    for k=1:1:n
        [sig1, Fs1, tm1] = rdsamp(strcat(fname1,'seg0',num2str(k)), 1);
        fname = strcat('samples/patient',num2str(m),'/seg0',num2str(k));
        save(fname,'sig1','Fs1','tm1');
    end
end
