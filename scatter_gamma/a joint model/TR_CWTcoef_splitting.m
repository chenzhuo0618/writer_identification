%%  splitting image 
tic
clear all
clc
clear

%     storage_path = 'D:\A Joint Model of Complex Wavelet Coefficients for Texture Retrieval\splitting imgs\Stone.0001\';
%     original_image = imread('D:\A Joint Model of Complex Wavelet Coefficients for Texture Retrieval\imgs\Stone.0001.tif');
    storage_path = 'G:\scattering+gamma\scattering+gamma\Brodatz\';
    original_image = imread('G:\scattering+gamma\scattering+gamma\Brodatz\brodatz.012.gif');
 
    [imageA,imageB,imageC,imageD]=TR_CWTcoef_quartering(original_image);


    [ sub_image1, sub_image2,  sub_image3,  sub_image4 ] = TR_CWTcoef_quartering(imageA); 
    [ sub_image5, sub_image6,  sub_image7,  sub_image8 ] = TR_CWTcoef_quartering(imageB);
    [ sub_image9, sub_image10, sub_image11, sub_image12] = TR_CWTcoef_quartering(imageC);
    [sub_image13, sub_image14, sub_image15, sub_image16] = TR_CWTcoef_quartering(imageD);

    for subimgs_id=1:9
        storage_name   = strcat(storage_path,'brodatz.012.0',num2str(subimgs_id),'.gif');
        sub_image_name = strcat('sub_image',num2str(subimgs_id));
        imwrite(eval(sub_image_name),storage_name);
    end 
    for subimgs_id=10:16
        storage_name = strcat(storage_path,'brodatz.012.',num2str(subimgs_id),'.gif');
        sub_image_name = strcat('sub_image',num2str(subimgs_id));
        imwrite(eval(sub_image_name),storage_name);
    end
    
toc
    
    