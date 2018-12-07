% ------------------------------------------------------------------------------------ %
% GERADOR DE FILLING                     
%                                                       
% RESUMO: Este programa preenche os par�metros n�mericos da rede no arquivo de banco 
% de dados .mdb pr�-formatado pela ITU com as tabelas e campos.
%
% SETUP: Utilize o App "Database Explorer" para conectar ao arquivo de banco de dados 
% .mdb que ser� preenchido por este programa. O nome deste arquivo .mdb deve ser igual
% ao nome da rede. Ex.: Se a rede vai se chamar SISCOMIS-10, ent�o o
% arquivo ser� SISCOMIS-10.mdb.
%
%
% INPUT: Os inputs  s�o os par�metros da rede lan�ados nos arquivos de 
% excell salvados na pasta Input. Os nomes dos arquivos devem
% ser lan�ados na lista "bands" na se��o input deste programa.
%
% OUTPUT: O output principal � o arquivo de banco de dados .mdb 
% com os campos das tabelas  preenchidos com os parametros n�mericos da
% rede. A pasta Output receber� os gr�ficos dos par�metros das emiss�es de
% uplink e downlink da rede criada. Eles servem para verificar a
% conformidade com os limites de emiss�o estipulado pela regulamenta��o da
% ITU para cada faixa de frequ�ncia.
% ------------------------------------------------------------------------------------ %

%% ----- INPUTS -----
%bands = {'QV-Band_V4','X-Band_V4','Ka-Band_V4','UHF-Band_V4'}; %Lista dos arquivos de excell salvos na pasta Input que ser�o considerados para o filling
bands = {'MYNET_X-Band','MYNET_Ka-Band'};
databaseName = 'MY-NETWORK_DB'; %Nome do arquivo .mdb que foi configurado a conex�o pelo App "Database Explorer". � este arquivo que receber� os dados n�mericos da rede gerados por este programa.

%%
prompt = 'All records shall be deleted. Do you want to proceed? Y/N [Y]: ';
answer = input(prompt,'s');
if(strcmp(answer,'y'))
    DeleteAllRecords(databaseName)
    disp('All records deleted successfully.')

    for b=1:length(bands)
        close all
        file = strcat(bands{b},'.xlsx');
        msg = ['Loading parameters from ' file];
        disp(msg)
        p = loadParameters_V4(file);
        msg = ['Calculating emissions for ' bands{b}];
        disp(msg)
        EMISSION = generateEmissions_V4(p);
        
        prompt = 'Do you want to see and save the results? Y/N [Y]: ';
        %answer = input(prompt,'s');
        answer = 'y';
        if(strcmp(answer,'y'))
            plotResults_V4
        end
        
        prompt = 'Do you want load it into the filling? Y/N [Y]: ';
        %answer = input(prompt,'s');
        answer = 'y';
        if(strcmp(answer,'y'))
            loadDataIntoDataBase_V4(databaseName,p,EMISSION)
        end
    end
    finalmsg = [databaseName ' Filling Completed'];
    disp(finalmsg);
end
