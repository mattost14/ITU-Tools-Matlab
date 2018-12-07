function [band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type)
    phimax=25; 
    grpWithProblems={};
    uplinkEmissions={};
    violationFound=false; band_present = false;
    for g=1:length(grp{:,'grp_id'})
        emi_rcp = grp{g,'emi_rcp'};
        if(strcmp(emi_rcp,'R')) %If it is an Uplink Emission
            grp_id = grp{g,'grp_id'};
            freq_min = grp{g,'freq_min'};
            freq_max = grp{g,'freq_max'};
            if(freq_min < band_freqmax && freq_max > band_freqmin)
                band_present  = true;
                grpEmission = emiss(emiss{:,'grp_id'}==grp_id,:);
                grpEarthStation = e_as_stn(e_as_stn{:,'grp_id'}==grp_id,:);
                %Loop though all emissions
                for e=1:length(grpEmission{:,1})
                    emission = char(grpEmission{e,'design_emi'});
                    pwr_ds_max = grpEmission{e,'pwr_ds_max'};
                    pwr_max = grpEmission{e,'pep_max'};
                    %Loop though all Earth Station
                    for stn=1:length(grpEarthStation{:,1})
                        stn_name = char(grpEarthStation{stn,'stn_name'});
                        pattern_id = grpEarthStation{stn,'pattern_id'};
                        Gmax = grpEarthStation{stn,'gain'};
                        uplinkEmissions=[uplinkEmissions;{grp_id,e,emission,stn_name,pattern_id,Gmax,pwr_ds_max,pwr_max}];
                        bmwdth = grpEarthStation{stn,'bmwdth'};
                        ant_diam = grpEarthStation{stn,'ant_diam'};
                        pattern_name = char(ant_type{pattern_id==ant_type{:,'pattern_id'},'pattern'});
                        A = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefa'};
                        B = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefb'};
                        C = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefc'};
                        D = ant_type{pattern_id==ant_type{:,'pattern_id'},'coefd'};
                        Phi1 = ant_type{pattern_id==ant_type{:,'pattern_id'},'phi1'};
                        %Check ESD compliance for off-axis antenna angle range
                        for phi=2:0.1:phimax
                            gain = gainMask(phi,pattern_name,Gmax,A,B,C,D,Phi1);
                            if(isnan(gain))
                                break
                            end                                
                            if(phi<=bmwdth*.5 && gain<Gmax-3) %Check 3dB beamwidth condition
                                gain=Gmax-3;
                            end
                            if(~isnan(gain))
                                ESD = gain+pwr_ds_max;
                                ESD_limit = getESDLimit(phi,regulation);
                                delta = ESD-ESD_limit;
                                if(delta>1)%ESD is over ESD limit for this phi angle
                                    violationFound = true;
                                    grpWithProblems=[grpWithProblems;{grp_id,stn_name,emission,phi,delta}];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end