clear all;
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
        xl = [v1(:, 1),  v3(:, 1), v2(:, 1),  v4(:, 1),  v1(:, 1)];
        yl = [v1(:, 2),  v3(:, 2),  v2(:, 2),  v4(:, 2),  v1(:, 2)];
        [in,on] = inpolygon(xtar,ytar,xl,yl);
        plot(xl,yl)
        numel(xtar(in))
        numel(xtar(on))
        numel(xtar(~in))
        if xtar(in)
            disp('Not detected');
        else xtar(~in)
            disp('Detected');
         end