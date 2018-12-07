function R=overlap(freq_min,freq_max,FREQMAX,FREQMIN)
bdwth = FREQMAX-FREQMIN;  
if(freq_min>=FREQMIN && freq_max>=FREQMAX)
    overlap = (FREQMAX-freq_min)/bdwth;
    fmin = freq_min; fmax = FREQMAX;
elseif(freq_min<FREQMIN && freq_max>=FREQMAX)
    overlap = (FREQMAX-FREQMIN)/bdwth;
    fmin = FREQMIN; fmax = FREQMAX;
elseif(freq_min>=FREQMIN && freq_max<=FREQMAX)
    overlap = (freq_max - freq_min)/bdwth;
    fmin = freq_min; fmax = freq_max;
elseif(freq_min<FREQMIN && freq_max<=FREQMAX)
    overlap = (freq_max - FREQMIN)/bdwth;
    fmin = FREQMIN; fmax = freq_max;
end
R=[fmin,fmax,overlap];
end