clear dir
fileLst=dir([sacDir,'*00.00.00.*.*.HHZ.M.SAC']);
fileLst=dir([sacDir,'*HHZ*SAC']);
fid=fopen('staLst','w+');

for i=1:length(fileLst)
    sac=readsac([fileLst(i).folder,'\',fileLst(i).name]); 
    fprintf(fid,'%s %s %s %.4f %.4f %d\n',sac.KNETWK,sac.KSTNM,sac.KCMPNM(1:2),sac.STLO,sac.STLA,round(1/sac.DELTA)); 
    f1(i)=round(1/sac.DELTA);
end

fid=fopen('staLst','w+');

for i=1:length(staLst)
    staLa(i)=staLst(i).la;
    staLo(i)=staLst(i).lo;
end
worldmap
plotm(staLa(f1>50),staLo(f1>50),'.')
fid=fopen('staLst','w+');
for i=find((staLa>30).*(staLa<40).*(staLo>100).*(staLo<130).*(f1>=50))
    fprintf(fid,'%s %s BH %.4f %.4f\n',staLst(i).net,staLst(i).name,staLst(i).lo,staLst(i).la); 
end
%BLWY AF 2018 11 01 00 00 00.000 2018 11 01 00 00 09.000 1 BHN
fid=fopen('sacLst','w+');
for i=1:length(staLst)
    fprintf(fid,'%s %s 2018 07 01 07 00 00.000 2018 07 01 10 00 00.000 1 HHE\n',staLst(i).name,staLst(i).net);
    fprintf(fid,'%s %s 2018 07 01 07 00 00.000 2018 07 01 10 00 00.000 1 HHN\n',staLst(i).name,staLst(i).net);
    fprintf(fid,'%s %s 2018 07 01 07 00 00.000 2018 07 01 10 00 00.000 1 HHZ\n',staLst(i).name,staLst(i).net);
end