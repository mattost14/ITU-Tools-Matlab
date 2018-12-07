function plotUplinkEmission(UPLINKemission,p)
    count=0;
    for st=1:length(p.EarthStation{:,'ID'})
        colorNumber = rand(1,3);
        start=count;
        stID = p.EarthStation{st,'ID'};
        for e=1:length(UPLINKemission{:,'Grp'})
            if(strcmp(char(UPLINKemission{e,'EarthStation'}),stID))
                count=count+1;
                PWR(count) =  UPLINKemission{e,'PwrMax'};
                PWR_DENS(count) =  UPLINKemission{e,'PwrDensMax'};
            end
        end
        pwr = PWR(start+1:count);
        pwr = sort(pwr,'descend');
        pwr_dens = PWR_DENS(start+1:count);
        pwr_dens = sort(pwr_dens,'descend');        
        
        figure(1)
        hold on
        subplot(2,1,1)
        hold on
        plot(start+1:count,pwr(1:end),'color',colorNumber,'Marker','o','MarkerFaceColor',colorNumber,'DisplayName',char(stID));       
        subplot(2,1,2)
        plot(start+1:count,pwr_dens(1:end),'color',colorNumber,'Marker','o','MarkerFaceColor',colorNumber,'DisplayName',char(stID));       
    
        figure(2)
        plotUplinkMask(stID,p,pwr_dens(1),colorNumber);
    end
    
    figure(1)
    subplot(2,1,1)
    title('Emissões de Uplink')
    set(gca,'fontsize',18)
    grid on
    xlabel('Emissão', 'FontSize', 18);
    ylabel('PwrMax (dBW)', 'FontSize', 18);
    min=-20;
    max=50;
    set(gca, 'YTick',min:3:max);
    legend('show')
 
    
    subplot(2,1,2)
    set(gca,'fontsize',18)
    grid on
    xlabel('Emissão', 'FontSize', 18);
    ylabel('PwrDensMax (dBW/Hz)', 'FontSize', 18);
    min=-100;
    max=-20;
    set(gca, 'YTick',min:3:max);
    legend('show')
    hold off
    
    figure(2)
    plotUplinkESDlimits(p);
    ylabel('ESD (dBW/Hz)', 'FontSize', 18);
    xlabel('phi (graus)', 'FontSize', 18);
    set(gca,'fontsize',18)
    grid on
    legend('show')
end