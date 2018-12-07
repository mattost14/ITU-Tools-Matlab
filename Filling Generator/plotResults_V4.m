
%%
%Plot ESD results for each Earth Station
figure(1)
phimax=20;
fontsize=14;
num=0;
close all
[trash, idx] = sort([EMISSION{:,4}], 'descend');
EMISSION = EMISSION(idx,:);
Uplink_Emission={}; %(Pwr_Max,PwrDens_Max,Pwr_Min,PwrDens_Min)
for es = 1:length(p.EarthStation{:,1})
    PwrDensUpMax=[];PwrDensUpMin=[];
    color = rand(1,3);
    count=0;
    EarhStationID = p.EarthStation{es,'ID'};
    
    for emiss=1:length(EMISSION(:,1))
        if(strcmp(EMISSION{emiss,10},EarhStationID))
            count=count+1;
            num=num+1;
            PwrDensUpMax(count) = EMISSION{emiss,5};
            PwrDensUpMin(count) = EMISSION{emiss,7};
            newUplink_Emission={ EMISSION{emiss,4},EMISSION{emiss,5},EMISSION{emiss,6},EMISSION{emiss,7},char(EarhStationID),color};
            if(isempty(Uplink_Emission))
                Uplink_Emission = newUplink_Emission;
            else
                Uplink_Emission = [Uplink_Emission;newUplink_Emission];
            end
        end
    end
    PwrDensMax = max(PwrDensUpMax);
    PwrDensMin = min(PwrDensUpMin);
    figure(1)
    %Uplink Mask (PwrDensMax)
    hold on
    plotUplinkMask(EarhStationID,p,PwrDensMax,color,phimax,'Max')
    %Uplink Mask (PwrDensMin)
    hold on
    plotUplinkMask(EarhStationID,p,PwrDensMin,color,phimax,'Min')
end
figure(1)
title('Uplink ESD - Max & Min')
hold on
plotUplinkESDlimits(p,phimax)
grid on
ylabel('ESD (dBW/Hz)');
xlabel('phi (graus)');
set(gca,'fontsize',fontsize)
f=get(gca,'Children');
legend(f(fliplr(find(~strcmp({f.DisplayName},'')))))
ax=gca;
ax.YMinorTick = 'on';
grid minor
%%
%Plot Uplink Emissions (Pwr_Max, PwrDens_Max)
figure(2)
endnum=0;
for es = 1:length(p.EarthStation{:,1})
    EarthStationID = p.EarthStation{es,'ID'};
    UplinkFiltered = Uplink_Emission(strcmp(Uplink_Emission(:,5), char(EarthStationID)), :);
    color = UplinkFiltered{1,6};
    subplot(2,1,1)
    hold on
    %Uplink Pwr_Max 
    plot(endnum+1:endnum+length(UplinkFiltered(:,1)),[UplinkFiltered{:,1}],'color',color,'Marker','o','MarkerFaceColor',color,'DisplayName',char(EarthStationID))
    %Uplink Pwr_Min
    hold on
    plot(endnum+1:endnum+length(UplinkFiltered(:,1)),[UplinkFiltered{:,3}],'color',color,'Marker','.','MarkerFaceColor',color)
    subplot(2,1,2)
    %Uplink PwrDens_Max 
    hold on
    plot(endnum+1:endnum+length(UplinkFiltered(:,1)),[UplinkFiltered{:,2}],'color',color,'Marker','o','MarkerFaceColor',color,'DisplayName',char(EarthStationID))
    %Uplink PwrDens_Min
    hold on
    plot(endnum+1:endnum+length(UplinkFiltered(:,1)),[UplinkFiltered{:,4}],'color',color,'Marker','.','MarkerFaceColor',color)
    hold off
    endnum=endnum+length(UplinkFiltered(:,1));
end

figure(2)
subplot(2,1,1)
title('Uplink Emissions - Max & Min')
xlabel('Emissão');
ylabel('Pwr (dBW)');
set(gca,'fontsize',fontsize)
ymax = max([Uplink_Emission{:,1}]);
ymin = min([Uplink_Emission{:,3}]);
set(gca,'ylim',[ymin,ymax])
xmax = length(Uplink_Emission);
set(gca,'xlim',[0,xmax])
f=get(gca,'Children');
legend(f(fliplr(find(~strcmp({f.DisplayName},'')))),'Location','bestoutside')
ax=gca;
ax.YMinorTick = 'on';
grid minor

subplot(2,1,2)
xlabel('Emissão');
ylabel('PwrDens (dBW/Hz)');
set(gca,'fontsize',fontsize)
ymax = max([Uplink_Emission{:,2}]);
ymin = min([Uplink_Emission{:,4}]);
set(gca,'ylim',[ymin,ymax])
xmax = length(Uplink_Emission);
set(gca,'xlim',[0,xmax])
ax=gca;
ax.YMinorTick = 'on';
grid minor
f=get(gca,'Children');
legend(f(fliplr(find(~strcmp({f.DisplayName},'')))),'Location','bestoutside')

