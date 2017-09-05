# PMP-Project-2017
Detection of Animal Feacal Parasites Using an ioLight Portable Microscope




Introduction 


The purpose of this report is to give the results and a measure of complexity for each of the main algorithms that I have produced during the project. Explanations will be given briefly and relevant code signposted to help anyone who may wish to run code in the future. I give results in order of, in my opinion, usefulness. 


Images 


The algorithms all run on the images with a 1mm field of view and scaled to 25% of their original size to 486x648 pixels.I thinkI changed all the algorithms so they resize the images as soon as they loaded, but should things not run as expected then this is something to check. We have in total: 

• 97 images containing no eggs 

• 83 images containing 1 egg 

• 16 images containing 2 eggs 

• 5 images containing 3 eggs 


Notes 


• Accuracy is given by two main values. The first being the percentage of images where the algorithm has correctly identified the correct number of eggs. The second being the percentage of images that the algorithm has correctly identified as having eggs or not. This second number can be brokendown into the sensitivity (images not containing eggs correctly identified) and specificity ( images containing eggs which were correctly identified).

• Measures of complexity are given as an estimate for the number of floating point operations, they are unlikely to be accurate taken individually, but the same process was used for each method and so I believe it is suitable for comparison purposes. 
– I take 35 images containing between 1 and 3 eggs and run each algorithm on each image in turn 
– Using code obtained from Matlab file exchange I follow their instructions to make an estimate for the number of floating point operations (https://uk.mathworks.com/matlabcentral/fileexchange/50608counting-the-floating-point-operations–flops2) 


Segment  Image and Analyse Properties 


This is a simple method but is consistently one of the most effective and it is the least complex. It takes an image, pulls out regions that contain “something” and then analyse properties of this region to decide if it is an egg or not 


Basic Method 


There are 3 functions that are important with this algorithm. I also included the program Detectingroundobjects which is a script version of analysefeatures and is mainly what I have been using for development and contains, commented out, a section where I was playing with standard deviation filtering to disentangle eggs from black lines. I left it in in case it becomes useful. 

segmentImage1mm 

Takes an image as an input 

1. Convert to grayscale by taking the third RGB element 
2. Adjust contrast and binarise using adaptive thresholding 
3. Fill holes 
4. Remove small objects 
5. Use morphological openingand closing to smooth the image 
6.Trace the boundaries and find the area of all objects 
7.If the area of an object is between 1800 and 3000 (about twice the size of an egg) then we take that object and perform a distance transform before a watershed transform to try and separate to objects joined together 
8. Outputs the final binary image 


analysefeatures 

Takes an image path as an input 

1. Load and resize images 
2. Run segmentimage1mm 
3. On the binary image trace the boundaries and find region properties 
4. Decides whether or not it is an egg based on 
      (a) Area -currently 1000-1900 
      (b) Roundness metric --between 0.8-0.95 
      (c) Eccentricity-0.75-0.95 
      (d) Intensity of the region (an average of the grayscale values in this region) -80-115 

5. Outputs the total number of eggs predicted 
You can change the parameters for deciding if an object is an egg at the beginning of this program. There is some commented out sections where I have been investigating using colour to help decide if an object is an egg or not. I have not been very successful but I leave it in case it should become useful. 

testingAnalyseFeatures 

This is the program that brings things together allowingyou to run this on multiple images and output as a table. 


Results  and Complexity 


It correctly predicts the right number of eggs in an image 77.11% of the time. It predicts eggs/not 85.07% of the time. Sensitivity of 79.80% and specificity 90.72%. A confusion matrix is included in Figure 1. The paramaters were originally decided based on eggs in abut half of the images and then rounded to nearest ’nice’ numbers so I don’t believe it has been overfitted to just this set of images and should hopefully be successful with other samples. 
On the 35 images, it took 148846 floating point operations. 


 


Neural Networks 


I have created a classifier using the neural network app in Matlab which forms part of a method which when given an image will return a predicted number of eggs thus can be run without any knowledge of machine learning. I will explain how to run this and then how to train another classifier should you wish. 

Current method 


There are 4 items that you need to run this program and then the segmentImage1mm.m algorithm described above. 

cropandanalyse.m 

This is the main function that is required. It takes on image path as its input and outputs a predicted number of eggs 

1. Loads bagoffeaturescroppedimages5.mat 
2. Read and resize image 
3. run segmentimage1mm 
4. Find theboundaries of all objects 
5. For all objects with area between 600 and 2500 it crops the colour image around the object and then rotates the image so that the major axis of the object lies horizontally 
6. The new cropped image is then encoded using the bagoffeatures and the resulting vector run through the myNueralNetworkFunction5.m to see if it is an egg or not 
7. It counts and outputs the numberof eggs in theimage


bagoffeaturescroppedimages5.mat 

This is a mat file containing the bagoffeatures that is used to encode images 


myNueralNetworkFunction5.m 

This takes a vector representing an images encoded using the bagooffeatures and outputsa 1 x 2 vector. If this rounds to [1,0] I have taken this as to predict an egg, [0,1] to not predict an egg, however it might be interesting 
to consider using the non-rounded values as some measure of probabilityof whether the image is an egg or not. I have also included in the dropbox the program myNeuralNetworkFunctionCoder5.m whichis meant to work  better with the Matlab code converter. 

testingneuralnetwork.m 

This runs cropandanalyse on an image set and outputs as a table. 

Results 


This neural network has 20 nodes and was trained on 55% of the set. On the whole set it got results of 84.08% for correctly determining the number of eggs and 90.05% for deciding eggs or not. With a sensitivity of 82.69% and a specificity of 97.94%. Results should only improve with more images but due to the method of cropping out objects it will generally always miss eggs attached to the black 
lineboundaries. 
For the 25 images it required 4112597 floatingpoint operations (about 40 times more than the previous method). 


Figure 2: Confusion Matrix for the method “Neural Network” 

Training a new network 


For thisyou could use the script processandcropimagesinimageset.m and the functions cropimages.m and segmentimages1mm.m. Firstyou load the folder that contains the images and then have a choice of what percentage you use for training and testing (note thatyou will get this option again in the neural network pattern finder so you could just set imgSet=Set). 

The next section then uses the cropimages.m function to crop the segmented objects out of the image and save them to a file. The file path needs changing in the function cropimages.m. You then manually need to split the images in this folder into ’eggs’ and ’other stuff’. A new image set is then created from these images. 

A visual bag of features is created from these sets and all the images are encoded as a histogram of features. Should the neural networkbe sucessful and you want to save the functionyou also need to save the variable "bag”. 

You can now run the neural network pattern recognition app. You want to take your independent variables as eggsData and dependent as eggsType and you may need to select the option to switch rows and columns in order that they match up. 


Rotate, Scale and Find Circles 


This methodis not the most accurate or the least complex but I am quite fond of it. It uses a circular Hough transform to find circles in a rotated and rescaled binary edge image. Such a circle would correspond to an ellipse with the same ratio of major to minor axis as the eggs we are looking for. 

Basic Method 


The main function does all the work for this method and then there is an optional extra program to run on multiple images and output as a table. 

scaleRotateFindCriclesOld.m 

The program input is an image path 

1. Read image and resize 
2. Grayscalebytaking the third element in the YCbCr image space 
3.Adjust contrast and set all very dark areas to a middling intensity before adjusting again 
4. Gaussian filter with standard deviation5. Use a Sobel edge detector to produce a binary edge image 
5. Remove excess noise by getting rid of some of the smallest connected components 
6. Remove the vertical lines using a Hough transform to find them and then draw black lines over the top 
7.For each 10 degrees between 0 and 170 inclusive: 
(a) Rotate the image by this degree and rescale vertically 
(b) Use the function imfindcircles to look for circles 
(c) Check that the mean and minimum intensity of an area around the middle of the circle is in a sensible 
range and put a tighter condition on the radius 
(d) Check to see that the egg hasn’t been found before 
(e) Adjust total number of eggs accordingly 
8. The program outputs the total number of eggs in an image 

MultipleImagesRotateFindCirclesOld.m 

Runs scaleRotateFindCriclesOld.m on an image set and ouputs results as a table 

Results 


The algorithm correctly predicts the number of eggs in an image 67.16% of the time and if the image contains eggs or not 77.61% of the time. It has a sensitivity of 71.15% and specificity of 83.67%.

For the 35 images, it took 43804 floating point operations, about 4 times as many as the segment and analyse method. 


 
Rotate, Scale and Find Circles with Total Variation


This method is almost identical to before and the main function is the same -minus the suffix ’Old’. It can be run on multiple images by removing the suffix old in the relevant line of the multiple images script. 

Instead of a standard Gaussian filter it uses Total Variation (Code retrieved from: G. Gilboa, “A Total Variation Spectral Framework for Scale andTexture Analysis”, SIAM Journal on Imaging Sciences,Vol. 7, No. 4, pp. 1937–1961, 2014. )to prepare the image before using the edge detector. This means that the end of the egg are more likely to be captured clearly, helping them to be identified. It produces better results with 77.61% with the right number of eggs and 81.09% with correct eggs/not. This is mainly by improvements in sensitivity, specificity again at 83.67% but sensitivity at 77.88%, more eggs have been detected which is the outcome we expected. 

However, this comes at a high computational cost and in fact I haven’t managed to run the program to count the floating point operations, it is taking so long. 




