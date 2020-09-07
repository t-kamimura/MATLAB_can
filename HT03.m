classdef HT03 < handle
    %UNTITLED3 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        canCh;
        pos_tgt;
        vel_tgt;
        ff_tgt;
        kp;
        kd;
        rawData;
        logData;
    end
    
    methods
        function obj = HT03(COM,BusSpeed)
            % COM = COM3
            % BusSpeed = 1000e3
            arduinoObj = arduino(COM, 'Uno', 'Libraries', 'CAN');
            obj.canCh = canChannel(arduinoObj,"Sparkfun CAN-Bus Shield", "BusSpeed", BusSpeed);
            obj.rawData = [];
            obj.logData = [];
        end
        
        function posReset(self,ID)
            disp('Zero Reset')
            data(1) = 0xFF;
            data(2) = 0xFF;
            data(3) = 0xFF;
            data(4) = 0xFF;
            data(5) = 0xFF;
            data(6) = 0xFF;
            data(7) = 0xFF;
            data(8) = 0xFE;
            write(self.canCh, ID, false, data)
            read(self.canCh);
        end

        function motorON(self,ID)
            disp('ON')
            data(1) = 0xFF;
            data(2) = 0xFF;
            data(3) = 0xFF;
            data(4) = 0xFF;
            data(5) = 0xFF;
            data(6) = 0xFF;
            data(7) = 0xFF;
            data(8) = 0xFC;
            write(self.canCh, ID, false, data)
            read(self.canCh);
        end

        function motorOFF(self,ID)
            disp('OFF')
            data(1) = 0xFF;
            data(2) = 0xFF;
            data(3) = 0xFF;
            data(4) = 0xFF;
            data(5) = 0xFF;
            data(6) = 0xFF;
            data(7) = 0xFF;
            data(8) = 0xFD;
            write(self.canCh, ID, false, data)
            read(self.canCh);
        end

        function motorMove(self,ID,pos,vel,kp,kd,ff)
%             disp('Motor move')
            % バイアス
            pos = pos + 32768;
            vel = vel + 2048;
            ff = ff + 2048;

            cmd(1) = uint8(bitshift(pos, -8)); % pos上8bitのみ抜き出し
            cmd(2) = uint8(bitand(pos, hex2dec('FF'))); % pos下8bitのみ抜き出し
            cmd(3) = uint8(bitshift(vel, -4)); % vel上8ビットのみ抜き出し
            cmd(4) = uint8(bitshift(bitand(vel, hex2dec('F')), 4) + bitand(bitshift(kp,-8),hex2dec('F'))); % velの下4桁と，kpの上4桁を合成
            cmd(5) = uint8(bitand(kp, hex2dec('FF')));  % kpの下8bit
            cmd(6) = uint8(bitshift(kd, -4));   % kdの上8bit
            cmd(7) = uint8(bitshift(bitand(kd, hex2dec('F')), 4) + bitand(bitshift(ff, -8), hex2dec('F'))); % kdの下4桁と，kpの上4桁を合成
            cmd(8) = uint8(bitand(ff, hex2dec('FF')));

            write(self.canCh, ID, false, cmd)
        end

        function motorRead(self)
            timeTable = read(self.canCh);
            buf = int16(cell2mat(timeTable.Data));
            self.rawData=[self.rawData;buf];
        end
        
        function postProcess(self)
            for i = 1:length(self.rawData)
                buf = self.rawData(i,:);
                upos = bitshift(buf(2),8) + buf(3);
%                 pos_cur = upos;
                if upos < 0
                    pos_cur = 32768 + upos;
                else
                    pos_cur = upos - 32768;
                end
                vel_cur = bitshift(buf(4),4) + bitshift(buf(5),-4) - 2048;
                cur_cur = bitshift(bitand(buf(5), hex2dec('F')), 8) + buf(6) - 2048;
                self.logData=[self.logData;[pos_cur, vel_cur, cur_cur]];
            end
            
        end
    end
end

