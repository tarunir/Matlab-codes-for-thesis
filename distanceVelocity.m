

% Code to take inputs from the digitized x,y,z points and calculate the
% distance and airspeeds of flying bees.
     
     % code to read the 3D points from the file
     
     uiwait(msgbox('PLOTTING 3D DISTANCE PLOT'));
     
     [specfile,specpath]=uigetfile({'*.csv','comma separated values'}, ...
       'Please select data file for head');
     hspecdata=dlmread([specpath,specfile],',',1,0);
     
     d3hx=hspecdata(:,1);
     d3hy=hspecdata(:,2);
     d3hz=hspecdata(:,3);
     
for i=1:size(d3hx)
    hxb=d3hx(i);
    hyb=d3hy(i);
    hzb=d3hz(i);
    hxf=d3hx(length(d3hx));
    hyf=d3hy(length(d3hy));
    hzf=d3hz(length(d3hz));
    dh=sqrt((power((hxf-hxb),2))+(power((hyf-hyb),2))+(power((hzf-hzb),2)));
    dist_head(i)=dh;
end


range=numel(d3hx);
tt=linspace(0,(range/800),range);

%code to pick a point every 4th frame of the distance covered
%O=size(dist_head);
%X= O(1,2);
%DS= zeros(X/4, 1);
%b=0;
%for i= 1:4:X
    %b=b+1;
    %DS(b)=dist_head(i);
%end
%code to pick every 4th time point
%P=size(tt);
%Y= P(1,2);
%DT= zeros(Y/4, 1);
%a=0;
%for i= 1:4:Y
    %a=a+1;
   % DT(a)=tt(i);
%end
% smoothening dist_head values usling s golay of pole 8 and a moving window
% of 9 points
dist_head_smooth=smooth(dist_head,9,'sgolay',8)
% code to filter the calculted distance time data

[B,A]=butter(8,(90/400));
head_filt=filtfilt(B,A,dist_head_smooth);
% Moving-window average
%dt = tt(2) - tt(1);
%width = 0.003; % in seconds
%width = width / dt;
%[ head_filt, weights ] =moving(dist_head,width,'gaussian');

% Computing velocities
velocity =-(diff(dist_head)./diff(tt));
DV= -(diff(head_filt')./diff((tt)-1));
%code to pick every 4th time point
%Q=size(velocity);
%Z= Q(1,2);
%DV= zeros(Z/4, 1);
%c=0;
%for i= 1:4:Z
    %c=c+1;
    %DV(c)=velocity(i);
%end


% code to plot the distance time - (Blue-> original, red->filtered) 

hold on,figure(1);
subplot(2,2,1);
plot(tt,dist_head,tt,head_filt,'r',tt,dist_head_smooth,'g');
xlabel('Time(sec)');
ylabel('Distance(FILTERED)(cm)');
title('DISTANCE-TIME');




% code to plot the velocity - (Blue-> original, red->filtered) 

hold on,figure(1);
subplot(2,2,2);
hold on,plot(tt(1:length(tt)-1),DV,'r');
xlabel('Time');
ylabel('Velocity');
title('VELOCITY-TIME');


hold on,figure(1);
subplot(2,2,3);
plot(tt(1:length(tt)-1), velocity);
xlabel('Time');
ylabel('Velocity');
title('VELOCITY-TIME');

hold on,figure(1);
subplot(2,2,4);
plot(tt(1:length(tt)-1), velocity);
hold on,plot(tt(1:length(tt)-1),DV,'r');
%hold on,plot(-tt(1:length(tt)-1),weights(1:end-1)*max(velocity),'.black');
xlabel('Time');
ylabel('Velocity');
title('VELOCITY-TIME');
[fname,pathname]=uiputfile('*fig','filename to save Airspeeds plot')
hgsave([pathname,fname]);

% code to save the calculated distance-time data
%[fname,pathname]=uiputfile('*.csv','filename to save distance and time');
%velocity_padded = [ velocity 0.0 ];
%velocity_filt_padded = [ velocity_filt 0.0 ];
%fs=[tt' dist_head' DT' DS' velocity_padded' velocity_filt_padded'];
%fe=[tt' dist_head'];
%csvwrite([pathname,'\',fname],fe);
%[fname,pathname]=uiputfile('*.csv','filename to save downsampled distance,velocity and time');
%ff=[DT' DS' velocity_filt'];
%csvwrite([pathname,'\',fname],DT, DS, velocity_filt);
%[fname,pathname]=uiputfile('*.csv','filename to save velocity');
%fg=[velocity'];
%csvwrite([pathname,'\',fname],fg);