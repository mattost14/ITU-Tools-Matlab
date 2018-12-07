function totalOverLap = calculateOverlap(grp_data,emi_rcp,FREQMIN,FREQMAX)
grp_data = grp_data(strcmp(grp_data (:,3),emi_rcp),:);
grp_data = grp_data(cell2mat(grp_data(:,4))<=FREQMAX,:);
grp_data = grp_data(cell2mat(grp_data(:,5))>=FREQMIN,:);
overlaps = [];
if(isempty(grp_data))
    totalOverLap = 0;
    return
end
for i=1:length(grp_data(:,1))
    freq_min = grp_data{i,4}; freq_max = grp_data{i,5};
    R=overlap(freq_min,freq_max,FREQMAX,FREQMIN);
    overlaps = [overlaps;R];
    if(R(3)>=1)
        break
    end
end
    if(R(3)>=1)
        totalOverLap=1;
        return
    else
        %Calculate the agregated overlap
        overlaps = sort(overlaps,1);
        fim=false; k=1;
        aggr = [overlaps(1,1),overlaps(1,2)];
        while (fim==false)
            %expand
            filter1 = overlaps(overlaps(:,1)<=aggr(k,2),:);
            f2 = max(filter1(filter1(:,2)>aggr(k,2),2));
            if(~isempty(f2))
                aggr(k,2)=f2;
            end
            %add another
            overlaps = overlaps(overlaps(:,1)>aggr(k,2),:);
            if(isempty(overlaps))
                fim=true;
            else
                k=k+1;
                aggr(k,:)=overlaps(1,1:2);
            end
        end
    end
    diff = aggr(:,2)-aggr(:,1);
    totalOverLap = sum(diff)/(FREQMAX-FREQMIN);       
end