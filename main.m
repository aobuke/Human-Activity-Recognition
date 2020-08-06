% created by aobuke 2016/01
% read data to activity recognition
%
frameSize = 250;
frameOverlap = 50;
dimNum = 8;

frames = [];
labels = [];
keySet =        {'driving','brushing','cycling', 'bathing', 'commuting','walking','standing','running', 'sitting', 'sleeping'};
% valueSet = int32([1      2     3       4     5          6        7      8       9       10]);
% mapObj = containers.Map(keySet,valueSet);

for iLabel = 1:10
    folderName = keySet{iLabel}
    fileList = dir(folderName);
    fileList = struct2cell(fileList(3:end));
    fileList = fileList(1,:)'; %get the final file list
    
    rawData = [];
    frame = []; % frameNum * winSize * axis.
    
    for i = 1:length(fileList)
        fileName = fileList{i}
        if (~strcmp(fileName(1:3),'acc'))
            continue;
        end
        fid = fopen(strcat(folderName,'/',fileList{i}));
        c = textscan(fid, '%s %s %s');
        fclose(fid);
        
        x = cellfun(@str2num, c{1}(5:end));
        y = cellfun(@str2num, c{2}(5:end));
        z = cellfun(@str2num, c{3}(5:end));
        data = [x,y,z];
 
        rawData = [rawData; data];
        
    end
    
    frame(:,:,1) = buffer(rawData(:,1),frameSize,frameOverlap,'nodelay')';
    frame(:,:,2) = buffer(rawData(:,2),frameSize,frameOverlap,'nodelay')';
    frame(:,:,3) = buffer(rawData(:,3),frameSize,frameOverlap,'nodelay')';
    frame(end,:,:) = []; % remove zero-padding data
    
    frameNum = size(frame,1);
    label = iLabel*ones(frameNum,1);
    frames = cat(1, frames, frame);
    labels = cat(1, labels, label);

end
%save('frames.mat','frames');
%save('labels.mat','labels');
frameData= frames/1000; 
%% feature extraction
if 1
frameNum = size(frameData,1);
frameLen = size(frameData,2);

% featureData = frameNum * featureNum * dimension


mag = sqrt(frameData(:,:,1).^2 + frameData(:,:,2).^2 + frameData(:,:,3).^2);
frameData(:,:,4) = mag;
frameData(:,:,5) = acos(frameData(:,:,3)./mag); % x,y -> mag is not make sense
frameData(:,:,6) = atan(frameData(:,:,1)./sqrt(frameData(:,:,2).^2 + frameData(:,:,3).^2));
frameData(:,:,7) = atan(frameData(:,:,2)./sqrt(frameData(:,:,1).^2 + frameData(:,:,3).^2));
frameData(:,:,8) = atan(sqrt(frameData(:,:,1).^2 + frameData(:,:,2).^2)./frameData(:,:,3));


featureData = zeros(frameNum, 18, dimNum);
for dim = 1:dimNum
    featureData(:, 1, dim) = mean(frameData(:,:,dim), 2);
    featureData(:, 2, dim) = var(frameData(:,:,dim), [], 2);
    featureData(:, 3, dim) = max(frameData(:,:,dim), [], 2);
    featureData(:, 4, dim) = min(frameData(:,:,dim), [], 2);
    featureData(:, 5, dim) = skewness(frameData(:,:,dim), [], 2);
    featureData(:, 6, dim) = kurtosis(frameData(:,:,dim), [], 2);
    featureData(:, 7, dim) =  sum(frameData(:,:,dim).^2, 2)/frameLen;
    
    temp = frameData(:,:,dim);
    spec = abs(fft(temp,[],2));
    spec = spec(:,2:end); % remove the 0Hz coef
    [~, featureData(:,8, dim)] = max(spec, [], 2); % peak position of fft
    % Frequency features depends on Fs
    f0_1 = sum(spec(:,1:9), 2); % (0,1] Hz
    f1_3 = sum(spec(:,10:25), 2); % (1,3] Hz
    f3_5 = sum(spec(:,26:41), 2); % (3,5] Hz
    f5_16 = sum(spec(:,42:129), 2); % (5,16] Hz
    featureData(:, 9, dim) = f0_1;
    featureData(:, 10, dim) = f1_3;
    featureData(:, 11, dim) = f3_5;
    featureData(:, 12, dim) = f5_16;
    featureData(:, 13, dim) = f0_1./f1_3;
    featureData(:, 14, dim) = f3_5./f5_16;
    featureData(:, 15, dim) = (f0_1 + f1_3)./(f3_5 + f5_16);
    
    featureData(:, 16, dim) = sum(spec, 2);
    temp = spec .* log2(spec); % frequency entropy
    featureData(:, 17, dim) = log2(frameLen) - sum(temp, 2)/frameLen; % frequency entropy
    for i = 1:frameNum
        featureData(i,18, dim) = ZCR(frameData(i,:,dim), mean(frameData(i,:,dim))); % mean-crossing rate
    end
