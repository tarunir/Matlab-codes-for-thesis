% cartspher converts a set of orthogonal right handed cartesian coordinates (x,y,z) to 
% spherical coordinates r, theta, phi. where r is the distance of the
% point from the origin (0,0,0), theta is its angular elevation to the x-y
% plane and phi is its azimuthal inclination to the x-z plane (angles in
% radians)

function[r theta phi]=cartspher2(x,y,z)
r=sqrt(x.^2+y.^2+z.^2);
theta=atan(z./sqrt(x.^2+y.^2));

for i=1:length(x)
    %y(i)>=0 & x(i)>=0
           phi(i)=(atan2(y(i),x(i)));
       
                
   %elseif y(i)>=0 & x(i)<=0
           %phi(i)=pi-abs(atan(y(i)./x(i)));
            
   %elseif y(i)<=0 & x(i)<=0
               %phi(i)=pi+abs(atan(y(i)./x(i)));
               
   %elseif y(i)<=0 & x(i)>=0
                  %phi(i)=2*pi-abs(atan(y(i)./x(i)));
                  %  phi(i)=-abs(atan(y(i)./x(i)));
   
end
phi=phi';