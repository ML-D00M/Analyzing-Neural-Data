dataset = 'C:\Users\User\Downloads\sampleEEGdata.mat';  % path to the data
load(dataset)                                       % load the data

time = EEG.times;                                  
chans = {EEG.chanlocs.labels}; 
Nel = length(chans); 

%% Compute the ERP at each of the Nel electrodes. 
%% Select five time points at which to show topographical plots
%% (e.g., 0 to 400 ms in 100-ms steps). In one figure, make a series of
%% topographical plots at these time points. To increase 
%% the signal-to-noise ratio, make each plot show the average of activity 
%% from 20 ms before until 20 ms after each time point. For example,
%% the topographical plot from 200 ms should show average activity 
%% from 180 ms until 220 ms. Indicate the center time point 
%% in a title on each subplot.

time_windows = [0 100 200 300 400];               % select time windows
start_times = time_windows - 20; 
end_times = time_windows + 20; 

start_index = zeros([1, length(time_windows)]);    % allocate the memory
end_index = zeros([1, length(time_windows)]); 

% find the closest time index in EEG recording
for eeg_time_index = 1:length(time_windows)
    [~, start_index(eeg_time_index)] = min(abs(time -... 
        start_times(eeg_time_index)));                     
    [~, end_index(eeg_time_index)] = min(abs(time -...
        end_times(eeg_time_index))); 
end 
 
% Compute ERP: taking the mean across all trials
erp_data = mean(EEG.data, 3); 

% Compute data for ERP time indices
erp_time_index = zeros([Nel, length(time_windows)]);
for eeg_time_index = 1:length(time_windows)
    erp_time_index(:, eeg_time_index) = mean(erp_data(:,...
        [start_index(eeg_time_index):end_index(eeg_time_index)]), 2); 
end 

% Plot 
figure
for eeg_time_index = 1:length(time_windows)
subplot(3, 2, eeg_time_index)
topoplot(erp_time_index(:,eeg_time_index), EEG.chanlocs); 
title([ num2str(time_windows(eeg_time_index)), ' ms'])
end 

%% Loop through each electrode and find the peak time of the ERP 
%% between 100 and 400 ms. Store these Nel peak times in a separate variable.
%% Eliminate duplicates and then make topographical plot of peak times 
%% (a subplot for each latency in temporal order ). Include a color
%% bar in the figure and make sure to show times in milliseconds from time 0.
%% What areas of the scalp show the earliest and the latest 
%% peak responses to the stimulus within this window?

% Select relevant time roi
[~, roi(1)] = min(abs(time - 100)); 
[~, roi(2)] = min(abs(time - 400)); 
erp_roi = erp_data(:, roi(1):roi(2)); 
t_roi = time(roi(1):roi(2)); 

% Find index with max values
max_time_ind = zeros([1, Nel]);
for el_n = 1:Nel
    [~, max_time_ind(el_n)] = max(erp_roi(el_n, :)); 
end 

% Select unique and sort 
max_time_ind = unique(max_time_ind); 

% Plot max values 
figure
for eeg_time_index = 1:length(max_time_ind)
subplot(4, 4, eeg_time_index)
topoplot(erp_roi(:, max_time_ind(eeg_time_index)), EEG.chanlocs); 
title([num2str(round(t_roi(max_time_ind(eeg_time_index)))), ' ms'])
colorbar;
end 

% The first peak responses are shown in higher visual areas in occipital
% lobe
% The last peak responses are in two areas — one in occipital and one in
% temporal lobe

%% Create two kernels for convolution: one that looks like an inverted U 
%% (min at the edges, max in the center) and one that looks like 
%% a decay function. The kernels must be 20 samples long. There is no need 
%% to be too sophisticated in generating, for example, a Gaussian and 
%% an exponential; numerical approximations are fine.

x = linspace(0,8,20); 
gaus_k = gaussmf(x,[1 3]);                  % gaussian kernel
exp_f = exp(-x);                            % exponent kernel

%% Convolve these two kernels with 50 time points of EEG data 
%% from one electrode. Make a plot showing the kernels, the EEG data, and 
%% the result of the convolution between the data and each kernel. 
%% Use time-domain convolution as explained in this chapter and 
%% as illustrated in the online Matlab code. Based on visual inspection, 
%% what is the effect of convolving the EEG data with these two kernels?

channel_num = find(strcmp(chans, 'FCz'));   % find relevant channel

convolved_erp = erp_data(channel_num,...          % select time around 200
    start_index(3):start_index(3)+49); 

Gaus_conv = conv(convolved_erp, gaus_k, 'same');   % convolve with gaussian kernel
Exp_conv = conv(convolved_erp, exp_f, 'same');     % convolve with exponent kernel

% Plot
figure; 
subplot(3,2,1); plot(convolved_erp); 
title('Original ERP')
subplot(3,2,2); plot(convolved_erp); 
title('Original ERP')
subplot(3,2,3); plot(gaus_k);
title('Gaussian')
subplot(3,2,5); plot(exp_f); 
title('Exponent')
subplot(3,2,4); plot(convgaus); 
title('Convolution with Gaussian')
subplot(3,2,6); plot(convexp);
title('Convolution with exponent')