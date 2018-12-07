function loadDataIntoDataBase2(conn2,newdata)
%% Accessing table notice
tablename = 'notice';
selectquery = ['SELECT ntc_id,d_rcv,d_upd, ntc_type FROM ' tablename];
curs = exec(conn2,selectquery);
curs = fetch(curs);
data = curs.Data;
noticeID = data{1};
d_rcv = data{2};
d_upd = data{3};
ntc_type = data{4};

%% Accessing table grp to check the number of existing groups
tablename = 'grp';
selectquery = ['SELECT grp_id FROM ' tablename];
curs = exec(conn2,selectquery);
curs = fetch(curs);
data = curs.Data;
if(strcmp(data{1},'No Data'))
    lastgrp=0;
else
    lastgrp = max(cell2mat(data));
end
%% Accessing table e_as_stn to check number of last stn
tablename = 'e_as_stn';
selectquery = ['SELECT e_as_id FROM ' tablename];
curs = exec(conn2,selectquery);
curs = fetch(curs);
data = curs.Data;
if(strcmp(data{1},'No Data'))
    laststn=0;
else
    laststn = max(cell2mat(data));
end

%%  TABLE grp
tablename = 'grp';
newgrp = newdata.grp;
colnames = {'grp_id','ntc_id','emi_rcp','beam_name','noise_t','d_rcv','bdwdth','freq_min','freq_max','polar_type','pwr_max','d_upd','prd_valid','adm_resp','op_agcy','area_no'};
for grp=1:length(newgrp{:,1})
    grp_id=grp+lastgrp;
    newrecord = newgrp(grp,:);   
    %Need to change: grp_id,area_no,adm_resp,op_agcy,polar_type,d_rcv,d_upd
    adm_resp={'A'}; %Anatel
    op_agcy=47; %Ministério da Defesa
    area_no = 1;
    polar_type = {'M'};
    prd_valid=30;
    %Apply changes
    newrecord{1,'grp_id'}=grp_id;
    newrecord{1,'adm_resp'}=adm_resp;
    newrecord{1,'op_agcy'}=op_agcy;
    newrecord{1,'area_no'}=area_no;
    newrecord{1,'polar_type'}=polar_type;
    newrecord{1,'prd_valid'}=prd_valid;
    newrecord{1,'d_rcv'}={d_rcv};
    newrecord{1,'d_upd'}={d_upd};
    %Insert row
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table grp completed.')
%%  TABLE assgn
tablename = 'assgn';
colnames = {'grp_id','seq_no','freq_sym','freq_assgn','freq_mhz'};
newassgn = newdata.assgn;
for a=1:length(newassgn{:,1})
    grp_id=newassgn{a,'grp_id'}+lastgrp;
    newrecord = newassgn(grp,:);
    newrecord{1,'grp_id'}=grp_id;
    %Insert row
    datainsert(conn2,tablename,colnames,newrecord)   
end
disp('Table assgn completed.')

%%  TABLE freq
tablename = 'freq';
newfreq = newdata.freq;
colnames = {'ntc_id','emi_rcp','beam_name','grp_id','seq_no','freq_sym','freq_assgn','freq_mhz','freq_min','freq_max','bdwdth','ntc_type'};
for f=1:length(newfreq{:,1})
    newrecord = newfreq(f,:);
    %Need to change: ntc_id,grp_id,ntc_type
    ntc_id = noticeID;
    grp_id=newfreq{f,'grp_id'}+lastgrp;
    %Apply changes
    newrecord{1,'ntc_id'}=ntc_id;
    newrecord{1,'grp_id'}=grp_id;
    newrecord{1,'ntc_type'}={ntc_type};
    %Insert row
    datainsert(conn2,tablename,colnames,newrecord)   
end
disp('Table freq completed.')

%%  TABLE e_as_stn
tablename = 'e_as_stn';
newe_as_stn = newdata.e_as_stn;
colnames = {'grp_id','seq_no','e_as_id','stn_name','stn_type','lat_dec','long_dec','noise_t','gain','ant_diam', 'bmwdth','pattern_id'};
for stn=1:length(newe_as_stn{:,1})
    newrecord = newe_as_stn(stn,:);
    %Need to change: grp_id,e_as_id
    grp_id=newe_as_stn{stn,'grp_id'}+lastgrp;
    e_as_id = newe_as_stn{stn,'e_as_id'}+laststn;
    %Apply change
    newrecord{1,'grp_id'}=grp_id;
    newrecord{1,'e_as_id'}=e_as_id;
    %Insert row  
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table e_as_stn completed.')

%%  TABLE e_srvcls
tablename = 'e_srvcls';
newe_srvcls = newdata.e_srvcls;
colnames = {'grp_id','seq_e_as','seq_no','stn_cls','nat_srv'};
for stn=1:length(newe_srvcls{:,1})
    newrecord = newe_srvcls(stn,:);
    %Need to change: grp_id,nat_srv
    grp_id=newe_srvcls{stn,'grp_id'}+lastgrp;
    %Apply change
    newrecord{1,'grp_id'}=grp_id;
    %Insert row  
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table e_srvcls completed.')
%%  TABLE s_beam
tablename = 's_beam';
news_beam = newdata.s_beam;
colnames = {'ntc_id','emi_rcp','beam_name','f_steer','gain','pnt_acc','freq_min','freq_max','f_pfd_steer_default'};
for beam=1:length(news_beam{:,1})
    newrecord = news_beam(beam,:);
    %Need to change: ntc_id
    ntc_id=noticeID;
    %Apply change
    newrecord{1,'ntc_id'}=ntc_id;
    %Insert row  
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table s_beam completed.')

%%  TABLE srv_cls
tablename = 'srv_cls';
newsrv_cls = newdata.srv_cls;
colnames = {'grp_id','seq_no','stn_cls','nat_srv'};
for stn=1:length(newsrv_cls{:,1})
    newrecord = newsrv_cls(stn,:);
    %Need to change: grp_id,nat_srv
    grp_id=newsrv_cls{stn,'grp_id'}+lastgrp;
    nat_srv = 'CO';
    %Apply change
    newrecord{1,'grp_id'}=grp_id;
    newrecord{1,'nat_srv'}={nat_srv};
    %Insert row  
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table srv_cls completed.')

%%  TABLE emiss
tablename = 'emiss';
newemiss = newdata.emiss;
colnames = {'grp_id','seq_no','design_emi','pep_max','pwr_ds_max','pep_min','pwr_ds_min','c_to_n'};
for e=1:length(newemiss{:,1})
    newrecord = newemiss(e,:);
    %Need to change: grp_id
    grp_id=newemiss{e,'grp_id'}+lastgrp;
    %Apply change
    newrecord{1,'grp_id'}=grp_id;
    %Insert row  
    datainsert(conn2,tablename,colnames,newrecord)
end
disp('Table emiss completed.')
close(conn2);
end