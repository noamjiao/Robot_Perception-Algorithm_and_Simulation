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
x2_i=-5.54;
y2_i=0;
z2_i=3.18;
a2=36;
b2=27;
lambda2=50;
psi2=-105; %pan angel
phi2=150; %tilt angel

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

        rho_14=(-3.18)/(b/2*sin(phi)+lambda*cos(phi));
        rho_23=(-3.18)/(-b/2*sin(phi)+lambda*cos(phi));

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
        q1_v2=[a2/2 b2/2];
        q2_v2=[a2/2 -b2/2];
        q3_v2=[-a2/2 -b2/2];
        q4_v2=[-a2/2 b2/2];
        q1_vt2=q1_v2.';
        q2_vt2=q2_v2.';
        q3_vt2=q3_v2.';
        q4_vt2=q4_v2.';

        q1_B2=[q1_vt2; lambda2];
        q2_B2=[q2_vt2; lambda2];
        q3_B2=[q3_vt2; lambda2];
        q4_B2=[q4_vt2; lambda2];

        H_phi2=[cos(psi2) -sin(psi2) 0;
               sin(psi2) cos(psi2)  0
               0 0 1];
        H_phy2=[1 0 0;
               0 cos(phi2) -sin(phi2);
               0 sin(phi2) cos(phi2)];
        q1_I2=H_phi2*H_phy2*q1_B2;
        q2_I2=H_phi2*H_phy2*q2_B2;
        q3_I2=H_phi2*H_phy2*q3_B2;
        q4_I2=H_phi2*H_phy2*q4_B2;

        rho_14_2=(-3.18)/(b2/2*sin(phi2)+lambda2*cos(phi2));
        rho_23_2=(-3.18)/(-b2/2*sin(phi2)+lambda2*cos(phi2));

        q1n_I2=rho_14_2*q1_I2;
        q2n_I2=rho_23_2*q2_I2;
        q3n_I2=rho_23_2*q3_I2;
        q4n_I2=rho_14_2*q4_I2;
        X2=[x2_i;y2_i;z2_i];
        ksai12=X2+q1n_I2;
        ksai22=X2+q2n_I2;
        ksai32=X2+q3n_I2;
        ksai42=X2+q4n_I2;
        v12=ksai12.';
        v22=ksai22.';
        v32=ksai32.';
        v42=ksai42.';
        Cam2=X2.';
        % Vertices
        V2 = [v12;v22;v32;v42;Cam2];
        % Faces
        F2 = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x2 = V2(:, 1);
        y2 = V2(:, 2);
        z2 = V2(:, 3);
    
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        plot3(x2, y2, z2, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
%         numel(xtar(in))
%         numel(xtar(on))
%         numel(xtar(~in))
%         if xtar(~in)
%             disp('Target Not detected!');
%         else xtar(in)
%             disp('Target Detected!');
%         end
         
        xl2 = [v12(:, 1),   v22(:, 1), v32(:, 1), v42(:, 1),  v12(:, 1)];
        yl2 = [v12(:, 2),   v22(:, 2), v32(:, 2),  v42(:, 2),  v12(:, 2)];
        plot(xl2,yl2)  
        [in2,on2] = inpolygon(xtar,ytar,xl2,yl2);
%         numel(xtar(in2))
%         numel(xtar(on2))
%         numel(xtar(~in2))

%         if in
%            disp('Target detected by 1!');
%         elseif in2
%            disp('Target detected by 2!');
        if in && ~in2
            disp('Target Detected by Camera 1!');
        elseif in2 && ~in
            disp('Target Detected by Camera 2!');
        elseif in && in2
            disp('Target Detected by Camera 1&2!');
        elseif ~in && ~in2
            disp('Target Not detected!');
        end
%         elseif 
%            disp('Target Not detected by 2!');

%         if xtar(in)
%            disp('Target detected by 1!');
%         elseif xtar(in2)
%            disp('Target detected by 2!');
%         if xtar(in) & xtar(~in2)
%             fprintf('Target Detected by 1!');
%         elseif xtar(in2) & xtar(~in)
%             fprintf('Target Detected 2!');
%         elseif xtar(in) & xtar(in2)
%             fprintf('Target Detected 1&2!');
%         elseif xtar(~in)& xtar(~in2)
%             fprintf('Target Not detected!');
%         elseif 
%            disp('Target Not detected by 2!');

%             if xtar(in)
%                 disp('Target detected!');
%             elseif xtar(in2)
%                 disp('Target detected!');
%             elseif xtar(~in)&& xtar(~in2)
%                  fprintf('Target Not detected!');
%              end
% disp(in2)
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
                 pointoutcam = sprintf('Camera1');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
        psi=psi+0.08;
        
        Buttomface2 = F2{1};
        Sideface2 = [F2{2:end}];
        Sideface2 = reshape(Sideface2, 3 ,4);
        Sideface2 = Sideface2';
        col2 = [0; 0; 0; 0; 3.18];
        patch('vertices', V2, 'faces', Buttomface2, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V2, 'faces', Buttomface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        patch('vertices', V2, 'faces', Sideface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V2)-1
                 number2 = sprintf('E%d', i);
                 pointoutcam2 = sprintf('Camera2');
                 text( x2(i), y2(i), z2(i), number2, 'fontsize', 12, 'color', 'k' );
                 text( x2(length(V2)), y2(length(V2)), z2(length(V2)), pointoutcam2, 'fontsize', 12, 'color', 'k' );
             end
        psi2=psi2+0.05;
    
        % phi=phi+0.05;
        xtar=xtar-0.1;
        ytar=ytar-0.5;
        pause(2)
        drawnow
        end
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

        rho_14=(-3.18)/(b/2*sin(phi)+lambda*cos(phi));
        rho_23=(-3.18)/(-b/2*sin(phi)+lambda*cos(phi));

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
        q1_v2=[a2/2 b2/2];
        q2_v2=[a2/2 -b2/2];
        q3_v2=[-a2/2 -b2/2];
        q4_v2=[-a2/2 b2/2];
        q1_vt2=q1_v2.';
        q2_vt2=q2_v2.';
        q3_vt2=q3_v2.';
        q4_vt2=q4_v2.';

        q1_B2=[q1_vt2; lambda2];
        q2_B2=[q2_vt2; lambda2];
        q3_B2=[q3_vt2; lambda2];
        q4_B2=[q4_vt2; lambda2];

        H_phi2=[cos(psi2) -sin(psi2) 0;
               sin(psi2) cos(psi2)  0
               0 0 1];
        H_phy2=[1 0 0;
               0 cos(phi2) -sin(phi2);
               0 sin(phi2) cos(phi2)];
        q1_I2=H_phi2*H_phy2*q1_B2;
        q2_I2=H_phi2*H_phy2*q2_B2;
        q3_I2=H_phi2*H_phy2*q3_B2;
        q4_I2=H_phi2*H_phy2*q4_B2;

        rho_14_2=(-3.18)/(b2/2*sin(phi2)+lambda2*cos(phi2));
        rho_23_2=(-3.18)/(-b2/2*sin(phi2)+lambda2*cos(phi2));

        q1n_I2=rho_14_2*q1_I2;
        q2n_I2=rho_23_2*q2_I2;
        q3n_I2=rho_23_2*q3_I2;
        q4n_I2=rho_14_2*q4_I2;
        X2=[x2_i;y2_i;z2_i];
        ksai12=X2+q1n_I2;
        ksai22=X2+q2n_I2;
        ksai32=X2+q3n_I2;
        ksai42=X2+q4n_I2;
        v12=ksai12.';
        v22=ksai22.';
        v32=ksai32.';
        v42=ksai42.';
        Cam2=X2.';
        % Vertices
        V2 = [v12;v22;v32;v42;Cam2];
        % Faces
        F2 = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x2 = V2(:, 1);
        y2 = V2(:, 2);
        z2 = V2(:, 3);
    
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        plot3(x2, y2, z2, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
%         numel(xtar(in))
%         numel(xtar(on))
%         numel(xtar(~in))
%         if xtar(~in)
%             disp('Target Not detected!');
%         else xtar(in)
%             disp('Target Detected!');
%         end
         
        xl2 = [v12(:, 1),   v22(:, 1), v32(:, 1), v42(:, 1),  v12(:, 1)];
        yl2 = [v12(:, 2),   v22(:, 2), v32(:, 2),  v42(:, 2),  v12(:, 2)];
        plot(xl2,yl2)  
        [in2,on2] = inpolygon(xtar,ytar,xl2,yl2);
%         numel(xtar(in2))
%         numel(xtar(on2))
%         numel(xtar(~in2))

%         if in
%            disp('Target detected by 1!');
%         elseif in2
%            disp('Target detected by 2!');
        if in && ~in2
            disp('Target Detected by Camera 1!');
        elseif in2 && ~in
            disp('Target Detected by Camera 2!');
        elseif in && in2
            disp('Target Detected by Camera 1&2!');
        elseif ~in && ~in2
            disp('Target Not detected!');
        end
%         elseif 
%            disp('Target Not detected by 2!');

%         if xtar(in)
%            disp('Target detected by 1!');
%         elseif xtar(in2)
%            disp('Target detected by 2!');
%         if xtar(in) & xtar(~in2)
%             fprintf('Target Detected by 1!');
%         elseif xtar(in2) & xtar(~in)
%             fprintf('Target Detected 2!');
%         elseif xtar(in) & xtar(in2)
%             fprintf('Target Detected 1&2!');
%         elseif xtar(~in)& xtar(~in2)
%             fprintf('Target Not detected!');
%         elseif 
%            disp('Target Not detected by 2!');

%             if xtar(in)
%                 disp('Target detected!');
%             elseif xtar(in2)
%                 disp('Target detected!');
%             elseif xtar(~in)&& xtar(~in2)
%                  fprintf('Target Not detected!');
%              end
% disp(in2)
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
                 pointoutcam = sprintf('Camera1');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
        phi=phi+0.08;
        
        Buttomface2 = F2{1};
        Sideface2 = [F2{2:end}];
        Sideface2 = reshape(Sideface2, 3 ,4);
        Sideface2 = Sideface2';
        col2 = [0; 0; 0; 0; 3.18];
        patch('vertices', V2, 'faces', Buttomface2, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V2, 'faces', Buttomface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        patch('vertices', V2, 'faces', Sideface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V2)-1
                 number2 = sprintf('E%d', i);
                 pointoutcam2 = sprintf('Camera2');
                 text( x2(i), y2(i), z2(i), number2, 'fontsize', 12, 'color', 'k' );
                 text( x2(length(V2)), y2(length(V2)), z2(length(V2)), pointoutcam2, 'fontsize', 12, 'color', 'k' );
             end
        phi2=phi2+0.05;
    
        % phi=phi+0.05;
        xtar=xtar-0.1;
        ytar=ytar-0.5;
        pause(2)
        drawnow
     end
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

        rho_14=(-3.18)/(b/2*sin(phi)+lambda*cos(phi));
        rho_23=(-3.18)/(-b/2*sin(phi)+lambda*cos(phi));

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
        q1_v2=[a2/2 b2/2];
        q2_v2=[a2/2 -b2/2];
        q3_v2=[-a2/2 -b2/2];
        q4_v2=[-a2/2 b2/2];
        q1_vt2=q1_v2.';
        q2_vt2=q2_v2.';
        q3_vt2=q3_v2.';
        q4_vt2=q4_v2.';

        q1_B2=[q1_vt2; lambda2];
        q2_B2=[q2_vt2; lambda2];
        q3_B2=[q3_vt2; lambda2];
        q4_B2=[q4_vt2; lambda2];

        H_phi2=[cos(psi2) -sin(psi2) 0;
               sin(psi2) cos(psi2)  0
               0 0 1];
        H_phy2=[1 0 0;
               0 cos(phi2) -sin(phi2);
               0 sin(phi2) cos(phi2)];
        q1_I2=H_phi2*H_phy2*q1_B2;
        q2_I2=H_phi2*H_phy2*q2_B2;
        q3_I2=H_phi2*H_phy2*q3_B2;
        q4_I2=H_phi2*H_phy2*q4_B2;

        rho_14_2=(-3.18)/(b2/2*sin(phi2)+lambda2*cos(phi2));
        rho_23_2=(-3.18)/(-b2/2*sin(phi2)+lambda2*cos(phi2));

        q1n_I2=rho_14_2*q1_I2;
        q2n_I2=rho_23_2*q2_I2;
        q3n_I2=rho_23_2*q3_I2;
        q4n_I2=rho_14_2*q4_I2;
        X2=[x2_i;y2_i;z2_i];
        ksai12=X2+q1n_I2;
        ksai22=X2+q2n_I2;
        ksai32=X2+q3n_I2;
        ksai42=X2+q4n_I2;
        v12=ksai12.';
        v22=ksai22.';
        v32=ksai32.';
        v42=ksai42.';
        Cam2=X2.';
        % Vertices
        V2 = [v12;v22;v32;v42;Cam2];
        % Faces
        F2 = { [4 3 2 1],[1 2 5],[2 3 5], [3 4 5], [4 1 5] };
        x2 = V2(:, 1);
        y2 = V2(:, 2);
        z2 = V2(:, 3);
    
        % % Draw and Mark all the vertices
        plot3(xtar, ytar, ztar, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        marktar = sprintf('Target');
        text( xtar, ytar, ztar, marktar, 'fontsize', 12, 'color', 'k' );
        hold on;
        plot3(x, y, z, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        plot3(x2, y2, z2, '.', 'MarkerSize', 20, 'MarkerFaceColor', 'r',...
        'MarkerEdgeColor', 'b');
        hold on;
        

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        [in,on] = inpolygon(xtar,ytar,xl,yl);
%         numel(xtar(in))
%         numel(xtar(on))
%         numel(xtar(~in))
%         if xtar(~in)
%             disp('Target Not detected!');
%         else xtar(in)
%             disp('Target Detected!');
%         end
         
        xl2 = [v12(:, 1),   v22(:, 1), v32(:, 1), v42(:, 1),  v12(:, 1)];
        yl2 = [v12(:, 2),   v22(:, 2), v32(:, 2),  v42(:, 2),  v12(:, 2)];
        plot(xl2,yl2)  
        [in2,on2] = inpolygon(xtar,ytar,xl2,yl2);
%         numel(xtar(in2))
%         numel(xtar(on2))
%         numel(xtar(~in2))

%         if in
%            disp('Target detected by 1!');
%         elseif in2
%            disp('Target detected by 2!');
        if in && ~in2
            disp('Target Detected by Camera 1!');
        elseif in2 && ~in
            disp('Target Detected by Camera 2!');
        elseif in && in2
            disp('Target Detected by Camera 1&2!');
        elseif ~in && ~in2
            disp('Target Not detected!');
        end
%         elseif 
%            disp('Target Not detected by 2!');

%         if xtar(in)
%            disp('Target detected by 1!');
%         elseif xtar(in2)
%            disp('Target detected by 2!');
%         if xtar(in) & xtar(~in2)
%             fprintf('Target Detected by 1!');
%         elseif xtar(in2) & xtar(~in)
%             fprintf('Target Detected 2!');
%         elseif xtar(in) & xtar(in2)
%             fprintf('Target Detected 1&2!');
%         elseif xtar(~in)& xtar(~in2)
%             fprintf('Target Not detected!');
%         elseif 
%            disp('Target Not detected by 2!');

%             if xtar(in)
%                 disp('Target detected!');
%             elseif xtar(in2)
%                 disp('Target detected!');
%             elseif xtar(~in)&& xtar(~in2)
%                  fprintf('Target Not detected!');
%              end
% disp(in2)
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
                 pointoutcam = sprintf('Camera1');
                 text( x(i), y(i), z(i), number, 'fontsize', 12, 'color', 'k' );
                 text( x(length(V)), y(length(V)), z(length(V)), pointoutcam, 'fontsize', 12, 'color', 'k' );
             end
        psi=psi+0.08;
        phi=phi+0.08;

        Buttomface2 = F2{1};
        Sideface2 = [F2{2:end}];
        Sideface2 = reshape(Sideface2, 3 ,4);
        Sideface2 = Sideface2';
        col2 = [0; 0; 0; 0; 3.18];
        patch('vertices', V2, 'faces', Buttomface2, 'FaceColor', 'white','FaceAlpha',.1);
        patch('vertices', V2, 'faces', Buttomface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        patch('vertices', V2, 'faces', Sideface2,'FaceAlpha',.3,'FaceVertexCData',col2,'FaceColor','interp');
        grid on;
        colorbar
             for i = 1 : length(V2)-1
                 number2 = sprintf('E%d', i);
                 pointoutcam2 = sprintf('Camera2');
                 text( x2(i), y2(i), z2(i), number2, 'fontsize', 12, 'color', 'k' );
                 text( x2(length(V2)), y2(length(V2)), z2(length(V2)), pointoutcam2, 'fontsize', 12, 'color', 'k' );
             end
        psi2=psi2+0.05;
        phi2=phi2+0.05;

        % phi=phi+0.05;
        xtar=xtar-0.1;
        ytar=ytar-0.5;
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

