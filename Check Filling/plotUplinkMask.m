function plotUplinkMask(uplinkEmissions,ant_type, e_as_stn, phimax)
    listofstn = unique(uplinkEmissions(:,4));
    
    for stn=1:length(listofstn)
        stn_name = char(listofstn{stn});
        %Filter e_as_stn by stn_name
        filtered = e_as_stn(strcmp(e_as_stn{:,'stn_name'},stn_name),:);
        [Gmax,idx] = max([filtered{:,'gain'}]);
        pattern_id = filtered{idx,'pattern_id'};
        bmwdth  = filtered{idx,'bmwdth'};
        pattern = char(ant_type{pattern_id==ant_type{:,'pattern_id'},'pattern'});
        A = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefa'};
        B = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefb'};
        C = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefc'};
        D = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefd'};
        Phi1 = ant_type{pattern_id==ant_type{:,'pattern_id'},'phi1'};
        pwr_ds_max_stn = [uplinkEmissions{strcmp(uplinkEmissions(:,4),stn_name),7}];
        PwrDensMax = max(pwr_ds_max_stn);
        color=rand(1,3);
        i=0;
        for phi=0:0.1:phimax
            i=i+1;
            gain = gainMask(phi,pattern,Gmax,A,B,C,D,Phi1);
            if(phi<=bmwdth*.5 && gain<Gmax-3) %Check 3dB beamwidth condition
                gain=Gmax-3;
            end
            ESD(i) = PwrDensMax + gain;
        end
        phi=0:0.1:phimax;
        hold on
        plot(phi,ESD,'color',color,'DisplayName',stn_name,'LineWidth',2);
        hold off
        
    end
end