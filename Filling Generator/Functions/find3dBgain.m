function error = find3dBgain(phi,pattern,Gmax)
    gain = gainMask(phi,pattern,Gmax);
    delta = Gmax - gain;
    error = abs(delta - 3);
end