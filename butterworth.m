function y = butterworth(x)

persistent Hd;

if isempty(Hd)
    
    Fpass = 1;    % Passband Frequency
    Fstop = 30;   % Stopband Frequency
    Apass = 1;    % Passband Ripple (dB)
    Astop = 60;   % Stopband Attenuation (dB)
    Fs    = 512;  % Sampling Frequency
    
    h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);
    
    Hd = design(h, 'butter', ...
        'MatchExactly', 'stopband', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);
