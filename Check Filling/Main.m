%%User Inputs
sat_name = 'SISCOMIS-8A';
databaseName = 'SRS_part1';
%databaseName = 'SISCOMIS-9';

%% Connecting to database
conn = database(databaseName,'','');
if(isempty(conn.message))
    msg = ['ITU database: ' databaseName ' connected successfully.'];
    disp(msg)
else   
    disp(conn.message)
end

%% Check register found and retrieve data
[ntc_id,long_nom,adm,ntc_type] = retrieve_ntc_id(conn,sat_name);
fprintf('\n')
msg=sprintf('NTC ID: %d   SATNAME: %s   LONG: %.1f   ADM: %s   NTC TYPE: %s',ntc_id,sat_name,long_nom,adm,ntc_type);
disp(msg)
prompt='Do you want to continue? [y/n] ';
answer = input(prompt,'s');
if(strcmp(answer,'y'))
    disp('Retrieving data from data base...')
    [grp, s_beam,emiss,e_as_stn,ant_type,e_srvcls]=retrieveData(conn,ntc_id);
    disp('All data retrieved with success.')
end

%% X-Band
regulation = 'X-Band MIL-STD-188/164B';
band_freqmax = 8400;
band_freqmin= 7900;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ X-Band _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('Result: %d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('X-Band Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end
    prompt='Do you want to see all earth station parameters? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        listofstn = unique(uplinkEmissions(:,4));
        for stn=1:length(listofstn)
            [PwrMax,idx]=max([uplinkEmissions{strcmp(uplinkEmissions(:,4),listofstn{stn}),8}]);
            msg = sprintf('stn: %s   PwrMax:%.2f',listofstn{stn},PwrMax);
            disp(msg)
        end      
    end
end

%% Ka-Band (Mil)
regulation = 'Ka-Band MIL-STD-188/164B';
band_freqmax = 31000;
band_freqmin= 29000;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ Ka-Band (Mil) _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)     
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('%d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('Ka-Band (Mil) Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end   
end

%% Ka-Band (Civil)
regulation = 'ITU-S.524-6 (29.5-30GHz)';
band_freqmax = 30000;
band_freqmin= 29500;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ Ka-Band (Civil) _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('%d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('Ka-Band (Civil) Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end   
end

%% QV-Band
regulation = 'ITU-S.524-6 (29.5-30GHz)';
band_freqmax = 51400;
band_freqmin= 47200;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ QV-Band _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)     
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('%d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('QV-Band Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end   
end

%% UHF
regulation = 'ITU-S.524-6 (29.5-30GHz)';
band_freqmax = 320;
band_freqmin= 290;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ UHF-Band _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)     
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('%d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('UHF-Band Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end
     prompt='Do you want to see all earth station parameters? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        listofstn = unique(uplinkEmissions(:,4));
        for stn=1:length(listofstn)
            [PwrMax,idx]=max([uplinkEmissions{strcmp(uplinkEmissions(:,4),listofstn{stn}),8}]);
            msg = sprintf('stn: %s   PwrMax:%.2f',listofstn{stn},PwrMax);
            disp(msg)
        end      
    end
end

%% C-Band
regulation = 'ITU-S.524-6 (6 GHz)';
band_freqmax = 6500;
band_freqmin= 5500;
[band_present,violationFound,grpWithProblems,uplinkEmissions]=checkUplinkCompliance(regulation,band_freqmax,band_freqmin,grp,emiss,e_as_stn,ant_type);
if(band_present)
    fprintf('\n')
    disp(' _______ C-Band _______ ');
    fprintf('Regulation:%s\n',regulation);
    if(violationFound)     
        ListGrpWithProblems  = unique([grpWithProblems{:,1}]);
        msg=sprintf('%d groups exceed the uplink limits',length(ListGrpWithProblems));
        disp(msg)
        prompt='Do you want to list all of those groups? [y/n] ';
        answer = input(prompt,'s');
        if(strcmp(answer,'y'))
            disp('Group      Station    AboveLimit(dB)   Phi(graus)');
            for i=1:length(ListGrpWithProblems)
                %filter grpWithProblems by grp_id
                filtered = grpWithProblems([grpWithProblems{:,1}]==ListGrpWithProblems(i),:);
                [maxDelta,idx] = max([filtered{:,5}]);
                stn_name = filtered{idx,2};
                phi = filtered{idx,4};
                fprintf('%d    %s      %.2f              %.2f\n',ListGrpWithProblems(i),stn_name,maxDelta,phi);
            end
        end
    else
        disp('C-Band Uplink OK.')
    end
    prompt='Do you want to plot the uplink mask for all associated earth station? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        figure
        phimax=25;
        plotUplinkMask(uplinkEmissions,ant_type,e_as_stn, phimax)
        hold on
        plotUplinkESDlimits(regulation,phimax)
        legend('show')
    end
    prompt='Do you want to see all earth station parameters? [y/n] ';
    answer = input(prompt,'s');
    if(strcmp(answer,'y'))
        listofstn = unique(uplinkEmissions(:,4));
        for stn=1:length(listofstn)
            [PwrMax,idx]=max([uplinkEmissions{strcmp(uplinkEmissions(:,4),listofstn{stn}),8}]);
            msg = sprintf('stn: %s   PwrMax:%.2f',listofstn{stn},PwrMax);
            disp(msg)
        end      
    end
end