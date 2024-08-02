pderect([0 0.0158 0.00021 0.00028])% WD %0.0 for water
pderect([0 0.0158 0.00028 0.00045])%glass
pderect([0 0.0158 0.00045 0.001])%water
pderect([0 0.0158 0.001 0.0011])%air

%% plot

v = pdeInterpolant(p,t,u)
Tinterp = evaluate(v,0.0079,0.000452)
plot(linspace(0,10,1000),Tinterp)
xlabel('Time/s')
ylabel('Temperature/°C')
title('Heat transfer through water objective')

%%
load("C:\Users\anne-\OneDrive\Bureau\phdstuff\matlab_pde\u_air70um10sec.mat");
load("C:\Users\anne-\OneDrive\Bureau\phdstuff\matlab_pde\p_air70um10sec.mat");
load("C:\Users\anne-\OneDrive\Bureau\phdstuff\matlab_pde\t_air70um10sec.mat");
load("C:\Users\anne-\OneDrive\Bureau\phdstuff\matlab_pde\e_air70um10sec.mat");

v = pdeInterpolant(p_air70um10sec,t_air70um10sec,u_air70um10sec)
Tinterp = evaluate(v,0.0079,0.000452)
plot(linspace(0,10,1000),Tinterp)
set(gca,'FontSize',12)
set(gcf, 'color', 'none');   
set(gca, 'color', 'none');
ylim([0 18])
xlabel('Time/s')
ylabel('Temperature/°C')
title('Heat transfer through air flow')