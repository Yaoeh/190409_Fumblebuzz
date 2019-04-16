%https://www.youtube.com/watch?v=L_-iY99-ePQ

Cf_Sweep= linspace(-30,30);
Cf_Sweep2= linspace(-30,30);
numExperiments= length(Cf_Sweep);


Cf_Sweep= Cf_Sweep(randperm(length(Cf_Sweep)));
Cf_Sweep2= Cf_Sweep2(randperm(length(Cf_Sweep2)));


for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('sldemo_auto_climatecontrol');
    in(i)=in(i).setBlockParameter('sldemo_auto_climatecontrol/User Setpoint in Celsius','MaskValues',{num2str(Cf_Sweep(i))});
    in(i)=in(i).setBlockParameter('sldemo_auto_climatecontrol/External Temperature in Celsius','MaskValues',{num2str(Cf_Sweep2(i))});
end

out= parsim(in);