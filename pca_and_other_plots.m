clc
clear
close all

data=load('sample_data.txt');
categories={'Na','Mg','Si','K','Ca','Al','Mn','Cu','Rb','Sr','Mo','Sb','Ba','U','Be','B','Zn','Pb','Li'};

set(figure,'Units','normalized','Position',[0,0,1,1]);
corrmatrix = corrcoef(data);
corrmatrix = flipud(corrmatrix);
imagesc(corrmatrix),colormap(parula);
atick=1:1:length(categories);
title('Correlation Matrix');
axis square, colorbar  hold
set(gca,'XTick',atick);
set(gca,'YTick',atick);
set(gca,'XTickLabel',categories,'YTickLabel',flipud(categories))

set(figure,'Units','normalized','Position',[0,0,1,1]);
imagesc(corrmatrix);colormap(parula);
caxis([-1,1])

%for creating a custom colormap to group all correlations above and below a
%threshold to be of a single color
map=colormap;
map(1:6, :) = repmat([0 0 0], 6, 1);
map(end-5:end, :) = repmat([1 1 1], 6, 1);

colormap(map)
atick=1:1:length(categories);
title('Grouped Correlation matrix');
axis square,  colorbar  hold
set(gca,'XTick',atick);
set(gca,'YTick',atick);
set(gca,'XTickLabel',categories,'YTickLabel',flipud(categories))

figure()
boxplot(data,'orientation','horizontal','labels',categories);
title('Boxplot for all elements and nutrients');
xlabel('Concentration in µg/L');

w=1./var(data);
[wcoeff,score,latent,tsquared,explained]=pca(data,'VariableWeights',w);

figure()
pareto(explained)
xlabel('Principal Component');
ylabel('Variance Explained (%)');
title('Data for all elements and nutrients');
coefforth=inv(diag(std(data)))*wcoeff;
clear coefforth
coefforth = diag(sqrt(w))*wcoeff;
cscores = zscore(data)*coefforth;
[st2,index] = sort(tsquared,'descend'); % sort in descending order


figure()
biplot(coefforth(:,1:2),'scores',score(:,1:2),'varlabels',categories);
title('All PC (rep. as points) and score (rep. as vectors) distribution');

figure()
biplot(coefforth(:,1:3),'scores',score(:,1:3),'varlabels',categories);
title('All PC (rep. as points) and score (rep. as vectors) distribution');

LargeDataSet=load('sample_data.txt');
LargeDataSet=LargeDataSet';
labels ={'Na','Mg','Si','K','Ca','Al','Mn','Cu','Rb','Sr','Mo','Sb','Ba','U','Be','B','Zn','Pb','Li'};
tree = linkage(LargeDataSet,'average'); 
figure();

% dendrogram(tree,'ColorThreshold','default');
[H,~,~]=dendrogram(tree);
grid on; grid minor;
% ylim([1 10000]);
hAxis = get(H(1),'parent');
perm = str2num(get(hAxis,'XtickLabel'));
set(hAxis,'XTickLabel',labels(perm));
set(gca,'yscale','log');
