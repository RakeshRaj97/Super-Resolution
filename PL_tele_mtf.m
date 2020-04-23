function flt = PL_tele_mtf(d,N)
%% computes the telescope MTF
% N = size in number of samples
% d = obscuration

rD0=N/2                     ;   % Number of points to compute        
rD1=d*rD0                   ;      
s  = [0:1/rD0:2]            ;   % Reduced spatial frequency axis
D0 = fspecial('disk',rD0)   ;
D0 = D0/max(D0(:))          ;
D1 = fspecial('disk',rD1)   ;
D1 = D1/max(D1(:))          ;
D1(size(D0,1),size(D0,2))=0 ;
D1 = circshift(D1,[round(rD0-rD1) round(rD0-rD1)]);
P  = D0-D1                  ;   % Aperture
T  = xcorr2(P)              ;   % Obscurated MTF
T  = T/max(T(:))            ;   % Normalize to max
T0 = xcorr2(D0)             ;   % Perfect MTF
T0 = T0/max(T0(:))          ;   % Normalize to max

% output results
flt.T   = T     ;
flt.T0  = T0    ;
flt.s   = s     ;               % Frequencies
flt.P   = P     ;
flt.rD0 = rD0   ;
flt.rD1 = rD1   ;