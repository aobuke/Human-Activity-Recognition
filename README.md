# Human-Activity-Recognition
Start Code of Human Activity Recognition by Sensor on Smartphone

Requirements: accelerometer, matlab, android, basic ML like how to call lib

## Introduction
Human activity recognition uses sensors on smartphone to estimate user's activities such as walking and running. Deep learning techniques like LSTM have been introduced and good performances are achieved. However, the computational cost of deep learning and the complexity of deployment limit the application of the method. Moreover, if you want explanable algorithms then the traditional machine learning techniques are more applicable.

Sensor data is one kind of time series data, for accelerometer, x-axis is time and y-axis is 'g' in Figure 0. 

![Alt ssstext](figure0.PNG?raw=true "place an example of 3-dim accelerometer here")

frame(:,:,1) = buffer(data(:,1),winSize,winOverlap,'nodelay')';

## Data pre-processing

The accelerometer data is stored in files by CSV format. For example,

  acc_2020.02.02.txt:
  
                                    x       y       z
                                    76    -1053    -7
                                    76    -1056    -9
                                    76    -1063    -4
                                    ...
                                   
Read all the data files into a variable DATA (size:timelength X 3) in Matlab.

By window=250 and overlap=100, the DATA is then segmented into frames in Figure 1.

  ![Alt ssstext](figure1.PNG?raw=true "place an example of 3-dim accelerometer here")

Figure 1(a) is the transform of single transformation, Figure 1 (b) is the situation of three dimensions. Hence, we have transformed Nx3 array into windowLength X windowCount X 3 array.

Besides the dimensions of the raw 3d data, we could also expand the dimensions like: 
magnitude: x2+y2+z2, enhance invariant of rotation   
angle X-Y,  
angle X-Z,  
etc.  


![Alt ssstext](har.PNG?raw=true "Titlssssssse")

Finally, we got an array of FRAME:  windowCount X windowLength X 8, which means FRAME(i,:,j) (windowLength x 1) is the data of i-th frame of j-th dimension.

## Feature extraction

The feature is extracted based on each frame (windowLength x 1), so for each DIMENSION we extract features from the FRAME and get a FEATURE with size of windowCount x 18 x 8.

| index | feature  | index | feature    | index | feature       | index | feature |
|-------|----------|-------|------------|-------|---------------|-------|---------|
| 1     | mean     | 8     | peak_pos   | 15    | f1_3/f4_16    | 22    | f4      |
| 2     | var      | 9     | f1         | 16    | sum(spec)     | 23    | f5      |
| 3     | max      | 10    | f2_3       | 17    | H(spectrum)   | 24    | f6      |
| 4     | min      | 11    | f4_5       | 18    | mean-crossing | 25    | f7      |
| 5     | skewness | 12    | f6_16      | 19    | f1            | 26    | f8      |
| 6     | kurtosis | 13    | f1/f2_3    | 20    | f2            | 27    | f9      |
| 7     | energy   | 14    | f4_5/f6_16 | 21    | f3            | 28    | f10     |

Table 1

Table 1 contains the statistical features, spectral features, and some heuristic features. For your implementation, you should adjust the frequency bins by your own sampling rate. 

FeatureDataset(:, 1, dim) = mean(frame(:,:,dim), 2);

In order to put the feature data into classifiers, we need adjust the FEATURE more. The FEATURE windowCount x 18 x 8 is rearranged into 2 dimensional array windowCount x 144. We also want the correlation coefficients between different dimensions included:

correlation pairs of 1 and 2, 1 and 3, 1 and 4, 2 and 3, 2 and 4, 3 and 4. Then the correlation features is padded to feature dataset.

Hence we have builded the full feature dataset with size of windowCount x featureNum;

## Optional data cleaning
1. for a real dataset, the classes might be severely inbalanced, so another downsampling of a class is added.
2. Remove NaN values in the feature data.

## classification
1. cross validation
2. normalized
3. select a classfier and training
4. test classifier
5. error analysis of results (confusion matrix, recall, precision, etc.), find problems, fix and improve performance.

In the report, a simple decision tree is employed and you could view the structure by view().

## Furthermore

Key variables is 3xN, windowCount X windowLength x 8, windowCount x 18 x 8 and windowCount x featureNum; 

the code is very easy to transform to C language since only array is used instead of complex data structures.

TL;DR: how to run this script:
1. prepare data
2. run
3. check


Experiment design notes:
1. Use a camera to record the subject's activity
    or one time period for one specific activity
2. device: smartphone, wrist band.
    attach the smartphone to a specific part of the body
3. an android app to record the sensor.
    e.g. Advanced Sensor Recorder, Sensor Record or https://github.com/kprikshit/android-sensor-data-recorder
    



A typical way of sensor data classification:

1. data pre-processing (clearning + segmentation)
2. fearure extraction
3. classification and test


For each data file there has only one label (activity), and we set the window size to 250 and overlap to 50.

First, read data

Second, data pre-processing (clearning + dimention expand + segmentation)

you could just plot every file and remove some data that is recorded in bad circumstance.
The 3d accelerometer is stored in a 3*N matrix. For each one column we segment the data and obtain a matrix, e.g. N = 1500 and then size(Matrix) is window size * 6 as shown in the Figure XXX.
For 3d acceleromter, we segment each axis and obtain three matrix in Figure XXX.





third, segementation and expand dimension:
in this step we have some predefined dimensions, but you could add more dimensions as you like, e.g. some specific shape
 

fourth, feature extraction

five, classification and test

Look into wrong classified labels

in order to add fearures, one could expand a dimension and craft any features like if has a peak, if has some specific shape

References:

Buke, Ao, et al. "**Healthcare algorithms by wearable inertial sensors: a survey.**" China Communications 12.4 (2015): 1-12.

Ao, Buke, et al. "**Context Impacts in Accelerometer-Based Walk Detection and Step Counting.**" Sensors 18.11 (2018): 3604.
