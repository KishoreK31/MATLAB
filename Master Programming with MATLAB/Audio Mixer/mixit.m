
function out = mixit(music,weight)

music = double(music);
out = zeros(size(music));

%standardized music to [-1 1]
s_music = music - 2^16/2; %meaning it is centered around 0

if max(abs(s_music))>1
    s_music = s_music./(2^16./2);
end

out = sum(s_music.*weight,2);
if max(abs(out))>1
    out = out./max(abs(out));
end
end
