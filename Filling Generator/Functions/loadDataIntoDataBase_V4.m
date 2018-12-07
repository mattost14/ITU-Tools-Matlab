function loadDataIntoDataBase_V4(databaseName,p,Emission)
conn = database(databaseName,'','');
if(isempty(conn.message))
    msg = ['ITU database: ' databaseName ' connected successfully.'];
    disp(msg)
else   
    disp(conn.message)
end
%% Accessing table notice
tablename = 'notice';
selectquery = ['SELECT ntc_id,d_rcv,d_upd, ntc_type FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
data = curs.Data;
noticeID = data{1};
d_rcv = data{2};
d_upd = data{3};
ntc_type = data{4};

%%
%Accessing table grp to check the number of existing groups
tablename = 'grp';
selectquery = ['SELECT grp_id FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
data = curs.Data;
if(strcmp(data{1},'No Data'))
    lastgrp=0;
else
    lastgrp = max(cell2mat(data));
end

%%  TABLE assgn
tablename = 'assgn';
colnames = {'grp_id','seq_no','freq_sym','freq_assgn','freq_mhz'};    
for grp=1:length(p.Groups{:,1})
    seq_no = 1;
    
    freq_min = p.Groups{grp,'FreqMin'};
    freq_max = p.Groups{grp,'FreqMax'};
    freq_mhz = round((freq_max-freq_min)*0.5)+freq_min;
    
    %Check if is above of 10500Mhz
    if(freq_mhz>10500)
        freq_sym = 'G';
        freq_assgn = freq_mhz/10^3;
    else
        freq_sym = 'M';
        freq_assgn = freq_mhz;
    end
    
    grp_id=grp+lastgrp;
    %Insert row
    newdata = {grp_id seq_no freq_sym freq_assgn freq_mhz};
    datainsert(conn,tablename,colnames,newdata)   
end
disp('Table assgn completed.')
%%  TABLE grp
tablename = 'grp';
colnamesR = {'grp_id','ntc_id','emi_rcp','beam_name','noise_t','d_rcv','bdwdth','freq_min','freq_max','polar_type','d_upd','prd_valid','adm_resp','op_agcy','area_no'};
colnamesE = {'grp_id','ntc_id','emi_rcp','beam_name','d_rcv','bdwdth','freq_min','freq_max','polar_type','pwr_max','bdwdth_aggr','d_upd','prd_valid','adm_resp','op_agcy','area_no'}; 
needPFDcompliance = false;
for grp=1:length(p.Groups{:,1})
    beam_name = char(p.Groups{grp,'Beam'});
    emi_rcp = char(p.Beam{beam_name,'E_R'});
    noise_t = p.Beam{beam_name,'T_K'};
    freq_min = p.Groups{grp,'FreqMin'};
    freq_max = p.Groups{grp,'FreqMax'};
    %Check if there is the band 42-42.5 GHz, if yes, then need to fill
    %c_pfd table
    if(freq_min<42500 && freq_max>42000)
        needPFDcompliance = true;
    end   
    area_no = p.Groups{grp,'Service_area_no'};
    bdwdth = (freq_max - freq_min)*1e3;
    polar_type = 'M';
    bdwdth_aggr = bdwdth;
    pwr_max = p.Beam{beam_name,'PwrMax'};
    prd_valid=30;
    adm_resp='A'; %Anatel
    op_agcy=47; %Ministério da Defesa
    grp_id=grp+lastgrp;
    %Insert row
    if(strcmp(emi_rcp,'R'))
        newdata = {grp_id noticeID emi_rcp beam_name noise_t d_rcv bdwdth freq_min freq_max polar_type d_upd prd_valid adm_resp op_agcy area_no};
        datainsert(conn,tablename,colnamesR,newdata)
    else
        newdata = {grp_id noticeID emi_rcp beam_name d_rcv bdwdth freq_min freq_max polar_type pwr_max bdwdth_aggr d_upd prd_valid adm_resp op_agcy area_no};
        datainsert(conn,tablename,colnamesE,newdata)
    end
end
disp('Table grp completed.')
%%  TABLE freq
tablename = 'freq';
colnames = {'ntc_id','emi_rcp','beam_name','grp_id','seq_no','freq_sym','freq_assgn','freq_mhz','freq_min','freq_max','bdwdth','ntc_type'};
for grp=1:length(p.Groups{:,1})
    beam_name = char(p.Groups{grp,'Beam'});
    emi_rcp = char(p.Beam{beam_name,'E_R'});
    freq_min = p.Groups{grp,'FreqMin'};
    freq_max = p.Groups{grp,'FreqMax'};
    bdwdth = (freq_max - freq_min)*1e3;
    seq_no = 1;
    freq_mhz = round((freq_max-freq_min)*0.5+freq_min);
    
        %Check if is above of 10500Mhz
    if(freq_mhz>10500)
        freq_sym = 'G';
        freq_assgn = freq_mhz/10^3;
    else
        freq_sym = 'M';
        freq_assgn = freq_mhz;
    end
    grp_id=grp+lastgrp;
    %Insert row
    newdata = {noticeID emi_rcp beam_name grp_id seq_no freq_sym freq_assgn freq_mhz freq_min freq_max bdwdth ntc_type};
    datainsert(conn,tablename,colnames,newdata)   
end
disp('Table freq completed.')

%%  TABLE e_as_stn
tablename = 'e_as_stn';
colnamesR = {'grp_id','seq_no','e_as_id','stn_name','gain','bmwdth','pattern_id','stn_type'};
colnamesE = {'grp_id','seq_no','e_as_id','stn_name','noise_t','gain','bmwdth','pattern_id','stn_type'};
stn_BeamWidth = array2table(nan(0,3),'VariableNames',{'stn_name','bmwdthTx','bmwdthRx'});
for grp=1:length(p.Groups{:,1})
    beam_name = char(p.Groups{grp,'Beam'});
    emi_rcp = char(p.Beam{beam_name,'E_R'});
    seq_no = 1;
    e_as_id = grp+1;
    stn_name = char(p.Groups{grp,'EarthStation'});
    gainTx = round(p.EarthStation{stn_name,'Gtx'},1);
    gainRx = round(p.EarthStation{stn_name,'Grx'},1);
    noise_t = p.EarthStation{stn_name,'T_K'};
    bmwdthTx = p.EarthStation{stn_name,'bmwdthTx'};
    bmwdthRx = p.EarthStation{stn_name,'bmwdthRx'};
    if(isnan(bmwdthTx) || isnan(bmwdthRx))
        %Check if it was already calculated and stored into
        %stn_3dBbeamWidth table
        if(~isempty(find(strcmp(stn_BeamWidth{:,1},stn_name)==1)))
            stn_BeamWidth.Properties.RowNames = stn_BeamWidth.stn_name;
            bmwdthTx = stn_BeamWidth{stn_name,'bmwdthTx'};
            bmwdthRx = stn_BeamWidth{stn_name,'bmwdthRx'};
        else
            [bmwdthTx,bmwdthRx] = getBeamWidth(stn_name,p);
            bmwdthTx = round(bmwdthTx,2);
            bmwdthRx = round(bmwdthRx,2);
            stn_BeamWidth = [stn_BeamWidth;{stn_name,bmwdthTx,bmwdthRx}];
        end
    end
    pattern_id = getPatternId(p.EarthStation{stn_name,'Pattern'},'Tx');
    stn_type='T'; %Typycal - Not need to provide locations
    grp_id=grp+lastgrp;
    %Insert row  
    if(strcmp(emi_rcp,'R'))
        newdata = {grp_id seq_no e_as_id stn_name gainTx bmwdthTx pattern_id stn_type};
        datainsert(conn,tablename,colnamesR,newdata)
    else
        newdata = {grp_id seq_no e_as_id stn_name noise_t gainRx bmwdthRx pattern_id stn_type};
        datainsert(conn,tablename,colnamesE,newdata)
    end
end
disp('Table e_as_stn completed.')

%%  TABLE e_srvcls
tablename = 'e_srvcls';
colnames = {'grp_id','seq_e_as','seq_no','stn_cls','nat_srv'};
for grp=1:length(p.Groups{:,1})
    seq_e_as = 1;
    seq_no = 1;
    nat_srv = 'CO';
    service = char(p.Groups{grp,'Service'});
    stn_cls = strsplit(service,'/');
    stn_cls = stn_cls{2};
    grp_id=grp+lastgrp;
    %Insert row
    newdata = {grp_id seq_e_as seq_no stn_cls nat_srv};
    datainsert(conn,tablename,colnames,newdata)
end
disp('Table e_srvcls completed.')

%%  TABLE provn
% tablename = 'provn';
% colnames = {'grp_id','coord_prov'};
% for grp=1:length(p.Groups{:,1})
%     coord_prov = ntc_type;
%     %agree_st = 'O'; - Not applicable for Coordination
%     %Insert row
%     newdata = {grp coord_prov};
%     datainsert(conn,tablename,colnames,newdata)
% end
% disp('Table provn completed.')

%%  TABLE s_beam
tablename = 's_beam';
colnames = {'ntc_id','emi_rcp','beam_name','f_steer','gain','pnt_acc','freq_min','freq_max','f_pfd_steer_default'};
for beam=1:length(p.Beam{:,1})
    emi_rcp = char(p.Beam{beam,'E_R'});
    beam_name = char(p.Beam{beam,'BeamName'});
    f_steer = char(p.Beam{beam,'Steerable'});
    if(f_steer==0)
        f_steer='';
    end
    if(strcmp(emi_rcp,'E'))
        gain = p.Beam{beam,'Gain_tx'};
        freq_min = p.Beam{beam,'Freq_Min'};
        freq_max = p.Beam{beam,'Freq_Max'};
    else
        gain = p.Beam{beam,'Gain_rx'};
        freq_min = p.Beam{beam,'Freq_Min'};
        freq_max = p.Beam{beam,'Freq_Max'};
    end
    pnt_acc = 0.18;
    f_pfd_steer_default = f_steer;
    %Insert row
    newdata = {noticeID emi_rcp beam_name f_steer gain pnt_acc freq_min freq_max f_pfd_steer_default};
    datainsert(conn,tablename,colnames,newdata)
end
disp('Table s_beam completed.')

%%  TABLE srv_cls
tablename = 'srv_cls';
colnames = {'grp_id','seq_no','stn_cls','nat_srv'};
for grp=1:length(p.Groups{:,1})
    seq_no = 1;
    nat_srv = 'CO';
    service = char(p.Groups{grp,'Service'});
    stn_cls = strsplit(service,'/');
    stn_cls = stn_cls{1};
    grp_id=grp+lastgrp;
    %Insert row
    newdata = {grp_id seq_no stn_cls nat_srv};
    datainsert(conn,tablename,colnames,newdata)
end
disp('Table srv_cls completed.')

%%  TABLE emiss
tablename = 'emiss';
colnames = {'grp_id','seq_no','design_emi','pep_max','pwr_ds_max','pep_min','pwr_ds_min','c_to_n'};
for e=1:length(Emission)
    grp_id=Emission{e,1}+lastgrp;
    %Insert row
    newdata = [grp_id,Emission(e,2:8)];
    datainsert(conn,tablename,colnames,newdata)
end
disp('Table emiss completed.')


%%  TABLE c_pfd
if(needPFDcompliance)
    tablename = 'c_pfd';
    colnames = {'ntc_id','seq_no','bdwdth','freq_max','freq_min','pfd','ra_stn_type'};
    ntc_id = noticeID;
    bdwdth = 1e6;
    freq_max = 43500; freq_min = 42500;
    %Radio Astronomy Station using Single Dish Compliance
    seq_no=1;
    pfd = -137;
    ra_stn_type = 'S';
    %Insert row
    newdata = {ntc_id,seq_no,bdwdth,freq_max,freq_min,pfd,ra_stn_type};
    datainsert(conn,tablename,colnames,newdata)
    
%     %Radio Astronomy Station using VLBI Compliance
%     seq_no=2;
%     pfd = -137;
%     ra_stn_type = 'V';
%     %Insert row
%     newdata = [ntc_id,seq_no,bdwdth,freq_max,freq_min,pfd,ra_stn_type];
%     datainsert(conn,tablename,colnames,newdata)
    
    disp('Table c_pfd completed. (42-42.5GHz - PFD compliance)')
end
close(conn);
end