function y=cdfvpin(vector)

maxele=max(vector);
minele=min(vector);
sizelength = length(vector);
sort_vec = sort(vector,'ascend');
cdfseq = zeros(sizelength,1);
for i=1:sizelength
    cdfseq(i)=max(find(sort_vec == vector(i)))/sizelength;
end
y=cdfseq;
