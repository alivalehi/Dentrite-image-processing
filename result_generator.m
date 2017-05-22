if(1) %ROC Curve
    
    clc;
    clear all
    p = 1;
    thresholdval = [1e3:3e3:1e4 1e4:1e5:5e5];
    portion = 1;%1.2;
    lngth = length(thresholdval);
    FP = zeros(1,lngth);
    FN = zeros(1,lngth);
    TP = zeros(1,lngth);
    TN = zeros(1,lngth);
    for threshold = thresholdval
        o=1;
        %fake pattern
        numberlist = [4,6,8,9,10,15,18,19,20,21]; %numberlist = [4,6,8,9,10,15,18,19,20,21];
        for q=numberlist
            imagestr{o} = ['original/ROC/fake-b' num2str(q) '.png']; %4,6,8,9,10,15,18,19,20,21 rest remain in db :,26,31,33,35,41,42,44,45,51
            string = imagestr{o};
            compareresult = graph_comparator(string);
            distances = 1e6 - compareresult.distance;
            [distances,I] =  sort(distances,'ascend')
            if((distances(2))>=(portion*distances(1))&& distances(1)< threshold)
                FP(p) = FP(p)+1 %fake image considered as real
            else
                FN(p) = FN(p)+1 %fake image detected as fake
            end
            o =o+1;
        end
        %real pattern
        o=1;
        numberlist = [5,7,13,17,32,36,43,52,55];%numberlist = [5,7,13,17,25,32,36,43,52,55];
        id = [3,4,5,6,10,13,16,20,21];
        for q=numberlist
            q
            imagestr{o} = ['original/ROC/gaus5-' num2str(q) '.png']; % imagestr{o} = ['original/ROC/gaus25-' num2str(q) '.png'];% imagestr{o} = ['original/ROC/skew7H-b' num2str(q) '.png'];%5,7,13,17,25,32,36,43,52,55
            string = imagestr{o};
            %  string = ['original/b4.png']
            compareresult = graph_comparator(string,1);
            distances = 1e6 - compareresult.distance;
            [distances,I] =  sort(distances,'ascend')
            I
            if(((distances(2))>=(portion*distances(1))&& distances(1)< threshold)&&I(1)==id(o)) %if(I(1)~=id(o))
                TP(p) = TP(p)+1
            else
                TN(p) = TN(p)+1
            end
            o =o+1;
        end
        p = p+1;
    end
end
if(0) %different skew -> measure distance
    
    clc;
    clear all
    o=1;
    numberlist = [2:1:12] ;
    for q=numberlist
        q
        imagestr{o} = ['original/skew' num2str(q) 'H-b1.png'];
        string = imagestr{o};
        %  string = ['original/b4.png']
        compareresult = graph_comparator(string);
        diffdistance(q).o = 1e6 - compareresult.distance;
        difflevel(q) = compareresult.j;
        %  difftime(o)  = compareresult.elapsedtime;
        o =o+1;
    end
    
    
    
    
    for q=numberlist
        q
        [B(q,:),I(q,:)]=sort(diffdistance(q).o);
    end
    for o =1:12
        for q=numberlist
            ali = B(q,:);
            ali1 = I(q,:);
            valehi(o,q) = ali(find(ali1==o));
        end
    end
    
    figure
    semilogy(1:12,valehi(1,:))
    hold all
    semilogy(1:12,valehi(2,:))
    semilogy(1:12,valehi(3,:))
    semilogy(1:12,valehi(4,:))
    semilogy(1:12,valehi(5,:))
    semilogy(1:12,valehi(6,:))
    semilogy(1:12,valehi(7,:))
    semilogy(1:12,valehi(8,:))
    semilogy(1:12,valehi(9,:))
    semilogy(1:12,valehi(10,:))
    semilogy(1:12,valehi(11,:))
    semilogy(1:12,valehi(12,:))
    zaeri = 10*log10(valehi)';
    bar(zaeri(:,1:2:12));
end
if(0) %different rotation -> measure distance
    
    clc;
    clear all
    o=1;
    numberlist = [2:2:30] ;
    for q=numberlist
        q
        imagestr{o} = ['original/rot' num2str(q) 'cw-b45.png'];
        string = imagestr{o};
        %  string = ['original/b4.png']
        compareresult = graph_comparator(string);
        diffdistance(q).o = 1e6 - compareresult.distance;
        %  difftime(o)  = compareresult.elapsedtime;
        o =o+1;
    end
    
    
    
    
    for q=numberlist
        q
        [B(q,:),I(q,:)]=sort(diffdistance(q).o);
    end
    for o =1:12
        for q=numberlist
            ali = B(q,:);
            ali1 = I(q,:);
            valehi(o,q) = ali(find(ali1==o));
        end
    end
    
    figure
    semilogy(1:12,valehi(1,:))
    hold all
    semilogy(1:12,valehi(2,:))
    semilogy(1:12,valehi(3,:))
    semilogy(1:12,valehi(4,:))
    semilogy(1:12,valehi(5,:))
    semilogy(1:12,valehi(6,:))
    semilogy(1:12,valehi(7,:))
    semilogy(1:12,valehi(8,:))
    semilogy(1:12,valehi(9,:))
    semilogy(1:12,valehi(10,:))
    semilogy(1:12,valehi(11,:))
    semilogy(1:12,valehi(12,:))
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
