function plotUplinkESDlimits(regulation,phimax)

    if(strcmp('ITU-S.524-6 (29.5-30GHz)',regulation))
        %Reference Band
        refBand = 40e3; %(Hz)
        i=0;
        for phi=2:0.1:phimax
            i=i+1;
            if(phi>=2 && phi<7)
                esd = 32-25*log10(phi);
            elseif(phi>=7 && phi<=9.2)
                esd = 11;
            elseif(phi>9.2 && phi<=48)
                esd = 35-25*log10(phi);
            else
                esd = -7;
            end
            ESD(i)=esd-10*log10(refBand);
        end
        hold on
        plot(2:0.1:phimax,ESD,'--k','DisplayName','Ref','LineWidth',3);
        hold off
    end
    if(strcmp('ITU-S.524-6 (6 GHz)',regulation))
    end
    if(strcmp('Ka-Band MIL-STD-188/164B',regulation))
        i=0;
        for phi=2:0.1:phimax
            i=i+1;
            if(phi>=2 && phi<20)
                esd = -6.4-25*log10(phi);
            elseif(phi>=20 && phi<=26.3)
                esd = -38.9;
            elseif(phi>26.3 && phi<48)
                esd = -3.4-25*log10(phi);
            else
                esd = -45.4;
            end
            ESD(i)=esd;
        end
        hold on
        plot(2:0.1:phimax,ESD,'--r','DisplayName','Ref','LineWidth',3);
        hold off
    end
    if(strcmp('X-Band MIL-STD-188/164B',regulation))
        i=0;
        for phi=2:0.1:phimax
            i=i+1;
            if(phi>=2 && phi<3.8)
                esd = 2.351-25*log10(phi);
            elseif(phi==3.8)
                esd = -13;
            elseif(phi>3.8 && phi<5)
                esd = 1.49-25*log10(phi);
            elseif(phi>=5 && phi<6.94)
                esd = -3.97-25*log10(phi);
            elseif(phi>=6.94 &&phi<=12.42)
                esd = -25;
            elseif(phi>12.42 && phi<48)
                esd = 2.35-25*log10(phi);
            else
                esd = -39.65;
            end
            ESD(i)=esd;
        end
        hold on
        plot(2:0.1:phimax,ESD,'--r','DisplayName','Ref','LineWidth',3);
        hold off
    end
end