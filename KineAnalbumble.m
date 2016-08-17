% Analysis of Kinematics and calculating IAA

% Input the appropriate file
[file,filepath]=uigetfile('c:\MATLAB7\work\*.txt','load raw data file')
eval(['load ',filepath,file,';']);
eval(['filestring=',file(1:length(file)-4),';'])
file
%Process file to recover spherical coordinates from cartesian coordinates

% Assign variables
eval(['left_tip_x=','filestring','(:,1);']);
eval(['left_tip_y=','filestring','(:,2);']);
eval(['left_tip_z=','filestring','(:,3);']);

eval(['right_tip_x=','filestring','(:,4);']);
eval(['right_tip_y=','filestring','(:,5);']);
eval(['right_tip_z=','filestring','(:,6);']);

eval(['left_base_x=','filestring','(:,7);']);
eval(['left_base_y=','filestring','(:,8);']);
eval(['left_base_z=','filestring','(:,9);']);

eval(['right_base_x=','filestring','(:,10);']);
eval(['right_base_y=','filestring','(:,11);']);
eval(['right_base_z=','filestring','(:,12);']);

right_dx=-(right_tip_x-right_base_x)/1000;% Calibration in millimeters.
right_dy=-(right_tip_y-right_base_y)/1000;
right_dz=-(right_tip_z-right_base_z)/1000;

[right_r right_theta right_phi]=cartspher2(right_dx,right_dy,right_dz);

% Shifting Origin to base of the left antenna
left_dx=-(left_tip_x-left_base_x)/1000;
left_dy=-(left_tip_y-left_base_y)/1000;
left_dz=-(left_tip_z-left_base_z)/1000;

% Converting from Cartesian to Spherical Polar Coordinates
[left_r left_theta left_phi]=cartspher2(left_dx,left_dy,left_dz);

%Calculating base-base distance (bbd) for control
bbd=10^-3*sqrt((right_base_x-left_base_x).^2+(right_base_y-left_base_y).^2+(right_base_z-left_base_z).^2);

%for left antenna, change phi to pi+phi because both y and x are negative,
%the ratio of left_dy./left_dx is positive (as if it were in the 1st quadrant) 
%and the atan of this ratio gives an angle comparable to right antenna

corr_left_phi=pi+left_phi;
%corr_left_phi=left_phi;

% setting filming parameters
sample_size=length(right_tip_x);
sample_rate=800;
time=(1/sample_rate:1/sample_rate:sample_size/sample_rate)';% creates a time axis


%--------------------------------------------------------------------------
% smoothing all data using a 10-span method

Ycontrol=smooth(bbd,4);
Yleft_r=smooth(left_r,4);
Yright_r=smooth(right_r,4);
Yleft_theta=smooth(left_theta,4);
Yright_theta=smooth(right_theta,4);
Yleft_phi=smooth(left_phi,4);
Yright_phi=smooth(right_phi,4); 

%Ycorr_left_phi=pi+Yleft_phi;
Ycorr_left_phi=Yleft_phi;
%--------------------------------------------------------------------------


% Inter Antennal Angles
%mean angles
[mean_left_r mean_left_theta mean_left_phi]=cartspher2(mean(left_dx), mean(left_dy), mean(left_dz));
[mean_right_r mean_right_theta mean_right_phi]=cartspher2(mean(right_dx), mean(right_dy), mean(right_dz));

inter_antennal_angle_phi=pi-abs(left_phi)-abs(right_phi);
inter_antennal_angle_theta=pi-left_theta-right_theta;

% From top view
inter_antennal_angle_xy=2*pi-(left_phi)-right_phi;

% From side view
inter_antennal_angle_yz=pi-abs(left_phi)-right_phi;

inter_antennal_angle=acos((left_dx.*right_dx+left_dy.*right_dy+left_dz.*right_dz)./((left_r).*(right_r)));
IAA=[inter_antennal_angle*180/pi];

figure;


subplot(321)
plot3(left_dx,left_dy,left_dz);
hold on
plot3(right_dx,right_dy,right_dz,'r');
xlabel('X axis m')
ylabel('Y axis m')
zlabel('Z axis m')
plot3(0,0,0,'ko')
plot3([mean(left_dx) 0],[mean(left_dy) 0],[mean(left_dz) 0],'k')
plot3([mean(right_dx) 0],[mean(right_dy) 0],[mean(right_dz) 0],'k')
hold off
axis(10^-3*[-30 30 -30 30 -30 30])
axis square
title(['Antennal motion in 3-D using x-y-z for ',file])


