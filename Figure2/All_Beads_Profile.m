%% now run jacobcode - this code is meant to, from one folder of beads, average them all, and plot the average profile
%run for one bead to get the dimensions
clear all
close all
%make 'D:\20240130_confocalbeadswater\' the working directory
locb = 'E:\airpoc';
cd(locb);
locf = 'D:\allbeads_codes';
filist=dir('*.tif');
pos = [-50:10:50];

for j = 1:length(pos)
    filename = [char(strcat(locb,'\',string(filist(1).name)))];
    cd(locf)
    im=loadtiff(filename);

    sz = size(im);

    centre =  round(sz(1)/2);

    if j == pos(1)
        xz = zeros(sz(3),sz(2),length(pos));
        yz = zeros(sz(3),sz(2),length(pos));
    end

    for i = 1:sz(3)
        xz(i,:,j) = im(centre,:,i);
        yz(i,:,j) = im(:,centre,i);
    end

end
cd(locb)
% run for all beads to make a plot of the average.

% create empty big array
bigarxz = zeros(size(xz,1),size(xz,2),size(xz,3),numel(dir('*.tif')));
bigaryz = zeros(size(yz,1),size(yz,2),size(yz,3),numel(dir('*.tif')));
avgxz = zeros(size(xz,1),size(xz,2),size(xz,3));
avgyz = zeros(size(yz,1),size(yz,2),size(yz,3));
xFWHM = zeros;
yFWHM = zeros;
check = 0;
%break in case
skipped = 0;
cd(locb);
filenumb = numel(dir('*.tif'));
for k = 1:filenumb % iterate of all files in a folder
    filename = [strcat(locb,'\',string(filist(k).name))];
    cd(locf);
    pos = [-50:10:50];
    skipIt = false;
    for j = 1:length(pos)
        
        im=loadtiff(filename);    
        sz = size(im);
        if sz(1) ~= sz(2)
        %skip and go to the next k
            skipIt = true;
            skipped = skipped+1;
            break;
        end
        if skipIt == true
            break;
        end
        centre =  round(sz(1)/2);    
        if j == pos(1)
            xz = zeros(sz(3),sz(2),length(pos));
            yz = zeros(sz(3),sz(2),length(pos));
        end
    
        for i = 1:sz(3)
            xz(i,:,j) = im(centre,:,i);
            yz(i,:,j) = im(:,centre,i);
        end
    
    end

    % find fwhm
    medx = median(xz,"all");
    medy = median(yz,"all");
    
    xhalfMax = (max(double(xz(1,:,1)))+medx)/2;
    yhalfMax = (max(double(yz(1,:,1)))+medy)/2;
    
    index1 = find(double(xz(1,:,1)) >= xhalfMax, 1, 'first');
    index2 = find(double(xz(1,:,1)) >= xhalfMax, 1, 'last');
    fwhm = index2-index1 + 1; 
    x = linspace(0,25*0.1075000,25);
    fwhm = x(index2) - x(index1);
    xFWHM(k)=fwhm
    
    index1 = find(double(yz(1,:,1)) >= yhalfMax, 1, 'first');
    index2 = find(double(yz(1,:,1)) >= yhalfMax, 1, 'last');
    fwhm = index2-index1 + 1; 
    x = linspace(0,25*0.1075000,25);
    fwhm = x(index2) - x(index1);
    yFWHM(k)=fwhm

    cd(locb);
    %store xz and yz into the big structure
    bigarxz(:,:,:,k) = double(xz);
    bigaryz(:,:,:,k) = double(yz);
    avgxz = avgxz + double(xz);
    avgyz = avgyz + double(yz);
    check = avgxz(1,1,1)
    
end
%
avgxz = avgxz/(filenumb-skipped);
avgyz = avgyz/(filenumb-skipped);
FW = [xFWHM; yFWHM];
FWxy = transpose(FW);
%change for each folder
cd("D:\beadsagain\components\");
save FWxyoilmin26.mat;

%% 
figure()
    subplot(1,2,1)   
    imagesc(avgyz(:,:,j))
    %imagesc(bigaryz(:,:,j,3))
    axis('equal')
    title('YZ')
    xlabel('pixels (50nm/pixel)')
    ylabel('steps (50nm/step)')
    subplot(1,2,2)
    imagesc(avgxz(:,:,j))
    %imagesc(bigarxz(:,:,j,3))
    axis('equal')
    title('XZ')
    xlabel('pixels (50nm/pixel)')
    ylabel('steps (50nm/step)')
%% plot for profile
figure()
    subplot(1,2,1)
    plot(linspace(0,0.1075*25,25),avgyz(1,:,1))
    %axis('equal')
    title('YZ')
    xlabel('profile width (um)')
    ylabel('grayscale value (arbitrary)')
    subplot(1,2,2)
    plot(linspace(0,0.1075*25,25),avgxz(1,:,1))
    %axis('equal')
    title('XZ')
    xlabel('profile width (um)')
    ylabel('grayscale value (arbitrary)')
    %% Functions for saving
    %imwrite(uint8(yz(:,:,j)),['Z:\Users\jrl70\OPM\20230314\Second_Go\CroppedBead1\Projections\YZ',num2str(pos(j)),'.png'])
    %imwrite(xz(:,:,j),['Z:\Users\jrl70\OPM\20230314\Second_Go\CroppedBead1\Projections\XZ',num2str(pos(j)),'.png'])
    