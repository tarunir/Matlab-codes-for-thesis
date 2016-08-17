% Code to stitch the different calibration files used to digitize bumblebee
% flight videos. The area to be calibrated was very large and one
% calibration object wasn't sufficient for it. We moved the calibration
% object lengthwise such that the z axis remained the same. Using this
% code, we stitched the resultant flight position data. 



dLoc=input('Directory location?','s')
%dLoc='bbee_pilot'
nfolders=input('Number of folders?')
%nfolders=2
ncalib=input('Number of calibration splits')
%ncalib=4

for folderN=155:nfolders;
    currentdir=strcat(dLoc,'/',num2str(folderN),'/');
    combinedfile=strcat(currentdir,'combined_data_',num2str(folderN),'.csv');
    delete(combinedfile);
    for fileN=1:ncalib;
        file=strcat(currentdir,num2str(fileN),'.csv');
        hspecdata=dlmread(file,',',1,0);
        t1=isnan(hspecdata(:,1));
        t2=diff(t1);
        %clear t1;
        t3=abs(t2);
        nanlimits=find(t3);
        %nanlimits=find(abs(diff(isnan(hspecdata(:,1)))))
        %if  fileN==1;
        %    filebeginningrow=1;
        %    filelastrow=nanlimits(2)-1;
        %elseif fileN==ncalib;
        %    filebeginningrow=nanlimits(2)+1;
        %    filelastrow=length(hspecdata(:,1));
        %else
        if length(nanlimits)==1;
            if hspecdata(1,1)==NaN;
                nanlimits=[nanlimits(1) length(hspecdata(:,1))];
            else
                nanlimits=[1 nanlimits(1)];
            end
        end
        if fileN>1;
            nanlimits(1)=lastlimit+1;
        end
            filebeginningrow=nanlimits(1)+1;
            filelastrow=nanlimits(2)-1;
        %end
        d3hx=hspecdata(filebeginningrow:filelastrow,1);
        d3hy=hspecdata(filebeginningrow:filelastrow,2);
        d3hz=hspecdata(filebeginningrow:filelastrow,3);
        if fileN==1;
            difference=0;
        else;
            difference=lastpoint-d3hz(1);
        end
        znew=d3hz+difference;
        lastpoint=znew(end);
        
        xnew=(1/sqrt(2))*(d3hx-d3hy);
        d3hxy=d3hx+d3hy;
        constant=22.4/sqrt(2);
        ynew=(-1/sqrt(2))*(d3hxy+constant);
        
        transformedaxes=[xnew ynew znew];
        %code to calculate mean velocity and standard deviation of veolcity
        samp=200;% frame rates
       cal=10^-2;%original calibration file in cm
      % assignment of variable names
        time=(1:length(d3hx))./samp;
        distance=[];
       %loop to calculate displacement values at each point
for j=1:size(d3hx)
    hxb=d3hx(j);
    hyb=d3hy(j);
    hzb=d3hz(j);
    hxf=d3hx(length(d3hx));
    hyf=d3hy(length(d3hy));
    hzf=d3hz(length(d3hz));
    dh=sqrt((power((hxf-hxb),2))+(power((hyf-hyb),2))+(power((hzf-hzb),2)));
    distance(j)=dh;
end

range=numel(d3hx);

%generates linearly spaced vectors
tt=linspace(0,(range/200),range);

% smoothening dist_head values usling s golay of pole 8 and a moving window
% of 9 points
dist_head_smooth=smooth(distance,9,'sgolay',8);

% code to filter the calculted distance time data using a low pass
% butterworth filter of pole 8 at 30 Hz
%[C,D]=butter(8,(90/400));
%distance_smooth_filtered=filtfilt(C,D,dist_head_smooth);


% Computing velocities.-ve sign in front of diff to make time go forward
velocity =-(diff(distance)./diff(tt));
velocity_smoothened= -(diff(dist_head_smooth')./diff((tt)-1));
meanvelocity=mean (velocity_smoothened)
standardevelocity=std (velocity_smoothened)
%code to make all vectors of equal length (of the length of the velocity
%vector)
p=size(velocity_smoothened',1);
r=size(dist_head_smooth,1);
s=size(tt',1) ;
 
u=r-p;

    for j=0:(u-1);
           dist_head_smooth(r-j)=[] ;
        distance(r-j)=[];
     dist_head_smooth(r-j)=[];
    end


v=s-p;

    for k=0:(v-1);
        tt(s-k)=[];
    end
 
    xx=input('Do you want to save this data? yes (type 0)or no (type 1)? xx=');
%case when you want to save the data
if xx==0
%code to save output vectors
fg=[tt' distance' dist_head_smooth velocity' velocity_smoothened']

        dlmwrite(combinedfile,transformedaxes,fg,'-append');
        lastlimit=nanlimits(2);
        clear xnew ynew znew transformedaxes file hspecdata t1 t2 t3 nanlimits
        clear filebeginningrow filelastrow d3hx d3hy d3hz d3hxy constant difference 
        clear tt' distance' dist_head_smooth  velocity' velocity_smoothened'
        
end
if xx==1
end
    end
end