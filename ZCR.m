function y = ZCR(x, thr)
% zero-crossing rate
    y = sum(abs(diff(x>thr)))/length(x);
end