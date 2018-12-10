myPath = pwd;
load(strcat(myPath, '/p300present.mat'));
fid = fopen('test.csv','w');
header = "";
for i=1:24
    header = strcat(header, 'vector', num2str(i), {','});
end
fprintf(fid,'%s\n',header);
y=data;
Fs=512;
y(:,2) = [];
NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*Fs).';
Ylp = extremeCut(Y,F);
ylp = ifft(Ylp,'symmetric');
g = reshape(ylp, 128, 24); 
meanG = mean(g);
allOneString = sprintf('%.0f,' , meanG);
fprintf(fid,'%s\n',allOneString);
inp = readtable('test.csv');
yfit = trainedModel.predictFcn(inp);
if yfit == 0
    disp('No P300');
else
    disp('P300 present');
end