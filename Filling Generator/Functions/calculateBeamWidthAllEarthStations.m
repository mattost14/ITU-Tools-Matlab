function bmwdth=calculateBeamWidthAllEarthStations(p)
    bmwdth ={};
    
    for stn=1:length(p.EarthStation{:,1})
        stn_name=char(p.EarthStation{stn,'ID'});
        [bmwdthTx,bmwdthRx] = getBeamWidth(stn_name,p);
        bmwdth = [bmwdth;{stn_name,bmwdthTx,bmwdthRx}];
    end
end