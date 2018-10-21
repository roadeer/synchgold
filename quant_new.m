
clear all;
clc;
data_quote_minute= csvread('xbtusd.csv',1,0);
len = length(data_quote_minute);
tmp = data_quote_minute(len-200000:len-190000,1:7)
data_size=size(tmp);
data_vol=tmp(:,7);
%threshold = quantile(data_vol,0.9);
threshold = max(data_vol)/3;
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
vpin_abs = abs(vpin_signed);
vpin_info=movavg(vpin_signed.*candle_data(:,6),50,50,1);
vpin_vol = movavg(candle_data(:,6),50,50,1);
vpin = vpin_info./vpin_vol;
vpin_cdf=cdfvpin(movavg(vpin_abs.*candle_data(:,6),50,50,1)./vpin_vol);
%plot(abs(vpin_signed))
shortma = movavg(candle_data(:,2),5,5,0);
longma = movavg(candle_data(:,2),50,50,0);
position = 0;
gain_seq_neg = [];
for i =50:length(shortma)
    if(((longma(i-1)>shortma(i-1) & longma(i-2)<=shortma(i-2)) || vpin_cdf(i-1)>0.95)  & position == -1)
        position = 0;
        price_buy = candle_data(i,2);
        direction = 1;
        gain = price_sell-price_buy;
        gain_seq_neg=[gain_seq_neg gain];
    end
    if(longma(i-1)<shortma(i-1) & longma(i-2)>=shortma(i-2) & position == 0 & vpin_cdf(i-1)<0.7 & vpin_cdf(i-1)>0.2)
        position = -1;
        price_sell = candle_data(i,2);
        direction = 0;
%         gain = price_buy-price_sell;
%         gain_seq=[gain_seq gain];
    end
end
gain_seq_posi = [];
for i =50:length(shortma)
    if(longma(i-1)>shortma(i-1) & longma(i-2)<=shortma(i-2)  & position == 0 & vpin_cdf(i-1)<0.7& vpin_cdf(i-1)>0.2)
        position = 0;
        price_buy = candle_data(i,2);
        direction = 1;

    end
    if(((longma(i-1)<shortma(i-1) & longma(i-2)>=shortma(i-2)) || vpin_cdf(i-1)>0.95) & position == 1)
        position = 1;
        price_sell = candle_data(i,2);
        direction = 0;
        gain = price_sell-price_buy;
        gain_seq_posi=[gain_seq_posi gain];
%         gain = price_buy-price_sell;
%         gain_seq=[gain_seq gain];
    end
end
gain_vec = [gain_seq_neg gain_seq_posi];
gain_add = zeros(1,length(gain_vec));
for i = 2:length(gain_vec)
    gain_add(i) = gain_add(i-1)+gain_vec(i);
end
plot(gain_add)
        
subplot(3,1,1)
candle(candle_data(:,2),candle_data(:,3),candle_data(:,4),candle_data(:,5))
grid on
subplot(3,1,2)
plot(vpin)
value = data_moderate(:,1);
name = data_moderate(:,2);
set(gca, 'XTickLabel', name); 
grid on
subplot(3,1,3)
plot( cdfvpin(vpin))
grid on
% pause
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
