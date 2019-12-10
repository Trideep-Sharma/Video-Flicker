function d = difference( f,a,k )
%Calulating luminance between neighboring pixels
d=f(k,a)-f(k-1,a);
d=abs(d);
if d<40
    d=0;
end
end