function [ac1, nmi1, Pri1,AR1] = printResult(X, label, K, kmeansFlag)
	if(~exist('kmeansFlag','var'))
		kmeansFlag = 1;
	end
    for i=1:1
        if kmeansFlag == 1
            indic = litekmeans(X, K, 'Replicates',20);
        else
            [~, indic] = max(X, [] ,2);
        end
        result = bestMap(label, indic);
        [ac(i), nmi_value(i), cnt(i)] = CalcMetrics(label, indic);
        [Pri(i)] = purity(label, indic);
        AR(i)=RandIndex(label, indic);
    end
    ac1 = mean(ac); nmi1=mean(nmi_value);
    Pri1=mean(Pri); AR1=mean(AR);
    fprintf('ac: %0.2f\tnmi:%0.2f\tpur:%0.2f\tar:%0.2f\n',...
        ac1*100, nmi1*100, Pri1*100,AR1*100);
end
