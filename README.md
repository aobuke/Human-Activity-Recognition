# Human-Activity-Recognition
Start Code of Human Activity Recognition by Sensor on Smartphone

Requirements: accelerometer, gyroscope

the code is very easy to transform to C language since only array is used instead of complex data structures.

Experiment design notes:
1. Use a camera to record the subject's activity
    or one time period for one specific activity
2. device: smartphone, wrist band.
    attach the smartphone to a specific part of the body
3. an android app to record the sensor.
    e.g. Advanced Sensor Recorder, Sensor Record or https://github.com/kprikshit/android-sensor-data-recorder
    


Sensor data is one kind of time series data. For a typical procedure of sensor data classification, we need:
1. prepare a labeled dataset: labeled by file/ by video camera/ by each point
2. segmentation
3. fearure extraction
4. classification and test

Another approach based on deep learning like LSTM is point-wise and could give each point a label.

We record the data by each file, which means each file is one activity.

First, read data

second, data cleaning & preprocessing
The window size and overlap is set to 250 and 50 respectively.

![Alt text](har.png)

expand dimension:
in this step we have some predefined dimensions, but you could add more dimensions as you like, e.g. some specific shape
  
third, segmentation

fourth, feature extraction

five, classification and test


References:

Buke, Ao, et al. "**Healthcare algorithms by wearable inertial sensors: a survey.**" China Communications 12.4 (2015): 1-12.

Ao, Buke, et al. "**Context Impacts in Accelerometer-Based Walk Detection and Step Counting.**" Sensors 18.11 (2018): 3604.
