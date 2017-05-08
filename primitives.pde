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
 
/** 
  * Pré-calcule des coordonnées des sommets de la sphère représantant la
  * planète pour accélérer l'affichage.
  * A faire : améliorer la précision en extrapolant les altitudes des points
  * voisins plutôt qu'en prenant l'altitude du point le plus proche.
  */
void calculePrimitive() {
  float altitude = 0;
  
  nbFaces = ceil(PI * RAYON_MOYEN / resolution);
  angleFace = PI / (nbFaces - 1);

  for (int colonne = 0; colonne < 2 * nbFaces - 1; colonne++) { 
    for (int ligne = 0; ligne < nbFaces; ligne++) {
      float r = sin( ligne * angleFace );
      y[colonne][ligne] = -cos( ligne * angleFace ); 
      x[colonne][ligne] = sin( colonne * angleFace ) * r;
      z[colonne][ligne] = cos( colonne * angleFace ) * r;
      altitude = calculeAltitudePosition(colonne * degrees(angleFace) - 180, 90 - ligne * degrees(angleFace));
      altitudes[colonne][ligne] = altitude / 1000;
    }
  }
  
}


/**
  * Dessine la planète.
  */
void dessinePlanete(float rayon, boolean fonds) {
  noStroke();
  
  float latitude = 0;
  float longitude = 0;
  float altitude = 0;

  PImage imageTexture;
  if (fonds) {
     imageTexture = imageTextureAvecFonds;
  }
  else {
     imageTexture = imageTextureSansFonds;
  }
  float pasTextureX = imageTextureAvecFonds.width / (float)(2 * nbFaces - 2);
  float pasTextureY = imageTextureAvecFonds.height / (float)(nbFaces - 1);

  beginShape(TRIANGLE_FAN);
  texture(imageTexture);
  altitude = altitudes[0][0];
  if (!fonds && altitude < 0) {
    altitude = 0;
  } else {
    altitude *= echelleRelief;
  }
  vertex(0, -(rayon + altitude) * echelle, 0, 0, 0);
  for (int colonne = 0; colonne < 2 * nbFaces - 2; colonne++) {
    altitude = altitudes[colonne][1];
    if (!fonds && altitude < 0) {
      altitude = 0;
    } else {
      altitude *= echelleRelief;
    }
    float r = ( rayon + altitude ) * echelle;
    vertex(x[colonne][1] * r, y[colonne][1] * r, z[colonne][1] * r, colonne * pasTextureX, pasTextureY);
  }
  endShape();

  for (int ligne = 1; ligne < nbFaces - 1; ligne++) {
    beginShape(QUAD_STRIP);
    texture(imageTexture);
    for (int colonne = 0; colonne < 2 * nbFaces - 1; colonne++) {
      altitude = altitudes[colonne][ligne];
      if (!fonds && altitude < 0) {
        altitude = 0;
      } else {
        altitude *= echelleRelief;
      }
      float r = ( rayon + altitude ) * echelle;
      vertex(x[colonne][ligne] * r, y[colonne][ligne] * r, z[colonne][ligne] * r, colonne * pasTextureX, ligne * pasTextureY);
      altitude = altitudes[colonne][ligne + 1];
      if (!fonds && altitude < 0) {
        altitude = 0;
      } else {
        altitude *= echelleRelief;
      }
      r = ( rayon + altitude ) * echelle;
      vertex(x[colonne][ligne + 1] * r, y[colonne][ligne + 1] * r, z[colonne][ligne + 1] * r, colonne * pasTextureX, (ligne + 1) * pasTextureY);
    }
    endShape(CLOSE);
  }

  
  beginShape(TRIANGLE_FAN);
  texture(imageTexture);
  altitude = altitudes[0][nbFaces - 1];
  if (!fonds && altitude < 0) {
    altitude = 0;
  } else {
    altitude *= echelleRelief;
  }
  vertex(0, (rayon + altitude) * echelle, 0, 0, (nbFaces - 1) * pasTextureY);
  for (int colonne = 0; colonne < 2 * nbFaces - 2; colonne++) {
    altitude = altitudes[colonne][nbFaces - 2];
    if (!fonds && altitude < 0) {
      altitude = 0;
    } else {
      altitude *= echelleRelief;
    }
    float r = ( rayon + altitude ) * echelle;
    vertex(x[colonne][nbFaces - 2] * r, y[colonne][nbFaces - 2] * r, z[colonne][nbFaces - 2] * r, colonne * pasTextureX, (nbFaces - 2) * pasTextureY);
  }
  endShape();
   
}