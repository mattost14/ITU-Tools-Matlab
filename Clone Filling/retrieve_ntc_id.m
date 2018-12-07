function [ntc_id,long_nom,adm,ntc_type] = retrieve_ntc_id(conn,satName)

%% 
%Accessing table com_el to find SatName ntc_id
tablename = 'com_el';
%selectquery = ['SELECT ntc_id,sat_name,long_nom,f_active FROM ' tablename ' WHERE ' 'sat_name=' satName];
selectquery = ['SELECT ntc_id,adm,sat_name,long_nom,ntf_rsn,d_rcv FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
com_el_data = curs.Data;
com_el_data = com_el_data(strcmp(com_el_data(:,3),satName),:);
NotificationFound = false; CRFound = false; APIFound = false;
if(isempty(com_el_data))
    msg=sprintf('There was no register found for %s.',satName);
    disp(msg)
else
    %Check if there network was already notified
    if(find(strcmp(com_el_data(:,5),'N')))
        NotificationFound = true;
        N_ntc_id = com_el_data{strcmp(com_el_data(:,5),'N'),1};
        N_d_rcv = com_el_data{strcmp(com_el_data(:,5),'N'),6};
        N_long_nom = com_el_data{strcmp(com_el_data(:,5),'N'),4};
        N_adm = com_el_data{strcmp(com_el_data(:,5),'N'),2};
        msg = sprintf('%s notified in %s',satName,N_d_rcv);
        disp(msg)
    else
        %Check API register
        if(find(strcmp(com_el_data(:,5),'A')))
            APIFound = true;
            %Check 7 years deadline from API d_rcv
            API_d_rcv = com_el_data{strcmp(com_el_data(:,5),'A'),6};
            API_ntc_id = com_el_data{strcmp(com_el_data(:,5),'A'),1};
            API_long_nom = com_el_data{strcmp(com_el_data(:,5),'A'),4};
            API_adm = com_el_data{strcmp(com_el_data(:,5),'A'),2};
            today=datetime('today');
            daysleft = datenum(API_d_rcv)+7*365-datenum(today);
            if(daysleft>0)
                msg=sprintf('%s has %d days left until 7 years deadline to notification.',satName,daysleft);
                disp(msg)
            else
                disp('Expired network - 7 years from API receive data with no notification found.')
            end
        end
        %Check CR register
        if(find(strcmp(com_el_data(:,5),'C')))
            CRFound = true;
            CR_ntc_id = com_el_data{strcmp(com_el_data(:,5),'C'),1};
            CR_d_rcv = com_el_data{strcmp(com_el_data(:,5),'C'),6};
            CR_long_nom = com_el_data{strcmp(com_el_data(:,5),'C'),4};
            CR_adm = com_el_data{strcmp(com_el_data(:,5),'C'),2};
        end
    end
end
if(NotificationFound)
    ntc_id = N_ntc_id;
    long_nom = N_long_nom;
    adm = N_adm;
    ntc_type='N';
elseif(CRFound)
    ntc_id = CR_ntc_id;
    long_nom = CR_long_nom;
    adm = CR_adm;
    ntc_type='C';
elseif(APIFound)
    ntc_id = API_ntc_id;
    long_nom = API_long_nom;
    adm = API_adm;
    ntc_type='A';
    disp('WARNING: Only API register found.')
end

end