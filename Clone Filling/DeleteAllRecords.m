function DeleteAllRecords(databaseName)

conn = database(databaseName,'','');

sqlquery = 'DELETE * FROM assgn';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM grp';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM freq';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM e_as_stn';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM e_srvcls';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM provn';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM s_beam';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM srv_cls';
curs = exec(conn,sqlquery);

sqlquery = 'DELETE * FROM emiss';
curs = exec(conn,sqlquery);
end