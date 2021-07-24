function mybox = boxfilter(size)
mybox = ones(size);
size = size*size;
mybox = mybox/size;
end

