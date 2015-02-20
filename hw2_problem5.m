clear all;
clc;

load('pointTargetData.mat');

data = veraStrct.data;
fs = 20e6;
speed = 1540; %m/s in body
pixel_size_through_depth = speed/fs; 

for ii = 1:max(size(data))
    time_array(ii) = ii/fs;
end

for nn = 2:2:16
    if nn == 2
        focus = [-round((1/6)*128)-0.5 round((1/6)*128)+0.5];
    elseif nn==4
        focus = [-round((3/10)*128)-0.5 -round((1/10)*128)-0.5 round((1/10)*128)+0.5 round((3/10)*128)+0.5];
    elseif nn==8
        focus = [-round((7/18)*128)-0.5 -round((5/18)*128)-0.5 -round((3/18)*128)-0.5 -round((1/18)*128)-0.5...
            round((1/18)*128)+0.5 round((3/18)*128)+0.5 round((5/18)*128)+0.5 round((7/18)*128)+0.5]; 
    elseif nn==16
        focus = [-round((15/34)*128)-0.5 -round((13/34)*128)-0.5 -round((11/34)*128)-0.5 -round((9/34)*128)-0.5...
            -round((7/34)*128)-0.5 -round((5/34)*128)-0.5 -round((3/34)*128)-0.5 -round((1/34)*128)-0.5...
            round((1/34)*128)+0.5 round((3/34)*128)+0.5 round((5/34)*128)+0.5 round((7/34)*128)+0.5 round((9/34)*128)+0.5...
            round((11/34)*128)+0.5 round((13/34)*128)+0.5 round((15/34)*128)+0.5];
    end


for ff = 1:length(focus)
    
channel = [[-63.5:1:63.5]];
n=0;
for cc = 1:length(channel)
    n = n+1;
    if channel(cc) == focus(ff)
        index_channel = n;
    end      
end

for jj = 1:max(size(data))
    
depth = jj*pixel_size_through_depth; %m

for ii = 1:(length(channel))
    xe(ii) = 0.1953e-3*abs(channel(ii)); 
    d(ii) = (xe(ii)^2+depth^2)^0.5;
    time_to_point(ii) = d(ii)/speed;
end
time_from_zero = time_to_point(index_channel);
time_from_zero_v = ones(1,length(time_to_point))*time_from_zero;
time_delay = time_to_point - time_from_zero_v;

for aa = 1:128
    delay = time_delay(aa);
    time_array_delayed(:,aa,:) = time_array+delay;
    delayed_channel(:,aa,:) = interp1(time_array(:,aa,:),data(:,aa,:),time_array_delayed,'linear');
end

summed_channels = sum(delayed_channel,2);

end

end

end