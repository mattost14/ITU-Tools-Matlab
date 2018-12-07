function Error = ReachESDLimit(Pwr_Max,pattern,Gmax,bwdth,regulation,margem)

i=0;
for phi=2:180
    i=i+1;
    gain = gainMask(phi,pattern,Gmax);
    ESD = gain + Pwr_Max -10*log10(bwdth);
    ESDLimit = getESDLimit(phi,regulation);
    Residual(i)=abs(ESDLimit-margem-ESD)^2;
end
    Error = sum(Residual);
end