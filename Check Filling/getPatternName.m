function patternName = getPatternName(pattern_id)
    genericRx = [1,2,3,4,5,6,7,8,9,627];
    genericTx = [50,51,52,53,54];
    
    if(pattern_id ==33 || pattern_id==76)
        patternName = 'Appendix 8';
    elseif(pattern_id ==601 || pattern_id==602)
        patternName = 'S.465-5';
    elseif(pattern_id ==605 || pattern_id==606)
        patternName = 'S.465-5';
    elseif(find(genericRx==pattern_id) || find(genericTx==pattern_id))
        patternName = 'Generic Pattern';
    end

end