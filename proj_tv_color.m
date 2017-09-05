function u = proj_tv_color(f,lam,iter,dt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: 	Xavier Bresson (xbresson@math.ucla.edu)
% Last version: Aug 3, 2008
% Some adaptations by Guy Gilboa (16.6.2013)
% For more information:  X. Bresson and T.F. Chan, "Fast Minimization of the
% Vectorial Total Variation Norm and Applications to Color Image Processing", CAM Report 07-25
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterative Denoising Scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial value
pxU = zeros(size(f));
pyU = zeros(size(f));
u = zeros(size(f));
Denom = zeros(size(f));

lami=1/lam;  % here the algorithm works with inverse of lambda


for cpt=1:iter
    
    Divp = ( BackwardX(pxU) + BackwardY(pyU) );
    Term = Divp -f/ lami;
    Term1 = ForwardX(Term);
    Term2 = ForwardY(Term);  
    Norm = sqrt(sum(Term1.^2 + Term2.^2,3));    
    Denom(:,:,1)=1+dt*Norm; %Denom(:,:,2)=Denom(:,:,1); Denom(:,:,3)=Denom(:,:,1);
    pxU = (pxU+dt*Term1)./Denom;
    pyU = (pyU+dt*Term2)./Denom;
    u = f - lami* Divp;


end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sub Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dx] = BackwardX(v);

[Ny,Nx,Nc] = size(v);
dx = v;
dx(2:Ny-1,2:Nx-1,:)=( v(2:Ny-1,2:Nx-1,:) - v(2:Ny-1,1:Nx-2,:) );
dx(:,Nx,:) = -v(:,Nx-1,:);


function [dy] = BackwardY(v);

[Ny,Nx,Nc] = size(v);
dy = v;
dy(2:Ny-1,2:Nx-1,:)=( v(2:Ny-1,2:Nx-1,:) - v(1:Ny-2,2:Nx-1,:) );
dy(Ny,:,:) = -v(Ny-1,:,:);



function [dx] = ForwardX(v);

[Ny,Nx,Nc] = size(v);
dx = zeros(size(v));
dx(1:Ny-1,1:Nx-1,:)=( v(1:Ny-1,2:Nx,:) - v(1:Ny-1,1:Nx-1,:) );



function [dy] = ForwardY(v);

[Ny,Nx,Nc] = size(v);
dy = zeros(size(v));
dy(1:Ny-1,1:Nx-1,:)=( v(2:Ny,1:Nx-1,:) - v(1:Ny-1,1:Nx-1,:) );




