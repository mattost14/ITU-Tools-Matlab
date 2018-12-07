% ------------------------------------------------------------------------------------ %
% GERADOR DE FILLING                     
%                                                       
% RESUMO: Este programa preenche os parâmetros númericos da rede no arquivo de banco 
% de dados .mdb pré-formatado pela ITU com as tabelas e campos.
%
% SETUP: Utilize o App "Database Explorer" para conectar ao arquivo de banco de dados 
% .mdb que será preenchido por este programa. O nome deste arquivo .mdb deve ser igual
% ao nome da rede. Ex.: Se a rede vai se chamar SISCOMIS-10, então o
% arquivo será SISCOMIS-10.mdb.
%
%
% INPUT: Os inputs  são os parâmetros da rede lançados nos arquivos de 
% excell salvados na pasta Input. Os nomes dos arquivos devem
% ser lançados na lista "bands" na seção input deste programa.
%
% OUTPUT: O output principal é o arquivo de banco de dados .mdb 
% com os campos das tabelas  preenchidos com os parametros númericos da
% rede. A pasta Output receberá os gráficos dos parâmetros das emissões de
% uplink e downlink da rede criada. Eles servem para verificar a
% conformidade com os limites de emissão estipulado pela regulamentação da
% ITU para cada faixa de frequência.
% ------------------------------------------------------------------------------------ %

%% ----- INPUTS -----
%bands = {'QV-Band_V4','X-Band_V4','Ka-Band_V4','UHF-Band_V4'}; %Lista dos arquivos de excell salvos na pasta Input que serão considerados para o filling
bands = {'MYNET_X-Band','MYNET_Ka-Band'};
databaseName = 'MY-NETWORK_DB'; %Nome do arquivo .mdb que foi configurado a conexão pelo App "Database Explorer". É este arquivo que receberá os dados númericos da rede gerados por este programa.

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
