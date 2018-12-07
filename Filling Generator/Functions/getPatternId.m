function id=getPatternId(pattern,TxOrRx)
    if(strcmp(pattern,'AP8'))
        if(strcmp(TxOrRx,'Tx'))
            id=76;
        else
            id=33;
        end
    elseif(strcmp(pattern,'REC-465-5'))
        if(strcmp(TxOrRx,'Tx'))
            id=602;
        else
            id=601;
        end
    elseif(strcmp(pattern,'REC-580-6'))
        if(strcmp(TxOrRx,'Tx'))
            id=606;
        else
            id=605;
        end
    elseif(strcmp(pattern,'ND-EARTH'))
        if(strcmp(TxOrRx,'Tx'))
            id=607;
        else
            id=607;
        end
    else
        id=nan;
        disp('patternId not found')
    end

end
