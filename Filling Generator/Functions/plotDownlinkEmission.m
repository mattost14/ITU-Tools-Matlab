function plotDownlinkEmission(DOWNLINKemission,p)
    count=0;
    warningCount=0;
    for b=1:length(p.Beam{:,'BeamName'})
        colorNumber = rand(1,3);
        beamName = p.Beam{b,'BeamName'};
        start=count; found=false;
        for e=1:length(DOWNLINKemission{:,'Grp'})
            if(strcmp(char(DOWNLINKemission{e,'Beam'}),beamName))
                count=count+1;
                PWR(count) =  DOWNLINKemission{e,'PwrMax'};
                PWR_DENS(count) =  DOWNLINKemission{e,'PwrDensMax'};
                found=true;
                
                %Checking PFD limits
                if(~isnan(p.PFD_Limit))
                    refBand = p.PFD_RefBand; %Reference Band for PFD (kHz)
                    Gmax = p.Beam{beamName,'Gain_tx'};
                    pfdLimit=p.PFD_Limit;
                    grp=DOWNLINKemission{e,'Grp'};
                    ems=DOWNLINKemission{e,'Emission'};
                    d = 36000e3;
                    PFD = PWR_DENS(count)+ Gmax + 10*log10(refBand*10^3) - 10*log10(4*pi*d^2);
                    if(round(PFD) > pfdLimit)
                        warningCount=warningCount+1;
                        msg = sprintf('grp:%d    emission:%s   beam:%s   pfd:%.2f  limit:%.2f WARNING',grp,char(ems),char(beamName),PFD,pfdLimit);
                        disp(msg)
                    end
                end
            end
        end      
        if(found)
            pwr = PWR(start+1:count);
            pwr = sort(pwr,'descend');
            pwr_dens = PWR_DENS(start+1:count);
            pwr_dens = sort(pwr_dens,'descend');
                       
            figure(3)
            hold on
            subplot(2,1,1)
            hold on
            plot(start+1:count,pwr(1:end),'color',colorNumber,'Marker','o','MarkerFaceColor',colorNumber,'DisplayName',char(beamName));
            subplot(2,1,2)
            plot(start+1:count,pwr_dens(1:end),'color',colorNumber,'Marker','o','MarkerFaceColor',colorNumber,'DisplayName',char(beamName));
            hold off
            
            figure(4)
            plotPFD(beamName,b,p,pwr_dens(1),colorNumber)
        end
    end
    figure(3)
    subplot(2,1,1)
    title('Emissões de Downlink')
    set(gca,'fontsize',18)
    grid on
    xlabel('Emissão', 'FontSize', 18);
    ylabel('PwrMax (dBW)', 'FontSize', 18);
    min=-30;
    max=30;
    set(gca, 'YTick',[min:3:max]);
    legend('show')
    
    figure(3)
    subplot(2,1,2)
    set(gca,'fontsize',18)
    grid on
    xlabel('Emissão', 'FontSize', 18);
    ylabel('PwrDensMax (dBW/Hz)', 'FontSize', 18);
    min=-80;
    max=-10;
    set(gca, 'YTick',[min:3:max]);
    legend('show')
    hold off
    
    figure(4)
    set(gca,'fontsize',18)
    label = strcat('Power Flux Density Maximum (dBW/m2|',num2str(p.PFD_RefBand),'kHz)');
    ylabel(label, 'FontSize', 18);
    set(gca, 'XTick', [])
    if(~isnan(p.PFD_Limit))
        xlim=get(gca,'xlim');
        hold on
        plot(xlim,[p.PFD_Limit p.PFD_Limit],'--r','DisplayName',char(p.PFD_Limit_Regulation),'LineWidth',3)
        text(0.5*(xlim(end)+xlim(1)),p.PFD_Limit,num2str(p.PFD_Limit,'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',18)
    end
    legend('Location','southoutside','Orientation','horizontal')
    legend('show')
    msg=sprintf('Total Warning(s):%d',warningCount);
    disp(msg)
end