%%User Inputs
sat_name = 'SISCOMIS-9';
databaseName = 'SISCOMIS-9';
%% Connecting to database
conn = database(databaseName,'','');
if(isempty(conn.message))
    msg = ['ITU database: ' databaseName ' connected successfully.'];
    disp(msg)
else   
    disp(conn.message)
end
selectquery = 'SELECT DISTINCT grp.grp_id,emiss.seq_no, grp.emi_rcp, s_beam.beam_name, s_beam.gain, grp.noise_t, e_as_stn.stn_name, e_as_stn.stn_type, e_as_stn.gain, e_as_stn.noise_t, e_as_stn.ant_diam, e_as_stn.bmwdth, e_as_stn.pwr_max, freq.freq_assgn, emiss.design_emi, emiss.pep_max, emiss.pwr_ds_max, emiss.pep_min, emiss.pwr_ds_min, emiss.c_to_n FROM (((e_as_stn INNER JOIN emiss ON e_as_stn.grp_id = emiss.grp_id) INNER JOIN grp ON emiss.grp_id = grp.grp_id) INNER JOIN s_beam ON grp.beam_name = s_beam.beam_name) INNER JOIN freq ON grp.grp_id = freq.grp_id;';
curs = exec(conn,selectquery);
curs = fetch(curs);
dados = curs.Data;
fileName = 'Thales_QueryOutput.csv';
cell2csv(fileName, dados)