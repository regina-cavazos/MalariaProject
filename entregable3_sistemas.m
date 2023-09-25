%Entregable 3 - Equipo 2
clc
clear

%Constante
Ke=8.9876e9;

%Preguntar al usuario por el tamaño del alambre
LCN = input("Longitud del cable de cargas negativas: ");
LCP = input("Longitud del cable de cargas positivas: ");

%Distancias
DH = input("Distancia horizontal entre los alambres de carga negativa y positiva (Eje X): ");

%Valor de lambda
LP = 4;
LN = -4;

%Calculo de las cargas para que las lambdas sean iguales
QP = LCP*LP;
QN = LCN*LN;

%Cantidad de cargas en el cable
CP = floor(LCP/0.15);%0.3 %0.15
CN = floor(LCN/0.15);%0.3 %0.15

%Diferencial de posicion en el eje Y
DVP = LCP/CP;
DVN = LCN/CN;

%Creacion de intervalos de representacion grafica de las cargas
if ((DVP*CP)>=(DVN*CN) && (0.9*DVP*CP)>=(1.2*DH))
    Vx=(-(0.9*DVP*CP):0.3:(0.9*DVP*CP));%0.6 %0.3
    Vy=(-(0.9*DVP*CP):0.3:(0.9*DVP*CP));%0.6 %0.3

elseif ((DVN*CN)>=(DVP*CP) && (0.9*DVN*CN)>=(1.2*DH))
    Vx=(-(0.9*DVN*CN):0.3:(0.9*DVN*CN));%0.6 %0.3
    Vy=(-(0.9*DVN*CN):0.3:(0.9*DVN*CN));%0.6 %0.3

else
    Vx=(-(1.2*DH):0.3:(1.2*DH));%0.6 %0.3
    Vy=(-(1.2*DH):0.3:(1.2*DH));%0.6 %0.3

end

%Malla de vectores
[X,Y] = meshgrid(Vx,Vy);

%Vectores de Posicion
XCP = [];
YCP = [];
XCN = [];
YCN = [];

%Posicion inicial en el eje Y
DYIP = ((CP * DVP) -DVP)/ 2;
DYIN = ((CN * DVN) -DVN)/ 2;

%Calculo de Posicion de las Cargas Positivas
for i = 1 : CP
    XCP(i) = -(DH/2);
    YCP(i) = DYIP;
    DYIP = DYIP - DVP;
end

%Calculo de Posicion de las Cargas Negativas 
for i = 1 : CN
    XCN(i) = (DH/2);
    YCN(i) = DYIN;        
    DYIN = DYIN - DVN;
end

%Creacion de Vectores de Carga
CEPX (1:length(Vy),1:length(Vx)) = 0;
CEPY (1:length(Vy),1:length(Vx)) = 0;
CENX (1:length(Vy),1:length(Vx)) = 0;
CENY (1:length(Vy),1:length(Vx)) = 0;

%Creacion de Vectores de Distancias de las Cargas Positivas
RP = [];
DPX = [];
DPY = [];

%Creacion de Vectores de Distancias de las Cargas Negativas
RN = [];
DNX = [];
DNY = [];

%Ecuaciones
for k = 1: CP
    for i = 1 : (length(Vy))
        for j = 1: (length(Vx))
           RP(i,j) = sqrt((X(i,j)-XCP(k)).^2 + (Y(i,j)-YCP(k)).^2);
           DPX(i,j) = X(i,j)-XCP(k);
           DPY(i,j) = Y(i,j)-YCP(k);
           CEPX(i,j) = CEPX(i,j) + (Ke*(LP/(RP(i,j))^2))*(DPX(i,j)/RP(i,j));
           CEPY(i,j) = CEPY(i,j) + (Ke*(LP/(RP(i,j))^2))*(DPY(i,j)/RP(i,j));
        end
    end
end

for k = 1: CN
    for i = 1 : (length(Vy))
        for j = 1: (length(Vx))
           RN(i,j) = sqrt((X(i,j)-XCN(k)).^2+(Y(i,j)-YCN(k)).^2);
           DNX(i,j) = X(i,j)-XCN(k);
           DNY(i,j) = Y(i,j)-YCN(k);
           CENX(i,j) = CENX(i,j) + (Ke*(LN/(RN(i,j))^2))*(DNX(i,j)/RN(i,j));
           CENY(i,j) = CENY(i,j) + (Ke*(LN/(RN(i,j))^2))*(DNY(i,j)/RN(i,j));
        end
    end
end

%Suma de resultados
CETX = CEPX + CENX;
CETY = CEPY + CENY;

%Calculo dle vectro resultante del campo 
CET = sqrt(CETX.^2 + CETY.^2);

%Grafica del Campo Positivo
figure(Name="Prueba Stream Campo Positivo")
streamslice(X,Y,CEPX,CEPY);
hold on
plot(XCP,YCP,"r*")
hold off

%Grafica del Campo Negativo
figure(Name="Prueba Campo Negativo")
streamslice(X,Y,CENX,CENY);
hold on
plot(XCN,YCN,"b*")
hold off

%Grafica de los Resultados
figure(Name="Resultados Streamslice")
plot(XCN,YCN,"b*")
hold on
plot(XCP,YCP,"r*")
streamslice(X,Y,CETX,CETY);
legend("Carga Negativa","Carga Positiva","Vectores")
hold off

%Grafica con color
figure(Name="Prueba Colores")
pcolor(X,Y,CET); colormap jet; shading interp;
h2 = streamslice(X,Y,CETX,CETY,2);
set(h2,"Color",[1 1 1]);
set(h2,"LineWidth",1.5);