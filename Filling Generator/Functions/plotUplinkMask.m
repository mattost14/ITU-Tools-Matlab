function plotUplinkMask(stationID,p,PwrDensMax,color,phimax,MinOrMax)
    pattern = p.EarthStation{stationID,'Pattern'};
    Gmax = p.EarthStation{stationID,'Gtx'};
    i=0;
    for phi=0:0.1:phimax
        i=i+1;
        ESD(i) = PwrDensMax + gainMask(phi,pattern,Gmax);
    end
    phi=0:0.1:phimax;
    hold on
    if(strcmp(MinOrMax,'Max'))
        plot(phi,ESD,'color',color,'DisplayName',char(stationID), 'LineWidth',2); 
    else
        plot(phi,ESD,'color',color,'LineStyle','-');
    end
    hold off
end