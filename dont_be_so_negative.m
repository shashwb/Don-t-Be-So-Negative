%two images needed...
%image_gray -> image that will be greyscaled
%image_palette -> the image that will be used as the color palette
tic %measure performance
clc;
clear all;
close all;

image_gray = imread('lena.png'); 
image_palette = imread('blueberries.jpg'); 
figure
imshow(image_gray);
figure
imshow(image_palette);

[gray_x gray_y gray_z] = size(image_gray);
[palette_x palette_y palette_z] = size(image_palette);

if gray_z~=1
    
    image_gray = rgb2gray(image_gray);
    figure
    imshow(image_gray)
    title('turned to gray');
    
end

if palette_z~=3
    
    disp ('make sure the palette is actually colored!');
    
else
    
    image_gray(:,:,2) = image_gray(:,:,1);
    image_gray(:,:,3) = image_gray(:,:,1);
    
    %need to convert to the ycbcr color space!
    ycbr_space_gray = rgb2ycbcr(image_gray); %2
    ycbr_space_palette = rgb2ycbcr(image_palette); %1
    
    palette_ms = double(ycbr_space_palette(:,:,1));
    grayscale_ms = double(ycbr_space_gray(:,:,1));
    
    %recieve the values from the palette and the grayscale
    first_pallete = max(max(palette_ms));
    second_palette = min(min(palette_ms));
    first_grayscale = max(max(grayscale_ms));
    second_grayscale = min(min(grayscale_ms));
    
    value_palette = first_pallete - second_palette;
    value_grayscale = first_grayscale - second_grayscale;
    
    %now we have to normalize the values
    palette_to_grayscale = grayscale_ms;
    palette_to_normal = palette_ms;
    palette_to_normal = (palette_to_normal * 255) / (255 - value_palette);
    palette_to_grayscale = (palette_to_grayscale * 255) / (255 - value_grayscale);
    [coordx, coordy, coordz] = size(palette_to_grayscale);
    
    %compare the luminance
    %the luminance will loop through all of the channels and values
    %this is resource intensive and will take a while
    disp('Calculating luminance, this could take a while, please wait....');
    disp('average time: 577 seconds');
    for i = 1:coordx
        for j = 1:coordy
            coord_palette = palette_to_grayscale(i,j);
            temp_value = abs(palette_to_normal-coord_palette);
            check_lum = min(min(temp_value));
            [r,c] = find(temp_value==check_lum);
            check_lum = isempty(r);
            if (check_lum~=1)
                output_image(i,j,2) = ycbr_space_palette(r(1),c(1),2);
                output_image(i,j,3) = ycbr_space_palette(r(1),c(1),3);
                output_image(i,j,1) = ycbr_space_gray(i,j,1);
            end
        end
    end
    
    output_result = ycbcr2rgb(output_image)
    figure, title('Image Gray')
    imshow(uint8(image_gray));
    %verify the proper result!
    figure, title('Image Result')
    imshow(uint8(output_result));
    R = uint8(output_result);
    toc
    
    %write out a new file for part 1
    imwrite(uint8(output_result), 'Part_One_Solution.jpg');
    figure
    imshow(uint8(output_result))
    title('Part One Solution');
    
    %read in the newly created file for part 2
    %here we will use the rgb channels used for the negative image
    negative_image = imread('newfile.jpg');
    negative_image = im2double(negative_image);
    [size_one,size_two,size_three] = size(negative_image);
    red_channel = negative_image(:,:,1);
    green_channel = negative_image(:,:,2);
    blue_channel = negative_image(:,:,3);
    
    %go through and take the negative values of the channels.
    %need to loop through the arrays and subtract away the pixels at the
    %proper channels
    
    %we want to take the negative of the red channel. Null Array necessary
    channel_red_negative = zeros(size_one,size_two);
    for i = 1:size_one
        for j = 1:size_two
            %obtain the negative of the red color channel
            channel_red_negative(i,j) = 1 - red_channel(i,j);
        end
    end
    
    %negative of green channel
    channel_green_negative = zeros(size_one,size_two);
    for i = 1:size_one
        for j = 1:size_two
            %obtain the negative of the green color channel
            channel_green_negative(i,j) = 1 - green_channel(i,j);
        end
    end
    
    %negative of blue channel
    blue_channel_negative = zeros(size_one,size_two);
    for i = 1:size_one
        for j = 1:size_two
            %obtain the negative of the blue color value
            blue_channel_negative(i,j) = 1 - blue_channel(i,j);
        end
    end
    
    %produce an image through the negative channels calculated above
    null_matrix = zeros(size_one,size_two,size_three);
    null_matrix(:,:,1) = channel_red_negative;
    null_matrix(:,:,2) = channel_green_negative;
    null_matrix(:,:,3) = blue_channel_negative;
    
    imshow([negative_image null_matrix]);  
    
end
    
    
    
    
    
  
    

