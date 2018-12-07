function data1=retrieveData(conn_srs1,conn_srs2,ntc_id)
data1 = struct();

%%Table grp
tablename = 'grp';
selectquery = ['SELECT grp_id,ntc_id,emi_rcp,beam_name,noise_t,d_rcv,bdwdth,freq_min,freq_max,polar_type,pwr_max,d_upd,prd_valid,adm_resp,op_agcy,area_no FROM ' tablename ' WHERE ' 'ntc_id=' num2str(ntc_id)];
curs = exec(conn_srs1,selectquery);
curs = fetch(curs);
grp = curs.Data;
data1.grp = cell2table(grp,'VariableNames',{'grp_id','ntc_id','emi_rcp','beam_name','noise_t','d_rcv','bdwdth','freq_min','freq_max','polar_type','pwr_max','d_upd','prd_valid','adm_resp','op_agcy','area_no'});

%%
%Table s_beam
tablename = 's_beam';
selectquery = ['SELECT ntc_id,emi_rcp,beam_name,f_steer,gain,pnt_acc,freq_min,freq_max FROM ' tablename ' WHERE ' 'ntc_id=' num2str(ntc_id)];
curs = exec(conn_srs1,selectquery);
curs = fetch(curs);
s_beam = curs.Data;
data1.s_beam = cell2table(s_beam,'VariableNames', {'ntc_id','emi_rcp','beam_name','f_steer','gain','pnt_acc','freq_min','freq_max'});
%%
%Table emiss
tablename = 'emiss';
emiss={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_no,design_emi,pep_max,pwr_ds_max,pep_min,pwr_ds_min,c_to_n FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs1,selectquery);
        curs = fetch(curs);
        emiss = [emiss; curs.Data];
    end
    data1.emiss = cell2table(emiss,'VariableNames',{'grp_id','seq_no','design_emi','pep_max','pwr_ds_max','pep_min','pwr_ds_min','c_to_n'});
end

%%
%Table e_as_stn
tablename = 'e_as_stn';
e_as_stn={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_no,e_as_id,stn_name,stn_type,lat_dec,long_dec,noise_t,gain,ant_diam, bmwdth,pattern_id FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs1,selectquery);
        curs = fetch(curs);
        e_as_stn = [e_as_stn; curs.Data];
    end
    data1.e_as_stn = cell2table(e_as_stn,'VariableNames',{'grp_id','seq_no','e_as_id','stn_name','stn_type','lat_dec','long_dec','noise_t','gain','ant_diam', 'bmwdth','pattern_id'});
end

%% Table ant_type
tablename = 'ant_type';
selectquery = ['SELECT pattern_id,f_ant_type,emi_rcp,pattern,coefa,coefb,coefc,coefd,phi1 FROM ' tablename];
curs = exec(conn_srs1,selectquery);
curs = fetch(curs);
ant_type = curs.Data;
data1.ant_type = cell2table(ant_type,'VariableNames',{'pattern_id','f_ant_type','emi_rcp','pattern','coefa','coefb','coefc','coefd','phi1'});

%% Table assgn
tablename = 'assgn';
assgn={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_no,freq_sym,freq_assgn,freq_mhz FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs1,selectquery);
        curs = fetch(curs);
        assgn = [assgn; curs.Data];
    end
    data1.assgn = cell2table(assgn,'VariableNames',{'grp_id','seq_no','freq_sym','freq_assgn','freq_mhz'});
end
%% Table freq (It uses part2 of srs database)
tablename = 'freq';
freq={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT ntc_id,emi_rcp,beam_name,grp_id,seq_no,freq_sym,freq_assgn,freq_mhz,freq_min,freq_max,bdwdth,ntc_type FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs2,selectquery);
        curs = fetch(curs);
        freq = [freq; curs.Data];
    end
    data1.freq = cell2table(freq,'VariableNames',{'ntc_id','emi_rcp','beam_name','grp_id','seq_no','freq_sym','freq_assgn','freq_mhz','freq_min','freq_max','bdwdth','ntc_type'});
end

%%  TABLE e_srvcls
tablename = 'e_srvcls';
e_srvcls={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_e_as,seq_no,stn_cls,nat_srv FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs1,selectquery);
        curs = fetch(curs);
        e_srvcls = [e_srvcls; curs.Data];
    end
    data1.e_srvcls = cell2table(e_srvcls,'VariableNames',{'grp_id','seq_e_as','seq_no','stn_cls','nat_srv'});
end

%%  TABLE srv_cls
tablename = 'srv_cls';
srv_cls={};
if(~isempty(data1.grp))
    for count=1:length(data1.grp{:,1})
        grp_id = data1.grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_no,stn_cls,nat_srv FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn_srs1,selectquery);
        curs = fetch(curs);
        srv_cls = [srv_cls; curs.Data];
    end
    data1.srv_cls = cell2table(srv_cls,'VariableNames',{'grp_id','seq_no','stn_cls','nat_srv'});
end
%% Close all connections
close(conn_srs1)
close(conn_srs2)
end
