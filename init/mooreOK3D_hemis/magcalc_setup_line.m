%SIMULATIONS LOCAITONS
%simname='chile20153D_0.5_medres/';
%simname='tohoku20113D_highres_var/';
%simname='tohoku20112D_3Dtest/'
simname='mooreOK3D_hemis_medres/';
basedir='~/zettergmdata/simulations/'
%basedir='/scratch/zettergm/simulations/'
direc=[basedir,simname];
mkdir([direc,'/magplots']);    %store output plots with the simulation data


%UTseconds of the frame of interest
ymd_TOI=[2015,09,16];
UTsec_TOI=82923;


%SIMULATION META-DATA
cfg = gemini3d.read_config(direc);

%TABULATE THE SOURCE LOCATION
thdist=pi/2-cfg.sourcemlat*pi/180;    %zenith angle of source location
phidist= cfg.sourcemlon*pi/180;


%ANGULAR RANGE TO COVER FOR THE CALCLUATIONS (THIS IS FOR THE FIELD POINTS - SOURCE POINTS COVER ENTIRE GRID)
dang=10;


%WE ALSO NEED TO LOAD THE GRID FILE
if (~exist('xg','var'))
  fprintf('Reading grid...\n');
  xg=readgrid([direc,'/inputs/']);
  lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
  lh=lx1;   %possibly obviated in this version - need to check
  if (lx3==1)
    flag2D=1;
    fprintf('2D meshgrid...\n')
    x1=xg.x1(3:end-2);
    x2=xg.x2(3:end-2);
    x3=xg.x3(3:end-2);
    [X2,X1]=meshgrid(x2(:),x1(1:lh)');
  else
    flag2D=0;
    fprintf('3D meshgrid...\n')
    x1=xg.x1(3:end-2);
    x2=xg.x2(3:end-2);
    x3=xg.x3(3:end-2);
    [X2,X1,X3]=meshgrid(x2(:),x1(1:lh)',x3(:));   %loadframe overwrites this (sloppy!) so redefine eeach time step
  end
end
fprintf('Grid loaded...\n');


%FIELD POINTS OF INTEREST (CAN/SHOULD BE DEFINED INDEPENDENT OF SIMULATION GRID)
ltheta=1600;
if (~flag2D)
  lphi=1;
else
  lphi=1;
end
lr=1;

thmin=thdist-dang*pi/180;
thmax=thdist+dang*pi/180;
phimin=phidist-dang*pi/180;
phimax=phidist+dang*pi/180;

theta=linspace(thmin,thmax,ltheta);
if (~flag2D & lphi>1)
  phi=linspace(phimin,phimax,lphi);
else
  phi=phidist;
end
r=(6370e3+500e3)*ones(ltheta,lphi);                          %use ground level for altitude for all field points
[phi,theta]=meshgrid(phi,theta);

%CREATE AN INPUT FILE OF FIELD POINTS
fid=fopen([basedir,'/input/',simname,'/magfieldpoints.dat'],'w');
fwrite(fid,numel(theta),'integer*4');
fwrite(fid,r(:),'real*8');
fwrite(fid,theta(:),'real*8');
fwrite(fid,phi(:),'real*8');
