%
clear
close all

arduinoObj = arduino('COM3', 'Uno', 'Libraries', 'CAN');
ch = canChannel(arduinoObj,"Sparkfun CAN-Bus Shield", "BusSpeed", 1000e3);


% position reset command
disp('position RESET')
data(1) = 0xFF;
data(2) = 0xFF;
data(3) = 0xFF;
data(4) = 0xFF;
data(5) = 0xFF;
data(6) = 0xFF;
data(7) = 0xFF;
data(8) = 0xFE;
write(ch, 1, false, data)
pause(1)

% Motor command
disp('motor cmd reset')
pos_tgt = 0; % 16 bit (max. 65535)
vel_tgt = 0; % 12 bit (max. 4095)
kp_tgt = 1000; % 12 bit (max. 4095)
kd_tgt = 0; % 12 bit (max. 4095)
ff_tgt = 0; % 12 bit (max. 4095)

cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt);
write(ch, 1, false, cmd)
pause(3)

% Motor ON command
disp('ON')
data(1) = 0xFF;
data(2) = 0xFF;
data(3) = 0xFF;
data(4) = 0xFF;
data(5) = 0xFF;
data(6) = 0xFF;
data(7) = 0xFF;
data(8) = 0xFC;
write(ch, 1, false, data)
pause(1)

% Motor command
disp('motor MOVE')
pos_tgt = 256; % 16 bit (max. 65535)
vel_tgt = 0; % 12 bit (max. 4095)
kp_tgt = 800; % 12 bit (max. 4095)
kd_tgt = 800; % 12 bit (max. 4095)
ff_tgt = 0; % 12 bit (max. 4095)

cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt);
write(ch, 1, false, cmd)
pause(1)

% motor read
logData = read(ch)

% Motor command
disp('motor MOVE')
pos_tgt = -256; % 16 bit (max. 65535)
vel_tgt = 0; % 12 bit (max. 4095)
kp_tgt = 800; % 12 bit (max. 4095)
kd_tgt = 800; % 12 bit (max. 4095)
ff_tgt = 0; % 12 bit (max. 4095)

cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt);
write(ch, 1, false, cmd)
pause(1)

% motor read
logData = read(ch)

% Motor command
disp('motor MOVE')
pos_tgt = 0; % 16 bit (max. 65535)
vel_tgt = 0; % 12 bit (max. 4095)
kp_tgt = 800; % 12 bit (max. 4095)
kd_tgt = 800; % 12 bit (max. 4095)
ff_tgt = 0; % 12 bit (max. 4095)

cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt);
write(ch, 1, false, cmd)
pause(1)

% motor read
logData = read(ch)

% Motor OFF command
disp('OFF')
data(1) = 0xFF;
data(2) = 0xFF;
data(3) = 0xFF;
data(4) = 0xFF;
data(5) = 0xFF;
data(6) = 0xFF;
data(7) = 0xFF;
data(8) = 0xFD;
write(ch, 1, false, data)
pause(1)

% Motor command
disp('motor cmd reset')
pos_tgt = 0; % 16 bit (max. 65535)
vel_tgt = 0; % 12 bit (max. 4095)
kp_tgt = 0; % 12 bit (max. 4095)
kd_tgt = 0; % 12 bit (max. 4095)
ff_tgt = 0; % 12 bit (max. 4095)

cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt);
write(ch, 1, false, cmd)
pause(1)

clear arduinoObj
clear ch

disp('Finish!')