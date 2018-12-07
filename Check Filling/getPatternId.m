function id=getPatternId(pattern,TxOrRx)
    if(strcmp(pattern,'Appendix 8'))
        if(strcmp(TxOrRx,'Tx'))
            id=76;
        else
            id=33;
        end
    elseif(strcmp(pattern,'S.465-5'))
        if(strcmp(TxOrRx,'Tx'))
            id=602;
        else
            id=601;
        end
    elseif(strcmp(pattern,'S.580-6'))
        if(strcmp(TxOrRx,'Tx'))
            id=606;
        else
            id=605;
        end
    else
        id=nan;
        disp('patternId not found')
    end

end
