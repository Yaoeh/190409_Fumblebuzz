%https://www.youtube.com/watch?v=L_-iY99-ePQ
%https://www.mathworks.com/help/simulink/ug/using-the-sim-command.html
%Accessing data: https://www.mathworks.com/matlabcentral/answers/384492-how-to-access-scope-data-when-running-model-with-sim-command
simulation_time = 10000;
numExperiments = 10;
Cf_Sweep= linspace(1000,1200,100);
Cf_Sweep2= linspace(1000,1200,100);
Cf_Sweep= Cf_Sweep(randperm(length(Cf_Sweep)));
Cf_Sweep2= Cf_Sweep2(randperm(length(Cf_Sweep2)));

% ERP, RRP, conduction, rest

%data=[];
for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('NPNwithVVI'); %name of project
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/Rest_def','Value',num2str(Cf_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/ERP_def','Value',num2str(Cf_Sweep2(i)));
    %in(i)=in(i).setBlockParameter('NPNwithVVI.slx/NodeLongERP1/ERP_def','MaskValues',{num2str(Cf_Sweep2(i))});

end

out= parsim(in);

% A2V delay
a2v = zeros(numExperiments, simulation_time);

for i=1: numExperiments
    Vnode = out(i).logsout{1}.Values.Data;
    SAnode = out(i).logsout{2}.Values.Data;

    index = 1;
    cur_s = 1;
    cur_v = 1;

    while index < simulation_time

        cur_flag = 0;

        if SAnode(index) == 1
            cur_s = index;
        end

        if Vnode(index) == 1 && index > cur_s && cur_s ~= 0
            cur_v = index;

            delta = cur_v - cur_s;

            if delta > 300 || delta < 5
                cur_flag = 1;
                cur_s=0;
            else
                cur_s = 0;
                cur_v = 0;
            end
        end

        a2v(i, index) = cur_flag;
        index = index + 1;


    end

%     plot(1:simulation_time, a2v(i,:), '-o');
%     axis([0, simulation_time, -0.2,1.2]);
%     xlabel('Simulation time');
%     ylabel('Violation');
%     title(['Violations of A2V Delay']);
%     drawnow;

end

figure(1)
hold on

for i=1:numExperiments
plot(1:simulation_time, a2v(i,:), '-o', 'DisplayName', ['experiment ' num2str(i)]);
end
legend('show');
axis([0, simulation_time, -0.2,1.2]);
xlabel('Simulation time');
ylabel('Violation');
title(['Violations of A2V Delay']);
drawnow;
%NodeLongERP.data

% variable1 = ( beats in interval / interval length )
% convert variable1 to beats/minute

%for i=out
%  i.logsout
%end

%Simulink.sdi.view;