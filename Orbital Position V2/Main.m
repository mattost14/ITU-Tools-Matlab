%% Database
databaseName = 'SRS_part1';
%% Interval of interest
longmin = -80;
longmax = 0;

colors = {[0,0.2,0.9],[0,0.7,0],[0.8,0,0],[1,0.6,0],[0.1,1,0.9],[0,0,0],[0.5,0.5,0.5]};
%Bands of Frequencies
% bands = [{'X-Band',7250,7750,7900,8400};
%          {'Ka-Band(MIL)',20200,21200,30000,31000};
%          {'Ka-Band(CIVIL)',17700,20200,27000,30000};
%          {'C-Band',3625,4200,5850,6425}];
bands = [{'X-Band',7250,7750,7900,8400,colors{1}};
         {'Ka-Band(MIL)',20200,21200,30000,31000,colors{2}}];
         %{'Ka-Band(CIVIL)',17700,20200,27000,30000,colors{3}};
         %{'UHF-Band',240,290,290,340,colors{4}};     
         %{'C-Band',3625,4200,5850,6425,colors{5}};
         %{'Ku-Band',11000,12200,13750,14500,colors{6}};];
         %{'QV-Band',37500,42500,47200,51400,colors{7}}];
%%Separation constrain
minSeperation = 2; %degree

%% Connecting to database
conn = database(databaseName,'','');
if(isempty(conn.message))
    msg = ['ITU database: ' databaseName ' connected successfully.'];
    disp(msg)
else   
    disp(conn.message)
end

[notified_ntw,coord_ntw] = retrieve_ntc_id(conn);
Result=[];
for k = 1:length(bands(:,1))
    bandName = bands{k,1};
    FREQMIN_E = bands{k,2};FREQMAX_E = bands{k,3};
    FREQMIN_R = bands{k,4};FREQMAX_R = bands{k,5};
    color = bands{k,6};
%% Verifing notified networks
ntw = notified_ntw(cell2mat(notified_ntw(:,4))>=longmin,:);
ntw = ntw(cell2mat(ntw(:,4))<=longmax,:);
listOfNotifiedNtw = [];
for i=1:length(ntw)
    ntc_id = ntw{i,1};
    %Accessing table grp
    tablename = 'grp';
    selectquery = ['SELECT grp_id,ntc_id,emi_rcp,freq_min,freq_max FROM ' tablename ' WHERE ntc_id=' num2str(ntc_id)];
    curs = exec(conn,selectquery);
    curs = fetch(curs);
    grp_data = curs.Data;
    found=false;
    overlapR=0; overlapE=0;
    for grp_number=1:length(grp_data(:,1))
        emi_rcp = grp_data{grp_number,3}; freq_min = grp_data{grp_number,4}; freq_max = grp_data{grp_number,5};
        if(freq_min<FREQMAX_R  && freq_max>FREQMIN_R && strcmp(emi_rcp,'R'))
            found=true;
        end
        if(freq_min<FREQMAX_E && freq_max>FREQMIN_E && strcmp(emi_rcp,'E'))
            found=true;
        end
        if(found)
            overlapR = calculateOverlap(grp_data,'R',FREQMIN_R,FREQMAX_R);
            overlapE = calculateOverlap(grp_data,'E',FREQMIN_E,FREQMAX_E);
            listOfNotifiedNtw=[listOfNotifiedNtw;ntw(i,:),overlapR,overlapE];
            break
        end
    end  
end

%% Verifing coord networks
ntw = coord_ntw(cell2mat(coord_ntw(:,4))>=longmin,:);
ntw = ntw(cell2mat(ntw(:,4))<=longmax,:);
listOfCoordNtw = [];
for i=1:length(ntw)
    ntc_id = ntw{i,1};
    %Accessing table grp
    tablename = 'grp';
    selectquery = ['SELECT grp_id,ntc_id,emi_rcp,freq_min,freq_max FROM ' tablename ' WHERE ntc_id=' num2str(ntc_id)];
    curs = exec(conn,selectquery);
    curs = fetch(curs);
    grp_data = curs.Data;
    found=false;
    for grp_number=1:length(grp_data(:,1))
        emi_rcp = grp_data{grp_number,3}; freq_min = grp_data{grp_number,4}; freq_max = grp_data{grp_number,5};
        if(strcmp(emi_rcp,'R'))
            if(freq_min<=FREQMAX_R  && freq_max>=FREQMIN_R)
                listOfCoordNtw = [listOfCoordNtw;ntw(i,:)];
                found=true;
            end            
        else
            if(freq_min<=FREQMAX_E && freq_max>=FREQMIN_E)
                listOfCoordNtw = [listOfCoordNtw;ntw(i,:)];
                found=true;
            end
        end
        if(found)
            break
        end
    end
end
Result = [Result;{bandName,listOfNotifiedNtw,listOfCoordNtw,color}];
end
plotarc(Result,longmin,longmax)