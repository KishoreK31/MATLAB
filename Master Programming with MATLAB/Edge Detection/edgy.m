function out = edgy(img)
    if size(img,3)~=1   %convert to grayscale
        img_gray = rgb2gray(img);
    else
        img_gray = img;
    end

    S2 = [1 2 1;0 0 0; -1 -2 -1];
    S2 = int64(S2);
    S1 = S2'.*(-1);

    limits = size(img_gray)-1;
    out = img_gray;
    for r = 2:limits(1)
        for c = 2:limits(2)
            sub = img_gray(r-1:r+1,c-1:c+1);        
            sub = int64(sub);
            Sx = 0;
            Sy = 0;
            for i = 1:3    
                for j = 1:3
                    Sx = Sx + sub(i,j).*S1(i,j);
                    Sy = Sy + sub(i,j).*S2(i,j);
                end
            end       
            
            M = sqrt(double(Sx^2 + Sy^2));  %Sobel operator
            out(r,c) = uint8(M);
        end
    end

    out = out(2:limits(1),2:limits(2));
    out = uint8(out);
end