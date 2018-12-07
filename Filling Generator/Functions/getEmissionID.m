function emiss = getEmissionID (bwdth,ext)
    %Check if it is higher than 1MHz
    if(round(bwdth/10^6)>0)
        d = num2str(round(bwdth/10^6));
        if(length(d)==3)
            emiss = strcat(d,'M');
        elseif(length(d)==2)
            emiss = strcat(d,'M');
            rest = num2str(round(rem(bwdth,10^6)));
            emiss = strcat(emiss,rest(1));
        elseif(length(d)==1)
            emiss = strcat(d,'M');
            rest = num2str(round(rem(bwdth,10^6)));
            if(length(rest)>=2)
                emiss = strcat(emiss,rest(1:2));
            else
                emiss = strcat(emiss,rest(1),'0');
            end
        end          
    else
        d = num2str(round(bwdth/10^3));
        if(length(d)==3)
            emiss = strcat(d,'K');
        elseif(length(d)==2)
            emiss = strcat(d,'K');
            rest = num2str(round(rem(bwdth,10^3)));
            emiss = strcat(emiss,rest(1));
        elseif(length(d)==1)
            emiss = strcat(d,'K');
            rest = num2str(round(rem(bwdth,10^3)));
            if(length(rest)>=2)
                emiss = strcat(emiss,rest(1:2));
            else
                emiss = strcat(emiss,rest(1),'0');
            end
        end         
    end
    emiss = strcat(emiss,ext);   
end