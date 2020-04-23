function out = PL_ccrop(I,n)
%% Center-crops an RGB image
%        out = PL_ccrop(I,n)

out = I(round(end/2-n/2+1):round(end/2+n/2),round(end/2-n/2+1):round(end/2+n/2),:);