function OURrobot = Doosan_M0609 ()

% Robot parameters

% lunghezze dei lati per origine i a i+1, lungo la direzione relativa all'origine i
l12_z = 0.1777;
l12_y = 0.411;
l23_z = -0.1715;
l34_z = 0.368;
l56_z = 0.06;   % end effector

syms q [6 1]
q = subs(q,q,zeros(6,1));
q = eval(q);

DH_table_RBT = [0     -pi/2    0     q(1)
                l12_y   0    l12_z   q(2)
                0      pi/2  l23_z   q(3)
                0     -pi/2  l34_z   q(4)
                0      pi/2    0     q(5)
                0       0    l56_z   q(6)];

% Initialization of a rigid-body-tree
OURrobot = rigidBodyTree("DataFormat","row");

% First Link
body1 = rigidBody('body1'); % Initialization of the link

jnt1 = rigidBodyJoint('jnt1','revolute'); % Initialization of the revolute joint

% DH_table_eval = eval(q)
setFixedTransform(jnt1,DH_table_RBT(1,:),'dh'); 
% Definition of the relative transformation (a, alpha, d, theta) 
% -->child to joint transform

body1.Joint = jnt1; % Associate the joint with the body

addBody(OURrobot,body1,'base') % Add body to the rigidBody

% Second Link
body2 = rigidBody('body2');
jnt2 = rigidBodyJoint('jnt2','revolute'); 
setFixedTransform(jnt2,DH_table_RBT(2,:),'dh'); 
body2.Joint = jnt2; 
addBody(OURrobot,body2,'body1') 

% Third Link
body3 = rigidBody('body3');
jnt3 = rigidBodyJoint('jnt3','revolute'); 
setFixedTransform(jnt3,DH_table_RBT(3,:),'dh'); 
body3.Joint = jnt3; 
addBody(OURrobot,body3,'body2') 

% Fourth Link
body4 = rigidBody('body4');
jnt4 = rigidBodyJoint('jnt4','revolute'); 
setFixedTransform(jnt4,DH_table_RBT(4,:),'dh'); 
body4.Joint = jnt4; 
addBody(OURrobot,body4,'body3');

% Fifth Link
body5 = rigidBody('body5');
jnt5 = rigidBodyJoint('jnt5','revolute'); 
setFixedTransform(jnt5,DH_table_RBT(5,:),'dh'); 
body5.Joint = jnt5; 
addBody(OURrobot,body5,'body4'); 

% End effector
endeff = rigidBody('endeff');
jnt6 = rigidBodyJoint('jnt6','revolute');
setFixedTransform(jnt6,DH_table_RBT(6,:),'dh');
endeff.Joint = jnt6;
addBody(OURrobot,endeff,'body5');
end