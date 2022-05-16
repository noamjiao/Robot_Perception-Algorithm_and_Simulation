clc;
clear
close all
% Intake of case
% cs=input('1.Pan angel adjust 2.Tilt angel adjust 3.Pan & Tilt angel adjust: '); 
% Camera FOV model
x_i=2.54;
y_i=2.20;
z_i=3.18;
a=36;
b=27;
lambda=50;
psi=105*pi/180; %pan angel
phi=165*pi/180; %tilt angel
xtar=3.5;
ytar=2.4;
ztar=0;
% x_t=[3.62 3.08 0].';
dpsi=0.1;
dphi=0.1;
s=[psi; phi; dpsi; dphi];

u1=0.01;
u2=0.01;
u=[u1;u2];
% u=[;];                                         
                                                                  
dt=0.01;
b1=0.01;
b2=0.01;

A=[1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
B=[0 0; 0 0; b1 0; 0 b2];
errortilt=0;
errorpan=0;
error_sumpan=0;
error_sumtilt=0;
%%
%%%%%%%%%%
    %%
%  L=4;%
% %  T=0.1;%
% %  x=2;%
% %  y=1;%
%  theta=3*pi/4; %
% 
% %  x_goal=15;%
% %  y_goal=10;%
% %  x_push=[x];
% %  y_push=[y];
% %  theta_push=[];
% %  theta_push=[theta];
%  k=10;%P
%  ki=0.1;%I
%  kd=0.1;%D
%  k2=100;
%  error_sum=0;
%  pre_error=0;
%  %%%%%%

%%
 L=4;%
 T=0.1;%
%  xtrac=xcenter(1);%
%  ytrac=ycenter(1);%
 xtrac=3.43;%
 ytrac=2.44;%
 theta=pi/2;%
 
 x_goal=6;%
 y_goal=5;%
 
 x_p=[xtrac];
 y_p=[ytrac];
 theta_push=[];
 theta_push=[theta];
 
 kp=10;%
 ki=0.1;%
 kd=0.1;%
 
 k2=1;
 error_sum=0;
 pre_error=0;
 %%
 
 for t=0:50
     
     
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

        xl = [v1(:, 1),   v2(:, 1), v3(:, 1), v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),   v2(:, 2), v3(:, 2),  v4(:, 2),  v1(:, 2)];
        plot(xl,yl)
        xcenter=[v1(:, 1)+ v2(:, 1)+v3(:, 1)+v4(:, 1)]/4;
        ycenter=[v1(:, 2)+v2(:, 2)+v3(:, 2)+v4(:, 2)]/4;
        plot(xcenter,ycenter, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        hold on
%         xtrac=xcenter(1);%
%         ytrac=ycenter(1);%
        
        
        
%     
%        theta_goal=atan((ytar-ycenter)/(xtar-xcenter));
%        theta_error=theta-theta_goal;
%        
%        u=k*(theta_error);

  %%
% %%%%
%   
%     %%%
%         theta_tar=atan((ytar-ycenter)/(xtar-xcenter));
%         theta_error=theta-theta_tar;
%         error_sum=error_sum+theta_error;
%         w=-k*(theta_error)+ki*error_sum+kd*(theta_error-pre_error);
%         pre_error=theta_error;
%  
%         test1=xcenter-xtar;
%         test2=(xcenter-xtar)^2+(ycenter-ytar)^2;
%         theta_goal=atan((ytar-ycenter)/(xtar-xcenter));
%         theta_error=theta-theta_goal;
%         w=-k*(theta_error);
        
   %%
%         dist=((xcenter-xtar)^2+(ycenter-ytar)^2)^(1/2);
%         v=k2*dist;
%         
%         dist=((xcenter-xtar)^2+(ycenter-ytar)^2)^(1/2);
%         u=k2*dist;
%  
%  
%  vr=v+w*L/2; %
%  vl=v-w*L/2; %
%  
%  %%process model
%  
%  %
%  v=(vl+vr)/2;%
%  w=(vr-vl)/L;
%  xcenter=xcenter+v*cos(theta)*t;
%  ycenter=ycenter+v*sin(theta)*t;
%  theta=theta+w*t;
%  
% 
%  x_push=[x_push;x];
%  y_push=[y_push;y];
%  theta_push=[theta_push;theta];

%% control


%                 lenpsi1 = sqrt((x_i - xcenter) ^2 + (y_i - ycenter) ^2); 
%                 lenpsi2 = sqrt((xcenter - xtar) ^2 + (ycenter - ytar) ^2); 
%                 lenpsi3 = sqrt((x_i - xtar) ^2+ (y_i - ytar) ^2); 
%                 errorpsi = acos((lenpsi3 ^2+ lenpsi1^2 - lenpsi2^2) / (2 * lenpsi3 * lenpsi1));


%         lenphi1 = ((x_i - xcenter)^2+ (y_i - ycenter)^2 + (z_i ^2)).^(1/3);
%         lenphi2 = sqrt((xcenter - xtar) ^2 + (ycenter - ytar) ^2);
%         lenphi3 = ((x_i - xtar) ^2 + (y_i - ytar) ^2 + (z_i ^2)).^(1/3); 
% 
%         errorphi = acos((lenpsi3 ^2+ lenpsi1^2 - lenpsi2^2) / (2 * lenpsi3 * lenpsi1));

            lenctilt=abs(ycenter-y_i);
            lenttilt=abs(ytar-y_i);
            if ytar<0
            errortilt=atan(lenctilt/z_i)-atan(lenttilt/z_i);
            else
            errortilt=-(atan(lenctilt/z_i)-atan(lenttilt/z_i));
            end

            if xcenter*ycenter<0
                                  errorpan=atan(abs(xcenter/ycenter))-atan(abs(xtar/ytar));
            else
                                   errorpan=-(atan(abs(xcenter/ycenter))-atan(abs(xtar/ytar)));

            end
                

        dist=sqrt((xcenter - xtar)^2+(ycenter - ytar) ^2);
        disp(dist);
        
% 
%             error_sumpan=error_sumpan+errorpan;
%             error_sumtilt=error_sumtilt+errortilt;
%             ki=50;
% %         u(1) = -50 * errorpan+ki*error_sumpan;  %
% %         u(2) = -50 * errortilt+ki*error_sumtilt;  
        
        u(1) = -125* errorpan;  %
        u(2) = -28 * errortilt;  %

        
        


%%
         s=A*s+B*u;
                
        [in,on] = inpolygon(xtar,ytar,xl,yl);
        numel(xtar(in));
        numel(xtar(on));
        numel(xtar(~in));
        
        if xtar(~in)
            disp('Target Not detected!');
        else xtar(in)
            disp('Target Detected!');
         end

%              xtrac=3.43;%
%              ytrac=2.44;%
        % xl = [v1(:, 1),  v3(:, 1), v2(:, 1),  v4(:, 1),  v1(:, 1),  2.54, v4(:, 1), 2.54,  v3(:, 1),  2.54,  v2(:, 1)];
        % yl = [v1(:, 2),  v3(:, 2),  v2(:, 2),  v4(:, 2),  v1(:, 2),  2.20,  v4(:, 2),  2.20, v3(:, 2),  2.20, v2(:, 2)];
        % zl = [v1(:, 3), v3(:, 3),v2(:, 3), v4(:, 3), v1(:, 3), 3.18, v4(:, 3), 3.18, v3(:, 3), 3.18, v2(:, 3)];
        % plot3(xl,yl,zl)
        xtarg=5;

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
        % s1=s1+0.05;
        % phi=phi+0.05;
%         xcent=10*xtarg;
        
  
        xtar=xtar+0.05;
        ytar=ytar+0.05;
  


        pause(0.01)
        drawnow
 end
 pause(1)
 while((xtrac-x_goal)^2+(ytrac-y_goal)^2 >0&&(xtrac-x_goal<=0)) 
  %%%
    %%%
        test1=xtrac-x_goal;
        theta_goal=atan((y_goal-ytrac)/(x_goal-xtrac));
        theta_error=theta-theta_goal;
        error_sum=error_sum+theta_error;
        w=-kp*(theta_error)+ki*error_sum+kd*(theta_error-pre_error);
        pre_error=theta_error;
        
   %%%%    
        dist=((xtrac-x_goal)^2+(ytrac-y_goal)^2)^(1/2);
        v=k2*dist;
        
 %%%%
 
 vr=v+w*L/2;%
 vl=v-w*L/2;%
 
 
 
 %%%%process model
 
 %%%
 v=(vl+vr)/2;%
 w=(vr-vl)/L;
 xtrac=xtrac+v*cos(theta)*T;
 ytrac=ytrac+v*sin(theta)*T;
 theta=theta+w*T;
 x_p=[x_p;xtrac];
 y_p=[y_p;ytrac];
 theta_push=[theta_push;theta];

 end
 figure
plot(x_p,y_p,'+')

 xlabel("X")
 ylabel("Y")
 title("Tracking with a given start/end point and heading angle")