function cmd = makeCmd(pos_tgt, vel_tgt, kp_tgt, kd_tgt, ff_tgt)
    % バイアス
    pos_tgt = pos_tgt + 32768;
    vel_tgt = vel_tgt + 2048;
    ff_tgt = ff_tgt + 2048;

    cmd(1) = uint8(bitshift(pos_tgt, -8)); % pos上8bitのみ抜き出し
    cmd(2) = uint8(bitand(pos_tgt, hex2dec('FF'))); % pos下8bitのみ抜き出し
    cmd(3) = uint8(bitshift(vel_tgt, -4)); % vel上8ビットのみ抜き出し
    cmd(4) = uint8(bitshift(bitand(vel_tgt, hex2dec('F')), 4) + bitand(bitshift(kp_tgt,-8),hex2dec('F'))); % velの下4桁と，kpの上4桁を合成
    cmd(5) = uint8(bitand(kp_tgt, hex2dec('FF')));  % kpの下8bit
    cmd(6) = uint8(bitshift(kd_tgt, -4));   % kdの上8bit
    cmd(7) = uint8(bitshift(bitand(kd_tgt, hex2dec('F')), 4) + bitand(bitshift(ff_tgt, -8), hex2dec('F'))); % kdの下4桁と，kpの上4桁を合成
    cmd(8) = uint8(bitand(ff_tgt, hex2dec('FF')));
end

