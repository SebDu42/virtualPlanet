/*
    Virtual Planet
 Copyright (C) 2016 Sébastien Dupuis
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Dessine la planete
void dessinePlanete(float res, float rayon, boolean fond) {
  noStroke();
  float latitude = 0;
  float longitude = 0;
  float altitude = 0;

  PImage imageTexture;
  if (fond) {
     imageTexture = imageTextureAvecFond;
  }
  else {
     imageTexture = imageTextureSansFond;
  }
  float pasTextureX = imageTextureAvecFond.width / (float)(2 * nbFaces - 1);
  float pasTextureY = imageTextureAvecFond.height / (float)(nbFaces - 1);

  
  for (int i = 0; i < 2 * nbFaces; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(imageTexture);
    altitude = altitudes[0][0];
    if (!fond && altitude < 0) {
      fill(couleurAltitudeAvecFond(-4));
      altitude = 0;
    } else {
      fill(couleurAltitudeAvecFond(altitude));
      altitude *= echelleRelief;
    }
    vertex(0, -( rayon + altitude) * echelle, 0, 0, 0);
    for (int j = 1; j < nbFaces; j++) {
      altitude = altitudes[i][j];
      if (!fond && altitude < 0) {
        fill(couleurAltitudeAvecFond(-4));
        altitude = 0;
      } else {
        fill(couleurAltitudeAvecFond(altitude));
        altitude *= echelleRelief;
      }
      float r = ( rayon + altitude ) * echelle;
      vertex(x[i][j] * r, y[i][j] * r, z[i][j] * r, i * pasTextureX, j * pasTextureY);
      if (i < 2 * nbFaces - 1) altitude = altitudes[i + 1][j];
      else altitude = altitudes[0][j];
      if (!fond && altitude < 0) {
        fill(couleurAltitudeAvecFond(-4));
        altitude = 0;
      } else {
        fill(couleurAltitudeAvecFond(altitude));
        altitude *= echelleRelief;
      }
      r = (rayon + altitude ) * echelle;
      if (i < 2 * nbFaces - 1) vertex(x[i+1][j] * r, y[i+1][j] * r, z[i+1][j] * r,  (i+1) * pasTextureX, j * pasTextureY);
      else vertex(x[0][j] * r, y[0][j] * r, z[0][j] * r, (i+1) * pasTextureX, j * pasTextureY);
    }
    altitude = altitudes[0][nbFaces];
    if (!fond && altitude < 0) {
      fill(couleurAltitudeAvecFond(-4));
      altitude = 0;
    } else {
      fill(couleurAltitudeAvecFond(altitude));
      altitude *= echelleRelief;
    }
    vertex(0, ( rayon + altitude) * echelle, 0, 0, imageTexture.height - 1);
    endShape(CLOSE);
  }
}


// Dessine un cylindre
void dessineCylindre(int NOMBRE_FACESs, float diametre, float hauteur) {
  float angle = 360 / NOMBRE_FACESs;
  float rayon = diametre / 2;
  float demiHauteur = hauteur / 2;

  // Dessine le disque supérieur
  beginShape();
  for (int i = 0; i < NOMBRE_FACESs; i++) {
    float x = cos( radians( i * angle ) ) * rayon;
    float z = sin( radians( i * angle ) ) * rayon;
    vertex(x, -demiHauteur, z);
  }
  endShape(CLOSE);

  // Dessine le disque inférieur
  beginShape();
  for (int i = 0; i < NOMBRE_FACESs; i++) {
    float x = cos( radians( i * angle ) ) * rayon;
    float z = sin( radians( i * angle ) ) * rayon;
    vertex(x, demiHauteur, z);
  }
  endShape(CLOSE);

  // Dessine le corps
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < NOMBRE_FACESs + 1; i++) {
    float x = cos( radians( i * angle ) ) * rayon;
    float z = sin( radians( i * angle ) ) * rayon;
    vertex( x, demiHauteur, z);
    vertex( x, -demiHauteur, z);
  }
  endShape(CLOSE);
}

// Dessine un cône
void dessineCone(int NOMBRE_FACESs, float diametre, float hauteur) {
  float angle = 360 / NOMBRE_FACESs;
  float rayon = diametre / 2;
  float demiHauteur = hauteur / 2;

  // Dessine le disque inférieur
  beginShape();
  for (int i = 0; i < NOMBRE_FACESs; i++) {
    float x = cos( radians( i * angle ) ) * rayon;
    float z = sin( radians( i * angle ) ) * rayon;
    vertex(x, demiHauteur, z);
  }
  endShape(CLOSE);

  // Dessine le corps
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < NOMBRE_FACESs + 1; i++) {
    float x = cos( radians( i * angle ) ) * rayon;
    float z = sin( radians( i * angle ) ) * rayon;
    vertex( x, demiHauteur, z);
    vertex( 0, -demiHauteur, 0);
  }
  endShape(CLOSE);
}