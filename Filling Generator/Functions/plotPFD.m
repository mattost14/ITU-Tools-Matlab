function plotPFD(beamTx,p,pwrDensMax,color)
    d = 36000e3; %distance sat-earth (m)
    Gmax = p.Beam{beamTx,'Gain_tx'};
    refBand = p.PFD_RefBand; %Reference Band for PFD (kHz)
    ESD = Gmax + pwrDensMax + 10*log10(refBand*10^3);
    pfd = ESD - 10*log10(4*pi*d^2);   
    %bar(beamNumber,pfd,'FaceColor',color,'DisplayName',char(beamTx))
    xlim=get(gca,'xlim');
    hold on
    xlim=[xlim(end),xlim(end)+1];
    plot(xlim,[pfd pfd],'color',color,'DisplayName',char(beamTx),'LineWidth',3)
    text(0.5*(xlim(end)+xlim(1)),round(pfd),num2str(round(pfd),'%0.0f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',18)
    hold off
end