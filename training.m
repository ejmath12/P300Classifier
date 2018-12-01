myDir = uigetdir;
myFiles = dir(fullfile(myDir,'/Subject*/*.mat'));
fid = fopen('subjects.csv','w');
header = "";
for i=1:24
    header = strcat(header, 'vector', num2str(i), {','});
end
header = strcat(header,'label');
fprintf(fid,'%s\n',header);
i =0;
sum = 0;
for k = 1:length(myFiles)
    baseFolder = strcat(myFiles(k).folder, "/");
    baseFileName = myFiles(k).name;
    load(strcat(baseFolder, baseFileName));
    y = data;
    y(:,2) = [];
    Fs=512;
    NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*Fs).';
Ylp = Y;
Ylp(F>50) = 0;
Ylp(F<1) = 0;
ylp = ifft(Ylp,'symmetric');
g = reshape(ylp, 128, 24);
meanG = mean(g);
allOneString = sprintf('%.0f,' , meanG);
baseFileName = replace(baseFileName, ".mat", "");
if(rem(length(baseFileName),2)~=0)
    allOneString = strcat(allOneString,'1');
else
    if(strcmp(baseFileName(1:length(baseFileName)/2), baseFileName((length(baseFileName)/2)+1: length(baseFileName))))
        allOneString = strcat(allOneString,'0');
    else
        allOneString = strcat(allOneString,'1');
    end
end
fprintf(fid,'%s\n',allOneString);
end
dTTable = readtable('subjects.csv');