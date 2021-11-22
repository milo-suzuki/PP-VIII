//projeção no espaço
float [][] grid;                //vetor bidimensional das coordenadas de elevação dos vértices
float [][] gridVis;
float [][] gridBackup;
int passo;
int cols, rows, scl;            //quantidade colunas, linhas, e o tamanho das células
int amplitude;                  //amplitude das coordenadas de elevação
int altura, incr;               //incremento da varredura das alturas, e incremento do loop
Triangulo[] t1, t2;             //vetor dos triangulos da malha: superior esquerdo e inferior direito 
PVector[] vSE, vID, v;          //vetor dos vértices dos triangulos Superior Esquerdo, Inferior Direito, e dos vértices da função ldc(linha de contorno)
float [] zSE, zID;              //vetor unidimensional das coordenadas de elevação 
int contador = 0;
boolean seID;                   //booleana para determinar função lcd nos triangulos SE/ID
float lim, ajusteX, ajusteY, mov; //recorte de altura
float ajusteXY;
int contaFrames;
//Visitantes
PShape [] vetorVisitas;
int contadorVis;
int [] visX;
int [] visY;
int tamVis;
long seed;
float max_distance;
boolean visitante; 
int visitantes;
float visMovX [];
float visMovY[];
float visx0[];
float visy0 [];
boolean showCentro;

import processing.sound.*;

SoundFile soundfile;

void setup () {
  size(1500, 560);  //52.74m x 19,70m (20px/m)
  max_distance = dist(0, 0, width, height);
  soundfile = new SoundFile(this, "vibraphon.aiff");
  println(soundfile.frames());
  soundfile.loop();
  //noCursor();
  //fullScreen();
  frameRate(24);
  contaFrames = 0;
  showCentro = false;
  seed = (long)random(1000);
  println(seed);
  passo = 0;
  visitante = false;
  visx0 = new float [1000];
  for (int i = 0; i < 1000; i++) {
    visx0[i] = random(0, width);
  }
  visy0 = new float [1000];
  for (int i = 0; i < 1000; i++) {
    visy0[i] = random(0, height);
  }
  visMovX = new float [1000];
  for (int i = 0; i < 1000; i++) {
    visMovX[i] = random (10, 15);
  }
  visMovY = new float [1000];  
  for (int i = 0; i < 1000; i++) {
    visMovY[i] = random (10, 15);
  }
  visitantes = 1;

  scl       = 25;            //zoom in: 25px 
  amplitude = 750;           //valor máximo
  incr      = 25;            //intervalo de varreduras da altura das linhas de contorno
  ajusteXY  = 0.1;          //

  contador  = 0;
  altura    = 0;
  cols      = (width/scl);
  rows      = (height/scl);


  //Variáveis p/ a malha de triangulos
  t1   = new Triangulo  [cols*rows]; //objeto tSE da classe Triangulo
  vSE  = new PVector    [t1.length*3];
  zSE  = new float      [t1.length*3];
  t2   = new Triangulo  [cols*rows];
  vID  = new PVector    [t2.length*3];
  zID  = new float      [t2.length*3];
  grid = new float      [cols+1][rows+1];
  gridVis = new float      [cols+1][rows+1];
  gridBackup = new float      [cols+1][rows+1];

  //Variáveis p/ os visitantes
  vetorVisitas = new PShape [200];
  visX = new int[200];
  visY = new int[200];
  tamVis = 50;
  contadorVis = 0;

  //Passo 0: listar valores de altura para as coordenadas
  for (int m = 0; m <= cols; m++) {
    float ajusteX = 0;
    for (int n = 0; n <= rows; n++) {
      grid[m][n]= map(noise(ajusteX, ajusteY), 0, 1, 0, amplitude);
      ajusteX = ajusteX + ajusteXY;
    }
    ajusteY = ajusteY + ajusteXY;
  }
  for (int m = 0; m <= cols; m++) {
    for (int n = 0; n <= rows; n++) {
      gridBackup[m][n] = grid[m][n];
    }
  }
  for (int m = 0; m <= cols; m++) {
    float ajusteX = 0;
    for (int n = 0; n <= rows; n++) {
      gridVis[m][n]= map(noise(ajusteX, ajusteY), 0, 1, 0, amplitude);
      ajusteX = ajusteX + ajusteXY;
    }
    ajusteY = ajusteY + ajusteXY;
  }
}

