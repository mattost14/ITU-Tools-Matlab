function [bmwdthTx,bmwdthRx] = getBeamWidth(stn_name,p)
    pattern=p.EarthStation{stn_name,'Pattern'};
    Gmax=p.EarthStation{stn_name,'Gtx'};
    i=0;
    for phi=0:0.001:45
        i=i+1;
        Error1(i,1)=phi;
        Error1(i,2)=find3dBgain(phi,pattern,Gmax);
    end
    [minError, idx] = min(Error1(:,2));
    bmwdthTx = 2*Error1(idx,1);
    %Search for 3dB Beam Width for Rx
    Gmax=p.EarthStation{stn_name,'Grx'};
    i=0;
    for phi=0:0.001:45
        i=i+1;
        Error2(i,1)=phi;
        Error2(i,2)=find3dBgain(phi,pattern,Gmax);
    end
    [minError, idx] = min(Error2(:,2));
    bmwdthRx = 2*Error2(idx,1);
end