clear;
clc;

NA = 6.02214076E23;
V_bac = 8e-16;
n_bac = 1E8;

%% --------------------------Set initial substance number--------------------------
Ps_0 = 5;                                         % Number of plasmids.
Ds_0 = 5;                                          % cDNA                                         
Ps_Cre1_0 = 0;
Ds_Cre1_0 = 0;
Ps_Cre2_0 = 0;
Ds_Cre2_0 = 0;
Pp_Dp_Cre4_0 = 0;
Pp_Cre2_0 = 0;
Dp_Cre2_0 = 0;
Pp_Cre1_0 = 0;
Dp_Cre1_0 = 0;
Pp_0 = 0;
Dp_0 = 0;
Cre_0 = 10;
x0 = [Ps_0; Ds_0; Ps_Cre1_0; Ds_Cre1_0; Ps_Cre2_0; Ds_Cre2_0; Pp_Dp_Cre4_0; Pp_Cre2_0; Dp_Cre2_0; Pp_Cre1_0; Dp_Cre1_0; Pp_0; Dp_0; Cre_0];

%% --------------------------Solve the equations--------------------------
options=odeset('reltol',1e-8);             
tic
[t,y]=ode15s(@CreRcbFunc, [0 500000], x0, options);
toc

%% --------------------------Plot the result--------------------------
UnRec_p = y(:,1)./Ps_0 * 100;
Product_p = y(:, 12)./Ps_0 * 100;
subplot(2,2,[1 2])
l1 = semilogx(t, UnRec_p);  
hold on
l2 = semilogx(t, Product_p); 

set(gca,'linewidth',1.5,'FontSize',14,'FontWeight','bold','FontName','Arial')
set([l1 l2],'linewidth',2)
title('Cre-LoxP recombination kinetics', 'fontsize', 20)
xlabel('Time (s)', 'fontsize', 15)
ylabel('Percentage of substance (%)', 'fontsize', 15)
grid on
% axis square
% ����legend
legend([l1, l2], 'Unrecombined P_{target}', 'Recombined P_{Target}','location','NorthEast','Orientation', 'horizontal')
legend({},'FontSize',12)

subplot(2,2,[3 4])
bar(y(end,1:end-1)./sum(y(end,1:end-1)));
set(gca,'linewidth',1.5,'FontSize',14,'FontWeight','bold','FontName','Arial')
title('Steady-state substance distribution', 'fontsize', 20)
xticks(1:size(y,2)-1);
xticklabels({'Ps','Ds','PsC','DsC','PsC2','DsC2','PDC4','PpC2','DpC2','PpC1','DpC1','Pp','Dp'});
xlabel('Substance', 'fontsize', 15)
ylabel('Percentage of substance (%)', 'fontsize', 15)

set(gcf, 'InnerPosition', [440 69 900 729], 'OuterPosition', [440 69 900 802]);

% saveas(gcf,'CreDeteminate','jpg')