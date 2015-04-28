%%%
%%%Function image division 16 sub image
%%%
function [feature_matrix]=image_division_and_extra(image,feature_matrix)

[imageA,imageB,imageC,imageD]=half_sparate_image(image);

[sub_image(1).image,sub_image(2).image,sub_image(3).image,sub_image(4).image]=half_sparate_image(imageA);
[sub_image(5).image,sub_image(6).image,sub_image(7).image,sub_image(8).image]=half_sparate_image(imageB);
[sub_image(9).image,sub_image(10).image,sub_image(11).image,sub_image(12).image]=half_sparate_image(imageC);
[sub_image(13).image,sub_image(14).image,sub_image(15).image,sub_image(16).image]=half_sparate_image(imageD);

for i=1:16
    
    feature_vector=CT_Extra_Feature(sub_image(i).image);
    feature_matrix=[feature_matrix,feature_vector];
end


