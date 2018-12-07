function Error = reachMargem(Pwr_Min,bwdth,Freq,Gtx,Grx,T,Desired_CoverN,Desired_Margem)
    %Constants
    k=1.38064852e-23; %(m2Kgs-2K-1)
    c=3e8; %(m/s)
    d=36000e3; %(m)
    %Free Path Loss
    FPL = 20*log10(4*pi*d*Freq/c);
    %Link Budget
    CoverN = Pwr_Min - 10*log10(bwdth) + Gtx - FPL + Grx - 10*log10(k*T);
    Margem = CoverN - Desired_CoverN;   
    Error = abs(Margem - Desired_Margem);
end