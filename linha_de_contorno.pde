class linhaContorno {
  float [] v = new float [3];
  PVector [] vCoord = new PVector[3];
  float lim;

  linhaContorno(int triangulo, float recorte, boolean seID) {
    if (seID == true) {
      for (int i = 0; i < 3; i++) {
        v[i] = zSE[3*triangulo+i];
        vCoord[i]=vSE[3*triangulo+i];
        lim = recorte;
      }
    }
    if (seID == false) {
      for (int j = 0; j < 3; j++) {
        v[j] = zID[3*triangulo+j];
        vCoord[j] = vID[3*triangulo+j];
        lim = recorte;
      }
    }
  }

  void LdC() {
    float dist1, dist2;
    int contador_abaixo = 0;                       //
    int contador_acima = 0;                        //
    int posAbaixo = 0;                             //
    int posAcima = 0;                              //
    PShape l1, l2, l3;                            //Arestas que cruzam os recortes de altura
    PVector [] abaixo  = new PVector [v.length];     //
    float   [] abxZ    = new float [v.length];
    PVector [] acima   = new PVector [v.length];     //
    float   [] acmZ    = new float [v.length];
    PVector [] maioria = new PVector [v.length];   //
    float   [] maiorZ  = new float [v.length];
    PVector [] minoria = new PVector [v.length];   //
    float   [] minorZ  = new float [v.length];
    //ArrayList<PVector> abaixo = new ArrayList<PVector>();
    //ArrayList<PVector> acima = new ArrayList<PVector>();
    //ArrayList<PVector> maioria = new ArrayList<PVector>();
    //ArrayList<PVector> minoria = new ArrayList<PVector>();

    for (int i = 0; i < v.length; i++) {
      if (v[i] < lim) {
        abaixo[posAbaixo] =vCoord[i];
        abxZ[posAbaixo] =v[i];
        posAbaixo++;
      } else {
        acima[posAcima] = vCoord[i];
        acmZ[posAcima] = v[i];
        posAcima++;
      }
    }

    for (int j = 0; j < abaixo.length; j++) {
      if (abaixo[j] != null) {
        contador_abaixo++;
      }
    }

    for (int k = 0; k < acima.length; k++) {
      if (acima[k] != null) {
        contador_acima++;
      }
    }

    if (contador_acima == 0 || contador_abaixo == 0) {
      //println("não atravessa");
    } else {
      if (contador_acima < contador_abaixo) {
        arrayCopy(acima, minoria);
        arrayCopy(acmZ, minorZ);
      } else {
        arrayCopy(abaixo, minoria);
        arrayCopy(abxZ, minorZ);
      }

      if (contador_acima > contador_abaixo) {
        arrayCopy(acima, maioria);
        arrayCopy(acmZ, maiorZ);
      } else {
        arrayCopy(abaixo, maioria);
        arrayCopy(abxZ, maiorZ);
      }
      //println(lim);
      //println(v);
      //println(maioria);
      //println(minoria);
      l1 = createShape();
      l1.beginShape(LINES);
      //l1.stroke(0, 255, 255);
      //l1.strokeWeight(1);
      l1.noStroke();
      l1.noFill();
      l1.vertex(minoria[0].x, minoria[0].y, minoria[0].z);
      l1.vertex(maioria[0].x, maioria[0].y, maioria[0].z);
      l1.endShape();
      //shape(l1);

      l2 = createShape();
      l2.beginShape(LINES);
      //l2.stroke(255,0, 0);
      //l2.strokeWeight(1);
      l2.noStroke();
      l2.noFill();
      l2.vertex(minoria[0].x, minoria[0].y, minoria[0].z);
      l2.vertex(maioria[1].x, maioria[1].y, maioria[1].z);
      l2.endShape();
      //shape(l2);

      float v1z, v2z, v3z;
      v1z = minorZ[0];
      v2z = maiorZ[0];
      v3z = maiorZ[1];

      dist1 = ((lim - v2z)/(v1z-v2z));
      dist2 = ((lim - v3z)/(v1z-v3z));

      l3 = createShape();
      l3.beginShape(LINES);
      l3.colorMode(HSB, 360, 100, 100, 100);
      int cor = int(map(lim, 0, amplitude, 270, -90));
      l3.stroke(cor, 100, 80, 100);
      l3.strokeWeight(2);
      l3.vertex(dist1 * minoria[0].x + (1 - dist1) * maioria[0].x, 
        dist1 * minoria[0].y + (1 - dist1) * maioria[0].y);
      l3.vertex(dist2 * minoria[0].x + (1 - dist2) * maioria[1].x, 
        dist2 * minoria[0].y + (1 - dist2) * maioria[1].y);
      l3.endShape();
      shape(l3);
    }
  }
}