%     spec2 = abs(fft(temp(:,1:10:end)));
%     featureData(:,19:28,dim) = spec2(:,1:10);
end

temp = [];
for dim=1:dimNum
    temp = [temp featureData(:,:,dim)];
end
featureData = temp;

%correlation
temp = [];
for i = 1:frameNum
    temp(i,1) = max(abs(xcorr(frameData(i,:,1), frameData(i,:,2))));
    temp(i,2) = max(abs(xcorr(frameData(i,:,1), frameData(i,:,3))));
    temp(i,3) = max(abs(xcorr(frameData(i,:,1), frameData(i,:,4))));
    temp(i,4) = max(abs(xcorr(frameData(i,:,2), frameData(i,:,3))));
    temp(i,5) = max(abs(xcorr(frameData(i,:,2), frameData(i,:,4))));
    temp(i,6) = max(abs(xcorr(frameData(i,:,3), frameData(i,:,4))));
end

featureData = [featureData temp];

end

% Reducing class 8 
if 0
idx = find(labels==8);
[rIdx,~] = datasample(idx,70000,'Replace',false);
featureData(rIdx,:) = [];
labels(rIdx) = [];
end

%  remove nan
if 1
    [a,b] = find(isnan(featureData) == 1);
    featureData(a, :) = [];
    labels(a, :) = [];
end
save('featureData.mat','featureData');
% cross validation partition
CVO = cvpartition(labels,'k',10);
i = 1;
trIdx = CVO.training(i);
teIdx = CVO.test(i);

TrainingFeatureSet = featureData(trIdx,:);
TrainingFeatureLabel = labels(trIdx);
TestingFeatureSet = featureData(teIdx,:);
TestingFeatureLabel = labels(teIdx);

% normalize
[TrainingFeatureSet, mu, sigma] = zscore(TrainingFeatureSet); %每行一个样本
TestingFeatureSet = normalize(TestingFeatureSet, mu, sigma);

% training 
tc = fitctree(TrainingFeatureSet,TrainingFeatureLabel, 'MaxNumSplits',30);
y_hat = predict(tc, TestingFeatureSet);
cm = confusionmat(TestingFeatureLabel,y_hat); % confusion matrix
diag(cm)
sum(ans)/length(TestingFeatureLabel) % accuracy
view(tc, 'mode','graph');


return;
%%
[128 29 8 99 175 197 85 156 70 16 1 57 45 32 180] % important features
FeatureDataset2 = featureData(:,[128 29 8 99 175 197 85 156 70 16 1 57 45 32 180]);


iframe = frame;
% remove high freqency of angular dimension
reservedBins = 20;
lpfStart = 2+reservedBins;
lpfEnd = frameLen - reservedBins;
for dim = 1:3
    temp = fft(frame(:,:,dim),[],2);
    temp(:,lpfStart:lpfEnd) = 0;
    frame(:,:,dim) = real(ifft(temp,[],2));
end

