clc;
clear all ;
% Intake of case
cs=input('1.Pan angel adjust 2.Tilt angel adjust 3.Pan & Tilt angel adjust: '); 
% Camera FOV model
x_i=2.54;
y_i=2.20;
z_i=3.18;
a=36;
b=27;
lambda=50;
psi=105; %pan angel
phi=150; %tilt angel
xtar=-0.62;
ytar=3.08;
ztar=0;
% x_t=[3.62 3.08 0].';
dpsi=0.1;
dphi=0.1;
s=[psi; phi; dpsi; dphi];
u1=100;
u2=100;
u=[u1; u2];
dt=0.01;
b1=0.01;
b2=0.01;

A=[1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
B=[0 0; 0 0; b1 0; 0 b2];


switch cs
        case 1
        for t=0:15

        q1_v=[a/2 b/2];
        q2_v=[a/2 -b/2];
        q3_v=[-a/2 -b/2];
        q4_v=[-a/2 b/2];
        q1_vt=q1_v.';
        q2_vt=q2_v.';
        q3_vt=q3_v.';
        q4_vt=q4_v.';

        q1_B=[q1_vt; lambda];
        q2_B=[q2_vt; lambda];
        q3_B=[q3_vt; lambda];
        q4_B=[q4_vt; lambda];

        H_phi=[cos(s(1)) -sin(s(1)) 0;
               sin(s(1)) cos(s(1))  0;
               0 0 1];
        H_phy=[1 0 0;
               0 cos(s(2)) -sin(s(2));
               0 sin(s(2)) cos(s(2))];
        q1_I=H_phi*H_phy*q1_B;
        q2_I=H_phi*H_phy*q2_B;
        q3_I=H_phi*H_phy*q3_B;
        q4_I=H_phi*H_phy*q4_B;

        rho_14=(-3.18)/(b/2*sin(s(2))+lambda*cos(s(2)));
        rho_23=(-3.18)/(-b/2*sin(s(2))+lambda*cos(s(2)));

        q1n_I=rho_14*q1_I;
        q2n_I=rho_23*q2_I;
        q3n_I=rho_23*q3_I;
        q4n_I=rho_14*q4_I;
        X=[x_i;y_i;z_i];
        ksai1=X+q1n_I;
        ksai2=X+q2n_I;
        ksai3=X+q3n_I;
        ksai4=X+q4n_I;
        v1=ksai1.';
        v2=ksai2.';
        v3=ksai3.';
        v4=ksai4.';
        Cam=X.';
        % Vertices
        V = [v1;v2;v3;v4;Cam];
        % Faces
        F = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x = V(:, 1);
        y = V(:, 2);
        z = V(:, 3);
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
%



        s=A*s+B*u;

        
        
%      
        
        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
        numel(xtar(in))
        numel(xtar(on))
        numel(xtar(~in))
        if xtar(~in)
            disp('Target Not detected!');
        else xtar(in)
            disp('Target Detected!');
         end
        % xl = [v1(:, 1),  v3(:, 1), v2(:, 1),  v4(:, 1),  v1(:, 1),  2.54, v4(:, 1), 2.54,  v3(:, 1),  2.54,  v2(:, 1)];
        % yl = [v1(:, 2),  v3(:, 2),  v2(:, 2),  v4(:, 2),  v1(:, 2),  2.20,  v4(:, 2),  2.20, v3(:, 2),  2.20, v2(:, 2)];
        % zl = [v1(:, 3), v3(:, 3),v2(:, 3), v4(:, 3), v1(:, 3), 3.18, v4(:, 3), 3.18, v3(:, 3), 3.18, v2(:, 3)];
        % plot3(xl,yl,zl)


        Buttomface = F{1};
        Sideface = [F{2:end}];
        Sideface = reshape(Sideface, 3 ,4);
        Sideface = Sideface';
        col = [0; 0; 0; 0; 3.18];
        patch('vertices', V, 'faces', Buttomface, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V, 'faces', Buttomface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        patch('vertices', V, 'faces', Sideface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V)-1
                 number = sprintf('E%d', i);
                 pointoutcam = sprintf('Camera');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
%         s1=s1+0.05;
        % phi=phi+0.05;
        xtar=xtar-0.2;
        ytar=ytar-0.2;
        pause(2)
        drawnow
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %%
        
    case 2
     for t=0:15

        q1_v=[a/2 b/2];
        q2_v=[a/2 -b/2];
        q3_v=[-a/2 -b/2];
        q4_v=[-a/2 b/2];
        q1_vt=q1_v.';
        q2_vt=q2_v.';
        q3_vt=q3_v.';
        q4_vt=q4_v.';

        q1_B=[q1_vt; lambda];
        q2_B=[q2_vt; lambda];
        q3_B=[q3_vt; lambda];
        q4_B=[q4_vt; lambda];

        H_phi=[cos(s1) -sin(s1) 0;
               sin(s1) cos(s1)  0
               0 0 1];
        H_phy=[1 0 0;
               0 cos(s2) -sin(s2);
               0 sin(s2) cos(s2)];
        q1_I=H_phi*H_phy*q1_B;
        q2_I=H_phi*H_phy*q2_B;
        q3_I=H_phi*H_phy*q3_B;
        q4_I=H_phi*H_phy*q4_B;

        rho_14=(-3.18)/(b/2*sin(s2)+lambda*cos(s2));
        rho_23=(-3.18)/(-b/2*sin(s2)+lambda*cos(s2));

        q1n_I=rho_14*q1_I;
        q2n_I=rho_23*q2_I;
        q3n_I=rho_23*q3_I;
        q4n_I=rho_14*q4_I;
        X=[x_i;y_i;z_i];
        ksai1=X+q1n_I;
        ksai2=X+q2n_I;
        ksai3=X+q3n_I;
        ksai4=X+q4n_I;
        v1=ksai1.';
        v2=ksai2.';
        v3=ksai3.';
        v4=ksai4.';
        Cam=X.';
        % Vertices
        V = [v1;v2;v3;v4;Cam];
        % Faces
        F = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x = V(:, 1);
        y = V(:, 2);
        z = V(:, 3);
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
        numel(xtar(in))
        numel(xtar(on))
        numel(xtar(~in))
        if xtar(~in)
            disp('Target Not detected!');
        else xtar(in)
            disp('Target Detected!');
         end
%         xl = [v1(:, 1),  v3(:, 1), v2(:, 1),  v4(:, 1),  v1(:, 1),  2.54, v4(:, 1), 2.54,  v3(:, 1),  2.54,  v2(:, 1)];
%         yl = [v1(:, 2),  v3(:, 2),  v2(:, 2),  v4(:, 2),  v1(:, 2),  2.20,  v4(:, 2),  2.20, v3(:, 2),  2.20, v2(:, 2)];
%         % zl = [v1(:, 3), v3(:, 3),v2(:, 3), v4(:, 3), v1(:, 3), 3.18, v4(:, 3), 3.18, v3(:, 3), 3.18, v2(:, 3)];
%         % plot3(xl,yl,zl)
%         plot(xl,yl)
%         hold on


        Buttomface = F{1};
        Sideface = [F{2:end}];
        Sideface = reshape(Sideface, 3 ,4);
        Sideface = Sideface';
        col = [0; 0; 0; 0; 3.18];
        patch('vertices', V, 'faces', Buttomface, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V, 'faces', Buttomface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        patch('vertices', V, 'faces', Sideface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V)-1
                 number = sprintf('E%d', i);
                 pointoutcam = sprintf('Camera');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
%         psi=psi+0.05;
        s2=s2+0.05;
        xtar=xtar-0.2;
        ytar=ytar-0.2;
        pause(2)
        drawnow
     end
    
 %%  
    case 3
             for t=0:15

        q1_v=[a/2 b/2];
        q2_v=[a/2 -b/2];
        q3_v=[-a/2 -b/2];
        q4_v=[-a/2 b/2];
        q1_vt=q1_v.';
        q2_vt=q2_v.';
        q3_vt=q3_v.';
        q4_vt=q4_v.';

        q1_B=[q1_vt; lambda];
        q2_B=[q2_vt; lambda];
        q3_B=[q3_vt; lambda];
        q4_B=[q4_vt; lambda];

        H_phi=[cos(s1) -sin(s1) 0;
               sin(s1) cos(s1)  0
               0 0 1];
        H_phy=[1 0 0;
               0 cos(s2) -sin(s2);
               0 sin(s2) cos(s2)];
        q1_I=H_phi*H_phy*q1_B;
        q2_I=H_phi*H_phy*q2_B;
        q3_I=H_phi*H_phy*q3_B;
        q4_I=H_phi*H_phy*q4_B;

        rho_14=(-3.18)/(b/2*sin(s2)+lambda*cos(s2));
        rho_23=(-3.18)/(-b/2*sin(s2)+lambda*cos(s2));

        q1n_I=rho_14*q1_I;
        q2n_I=rho_23*q2_I;
        q3n_I=rho_23*q3_I;
        q4n_I=rho_14*q4_I;
        X=[x_i;y_i;z_i];
        ksai1=X+q1n_I;
        ksai2=X+q2n_I;
        ksai3=X+q3n_I;
        ksai4=X+q4n_I;
        v1=ksai1.';
        v2=ksai2.';
        v3=ksai3.';
        v4=ksai4.';
        Cam=X.';
        % Vertices
        V = [v1;v2;v3;v4;Cam];
        % Faces
        F = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x = V(:, 1);
        y = V(:, 2);
        z = V(:, 3);
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
        numel(xtar(in))
        numel(xtar(on))
        numel(xtar(~in))
        if xtar(~in)
            disp('Target Not detected!');
        else xtar(in)
            disp('Target Detected!');
         end
        % xl = [v1(:, 1),  v3(:, 1), v2(:, 1),  v4(:, 1),  v1(:, 1),  2.54, v4(:, 1), 2.54,  v3(:, 1),  2.54,  v2(:, 1)];
        % yl = [v1(:, 2),  v3(:, 2),  v2(:, 2),  v4(:, 2),  v1(:, 2),  2.20,  v4(:, 2),  2.20, v3(:, 2),  2.20, v2(:, 2)];
        % zl = [v1(:, 3), v3(:, 3),v2(:, 3), v4(:, 3), v1(:, 3), 3.18, v4(:, 3), 3.18, v3(:, 3), 3.18, v2(:, 3)];
        % plot3(xl,yl,zl)


        Buttomface = F{1};
        Sideface = [F{2:end}];
        Sideface = reshape(Sideface, 3 ,4);
        Sideface = Sideface';
        col = [0; 0; 0; 0; 3.18];
        patch('vertices', V, 'faces', Buttomface, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V, 'faces', Buttomface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        patch('vertices', V, 'faces', Sideface,'FaceAlpha',.3,'FaceVertexCData',col,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V)-1
                 number = sprintf('E%d', i);
                 pointoutcam = sprintf('Camera');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
        s1=s1+0.05;
        s2=s2+0.05;
        xtar=xtar-0.2;
        ytar=ytar-0.2;
        pause(2)
        drawnow
             end
end
%  Draw the target and label it
% 
% 
% hold on;
% Number and label all the FOV edge points and the camera
% 
% 
% Draw all the faces and mark the relative z direction distance using color
% % grading bar

