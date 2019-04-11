cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd, filesep, '../../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'setup/gridgen'])
addpath([gemini_root, filesep, 'setup'])

%PFISR LOWRES GRID (CARTESIAN)
xdist=1200e3;    %eastward distance
ydist=600e3;    %northward distance
lxp=15;
lyp=15;
glat=67.11;
glon=212.95;
gridflag=0;
I=90;



%MATLAB GRID GENERATION
xg=makegrid_cart_3D(xdist,lxp,ydist,lyp,I,glat,glon);


%GENERATE SOME INITIAL CONDITIONS FOR A PARTICULAR EVENT
%%ISINGLASS B LAUNCH
UT=7.5;
dmy=[2,3,2017];
activ=[76.5,79.3,31.5];


%USE OLD CODE FROM MATLAB MODEL
nmf=5e11;
nme=2e11;
[ns,Ts,vsx1]=eqICs3D(xg,UT,dmy,activ,nmf,nme);    %note that this actually calls msis_matlab - should be rewritten to include the neutral module form the fortran code!!!


%WRITE THE GRID AND INITIAL CONDITIONS
simlabel='isinglass_eq'
outdir='~/zettergmdata/simulations/input/isinglass_eq/'
writegrid(xg,outdir);
time=UT*3600;   %doesn't matter for input files
writedata(dmy,time,ns,vsx1,Ts,outdir,simlabel);


