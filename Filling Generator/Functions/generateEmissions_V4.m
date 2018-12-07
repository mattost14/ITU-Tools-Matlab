%Generating Emissions
function EMISSION = generateEmissions_V4(p)
    EMISSION={};    
    disp('Generating Emissions...')
    roll_off = 0.1; %Roll-Off (10%)
          
    for grp=1:length(p.Groups{:,1})
        beam = p.Groups{grp,'Beam'};
        E_R = p.Beam{beam,'E_R'};
        beam_Grx = p.Beam{beam,'Gain_rx'};
        beam_T = p.Beam{beam,'T_K'};
        beam_Gtx = p.Beam{beam,'Gain_tx'};
        EarhStationID = p.Groups{grp,'EarthStation'};
        FreqMaxGHz = p.Groups{grp,'FreqMax'}/10^3;
        grp_bwdth = p.Groups{grp,'FreqMax'}-p.Groups{grp,'FreqMin'}; %grp's band width (MHz) 
        MODnum = p.Groups{grp,'MOD'};
        ems_count=0;
        service = char(p.Groups{grp,'Service'});
        stn_cls = strsplit(service,'/');
        stn_cls = stn_cls{2};
       % service = strsplit(char(p.Groups{grp,'Service'}),'/');
       % s_stn_cls = service{1};
        %% UPLINK EMISSIONS
        if(strcmp(E_R,'R'))
            regulation = char(p.ESD_Limit_Regulation);
            %NumEmission = p.Groups{grp,'NumEmission'};
            pattern = p.EarthStation{EarhStationID,'Pattern'};
            e_stn_Gtx = p.EarthStation{EarhStationID,'Gtx'};
            e_stn_PwrMax = p.EarthStation{EarhStationID,'PwrMax'};
            D = p.EarthStation{EarhStationID,'D'};
            for emiss=1:length(p.TypeOfEmission{:,1})
                BitRate = p.TypeOfEmission{emiss,'bitRate'}; %Kpbs
                if(isnan(MODnum))
                    CoverN_required = p.TypeOfEmission{emiss,'CoverN'};
                    bwdth = p.TypeOfEmission{emiss,'bwdth'};
                else
                    MOD = p.TypeOfEmission{emiss,strcat('MOD',num2str(MODnum))};
                    CoverN_required = p.DVBS2{MOD,'CoverN'};
                    bwdth = (1+roll_off)*BitRate*10^3/p.DVBS2{MOD,'Spectral_Eff'}; %Hz
                end
                
                %Check if the class of station is EK, ED or ER. If yes,
                %limit bandwidth to maximum 2MHz
                if(strcmp(stn_cls,'EK')||strcmp(stn_cls,'ED')||strcmp(stn_cls,'ER'))
                    if(bwdth>2e6)
                        break
                    end
                end
                % Check the station category (Gateway or Terminal)
                if(~isnan(D))
                    if(D>5) %If stn is gateway increase C/N by 5dB
                        ems = getEmissionID (bwdth,'G7D--');
                        CoverN_required = CoverN_required + 5;
                        %If it is gateway, carrier bandwidth should be
                        %less than 100% of the total channel
                        if(bwdth/10^6 > grp_bwdth)
                            break
                        end
                    else %If stn is terminal increase C/N by 1dB
                        ems = getEmissionID (bwdth,'G1D--');
                        CoverN_required = CoverN_required + 2;
                        %If it is terminal, carrier bandwidth should be
                        %less than 20% of the total channel
                        if(bwdth/10^6 > grp_bwdth*.2)
                            break
                        end
                    end
                else
                    ems = getEmissionID (bwdth,'G1W--');
                end
                %Recommendation SF.675-4 (FootNote 2 - Tables A,B,C and D -
                %Anexo2 / Appendix 4
%                 if(FreqMaxGHz>15 && bwdth<1e6)
%                     bwdth_min =1e6;
%                 else
%                     bwdth_min =bwdth;
%                 end
                
                %% Defining Maximum Pwr and Pwr_Dens - UPLINK
                if(isempty(regulation))
                    %If any regulations was applyed, then use the maximum
                    %EarthStation power to define Pwr_Max             
                    Pwr_Max = e_stn_PwrMax;
                    PwrDens_Max = Pwr_Max - 10*log10(bwdth);            
                else
                    %If regulation is applyed, then use the max between
                    %what is regulated and the EarthStation maximum power.
                    options = optimoptions(@fmincon,'Display', 'off');
                    [Pwr_Max,Error1] = fmincon(@(Pwr_Max) ReachESDLimit(Pwr_Max,pattern,e_stn_Gtx,bwdth,regulation,p.Margem_ESD_FromLimit),20,[],[],[],[],[],[],[],options);
                    %Check if Pwr_Max found is less than the Maximum Power
                    %of the EarthStation
                    if(Pwr_Max> e_stn_PwrMax)
                        Pwr_Max = e_stn_PwrMax;
                    end
                    if(Pwr_Max>40) %Form of Notice - AP4/Annex2  - Validation Rule
                        Pwr_Max=40;
                    end
                    PwrDens_Max = Pwr_Max - 10*log10(bwdth);
                end
                
                %% Defining Minimun Pwr and Pwr_Dens - UPLINK
                MargemMin = p.MargemMin;               
                options = optimoptions(@fmincon,'Display', 'off');
                [Pwr_Min,Error2] = fmincon(@(Pwr_Min) reachMargem(Pwr_Min,bwdth,FreqMaxGHz*1e9,e_stn_Gtx,beam_Grx,beam_T,CoverN_required,MargemMin),-10,[],[],[],[],[],[],[],options);
                %Test limits conditions
                if(Pwr_Min > e_stn_PwrMax-3 || Pwr_Min > Pwr_Max)
                   break
                end
                if(Pwr_Min<-40) %Form of Notice - AP4/Annex2  - Validation Rule
                    Pwr_Min=-40;
                end
                PwrDens_Min = Pwr_Min - 10*log10(bwdth);
                %Add calculated Uplink Emission
                ems_count = ems_count+1;
                newEmission = {grp,emiss,char(ems),round(Pwr_Max,1),round(PwrDens_Max,1),round(Pwr_Min,1),round(PwrDens_Min,1),round(CoverN_required,1),'R',char(EarhStationID)};
                if(isempty(EMISSION))
                    EMISSION = [newEmission];
                else
                    EMISSION = [EMISSION;newEmission];
                end
            end
        else %If E_R=='E'
            %% DOWNLINK EMISSIONS
            regulation = char(p.PFD_Limit_Regulation);
            PFD_Limit = p.PFD_Limit;
            d=36000e3;
            refBand = p.PFD_RefBand;
            PwrMaxBeam = p.Beam{beam,'PwrMax'};
            e_stn_Grx = p.EarthStation{EarhStationID,'Grx'};
            e_stn_T = p.EarthStation{EarhStationID,'T_K'};
            D = p.EarthStation{EarhStationID,'D'};
            if(isempty(regulation))
                %If any regulations was applyed, then use the maximum
                %Beam power to define Pwr_Max
                Pwr_Max = PwrMaxBeam;
            else
                %If regulation is applyed, then use the limit to define
                %PwrMax;
                PwrDens_Max = PFD_Limit - (beam_Gtx + 10*log10(refBand*10^3)-10*log10(4*pi*d^2));
            end
            %NumEmission = p.Groups{grp,'NumEmission'};
            for emiss=1:length(p.TypeOfEmission{:,1})
                BitRate = p.TypeOfEmission{emiss,'bitRate'}; %Kpbs            
                if(isnan(MODnum))
                    CoverN_required = p.TypeOfEmission{emiss,'CoverN'};
                    bwdth = p.TypeOfEmission{emiss,'bwdth'};
                else
                    MOD = p.TypeOfEmission{emiss,strcat('MOD',num2str(MODnum))};
                    CoverN_required = p.DVBS2{MOD,'CoverN'};
                    bwdth = (1+roll_off)*BitRate*10^3/p.DVBS2{MOD,'Spectral_Eff'}; %Hz
                end
                
                %Check if the class of station is EK, ED or ER. If yes,
                %limit bandwidth to maximum 2MHz
                if(strcmp(stn_cls,'EK')||strcmp(stn_cls,'ED')||strcmp(stn_cls,'ER'))
                    if(bwdth>2e6)
                        break
                    end
                end
                % Check the station category (Gateway or Terminal)
                if(~isnan(D))
                    if(D>5) %If stn is gateway increase C/N by 2dB
                        ems = getEmissionID (bwdth,'G7D--');
                        CoverN_required = CoverN_required + 2;
                        %If it is gateway, carrier bandwidth should be
                        %less than 100% of the total channel
                        if(bwdth/10^6 > grp_bwdth)
                            break
                        end
                    else %If stn is terminal increase C/N by 5dB
                        ems = getEmissionID (bwdth,'G1D--');
                        CoverN_required = CoverN_required + 5;
                        %If it is terminal, carrier bandwidth should be
                        %less than 20% of the total channel
                        if(bwdth/10^6 > grp_bwdth*.2)
                            break
                        end
                    end
                else
                    ems = getEmissionID (bwdth,'G1W--');    
                end
                
                %Recommendation SF.675-4 (FootNote 2 - Tables A,B,C and D -
                %Anexo2 / Appendix 4
%                 if(FreqMaxGHz>15 && bwdth<1e6)
%                     bwdth_min =1e6;
%                 else
%                     bwdth_min =bwdth;
%                 end
                
                %Definig the Minimum Pwr and PwrDens  - DOWNLINK
                MargemMin = p.MargemMin;               
                options = optimoptions(@fmincon,'Display', 'off');
                [Pwr_Min,Error3] = fmincon(@(Pwr_Min) reachMargem(Pwr_Min,bwdth,FreqMaxGHz*1e9,beam_Gtx,e_stn_Grx,e_stn_T,CoverN_required,MargemMin),-10,[],[],[],[],[],[],[],options);
                if(Pwr_Min<-40) %Form of Notice - AP4/Annex2  - Validation Rule
                    Pwr_Min=-40;
                end                
                PwrDens_Min = Pwr_Min - 10*log10(bwdth);
                               
                %Definig the Maximum Pwr and PwrDens  - DOWNLINK
                if(isempty(regulation))
                    %Pwr_Max => PwrMaxBeam
                    PwrDens_Max = Pwr_Max - 10*log10(bwdth);
                else
                    %PwrDens_Max => PFD Limit
                    Pwr_Max = PwrDens_Max + 10*log10(bwdth);
                    if(Pwr_Max > PwrMaxBeam)
                        Pwr_Max = PwrMaxBeam;
                        PwrDens_Max = Pwr_Max - 10*log10(bwdth);
                    end
                end
                %Test limits conditions
                if(Pwr_Min > PwrMaxBeam-3 || Pwr_Min > Pwr_Max)
                    break
                end
                
                %Add calculated Downlink Emission
                ems_count = ems_count+1;
                newEmission = {grp,emiss,char(ems),round(Pwr_Max,1),round(PwrDens_Max,1),round(Pwr_Min,1),round(PwrDens_Min,1),round(CoverN_required,1),'E',char(beam)};
                if(isempty(EMISSION))
                    EMISSION = [newEmission];
                else
                    EMISSION = [EMISSION;newEmission];
                end
            end
        end
        if(ems_count==0)
            msg = sprintf('grp:%d %s stn:%s- has no emission subscribed',grp,char(E_R),char(EarhStationID));
            disp(msg)
        end
    end
    disp('All emissions were generated with success.')
end

