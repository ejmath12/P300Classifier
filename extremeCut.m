function y = extremeCut(Ylp,F)
Ylp(F>30) = 0;
Ylp(F<1) = 0;
y=Ylp;