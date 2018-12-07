%Read the GSO database
T = readtable('GSO.csv');

%Filter T table to only GSO satellites
T = T(strcmp(T{:,'OBJECT_TYPE'},'PAYLOAD'),:);
%Filter T table to only operational satellites using period time threshold
MAX_PERIOD = 1437;
T = T(find(str2double(T{:,'PERIOD'}) < MAX_PERIOD), :);
%Filter T table to only satellites with inclination lower than threshold
MAX_INCL = 5;
T = T(find(str2double(T{:,'INCLINATION'}) < MAX_INCL), :);