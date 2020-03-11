hold off;
    m = 1000;
    b = 50;
    u = 10;
    Zo=0.3;
    Po=0.03;
    numo=[1 Zo];
    deno=[m b+m*Po b*Po];

    figure
    hold;
    axis ([-0.6 0 -0.4 0.4])
    rlocus(numo,deno)
    sgrid(0.6,0.36)
    [Kp, poles]=rlocfind(numo,deno)

    figure
    t=0:0.1:20;
    numc=[Kp Kp*Zo];
    denc=[m b+m*Po+Kp b*Po+Kp*Zo];
    axis ([0 20 0 12])
    step (u*numc,denc,t)