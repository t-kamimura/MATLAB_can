clear
close all

motor = HT03('COM3',1000e3);

motor.motorOFF(1);
motor.posReset(1);
motor.motorON(1);
pause(1)

vel = 0;
kp = 1000;
kd = 1000;
ff = 0;

A = pi/4;   %[rad]
freq = 5;   %[Hz]

A = A*1024/pi;
tic

n = 50;
timer = zeros(n,1);
posCmd = zeros(n,1);
for i = 1:100
    t1 = toc;
    pos = round(A*sin(freq*toc));
    motor.motorMove(1,pos, vel, kp, kd, ff)
    motor.motorRead;
    timer(i) = t1;
    posCmd(i) = pos;
    if toc - t1 < 1e-2
        while toc - t1 < 1e-2
        end
    else
%         disp('time shortage')
    end
end
pause(1)

pos = 0;
motor.motorMove(1,pos, vel, kp, kd, ff)
pause(1)

motor.motorOFF(1);

motor.postProcess;

figure
hold on
plot(timer,posCmd)
stairs(timer,motor.logData(:,1))
legend('des','data')