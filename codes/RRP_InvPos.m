function [ theta1 , theta2 , d] = RRP_InvPos( pos )
pos = round (pos , 3);
L1 =310;
L2 =300;
d=(pos(1,:).^2+pos(2,:).^2+(pos(3,:)-L1).^2).^(0.5)-L2;
theta1=atan2d(pos(2,:),pos(1,:));
theta2=atan2d((pos(3,:)-L1).*sind(theta1),pos(2,:));
dtest=(pos(3,:)-L1)./sind(theta2)-L2;
id=isnan(dtest);
dtest(id)=pos(2,id)./(sind(theta1(id)).*cosd(theta2(id)))-L2;
id=isnan(dtest);
dtest(id)=pos(1,id)./(cosd(theta1(id)).*cosd(theta2(id)))-L2;
id= dtest<0;
theta2(id)=atan2d((pos(3,id)-L1).*cosd(theta1(id)),pos(1,id));
theta1=round(theta1,3);
theta2=round(theta2,3);
d=round(d,3);
end