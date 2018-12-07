function newdata=loadBeamData(beam_name,e_r,p)
        newdata=struct();
        %Filter by emi_rcp
        s_beam_filter1 = p.s_beam(strcmp(e_r,p.s_beam{:,'emi_rcp'}),:);
        grp_filter1 = p.grp(strcmp(e_r,p.grp{:,'emi_rcp'}),:);
        %Filter by beam name
        s_beam_filtered = s_beam_filter1(strcmp(beam_name,s_beam_filter1{:,'beam_name'}),:);
        grp_filtered = grp_filter1(strcmp(beam_name,grp_filter1{:,'beam_name'}),:);
        
        emiss_filtered=table();
        assgn_filtered=table();
        freq_filtered=table();
        e_srvcls_filtered=table();
        srv_cls_filtered=table();
        e_as_stn_filtered=table();
        last_stn_number=0;
        for g=1:length(grp_filtered{:,1})
            grp_id = grp_filtered{g,'grp_id'};
            %emiss table
            emiss_grp = p.emiss(p.emiss{:,'grp_id'}==grp_id,:);
            emiss_grp{:,'grp_id'}=g;
            emiss_filtered=[emiss_filtered;emiss_grp];
            %assgn table
            assgn_grp = p.assgn(p.assgn{:,'grp_id'}==grp_id,:);
            assgn_grp{:,'grp_id'}=g;
            assgn_filtered=[assgn_filtered;assgn_grp];
            %freq table
            freq_grp = p.freq(p.freq{:,'grp_id'}==grp_id,:);
            freq_grp{:,'grp_id'}=g;
            freq_filtered=[freq_filtered;freq_grp];
            %e_srvcls
            e_srvcls_grp = p.e_srvcls(p.e_srvcls{:,'grp_id'}==grp_id,:);
            e_srvcls_grp{:,'grp_id'}=g;
            e_srvcls_filtered=[e_srvcls_filtered;e_srvcls_grp];
            %srv_cls
            srv_cls_grp = p.srv_cls(p.srv_cls{:,'grp_id'}==grp_id,:);
            srv_cls_grp{:,'grp_id'}=g;
            srv_cls_filtered=[srv_cls_filtered;srv_cls_grp];
            %e_as_stn
            e_as_stn_grp = p.e_as_stn(p.e_as_stn{:,'grp_id'}==grp_id,:);
            e_as_stn_grp{:,'grp_id'}=g;
            e_as_stn_grp{:,'e_as_id'}=[last_stn_number+1:1:last_stn_number+length(e_as_stn_grp{:,'grp_id'})]';
            last_stn_number = last_stn_number+length(e_as_stn_grp{:,'grp_id'});
            e_as_stn_filtered=[e_as_stn_filtered;e_as_stn_grp];
            %Last cmd - Change grp_id number to g
            grp_filtered{g,'grp_id'}=g;
        end
        newdata.s_beam = s_beam_filtered;
        newdata.grp = grp_filtered;
        newdata.emiss = emiss_filtered;
        newdata.assgn = assgn_filtered;
        newdata.freq = freq_filtered;
        newdata.e_srvcls = e_srvcls_filtered;
        newdata.srv_cls = srv_cls_filtered;
        newdata.e_as_stn = e_as_stn_filtered;
end