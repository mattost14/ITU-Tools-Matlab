function updateDataBase()
username = 'helciohvj@comgar.aer.mil.br';
password = 'Senhaatspacetrack01';

URL='https://www.space-track.org/ajaxauth/login';
options = weboptions('RequestMethod','post','ArrayFormat','csv','ContentType','text');

%% GSO database
query_str = 'https://www.space-track.org/basicspacedata/query/class/satcat/PERIOD/1430--1450/CURRENT/Y/DECAY/null-val/orderby/NORAD_CAT_ID/format/csv';
filename = 'GSO.csv';
data=websave(filename,URL,'identity',username,'password',password,'query',query_str,'Timeout',5,options);
movefile([filename,'.html'],filename);

%% Small Sat Database (RCS < 0.1m2)
query_str = 'https://www.space-track.org/basicspacedata/query/class/satcat/RCS_SIZE/SMALL/OBJECT_TYPE/PAYLOAD/orderby/LAUNCH desc/format/csv/metadata/false';
filename = 'SMALL_SAT.csv';
data=websave(filename,URL,'identity',username,'password',password,'query',query_str,'Timeout',5,options);
movefile([filename,'.html'],filename);

end

