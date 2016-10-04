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

void calculeTexture(int colonne) {
  float r, x, y, z;
  float altitude = 0;
  int index;
  
//  noiseSeed(0);
  
  for (int ligne = 0; ligne < nbPixels + 1; ligne++) {
    r = sin( ligne * anglePixel );
    y = -cos( ligne * anglePixel ); 
    x = sin( colonne * anglePixel ) * r;
    z = cos( colonne * anglePixel ) * r;
    
    altitude = 24.0 * noise((x + 1) / TAILLE_RELIEF, (y + 1) / TAILLE_RELIEF, (z + 1) / TAILLE_RELIEF) - 12;
    index = colonne + 2 * ligne * nbPixels;
    imageTextureAvecFond.pixels[index] = couleurAltitudeAvecFond(altitude);
    imageTextureSansFond.pixels[index] = couleurAltitudeSansFond(altitude);
    imageAltitudes.pixels[index] = int(altitude * 1000);   
  }
  
}


void corrigeAltitude(int colonne) {
  color couleur;
  int index;

  for (int ligne = 0; ligne < nbPixels + 1; ligne++) {
    index = colonne + 2 * ligne * nbPixels;
    couleur = imageAltitudes.pixels[index];
    couleur = color(red(couleur), green(couleur),blue(couleur), red(couleur));
    imageAltitudes.pixels[index] = couleur;
  }
}


void calculeDistribution(int colonne) {
  float altitude = 0;
  
  for (int ligne = nbPixels / 4; ligne < 3 * nbPixels / 4; ligne++) {
    altitude = (float) calculeAltitudePixel(colonne, ligne) / 1000;
    
    for (int i = 0; i <= 20; i++) {
      if (altitude < i - 9.5) {
        distribution[i] += 1;
        if (distribution[i] > maxDistribution) maxDistribution = distribution[i];
        break;
      }
    }
  }
  
}

void calculeAltitudes(int colonne) {
  float altitude = 0;

  for (int ligne = 0; ligne <= nbFaces; ligne++) {
    float r = sin( ligne * angleFace );
    y[colonne][ligne] = -cos( ligne * angleFace ); 
    x[colonne][ligne] = sin( colonne * angleFace ) * r;
    z[colonne][ligne] = cos( colonne * angleFace ) * r;
    altitude = calculeAltitudePixel(round((float) colonne * nbPixels / nbFaces), round((float) ligne * nbPixels / nbFaces));
    altitudes[colonne][ligne] = altitude / 1000;
  }
}

void initialiseCamera() {
  r = (altitudeCamera + RAYON_MOYEN) * echelle * cos(radians(latitudeCamera));
  xCam = r * sin(radians(longitudeCamera));
  yCam = -(altitudeCamera + RAYON_MOYEN) * echelle * sin(radians(latitudeCamera));
  zCam = r * cos(radians(longitudeCamera));
 
  camera(xCam, yCam, zCam, 0, 0, 0, 0, 1, 0);
}