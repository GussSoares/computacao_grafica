graphics_toolkit("gnuplot");

global x1 x2 y1 y2 ponto;

function r_bresenham = bresenham (x1, y1, x2, y2, dx, dy)
    %dx = x2 - x1
    %dy = y2 - y1
    d = 2*dy - dx;
    incE = 2*dy;
    incNE = 2*(dy - dx);
    x = x1;
    y = y1;
    pontos = [x y];
    while(x < x2)
        if(d < 0)
              d = d + incE;
        else
            d = d + incNE;
            y = y + 1;
        endif
        x = x + 1;
        pontos = [pontos; x y];
    endwhile
    r_bresenham = pontos;
endfunction

function r_prim_oct = prim_oct(x1, y1, x2, y2)
    declive = 0;
    simetrico = 0;
    dx = x2 - x1;
    dy = y2 - y1;

    if (dx*dy < 0)
        y1 = y1*(-1);
        y2 = y2*(-1);
        dy = dy*(-1);
        simetrico = 1;
    endif    
    if (abs(dx) < abs(dy))
        aux1 = x1;
        aux2 = x2;
        x1 = y1;
        x2 = y2;
        y1 = aux1;
        y2 = aux2;
        aux_d = dx;
        dx = dy;
        dy = aux_d;
        declive = 1;
    endif    
    if (x1 > x2)
        aux_x = x1;
        x1 = x2;
        x2 = aux_x;
        aux_y = y1;
        y1 = y2;
        y2 = aux_y;
        dx = dx*(-1);
        dy = dy*(-1);
    endif    
    pontos = bresenham(x1, y1, x2, y2, dx, dy);
    
    if (declive  == 1)
        for i = 1:length(pontos)
            aux = pontos(i,1);
            pontos(i,1) = pontos(i,2);
            pontos(i,2) = aux;
        endfor
    endif
    if (simetrico == 1)
        for i = 1:length(pontos)
            pontos(i,2) = pontos(i,2)*(-1);
        endfor    
    endif  
      
    r_prim_oct = pontos;
endfunction

function plotPixel(a, color)
    plot(a(1), a(2), color);
    hold on;
endfunction

function plotLine(a, color)
    a = transpose(a);
    plot(a(1:1:1), a(2:1:2));
    hold on;
endfunction

function plotTriangle (a, b, c)
    a = transpose(a);
    b = transpose(b);
    c = transpose(c);
    plot(a(1,:), a(2,:), '-r', 'linewidth', 3,
         b(1,:), b(2,:), '-g', 'linewidth', 3,
         c(1,:), c(2,:), '-b', 'linewidth', 3);
endfunction  

figure
h1 = axes

% defino os pontos
ponto1 = [50 450];
ponto2 = [400 250];
ponto3 = [350 450];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RASTERIZAÇÃO DE PONTOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plotPixel(ponto1, '-r');
%plotPixel(ponto2, '-g');
%plotPixel(ponto3, '-b');

% gera as retas a partir dos pontos inicial e final.
% Os pontos são rasterizados para o primeiro octante.
a = prim_oct(ponto1(1),ponto1(2),ponto2(1),ponto2(2));
b = prim_oct(ponto2(1),ponto2(2),ponto3(1),ponto3(2));
c = prim_oct(ponto3(1),ponto3(2),ponto1(1),ponto1(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RASTERIZAÇÃO DE LINHAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plotLine(a, '-r');
%plotLine(b, '-g');
%plotLine(c, '-b');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESENHO DO TRIANGULO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plota o triangulo passando as retas que o definem
plotTriangle(a, b, c);

% para ficar parecido com a figura desejada na especificação do trabalho
% o eixo Y é invertido e o fundo é setado para preto
set(h1, 'Ydir', 'reverse');
set(h1, 'Color', 'k');