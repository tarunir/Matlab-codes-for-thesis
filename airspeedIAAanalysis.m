% Code to process the IAA and velocity values from previous code, calculate correlation coefficients and 
%plot a figure to correlate IAA and airspeeds of flying bees

clear all;
IAA_bee

distance_velocity

%code to make all vectors of equal length 
p=size(DV',1);
q=size(DIAA,1);
r=size(head_filt,1);
s=size(tt',1) ;

t=q-p

    for i=0:(t-1)
        DIAA(q-i)=[] 
        IAA(q-i)=[]
    end

u=r-p

    for j=0:(u-1)
        head_filt(r-j)=[] 
        dist_head(r-j)=[]
        dist_head_smooth(r-j)=[]
    end

v=s-p

    for k=0:(v-1)
        tt(s-k)=[]
    end

%code to save output vectors
[fname,pathname]=uiputfile('*.csv','filename to save airspeed,interantennal angles and time');
fg=[tt' dist_head' dist_head_smooth head_filt velocity' DV' DIAA IAA]
csvwrite([pathname,'\',fname],fg ,0,0);

[specfile,specpath]=uigetfile({'*.csv','comma separated values'}, ...
       'Please select data file for head');
     hspecdata1=dlmread([specpath,specfile],',',1,0);
     x=hspecdata1(:,1);
     y=hspecdata1(:,2);
     z=hspecdata1(:,3);

%uiwait(msgbox('PLOTTING 3D trajectory')) 

figure
subplot (221);
plot (tt', velocity')
hold on
plot (tt',DV,'r')
xlabel('Time (seconds)');
ylabel('Airspeed(cm/s)');
title('Airspeed-Time')
subplot (2,2,2)
plot (tt',IAA)
hold on
plot(tt',DIAA,'r')
xlabel('Time (seconds)');
ylabel('Interantennal angles(degrees)');
title('Interantennal angle-Time')
subplot (2,2,3)
plot(tt',DV,'b')
hold on
plot (tt',DIAA,'r')
xlabel('Time (seconds)');
ylabel('Interantennal angles(degrees)= red, Airspeeds(cm/s)=blue');
title('Interantennal angle, Airspeed-Time')
hold on
subplot (224)
 plot3(x,y,z)
 xlabel('x');
 ylabel('y');
 zlabel('z');
 title('3D trajectory plot')
    
[fname,pathname]=uiputfile('*fig','filename to save Final plot');
hgsave ([pathname,fname]);
y=corrcoef(DIAA,DV)
