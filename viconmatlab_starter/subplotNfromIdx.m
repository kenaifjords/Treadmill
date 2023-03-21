function [subnumber] = subplotNfromIdx(nr,nc,r,c)
    subnumber  = (r-1)* nc + c;
end