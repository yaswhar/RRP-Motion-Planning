function [pos,timeTotal]=TrapVel2Traj(startVel, endVel, maxVel, accel, decel, displacement)
    timeToMaxVel = (maxVel - startVel)/accel;
    distAccel = 0.5*(2*startVel + maxVel)*timeToMaxVel;
    timeToDecel = (maxVel - endVel)/decel;
    distDecel = 0.5*(maxVel + 2*endVel)*timeToDecel;
    if distAccel + distDecel > displacement(2) - displacement(1) % Trinagular Profile Check
        timeTotal = sqrt(abs(displacement(2) - displacement(1))/(0.5*(accel + decel)));
        maxVel = accel*timeTotal/2;
        time = 0:0.001:timeTotal;
        vel = zeros(size(time));
        vel = startVel.*(time<=timeTotal/2) + accel*time.*(time<=timeTotal/2) + maxVel.*(time>timeTotal/2) - decel*(time-timeTotal/2).*(time>timeTotal/2);
        pos = cumtrapz(time,vel);
        pos = displacement(1) + (pos-min(pos))*(displacement(2)-displacement(1))/(max(pos)-min(pos));
        return;
    end
    distConstVel = displacement(2) - displacement(1) - distAccel - distDecel;
    timeAccel = timeToMaxVel;
    timeConstVel = distConstVel/maxVel;
    timeTotal = timeAccel + timeConstVel + timeToDecel;
    time = 0:1/1000:timeTotal;
    vel = zeros(size(time));
    vel = startVel.*(time<=timeAccel) + accel*time.*(time<=timeAccel) + maxVel*(time>timeAccel & time<=(timeAccel+timeConstVel)) + maxVel.*(time>(timeAccel+timeConstVel)) - decel*(time-(timeAccel+timeConstVel)).*(time>(timeAccel+timeConstVel));
    pos = cumtrapz(time,vel);
    pos = pos + displacement(1);
end