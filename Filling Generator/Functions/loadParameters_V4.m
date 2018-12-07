function p=loadParameters_V4(filename)
    p=struct();    
    %Load worksheet General
    General=readtable(filename,'Sheet','General');
    General.Properties.RowNames = General.Parametro;
    p.Band_Identification=General{'Band Identification','Und'};
    p.ESD_Limit_Regulation = General{'ESD_Limit_Regulation','Und'};
    p.PFD_RefBand = General{'PFD_RefBand','Input'};
    p.PFD_Limit = General{'PFD_Limit','Input'};
    p.PFD_Limit_Regulation = General{'PFD_Limit','Und'};
    p.Margem_ESD_FromLimit = General{'Margem_ESD_FromLimit','Input'};
    p.MargemMin = General{'MinimumMargem','Input'};
    %Load worksheet Beam
    Beam=readtable(filename,'Sheet','Beam');
    Beam.Properties.RowNames = Beam.BeamName;
    p.Beam = Beam;
    %Load worksheet Earth Stations
    EarthStation=readtable(filename,'Sheet','Earth Stations');
    EarthStation.Properties.RowNames = EarthStation.ID;
    p.EarthStation = EarthStation;
    %Load worksheet Groups
    Groups=readtable(filename,'Sheet','Groups');
    p.Groups = Groups;
    %Load worksheet TypeOfEmission
    TypeOfEmission=readtable(filename,'Sheet','TypeOfEmission');
    p.TypeOfEmission = TypeOfEmission;
    %Load worksheet DVB-S2
    DVBS2=readtable(filename,'Sheet','DVB-S2');
    DVBS2.Properties.RowNames = DVBS2.MOD;
    p.DVBS2 = DVBS2;
    disp('All paramteres loaded with success.');
end