clear all;
% Camera FOV model
x_i=2.54
y_i=2.20
z_i=3.18
a=36
b=27
lambda=50
psi=105 %pan angel
phi=165 %tilt angel

x_t=[3.62 3.08 0].'
q1_v=[a/2 b/2];
q2_v=[a/2 -b/2];
q3_v=[-a/2 -b/2];
q4_v=[-a/2 b/2];
q1_vt=q1_v.';
q2_vt=q2_v.';
q3_vt=q3_v.';
q4_vt=q4_v.';

q1_B=[q1_vt; lambda]
q2_B=[q2_vt; lambda]
q3_B=[q3_vt; lambda]
q4_B=[q4_vt; lambda]

H_phi=[cos(psi) -sin(psi) 0;
       sin(psi) cos(psi)  0
       0 0 1];
H_phy=[1 0 0;
       0 cos(phi) -sin(phi);
       0 sin(phi) cos(phi)];
q1_I=H_phi*H_phy*q1_B;
q2_I=H_phi*H_phy*q2_B;
q3_I=H_phi*H_phy*q3_B;
q4_I=H_phi*H_phy*q4_B;

rho_14=(-3.18)/(b/2*sin(phi)+lambda*cos(phi))
rho_23=(-3.18)/(-b/2*sin(phi)+lambda*cos(phi))

q1n_I=rho_14*q1_I
q2n_I=rho_23*q2_I
q3n_I=rho_23*q3_I
q4n_I=rho_14*q4_I
X=[x_i;y_i;z_i]
ksai1=X+q1n_I
ksai2=X+q2n_I
ksai3=X+q3n_I
ksai4=X+q4n_I
v1=ksai1.';
v2=ksai2.';
v3=ksai3.';
v4=ksai4.';
Cam=X.';
%%
% Vertices
V = [v1;v3;v2;v4;Cam];
% Faces
F = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
% Draw and Mark all the vertices
x = V(:, 1);
y = V(:, 2);
z = V(:, 3);
plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
'MarkerEdgeColor', 'b');
hold on;
%% Draw the target and label it
xtar=3.62
ytar=3.08
ztar=0
plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
marktar = sprintf('Target');
text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
hold on;
%% Number and label all the FOV edge points and the camera
for i = 1 : length(V)-1
 number = sprintf('E%d', i);
 pointoutcam = sprintf('Camera');
  text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
  text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
end
%% Draw all the faces and mark the relative z direction distance using color
% grading bar
Buttomface = F{1};
Sideface = [F{2:end}];
Sideface = reshape(Sideface, 3 ,4);
Sideface = Sideface';
col = [0; 0; 0; 0; 3.18];
patch('vertices', V, 'faces', Buttomface, 'FaceColor', 'white','FaceAlpha',.1);
patch('vertices', V, 'faces', Sideface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
grid on;
colorbar
