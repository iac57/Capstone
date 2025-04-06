load ir_to_pos_data.mat

pos = data(:,1);
count = data(:,2);

% d1 = 19.90; % mm, distance from bottom of pedistal mount to top of pedistal mount
% d2 = 9.41; % mm, distance from top of pedistal mount to top of ball
% d3 = d1+d2; % mm, distance from bottom of pedistal mount on pink platform to top of ball
% d4 = 81.95; % mm, distance from bottom of pink platform to bottom of magnet
% d5 = 37.67; % mm, distance from bottom of pink platform to bottom of pedistal mount
% 
% d = d4 - d5 - d3

% can also use the fact that at the highest measurement, the ball was
% touching the magnet

in2mm = 25.4;
d_ball_at_magnet = pos(end)*in2mm;
pos = d_ball_at_magnet - pos*in2mm;

count = flipud(count);
pos   = flipud(pos);

figure, scatter(count, pos)
xlabel('ADC Count'), ylabel('Position (mm)')
title('Raw IR Data')

%%% Create lookup table

% Round ADC counts to integer
% rounded_counts = round(count);

% Create map of unique ADC values to positions (averaging duplicates)
unique_counts = unique(rounded_counts);
avg_pos = zeros(size(unique_counts));

for i = 1:length(unique_counts)
    idx = (rounded_counts == unique_counts(i));
    avg_pos(i) = mean(pos(idx));
end

% Define full range of desired ADC counts (e.g., min to max from your data)
lookup_counts = min(unique_counts):max(unique_counts);

% Interpolate using available average positions
interp_pos = interp1(unique_counts, avg_pos, lookup_counts, 'linear');

% add extraneus cases
len1 = length(0:lookup_counts(1));
len2 = length(lookup_counts(end):1023);

lookup_counts = [0:lookup_counts(1) lookup_counts(2:end-1) lookup_counts(end):1023];
interp_pos = [interp_pos(1)*ones(1,len1 - 1) interp_pos interp_pos(end)*ones(1,len2 - 1)];

% Optionally, visualize
figure;
plot(lookup_counts, interp_pos, 'b-')
xlabel('ADC Count'), ylabel('Interpolated Position (mm)')
title('Interpolated ADC-to-Position Lookup Table')
grid on
hold on, scatter(count, pos)

% Save lookup table
lookup_table = [lookup_counts' interp_pos'];
save('adc_to_position_lookup.mat', 'lookup_table');
writematrix(lookup_table, 'adc_to_position_lookup.csv');

