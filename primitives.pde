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

  for (int colonne = 0; colonne <= 2 * nbFaces; colonne++) { 
    for (int ligne = 0; ligne <= nbFaces; ligne++) {
      float r = sin( ligne * angleFace );
      y[colonne][ligne] = -cos( ligne * angleFace ); 
      x[colonne][ligne] = sin( colonne * angleFace ) * r;
      z[colonne][ligne] = cos( colonne * angleFace ) * r;
      altitude = calculeAltitudePixel(round((float) colonne * nbPixels / nbFaces), round((float) ligne * nbPixels / nbFaces));
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
  float pasTextureX = imageTextureAvecFonds.width / (float)(2 * nbFaces - 1);
  float pasTextureY = imageTextureAvecFonds.height / (float)(nbFaces - 1);

  
  for (int i = 0; i < 2 * nbFaces; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(imageTexture);
    altitude = altitudes[0][0];
    if (!fonds && altitude < 0) {
      fill(couleurAltitudeAvecFond(-4));
      altitude = 0;
    } else {
      fill(couleurAltitudeAvecFond(altitude));
      altitude *= echelleRelief;
    }
    vertex(0, -( rayon + altitude) * echelle, 0, 0, 0);
    for (int j = 1; j < nbFaces; j++) {
      altitude = altitudes[i][j];
      if (!fonds && altitude < 0) {
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
      if (!fonds && altitude < 0) {
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
    if (!fonds && altitude < 0) {
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