function [xpx,ypx] = get_pxLegion(xcm,ycm)
x_pxmm = 0.1643; y_pxmm = 0.1786;
xpx = xcm*10/x_pxmm; ypx = ycm*10/y_pxmm; % multiply by 10 to get to mm