void draw () {
  background(0);

  //Passo 1: Cobrir a área com triângulos
  for (int m = 0; m < cols; m++) {
    for (int n = 0; n < rows; n++) {
      t1[contador] = new Triangulo(contador, //contador
        m*scl, n*scl, grid[m][n], //x,y,z de A
        (m+1)*scl, n*scl, grid[m+1][n], //x,y,z de B
        (m+1)*scl, (n+1)*scl, grid[m+1][n+1], //x,y,z de C
        m*scl, (n+1)*scl, grid[m][n+1]);   //x,y,z de D

      t2[contador] = new Triangulo(contador, //contador
        m*scl, n*scl, grid[m][n], //x,y,z de A
        (m+1)*scl, n*scl, grid[m+1][n], //x,y,z de B
        (m+1)*scl, (n+1)*scl, grid[m+1][n+1], //x,y,z de C
        m*scl, (n+1)*scl, grid[m][n+1]);   //x,y,z de D

      t1[contador].tSE();
      t2[contador].tID();

      contador++;
      if (contador == t1.length) {
        contador =0;
      }
    }
  }


  linhaContorno [] ldc1 = new linhaContorno[cols*rows];
  linhaContorno [] ldc2 = new linhaContorno[cols*rows];



  lim = altura;
  altura++;

  if (lim >= incr || lim< 0) {
    altura=0;
  }

  //Passo 3 e 4: Encontra as intersecções da linha de contorno com os triângulo e as desenha
  for (int i = 0; i < t1.length; i++) {
    seID = true;
    for (int l = 0; l < amplitude-incr; l+=incr) {
      ldc1[i] = new linhaContorno(i, lim+l, seID);
      ldc1[i].LdC();
    }

    seID = false;
    for (int m =0; m < amplitude-incr; m+=incr) {
      ldc2[i] = new linhaContorno(i, lim+m, seID);
      ldc2[i].LdC();
    }
  }





  for (int v = 0; v < vetorVisitas.length; v++) {
    colorMode(RGB, 255, 255, 255, 100);
    fill(255, 100);
    noStroke();
    if ( vetorVisitas[v] != null ) {
      shape(vetorVisitas[v]);
    }
  }





  if (visitante) {
    float sumX = 0;
    float sumY = 0;
    float xVermelho = 0;
    float yVermelho = 0;
    for (int v = 0; v < visitantes; v++) {
      if (visx0[v] < 0 || visx0[v] > width) {
        visMovX[v] = -visMovX[v];
      } 
      if (visy0[v] < 0 || visy0[v] > height) {
        visMovY[v] = -visMovY[v];
      }
      visx0[v] += visMovX[v];
      visy0[v] += visMovY[v];
      sumX +=visx0[v];
      sumY +=visy0[v];
      for (int vis = 0; vis < visitantes; vis++) {
        for (int visita = 0; visita < visitantes; visita++) {
          if (dist(visx0[vis], visy0[vis], visx0[visita], visy0[visita]) <= 90 && vis != visita) {
            pushStyle();
            noFill();
            stroke(255);
            strokeWeight(3);
            ellipse(visx0[vis], visy0[vis], 45, 45);
            ellipse(visx0[visita], visy0[visita], 45, 45);
            popStyle();
          }
        }
      }

      ellipse (visx0[v], visy0[v], scl, scl);
    }

    xVermelho = sumX/visitantes;
    yVermelho = sumY/visitantes;
    endShape(CLOSE);

    if (showCentro) {
      pushStyle();
      fill(255, 0, 0);
      ellipse(xVermelho, yVermelho, 30, 30);
      popStyle();
    }
    float playbackSpeed = map(xVermelho, 0, width, 0.85, 1.25);
    soundfile.rate(playbackSpeed);

    // Map mouseY from 0.2 to 1.0 for amplitude
    float amplitude = map(yVermelho, 0, height, 0.5, 1.0);
    soundfile.amp(amplitude);

    // Map mouseY from -1.0 to 1.0 for left to right panning
    //float panning = map(yVermelho, 0, height, -0.5, 1);
    //soundfile.pan(panning);

    for (int i = 0; i <= width; i +=scl) {
      for (int j = 0; j <= height; j +=scl) {
        float size = dist(xVermelho, yVermelho, i, j);
        size = max_distance/size;
        if (grid[i/scl][j/scl] < incr ) {
          grid[i/scl][j/scl]=gridBackup[i/scl][j/scl];
        } else {
          grid[i/scl][j/scl] = size * (gridBackup [i/scl][j/scl] + gridVis[i/scl][j/scl])*1/15;
        }
      }
    }
  } else {
    for (int m = 0; m <= cols; m++) {
      for (int n = 0; n <= rows; n++) {
        grid[m][n] = gridBackup[m][n];
      }
    }
  }
}


void keyTyped() {
  if (key == 'a' || key == 'A') {
    visitante = !visitante;
  } else if (key == 'd' || key == 'D') {
    visitantes++;
  } else if (key == 's' || key == 'S') {
    visitantes--;
  } else if (key == 'w' || key == 'W') {
    showCentro = !showCentro;
  }
}
