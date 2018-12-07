function [grp, s_beam,emiss,e_as_stn,ant_type,e_srvcls]=retrieveData(conn,ntc_id)
%%
%Table grp
tablename = 'grp';
selectquery = ['SELECT grp_id,ntc_id,emi_rcp,beam_name,noise_t,bdwdth,freq_min,freq_max,polar_type,area_no FROM ' tablename ' WHERE ' 'ntc_id=' num2str(ntc_id)];
curs = exec(conn,selectquery);
curs = fetch(curs);
grp = curs.Data;
grp = cell2table(grp,'VariableNames',{'grp_id','ntc_id','emi_rcp','beam_name','noise_t','bdwdth','freq_min','freq_max','polar_type','area_no'});

%%
%Table s_beam
tablename = 's_beam';
selectquery = ['SELECT ntc_id,emi_rcp,beam_name,f_steer,gain,pnt_acc,freq_min,freq_max FROM ' tablename ' WHERE ' 'ntc_id=' num2str(ntc_id)];
curs = exec(conn,selectquery);
curs = fetch(curs);
s_beam = curs.Data;
s_beam = cell2table(s_beam,'VariableNames', {'ntc_id','emi_rcp','beam_name','f_steer','gain','pnt_acc','freq_min','freq_max'});

%%
%Table emiss
tablename = 'emiss';
emiss={};
if(~isempty(grp))
    for count=1:length(grp{:,1})
        grp_id = grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,seq_no,design_emi,pep_max,pwr_ds_max,pep_min,pwr_ds_min,c_to_n FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn,selectquery);
        curs = fetch(curs);
        emiss = [emiss; curs.Data];
    end
    emiss = cell2table(emiss,'VariableNames',{'grp_id','seq_no','design_emi','pep_max','pwr_ds_max','pep_min','pwr_ds_min','c_to_n'});
end

%%
%Table e_as_stn
tablename = 'e_as_stn';
e_as_stn={};
if(~isempty(grp))
    for count=1:length(grp{:,1})
        grp_id = grp{count,'grp_id'};
        selectquery = ['SELECT grp_id,stn_name,stn_type,lat_dec,long_dec,noise_t,gain,ant_diam, bmwdth,pattern_id FROM ' tablename ' WHERE ' 'grp_id=' num2str(grp_id)];
        curs = exec(conn,selectquery);
        curs = fetch(curs);
        if(~strcmp(curs.Data,'No Data'))
            e_as_stn = [e_as_stn; curs.Data]; 
        end
    end
    e_as_stn = cell2table(e_as_stn,'VariableNames',{'grp_id','stn_name','stn_type','lat_dec','long_dec','noise_t','gain','ant_diam', 'bmwdth','pattern_id'});
end

%%
%Table ant_type
tablename = 'ant_type';
selectquery = ['SELECT pattern_id,f_ant_type,emi_rcp,pattern,coefa,coefb,coefc,coefd,phi1 FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
ant_type = curs.Data;
ant_type = cell2table(ant_type,'VariableNames',{'pattern_id','f_ant_type','emi_rcp','pattern','coefa','coefb','coefc','coefd','phi1'});

%%
% Table e_srvcls
tablename = 'e_srvcls';
selectquery = ['SELECT grp_id,seq_e_as,seq_no,nat_srv,stn_cls FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
e_srvcls = curs.Data;
e_srvcls = cell2table(e_srvcls,'VariableNames',{'grp_id','seq_e_as','seq_no','nat_srv','stn_cls'});

end