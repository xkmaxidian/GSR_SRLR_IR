function [Par] = Deblock_Par_Set(JPEG_Quality)

Par.Iter = 100;
Par.step = 4;
Par.patch = 7;
Par.Sim = 60;

if JPEG_Quality <= 10
    Par.gamma = 0.1;
    Par.lamada = 0.7;
    Par.omega = 1.5;
    Par.tau = 12E3;
    Par.c1 = 0.2;
    Par.c2 = 0.3;
    Par.p = 0.9 ;
    Par.Error = 0.0001;
    Par.Qfactor = 0.25;
elseif JPEG_Quality <= 20
    Par.gamma = 0.1;
    Par.lamada = 0.8;
    Par.omega = 1.5;
    Par.tau = 10E3;
    Par.c1 = 0.2;
    Par.c2 = 0.3;
    Par.p = 0.8;
    Par.Error = 0.0001;
    Par.Qfactor = 0.25;
elseif JPEG_Quality <= 30
    Par.gamma = 0.1;
    Par.lamada = 1;
    Par.omega = 1.5;
    Par.tau = 9E3;
    Par.c1 = 0.2;
    Par.c2 = 0.3;
    Par.p = 0.2;
    Par.Error = 0.000076;
    Par.Qfactor = 0.25;
elseif JPEG_Quality <= 40
    Par.gamma = 0.1;
    Par.lamada = 1;
    Par.omega = 1.5;
    Par.tau = 7E3;
    Par.c1 = 0.5;
    Par.c2 = 0.5;
    Par.p = 0.2;
    Par.Error = 0.00005;
    Par.Qfactor = 0.25;
else
    Par.gamma = 0.1;
    Par.lamada = 1;
    Par.omega = 1.5;
    Par.tau = 5E3;
    Par.c1 = 0.5;
    Par.c2 = 0.5;
    Par.p = 0.1;
    Par.Error = 0.0001;
    Par.Qfactor = 0.25;
end

end