%% Source
sat_name1 = 'SICRAL-3H';
srs_part1 = 'SRS_part1'; srs_part2 = 'SRS_part2';

%% Destiny
sat_name2 = 'SISCOMIS-9';
databaseName2 = 'SISCOMIS-9';


%% Connecting to srs database (part1 and part2)
conn_srs1 = database(srs_part1,'','');
conn_srs2 = database(srs_part2,'','');
if(isempty(conn_srs1.message) && isempty(conn_srs2.message))
    msg = ['ITU SRS databases: ' srs_part1 ' and ' srs_part2 ' connected successfully.'];
    disp(msg)
else   
    disp(conn_srs1.message)
    disp(conn_srs2.message)
end

%% Connecting to database 2
conn2 = database(databaseName2,'','');
if(isempty(conn2.message))
    msg = ['ITU database destiny: ' databaseName2 ' connected successfully.'];
    disp(msg)
else   
    disp(conn2.message)
end

%% Retrieve data from sat_name1 and sat_name2
p=struct();
[ntc_id1,long_nom1,adm1,ntc_type1] = retrieve_ntc_id(conn_srs1,sat_name1);
[ntc_id2,long_nom2,adm2,ntc_type2] = retrieve_ntc_id(conn2,sat_name2);

fprintf('\n')
disp('SOURCE:')
msg=sprintf('NTC ID: %d   SATNAME: %s   LONG: %.1f   ADM: %s   NTC TYPE: %s',ntc_id1,sat_name1,long_nom1,adm1,ntc_type1);
disp(msg)
disp('DESTINY:')
msg=sprintf('NTC ID: %d   SATNAME: %s   LONG: %.1f   ADM: %s   NTC TYPE: %s',ntc_id2,sat_name2,long_nom2,adm2,ntc_type2);
disp(msg)
prompt='Do you want to continue? [y/n] ';
answer = input(prompt,'s');
if(strcmp(answer,'y'))
    disp('Retrieving data from data base source...')
    p.data1=retrieveData(conn_srs1,conn_srs2,ntc_id1);
    disp('All data retrieved with success.')
end

%% List all beam to be choosed by the user
disp('Available Beams to Clone:')
disp('#        E/R        Beam         FreqMin   FreqMax')
numberOfBeams = length(p.data1.s_beam{:,1});
for b=1:numberOfBeams
    msg=sprintf('%d        %s        %s         %.02f   %0.02f',b,char(p.data1.s_beam{b,'emi_rcp'}),char(p.data1.s_beam{b,'beam_name'}),p.data1.s_beam{b,'freq_min'},p.data1.s_beam{b,'freq_max'});
    disp(msg)
end
fprintf('\n')
prompt='Which beams do you want to clone? List all numbers seperated by common. Ex: 1,5\n';
answer = input(prompt,'s');
beamNumbers = strsplit(answer,',');
choosedBeams = {};
for i=1:length(beamNumbers)
    n=str2num(beamNumbers{i});
    if(n<=numberOfBeams && n>0)
         choosedBeams = [choosedBeams;{n,char(p.data1.s_beam{n,'beam_name'}),char(p.data1.s_beam{n,'emi_rcp'})}];
         msg=sprintf('%d        %s        %s         %.02f   %0.02f',n,char(p.data1.s_beam{n,'emi_rcp'}),char(p.data1.s_beam{n,'beam_name'}),p.data1.s_beam{n,'freq_min'},p.data1.s_beam{n,'freq_max'});
        disp(msg)
    else
        disp('Beam number invalid')
    end
end
fprintf('\n')
prompt='Proceed to export the choosed beams? [y/n]';
answer = input(prompt,'s');

if(strcmp(answer,'y'))
    for beam=1:length(choosedBeams)      
        beam_name = choosedBeams{beam,2};
        e_r = choosedBeams{beam,3};
        A=loadBeamData(beam_name,e_r,p.data1);
        %loadDataIntoDataBase2(conn2,A)
    end    
end
    
    