%% Plot Downlink Emissions
Downlink_Emission={};
num=0;
for b = 1:length(p.Beam{:,1})
    Beam = p.Beam{b,'BeamName'};
    color = rand(1,3);
    count=0;
    for emiss=1:length(EMISSION(:,1))      
        if(strcmp(EMISSION{emiss,10},Beam))
            count=count+1;
            num=num+1;
            PwrDensDown(count) = EMISSION{emiss,5};
            newDownlink_Emission={EMISSION{emiss,4},EMISSION{emiss,5},EMISSION{emiss,6},EMISSION{emiss,7},char(Beam),color};
            if(isempty(Downlink_Emission))
                Downlink_Emission = newDownlink_Emission;
            else
                Downlink_Emission = [Downlink_Emission;newDownlink_Emission];
            end
        end
    end
end
figure(3)
endnum=0;
for b = 1:length(p.Beam{:,1})
    Beam = p.Beam{b,'BeamName'};
    E_R = p.Beam{b,'E_R'};
    if(strcmp(E_R,'E'))
        DownlinkFiltered = Downlink_Emission(strcmp(Downlink_Emission(:,5), char(Beam)), :);
        color = DownlinkFiltered{1,6};
        subplot(2,1,1)
        %Downlink Pwr_Max
        hold on
        plot(endnum+1:endnum+length(DownlinkFiltered(:,1)),[DownlinkFiltered{:,1}],'color',color,'Marker','o','MarkerFaceColor',color,'DisplayName',char(Beam),'LineStyle','none')
        %Downlink Pwr_Min
        hold on
        plot(endnum+1:endnum+length(DownlinkFiltered(:,1)),[DownlinkFiltered{:,3}],'color',color,'Marker','.','MarkerFaceColor',color,'LineStyle','none')
        subplot(2,1,2)
        %Downlink PwrDens_Max
        hold on
        plot(endnum+1:endnum+length(DownlinkFiltered(:,1)),[DownlinkFiltered{:,2}],'color',color,'Marker','o','MarkerFaceColor',color,'DisplayName',char(Beam),'LineStyle','none')
        %Downlink PwrDens_Min
        hold on
        plot(endnum+1:endnum+length(DownlinkFiltered(:,1)),[DownlinkFiltered{:,4}],'color',color,'Marker','.','MarkerFaceColor',color,'LineStyle','none')
        hold off
        endnum=endnum+length(DownlinkFiltered(:,1));
    end
end

figure(3)
subplot(2,1,1)
title('Downlink Emissions - Max & Min')
xlabel('Emissão');
ylabel('Pwr (dBW)');
set(gca,'fontsize',fontsize)
ymax = max([Downlink_Emission{:,1}]);
ymin = min([Downlink_Emission{:,3}]);
set(gca,'ylim',[ymin,ymax])
xmax = length(Downlink_Emission);
set(gca,'xlim',[0,xmax])
f=get(gca,'Children');
legend(f(fliplr(find(~strcmp({f.DisplayName},'')))),'Location','bestoutside')
ax=gca;
ax.YMinorTick = 'on';
grid minor

subplot(2,1,2)
xlabel('Emissão');
ylabel('PwrDens (dBW/Hz)');
set(gca,'fontsize',fontsize)
ymax = max([Downlink_Emission{:,2}]);
ymin = min([Downlink_Emission{:,4}]);
set(gca,'ylim',[ymin,ymax])
xmax = length(Downlink_Emission);
set(gca,'xlim',[0,xmax])
ax=gca;
ax.YMinorTick = 'on';
grid minor
f=get(gca,'Children');
legend(f(fliplr(find(~strcmp({f.DisplayName},'')))),'Location','bestoutside')

%%
%Plot PFD Results for each Beam E
figure(4)
title('Power Flux Density Maximum') 
for b = 1:length(p.Beam{:,1})
    PwrDens=[];
    beam = p.Beam{b,'BeamName'};
    E_R = p.Beam{b,'E_R'};
    if(strcmp(E_R,'E'))
        count=0;
        for emiss=1:length(Downlink_Emission(:,1))
            if(strcmp(Downlink_Emission{emiss,5},beam))
                color = Downlink_Emission{emiss,6};
                count=count+1;
                PwrDens(count) = Downlink_Emission{emiss,2};
            end
        end
        PwrDensMax = max(PwrDens);
        hold on
        plotPFD(beam,p,PwrDensMax,color)
    end
     
end
xlim=get(gca,'xlim');
hold on
if(~isempty(p.PFD_Limit)&&~isnan(p.PFD_Limit))
    plot(xlim,[p.PFD_Limit-.1 p.PFD_Limit-.1],'--r','DisplayName','Ref','LineWidth',3)
    ylim([p.PFD_Limit-10,p.PFD_Limit+10])
end
%text(0.5*(xlim(end)+xlim(1)),p.PFD_Limit,num2str(p.PFD_Limit,'%0.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',fontsize)
legend('show')
label = strcat('(dBW/m2|',num2str(p.PFD_RefBand),'kHz)');
ylabel(label);
set(gca,'fontsize',fontsize)
set(gca, 'XTick', [])

%Save all plots into the Output folder
h = get(0,'children');
for i=1:length(h)
  figurename = strcat('/Output/',char(p.Band_Identification),'_', 'figure',num2str(i));
  saveas(h(i), [pwd figurename], 'jpeg');
  saveas(h(i), [pwd figurename], 'fig');
end


