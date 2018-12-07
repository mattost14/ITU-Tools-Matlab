function plotarc(Result,longmin,longmax)
figure
p=zeros(1,1);
for b = 1:length(Result(:,1))
    bandName = Result{b,1};
    listOfNotifiedNtw = Result{b,2};
    listOfCoordNtw = Result{b,3};
    color = Result{b,4};
    
    %plot notified ntws
    if(~isempty(listOfNotifiedNtw))
        plot([longmin,longmax],[b,b],'--k')
        hold on
        long_notif_ntw = [listOfNotifiedNtw{:,4}];
        y = ones(length(long_notif_ntw),1)*b;
        p(end+1)=plot(long_notif_ntw,y,'^','MarkerFaceColor',color,'MarkerEdgeColor',color,'MarkerSize',12,'DisplayName',bandName);
    end
    
    %plot coord ntws
    hold on
    long_coord_ntw = [listOfCoordNtw{:,4}];
    y = ones(length(long_coord_ntw),1)*b;
    if(b==1)
        p(1)=plot(long_coord_ntw,y,'o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3,'DisplayName','Em Coord');
    else
        plot(long_coord_ntw,y,'o','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',3)
    end
end



%% plot safe regions
safeDist=2;
safearc(:,1) = longmin:0.1:longmax;
safearc(:,2) = ones(length(safearc(:,1)),1)*10;
for b = 1:length(Result(:,1))
    listOfNotifiedNtw = Result{b,2};
    if(~isempty(listOfNotifiedNtw ))
        longNotif = cell2mat(listOfNotifiedNtw(:,4));
        for l=1:length(longNotif)
            rest = abs(safearc(:,1)-longNotif(l));
            safearc(rest<safeDist,2)=-9;
        end
    end
end
hold on
area(safearc(:,1),safearc(:,2),-10)
alpha(.4)

%% plot highlight positions
hold on
plot([longmin,longmax],[0,0],'b')
hold on
p(end+1)=plot(-75,0,'p','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','SGDC-1');
hold on
p(end+1)=plot(-57,0,'p','MarkerFaceColor','g','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','SGDC-2');

set(gca,'fontsize',16)
set(gca, 'YTick', [])
ax=gca;
ax.XMinorTick = 'on';
grid on
grid minor
ylim([-1,6])
xlim([longmin,longmax])
legend(p,'Location','bestoutside')
end