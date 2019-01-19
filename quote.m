
clear all;
clc;
data_quote_minute= csvread('aumin9999m.csv',1,0);
% data_quote_minute= csvread('xbtusd.csv',1,0);
% data_quote_minute= csvread('au9999withhour.csv',1,0);
data_csv = [];
data_all = [];
data_vol=data_quote_minute(:,7);

tmp = data_quote_minute(:,1:7);
%tmp = data_quote_minute;
data_size=size(tmp);

%threshold = quantile(data_vol,0.9);
threshold = max(data_vol)/4;
data_moderate=average_vol(tmp,threshold);
candle_data = data_moderate(:,2:7);
time_slice=candle_data(:,1);
data_moderate2=[];
data_vec = zeros(1,7);
slice = 1;
diff = candle_data(:,5)-candle_data(:,2);
nmean = 0;
nsigma2 = var(diff);

VB = diff/sqrt(nsigma2);
vpin_signed = 2*qfunc(VB)-1;
vpin_info=movavg(abs(vpin_signed).*candle_data(:,6),50,50,1);
vpin_vol = movavg(candle_data(:,6),50,50,1);
vpin = vpin_info./vpin_vol;
cdfpin = cdfvpin(vpin);
%plot(abs(vpin_signed))
data_csv=[data_moderate vpin cdfpin diff];
data_all = [data_all ; data_csv(11:end,:)];
subplot(3,1,1)
candle(candle_data(:,2),candle_data(:,3),candle_data(:,4),candle_data(:,5))
grid on
subplot(3,1,2)
plot(vpin)
value = data_moderate(:,1);
name = data_moderate(:,2);
%set(gca, 'XTickLabel', name); 
grid on
subplot(3,1,3)
plot( cdfpin)
grid on
% data_quote_minute= csvread('C_of_lbma_datatd.csv',1,0);
% tmp = data_quote_minute(20000:25000,1:7)
% data_size=size(tmp);
% data_vol=tmp(:,7);
% %threshold = quantile(data_vol,0.9);
% threshold = max(data_vol)/6;
% data_moderate=average_vol(tmp,threshold);
% candle_data = data_moderate(:,2:7);
% time_slice=candle_data(:,1);
% data_moderate2=[];
% data_vec = zeros(1,7);
% slice = 1;
% diff = candle_data(:,5)-candle_data(:,2);
% nmean = 0;
% nsigma2 = var(diff);
% 
% VB = diff/sqrt(nsigma2);
% vpin_signed = 2*qfunc(VB)-1;
% %vpin=movavg(abs(vpin_signed),50,50,1);
% vpin_info=movavg(vpin_signed.*candle_data(:,6),50,50,1);
% vpin_vol = movavg(candle_data(:,6),50,50,1);
% vpin = -1*vpin_info./vpin_vol;
% %plot(abs(vpin_signed))
% 
% subplot(3,1,1)
% candle(candle_data(:,2),candle_data(:,3),candle_data(:,4),candle_data(:,5))
% grid on
% subplot(3,1,2)
% plot(vpin,data_moderate(:,1))
% grid on
% subplot(3,1,3)
% plot( cdfvpin(vpin),data_moderate(:,1))
% grid on
% % subplot(2,1,2)
% % 
% % bar(candle_data(:,6));
% %subplot(3,1,2)
% %plot(movavg(vpin,50,50,1))
% %subplot(3,1,3)
% %plot( cdfvpin(vpin));
% % grid on
% % subplot(2,1,2)
% % bar(candle_data2(:,6));
% % grid on
% % % set(datestr(candle_data(:,1)))
% % figure(3)
% % subplot(2,1,1)
% % plot(abs(diff));
% % subplot(2,1,2)
% % plot(abs(diff1));
