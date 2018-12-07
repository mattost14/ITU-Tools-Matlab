function gain = gainMask(phi,pattern,Gmax,A,B,C,D,Phi1)

if(strcmp('AP8',pattern))
    %% AP8
    DoverLambda = 10^((Gmax-7.7)/20);
    G1 = 2 + 15*log10(DoverLambda);
    phiM = 20*DoverLambda^-1*sqrt(Gmax-G1);
    phiB = 48;
    if(DoverLambda>=100)
        phiR = 15.85*(DoverLambda)^(-0.6);
    else
        phiR = 100*(DoverLambda)^-1;
    end
    if(DoverLambda>=100)
        if(phi>=0 && phi <phiM)
            gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
        elseif(phi>=phiM && phi < phiR)
            gain = G1;
        elseif(phi>=phiR && phi<phiB)
            gain = 32-25*log10(phi);
        elseif(phi>=phiB && phi<=180)
            gain=-10;
        end
    else
        if(phi>=0 && phi <phiM)
            gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
        elseif(phi>=phiM && phi < phiR)
            gain = G1;
        elseif(phi>=phiR && phi<phiB)
            gain = 52-10*log10(DoverLambda)-25*log10(phi);
        elseif(phi>=phiB && phi<=180)
            gain=10-10*log10(DoverLambda);
        end       
    end   
elseif(strcmp('REC-465-5',pattern))
    %% REC-465-5  
    mi=0.7;
    DoverLambda = sqrt((10^(Gmax/10)/(mi*pi^2)));
    if(DoverLambda>100)
        G1 = 32;
        phiR = 1;
    else
        G1 = -18+25*log10(DoverLambda);
        phiR = 100*DoverLambda^-1;
    end
    phiM = 20*DoverLambda^-1*sqrt(Gmax-G1);
    phiB = 10^(42/25);
    if(phi>=0 && phi <phiM)
        gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
    elseif(phi>=phiM && phi < phiR)
        gain = G1;
    elseif(phi>=phiR && phi<phiB)
        gain = 32-25*log10(phi);
    elseif(phi>=phiB && phi<=180)
        gain=-10;
    end
elseif(strcmp('REC-580-6',pattern))
    %% REC-580-6
    mi=0.7;
    DoverLambda = sqrt((10^(Gmax/10)/(mi*pi^2)));
    if(DoverLambda<50)
        G1 = 2+15*log10(DoverLambda);
    elseif(DoverLambda>=50 && DoverLambda<100)
        G1 = -21+25*log10(DoverLambda);
    else
        G1 = -1 + 15*log10(DoverLambda);
    end
    phiM = 20*DoverLambda^-1*sqrt(Gmax-G1);
    phiB = 10^(42/25);
    if(DoverLambda>=100)
        phiR = 15.85*(DoverLambda)^(-0.6);
    else
        phiR = 100*(DoverLambda)^-1;
    end
    if(DoverLambda>=50)
        if(phi>=0 && phi <phiM)
            gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
        elseif(phi>=phiM && phi < phiR)
            gain = G1;
        elseif(phi>=phiR && phi<=19.95)
            gain = 29-25*log10(phi);
        elseif(phi>19.95 && phi<=phiB)
            gain=min(-3.5,32-25*log10(phi));
        else
            gain=-10;
        end
    else
        if(phi>=0 && phi <phiM)
            gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
        elseif(phi>=phiM && phi < phiR)
            gain = G1;
        elseif(phi>=phiR && phi<phiB)
            gain = 52-10*log10(DoverLambda)-25*log10(phi);
        elseif(phi>=phiB && phi<=180)
            gain=10-10*log10(DoverLambda);
        end       
    end
elseif(strcmp('ABCDphi1',pattern))
    %% REC-ABCDphi1 
    if(phi>=0 && phi<1)
        gain = Gmax;
    elseif(phi>=1 && phi<=Phi1)
        gain = A-B*log10(phi);
    else
        gain = max(min(gainMask(Phi1,pattern,Gmax,A,B,C,D,Phi1),C-D*log10(phi)),-10);
    end
    if(gain>Gmax)
        gain = Gmax;
    elseif(gain<-10)
        gain = -10;
    end  
elseif(strcmp('A-25*LOG(FI)',pattern))
    %% A-25*LOG(FI)  
    mi=0.7;
    DoverLambda = sqrt((10^(Gmax/10)/(mi*pi^2)));
    if(DoverLambda>100)
        G1=A;
        phiR=1;
    else
        G1=A-50+25*log10(DoverLambda);
        phiR = 100*DoverLambda^-1;
    end
    phiM = 20*DoverLambda^-1*sqrt(Gmax-G1);
    
    if(phi>=0 && phi<phiM)
        gain = Gmax - 2.5*10^(-3)*(DoverLambda*phi)^2;
    elseif(phi>=phiM && phi<phiR)
        gain =G1;
    else
        gain =max(A - 25*log10(phi),-10);
    end
elseif(strcmp('ND-EARTH',pattern))
    %% ND-EARTH
    gain = Gmax;
else
    msg = sprintf('Radiation Pattern: %s    NOT DEFINED',char(pattern));
    disp(msg);
    gain=nan;
end
end