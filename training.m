myDir = uigetdir;
totalSample = 3072;
Fs=512;
fid = fopen('subjects.csv','w');
prompt = 'Subject number whose data you would like to train the model with(Enter 4 for all)?';
subjectType = input(prompt);
prompt = 'Enter the sample divisions';
sampleDiv = input( prompt ); 
prompt = 'Filter Type?';
typeOfFilter = input( prompt, 's'); 
if subjectType == 1
    myFiles = dir(fullfile(myDir,'/Data/Subject 1/*.mat'));
elseif subjectType == 2
    myFiles = dir(fullfile(myDir,'/Data/Subject 2/*.mat'));
elseif subjectType == 3
    myFiles = dir(fullfile(myDir,'/Data/Subject 3/*.mat'));
else
    myFiles = dir(fullfile(myDir,'/Data/Subject*/*.mat'));
end
header = "";
for i=1:sampleDiv
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
    if(strcmp(typeOfFilter,'fft'))      
    NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*Fs).';
Ylp = extremeCut(Y,F);
ylp = ifft(Ylp,'symmetric');
    else
        ylp = butterworth(y);
    end
g = reshape(ylp, totalSample/sampleDiv, sampleDiv); 
if(totalSample == sampleDiv)
   meanG = g;
else
   meanG = mean(g);
end
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