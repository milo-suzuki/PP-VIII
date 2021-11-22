//classe
class Triangulo {
  int count;                                    //feed do loop
  PShape se, id;                              //array dos triangulos (superior esquerdo, inferior direito)
  
  //array dos vértices dos triangulos (superior esquerdo, inferior direito)
  int xA;  int xB;  int xC;  int xD;            //coordenadas X dos vértices dos triangulos
  int yA;  int yB;  int yC;  int yD;            //coordenadas Y dos vértices dos triangulos
  float zA;  float zB;  float zC;  float zD;    //coordenadas Z dos vértices dos triangulos

  //construtor
  Triangulo
   (int contador, int x1, int y1, float z1, 
    int x2, int y2, float z2, 
    int x3, int y3, float z3, 
    int x4, int y4, float z4) {
    count = contador;    
    xA = x1;  xB = x2;  xC = x3;  xD = x4;
    yA = y1;  yB = y2;  yC = y3;  yD = y4;
    zA = z1;  zB = z2;  zC = z3;  zD = z4;
    
  }

  //desenha triângulo superior esquerdo
  void tSE () {
    se = createShape();
    se.beginShape();
    if (contaFrames >= 45) {
    se.stroke(255, map(contaFrames,46,90,0,100));
    se.strokeWeight(1);
    }
    else {se.noStroke();}
    se.noFill();
    se.vertex(xA, yA);
    se.vertex(xB, yB);
    se.vertex(xD, yD);
    se.endShape(CLOSE);
    shape(se);
    vSE[(count*3)]=se.getVertex(0);
    vSE[(count*3)+1]=se.getVertex(1);
    vSE[(count*3)+2]=se.getVertex(2);
    zSE[(count*3)]=zA;
    zSE[(count*3)+1]=zB;
    zSE[(count*3)+2]=zD;
  }

  ////função para o triângulo inferior direito
  void tID () {
    id = createShape();
    id.beginShape();    
    id.strokeWeight(1);
    stroke(255);
    id.noFill();
    id.vertex(xB, yB);
    id.vertex(xD, yD);
    id.vertex(xC, yC);
    id.endShape(CLOSE);
    //shape(id);
    vID[(count*3)]=id.getVertex(0);
    vID[(count*3)+1]=id.getVertex(1);
    vID[(count*3)+2]=id.getVertex(2);
    zID[(count*3)]=zB;
    zID[(count*3)+1]=zD;
    zID[(count*3)+2]=zC;
  }
}
