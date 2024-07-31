clear all
close all
addpath 'C:\Users\anne-\OneDrive\Bureau\fiji-win64\Fiji.app\scripts' % Update for your ImageJ2 (or Fiji) installation as appropriate

%make this directory the main folder where your tif zstacks are located
loc = 'E:\20240408_confocalairtest';
%give a name for this location
cd(loc)
%% for each tif file already in the directory, create a new directory with the same name as the file but without the .tif
for k = 1:numel(dir('*.tif'))
    %get the name of the tif file
    file = dir('*.tif');
    %get the name of the tif file
    file = file(k).name;
    %get the name of the tif file without the .tif
    file = file(1:end-4);
    %create a new directory with the name of the tif file without the .tif
    mkdir(file);
end
%% start a loop for each tif file in the directory

for k = 1:numel(dir('*.tif'))
    ImageJ;
    %get the name of the tif file
    file = dir('*.tif');
    file = file(k).name;
    ij.IJ.open(strcat(loc,'\',file));
    ij.IJ.run("Slice Keeper", "first=1 last=1 increment=1");
    %ij.IJ.run("Stack Splitter", "number=2");
    %ij.IJ.selectImage(strcat('stk_0002_',file));
    ij.IJ.run("Find Maxima...", "prominence=20000 output=List");
    %save the results as a csv file
    filename = file(1:end-4);
    ij.IJ.saveAs("Results", strcat(loc,'/',filename,'/','Results.csv'));
    close()
    ij.IJ.run("Quit","");
end
%%
for k = 8:numel(dir('*.tif'))
    cd(loc)
    file = dir('*.tif');
    file = file(k).name;%issue here
    filename = file(1:end-4);
    cd(filename)
    coordlist = readtable('Results.csv');
    coordlist_ar = table2array(coordlist);
    rectlist = zeros(size(coordlist_ar,1),4);
    rectlist(:,1)=coordlist_ar(:,2)-12;
    rectlist(:,2)=coordlist_ar(:,3)-12;
    rectlist(:,3)=25;
    rectlist(:,4)=25;
    rectlist(rectlist(:,1)<0,:)=[];
    rectlist(rectlist(:,2)<0,:)=[];
    rectlist(rectlist(:,1)>319,:)=[];% to avoid rect going beyond the edge of frame change for each microscope
    rectlist(rectlist(:,1)>324,:)=[];% to avoid rect going beyond the edge of frame change for each microscope
    
    count=0;
    ImageJ;
    for i = 1:size(rectlist,1)
        formatSpec = '(%d,%d,%d,%d)';
        A1 = rectlist(i,1);
        A2 = rectlist(i,2);
        A3 = rectlist(i,3);
        A4 = rectlist(i,4);
        str = sprintf(formatSpec,A1,A2,A3,A4);
        ij.IJ.open(strcat(loc,'\',file));
        ij.IJ.makeRectangle(A1, A2, A3, A4);
        ij.IJ.run("Duplicate...", "duplicate");
        formspc=strcat(loc,filename,'\%d.tif');%issue here
        ij.IJ.saveAs("Tiff",strcat(loc,'\',filename,'\',string(i),'.tif'))%and here
        close()
        count = count+1;
        cd .. 
    end
    ij.IJ.run("Quit","");

end
