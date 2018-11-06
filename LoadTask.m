clc
clear
%% Monk
Stat = [];
StdErr = [];
Time = [];
xs = {60:30:240;50:25:250;40:20:180};
x = xs{1,:};
for i = x
    P = sprintf('LabStat-Monk-S%d', i);
    load(P);
    Stat = cat(2, Stat, LabStat(:,:,1));
    StdErr = cat(2, StdErr, LabStat(:,:,2));
    Time = cat(2, Time, LabTime(:,1));
end
Stat = Stat';
StdErr = StdErr';
Time = Time'*1000;

Stat = Stat(:,[2:6 1 9 10 12 11 13 8 7]);
StdErr = StdErr(:,[2:6 1 9 10 12 11 13 8 7]);
Time = Time(:,[2:6 1 9 10 12 11 13 8 7]);

%%
y0 = Stat(:,[1:6 13]);
y1 = Time(:,[1:6 13]);
e0 = StdErr(:,[1:6 13]);
y2 = Stat(:,[7:11 12 13]);
y3 = Time(:,[7:11 12 13]);
e2 = StdErr(:,[7:11 12 13]);
plot(x, y2);
% legend('SVM','PSVM','LSSVM','TWSVM','LS-TWSVM','\nu-TWSVM','MT-\nu-TWSVM2');
legend('MTPSVM','MTLS-SVM','MTL-aLS-SVM','DMTSVM','MCTSVM','MT-\nu-TWSVM','MT-\nu-TWSVM2');
xlabel('Task Size');
ylabel('Accuracy');
% ylabel('Running Time (ms)');

%% Landmine
Stat = [];
StdErr = [];
Time = [];
x = 3:2:11;
for i = x
    P = sprintf('LabStat-Landmine-D%d', i);
    load(P);
    Stat = cat(2, Stat, LabStat(:,:,1));
    StdErr = cat(2, StdErr, LabStat(:,:,2));
    Time = cat(2, Time, LabTime(:,1));
end
Stat = Stat';
StdErr = StdErr';
Time = Time'*1000;

%%
Stat = [];
StdErr = [];
Time = [];
x = 3:2:11;
for i = x
    P = sprintf('LabStat-Landmine-UF%d', i);
    load(P);
    Stat = cat(2, Stat, LabStat(:,:,1));
    StdErr = cat(2, StdErr, LabStat(:,:,2));
    Time = cat(2, Time, LabTime(:,1));
end
Stat = Stat';
StdErr = StdErr';
Time = Time'*1000;

%%
y0 = Stat(:,[1:6,end]);
y1 = Time(:,[1:6,end]);
y2 = Stat(:,[7:10 12 13]);
y3 = Time(:,[7:10 12 13]);
plot(x, y2);
% legend('SVM','PSVM','LSSVM','TWSVM','LS-TWSVM');
legend('MT-\nu-TWSVM','MTPSVM','MTLS-SVM','DMTSVM','MTL-aLS-SVM','MTCTSVM');
% legend('SVM','PSVM','LSSVM','TWSVM','LSTWSVM','MTPSVM','MTLSSVM','DMTSVM','MTLSTWSVM');
% xlabel('Task Number');
ylabel('Accuracy');
% ylabel('Running Time (ms)');

%%
load MyStat-Caltech.mat
MyStat = MyStat';
%%
bar(1-MyStat(1:5, [1:6, 7]));
legend('SVM','PSVM','LSSVM','TWSVM','LS-TWSVM','MTLS-TWSVM');
xlabel('Task Number');
ylabel('Error Rate');
%%
bar(MyStat(1:5, [7:9]));
legend('MTPSVM','MTLS-SVM','DMTSVM','MTLS-TWSVM');
xlabel('Task Number');
ylabel('Error Rate');

%% Caltech256
Stat = [];
Time = [];
x = [1:10];
for i = x
    P = sprintf('LabStat-Caltech256_V2_T%d', i);
    load(P);
    Stat = cat(2, Stat, LabStat(:,:,:));
    Time = cat(2, Time, LabTime(:,1));
end
% Stat = Stat';
Time = Time'*1000;