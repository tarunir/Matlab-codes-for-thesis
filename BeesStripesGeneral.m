%Code to generate black and white grating and moving it at a specified cps,
%duration of time and predefined pauses. Dimensions of the grating can be
%set in the code itself. Before using code, check the resolution of output
%screen.

function grating=BeesStripesGeneral(cyclespersecondList, duration, pauseDuration)
Screen('Preference', 'SkipSyncTests', 1);

if nargin < 1
    cyclespersecondList = [1];
end
if isempty(cyclespersecondList)
    cyclespersecondList=[6];
end
%if nargin < 2
    p=64;
%end
if nargin < 2
    movieDurationSecs=600;
else
    movieDurationSecs=duration;
end
if nargin < 3
    pauseDuration=2;
end

visiblesize=1024;
if rem(visiblesize, p)~=0
  error('Period p must divide default visiblesize of 512 pixels without remainder for this demo to work!');
end;

%AssertOpenGL;

%screens=Screen('Screens')
%screenNumber=max(screens)
screenNumber=0;
%white=WhiteIndex(screenNumber)
%black=BlackIndex(screenNumber)
white=255;
black=0;
gray=round((white+black)/2);
if gray == white
    gray=white / 2;
end
inc=white-gray;
f=1/p;
fr=f*2*pi;
x=meshgrid(0:visiblesize-1, 1);
grating=gray + inc*cos(fr*x)
whiteScreen=white*ones(1,1024);
w = Screen('OpenWindow',screenNumber,gray);
gratingtex=Screen('MakeTexture', w, grating, [], 1);
ifi=Screen('GetFlipInterval', w);    
waitframes = 1;
waitduration = waitframes * ifi;

for i = 1:length(cyclespersecondList)
    cyclespersecond = cyclespersecondList(i);

    shiftperframe= cyclespersecond * p * waitduration;
    vbl=Screen('Flip', w);
    vblendtime = vbl + movieDurationSecs;
    xoffset=0;
    sdpls=ones(1000,2);
    sdpls=sdpls*0.5;
    while(vbl < vblendtime)
       xoffset = xoffset + shiftperframe;
       srcRect=[xoffset 0 xoffset + visiblesize visiblesize];
       Screen('DrawTexture', w, gratingtex, srcRect);
       vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
       if KbCheck
           break;
       end
    end
%     Screen('FillRect', w, 511);
%     Screen('Flip', w);
    pause(pauseDuration);
end
Screen('CloseAll');
return;