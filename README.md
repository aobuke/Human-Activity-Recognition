# Human-Activity-Recognition
Start Code of Human Activity Recognition by Sensor on Smartphone

Requirements: accelerometer, matlab, android

## Introduction
Human activity recognition uses sensors on smartphone to estimate user's activities such as walking and running. Deep learning techniques like LSTM have been introduced and good performances are achieved. However, the computational cost of deep learning and the complexity of deployment limit the application of the method. Moreover, if you want explanable algorithms then the traditional machine learning techniques are more applicable.

Sensor data is one kind of time series data, for accelerometer, x-axis is time and y-axis is 'g'. 

![Alt ssstext](figure1.PNG?raw=true "place an example of 3-dim accelerometer here")

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



![Alt ssstext](har.PNG?raw=true "Titlssssssse")

third, segementation and expand dimension:
in this step we have some predefined dimensions, but you could add more dimensions as you like, e.g. some specific shape
 

fourth, feature extraction

five, classification and test

Look into wrong classified labels


References:

Buke, Ao, et al. "**Healthcare algorithms by wearable inertial sensors: a survey.**" China Communications 12.4 (2015): 1-12.

Ao, Buke, et al. "**Context Impacts in Accelerometer-Based Walk Detection and Step Counting.**" Sensors 18.11 (2018): 3604.
