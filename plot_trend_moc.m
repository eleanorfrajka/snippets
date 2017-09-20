% Load your MOC time series here.  This should be in units of Sverdrups, on a monthly timescale (bin averaged 
% per month, with the time step as the 15th of each month).
% Time should be in Matlab time, i.e. January 1 2004 is 731947 as given by datenum(2004,1,1).
moctimeseries = moc26.moc(:);
moctimevector = moc26.time(:);

% Create a time vector in years, for getting the coefficients out of regress in units of Sv/year and Sv.
time_in_years_since_2004 = (moctimevector-datenum(2004,1,1))/365.25;

% Plot the time series
figure(10);clf
plot(moctimevector,moctimeseries,'r','linewidth',2)
hold on

% Calculate a linear regression
itime = find(moctimevector>=datenum(2004,1,1)&moctimevector<=datenum(2015,3,31));
Y = moctimeseries(itime);
X = [time_in_years_since_2004(itime) ones(size(itime))];
[B,Bint] = regress(Y,X);
plot(moctimevector(itime),B(1)*time_in_years_since_2004(itime)+B(2),'k--','linewidth',2)
Bslope = round(100*B(1))/100;
Bintercept = round(100*B(2))/100;
% Add the equation
textstr={['y = ',num2str(Bslope),' t + ',num2str(Bintercept)],...
    ['over the period ',datestr(moctimevector(itime(1)),'mmmyyyy'),' to ',datestr(moctimevector(itime(end)),'mmmyyyy')],...
    ['where t is time in years since 1 Jan 2014']};
text(datenum(2010,3,1),27,textstr,'fontsize',12)

% Set the figure sizes
grid on
set(gca,'ylim',[10 20])
set(gca,'ylim',[5 30])
xlim=[datenum(2004,4,1) datenum(2015,10,31)];
set(gca,'xlim',xlim)
set(gca,'xtick',[datenum(2004:2015,1,1)])
datetick('x','keeplimits','keepticks')
set(gca,'tickdir','out')
box off

% Set figure dimensions
width=8; height=4;
set(gcf,'units','inches');
set(gcf,'PaperSize',[width height]);
mypos=get(gcf,'position');
set(gcf,'position',[mypos(1) mypos(2) width height]);

% Annotations
title('MOC strength from RAPID 26N (monthly bin-averaged)')
ylabel('MOC strength [Sv]')

% Export the figure
set(gcf,'paperpositionmode','auto')
print('-dpng',['MOC_plot.png'])