subplot(322)
plot3(Yleft_r.*cos(Ycorr_left_phi).*cos(Yleft_theta),Yleft_r.*sin(Ycorr_left_phi).*cos(Yleft_theta),Yleft_r.*sin(Yleft_theta));
hold
plot3(Yright_r.*cos(Yright_phi).*cos(Yright_theta),Yright_r.*sin(Yright_phi).*cos(Yright_theta),Yright_r.*sin(Yright_theta),'r');
plot3(0,0,0,'mo')

plot3([mean(left_dx) 0],[mean(left_dy) 0],[mean(left_dz) 0],'k')
plot3([mean(right_dx) 0],[mean(right_dy) 0],[mean(right_dz) 0],'k')

title(['Antennal motion in 3-D using r-theta-phi for ',file])


hold off
xlabel('X axis m')
ylabel('Y axis m')
zlabel('Z axis m')
axis(10^-3*[-30 30 -30 30 -30 30])
axis square

subplot(323)
plot(time,Yleft_theta)
hold on
plot(time,Yright_theta,'r')
plot(time,mean(Yleft_theta),'b')
plot(time,mean(Yright_theta),'r')

hold off
ylabel('Theta (Radians) ')
xlabel('Time(sec)')

subplot(324)
plot(time,(Ycorr_left_phi))
%plot(time,(Ycorr_left_phi-pi));% for science paper
hold on
plot(time,Yright_phi,'r')
meanlp=mean(Ycorr_left_phi)*ones(length(time),1);
%meanlp=mean(Ycorr_left_phi-pi)*ones(length(time),1);% for science paper
plot(time,meanlp,'b')
meanrp=mean(Yright_phi)*ones(length(time),1);
plot(time,meanrp,'b')
hold off
ylabel('Phi (Radians) ')
xlabel('Time(sec)')

subplot(325)
plot(time,Yleft_r)
hold on
plot(time,Yright_r,'r')
meanlr=mean(Yleft_r)*ones(length(time),1);
plot(time,meanlr,'b')
meanrr=mean(Yright_r)*ones(length(time),1);
plot(time,meanrr,'r')
ylabel('r (m) ')
xlabel('Time(sec)')
axis([0 4.1 0 10^-3*25])

plot(time,Ycontrol,'k')
meanbbd=mean(Ycontrol)*ones(length(time),1);
plot(time,meanbbd,'k')

%ylabel('base-base(mm) ')
xlabel('Time(sec)')
hold off
axis([0 1 0 10^-3*25])

subplot(326)
plot(time,IAA)
hold
meanIAA=mean(IAA)*ones(length(time),1);
plot(time,meanIAA,'k')
axis([0 max(time) 0 180])

%code to pick every 4th IAA
%P=size(IAA);
%Y= P(:,1);
%DIAA= zeros(Y/4, 1);
%a=0;
%for i= 1:4:Y
    %a=a+1;
    %DIAA(a)=IAA(i);
%end


%--------------------------------------------------------------------------
% Fourier analysis of the signal

left_phi_freq=fastfour(left_phi-mean(left_phi),sample_rate);
right_phi_freq=fastfour(right_phi-mean(right_phi),sample_rate);

left_theta_freq=fastfour(left_theta-mean(left_theta),sample_rate);
right_theta_freq=fastfour(right_theta-mean(right_theta),sample_rate);

figure(2)
subplot(211)
plot(left_phi_freq(:,1),left_phi_freq(:,2)*180/pi,'r')
hold on
plot(right_phi_freq(:,1),right_phi_freq(:,2)*180/pi,'b')
xlabel('Phi Frequency (Hz)')
ylabel('Phi Amplitude  (degrees)')

title(['Fourier transforms for ',file,' blue=right, red=left'])

subplot(212)
plot(left_theta_freq(:,1),left_theta_freq(:,2)*180/pi,'r')
hold on
plot(right_theta_freq(:,1),right_theta_freq(:,2)*180/pi,'b')
xlabel('Theta Frequency (Hz)')
ylabel('Theta Amplitude  (degrees)')



