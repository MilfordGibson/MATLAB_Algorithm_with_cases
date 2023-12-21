%%#��25��*�е�ʦѧϰ������Ļع���ϡ������ڽ�������׵���������ֵԤ��
% <html>
% <table border="0" width="600px" id="table1">	<tr>		<td><b><font size="2">�ð�������������</font></b></td>	</tr>	<tr><td><span class="comment"><font size="2">1�����˳���פ���ڴ�<a target="_blank" href="http://www.matlabsky.com/forum-78-1.html"><font color=" 0000FF">���</font></a>��Ըð������ʣ��������ʱش�</font></span></td></tr><tr>	<td><span class="comment"><font size="2">2</font><font size="2">���˰��������׵Ľ�ѧ��Ƶ����Ƶ��������<a href="http://www.matlabsky.com/forum-91-1.html">http://www.matlabsky.com/forum-91-1.html</a></font><font size="2">�� </font></span></td>	</tr>			<tr>		<td><span class="comment"><font size="2">		3���˰���Ϊԭ��������ת����ע����������MATLAB�����㷨30����������������</font></span></td>	</tr>		<tr>		<td><span class="comment"><font size="2">		4�����˰��������������о��й��������ǻ�ӭ���������Ҫ��ȣ����ǿ��Ǻ���Լ��ڰ����</font></span></td>	</tr>	<tr>		<td><span class="comment"><font size="2">		5����������Ϊ���壬��ʵ�ʷ��е��鼮�������г��룬�����鼮�е�����Ϊ׼��</font></span></td>	</tr>	</table>
% </html>

%% ��ջ�������
clear all
clc

%% ѵ����/���Լ�����
load spectra_data.mat
% �������ѵ�����Ͳ��Լ�
temp = randperm(size(NIR,1));
% ѵ��������50������
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';
% ���Լ�����10������
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';
N = size(P_test,2);

%% BP�����紴����ѵ�����������(R2014a)

% ��������
net = feedforwardnet(9);
% ����ѵ������
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;
% ѵ������
net = train(net,P_train,T_train);
% �������
T_sim_bp = net(P_test);

%% RBF�����紴�����������

% ��������
net = newrbe(P_train,T_train,0.3);
% �������
T_sim_rbf = sim(net,P_test);

%% ��������

% ������error
error_bp = abs(T_sim_bp - T_test)./T_test;
error_rbf = abs(T_sim_rbf - T_test)./T_test;
% ����ϵ��R^2
R2_bp = (N * sum(T_sim_bp .* T_test) - sum(T_sim_bp) * sum(T_test))^2 / ((N * sum((T_sim_bp).^2) - (sum(T_sim_bp))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
R2_rbf = (N * sum(T_sim_rbf .* T_test) - sum(T_sim_rbf) * sum(T_test))^2 / ((N * sum((T_sim_rbf).^2) - (sum(T_sim_rbf))^2) * (N * sum((T_test).^2) - (sum(T_test))^2));
% ����Ա�
result_bp = [T_test' T_sim_bp' T_sim_rbf' error_bp' error_rbf']

%% ��ͼ
figure
plot(1:N,T_test,'b:*',1:N,T_sim_bp,'r-o',1:N,T_sim_rbf,'k-.^')
legend('��ʵֵ','BPԤ��ֵ','RBFԤ��ֵ')
xlabel('Ԥ������')
ylabel('����ֵ')
string = {'���Լ�����ֵ����Ԥ�����Ա�(BP vs RBF)';['R^2=' num2str(R2_bp) '(BP)' '  R^2=' num2str(R2_rbf) '(RBF)']};
title(string)

%%
% <html>
% <table width="656" align="left" >	<tr><td align="center"><p align="left"><font size="2">�����̳��</font></p><p align="left"><font size="2">Matlab������̳��<a href="http://www.matlabsky.com">www.matlabsky.com</a></font></p><p align="left"><font size="2">M</font><font size="2">atlab�����ٿƣ�<a href="http://www.mfun.la">www.mfun.la</a></font></p></td>	</tr></table>
% </html>
  