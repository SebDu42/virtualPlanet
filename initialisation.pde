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
  * Première étape de l'initialisation si la planète est recalculée :
  * Calcul des textures et des altitudes de la planète.
  */
void calculePlanete() {
  float r, x, y, z;
  float altitude = 0;
  int index;
  
  etape = CALCULE_ALTITUDES;
  progressionMax = 2 * nbPixels;
  indexProgression = 0;
  
//  noiseSeed(0);
  for (int colonne = 0; colonne < 2 * nbPixels; colonne++) {
    for (int ligne = 0; ligne < nbPixels + 1; ligne++) {
      r = sin( ligne * anglePixel );
      y = -cos( ligne * anglePixel ); 
      x = sin( colonne * anglePixel ) * r;
      z = cos( colonne * anglePixel ) * r;
      
      altitude = 24.0 * noise((x + 1) / TAILLE_RELIEF, (y + 1) / TAILLE_RELIEF, (z + 1) / TAILLE_RELIEF) - 12;
      index = colonne + 2 * ligne * nbPixels;
      imageTextureAvecFonds.pixels[index] = couleurAltitudeAvecFond(altitude);
      imageTextureSansFonds.pixels[index] = couleurAltitudeSansFond(altitude);
      imageAltitudes.pixels[index] = int(altitude * 1000);
    }
    indexProgression++;
  }
  
  enregistreFichiers();

}


/**
  * Deuxième étape de l'initialisation si la planète est recalculée :
  * Enregistrement des textures et des altitudes de la planète pour pouvoir la
  * recharger ultérieurement.
  */
void enregistreFichiers() {
  
  etape = ENREGISTRE_FICHIERS;
  progressionMax = 3;
  indexProgression = 0;
  
  // Enregistrement de la texture avec fonds marins
  imageTextureAvecFonds.updatePixels();
  imageTextureAvecFonds.save(NOM_TEXTURE_AVEC_FONDS);
  indexProgression++;
  
  // Enregistrement de la texture sans fond marins
  imageTextureSansFonds.updatePixels();
  imageTextureSansFonds.save(NOM_TEXTURE_SANS_FONDS);
  indexProgression++;
  
  // Enregistrement des altitudes
  imageAltitudes.updatePixels();
  imageAltitudes.save(NOM_ALTITUDES);
  indexProgression++;
  
  etape = CALCULE_DISTRIBUTION;

}

/**
  * Première étape de l'initialisation si la planète est réchargée :
  * Chargement des textures et des altitudes de la planète.
  */
void chargeFichiers() {
  
  etape = CHARGE_FICHIERS;
  progressionMax = 3;
  indexProgression = 0;

  // Chargement de la texture avec fonds marins
  imageTextureAvecFonds = loadImage(NOM_TEXTURE_AVEC_FONDS);
  imageTextureAvecFonds.loadPixels();
  indexProgression++;

  // Chargement de la texture sans fond marins
  imageTextureSansFonds = loadImage(NOM_TEXTURE_SANS_FONDS);
  imageTextureSansFonds.loadPixels();
  indexProgression++;

  // Chargement des altitudes
  imageAltitudes = loadImage(NOM_ALTITUDES);      
  imageAltitudes.loadPixels();
  indexProgression++;
  
  corrigeAltitudes();
  
}


/**
  * Deuxième étape de l'initialisation si la planète est rechargée :
  * Correction des altitudes. Cette correction est nécessaire car les altitudes
  * sont enregistrer dans une image, et au chargement, le canal Aplha de la
  * couleur n'a pas la bonne valeur.
  */
void corrigeAltitudes() {
  color couleur;
  int index;
  
  etape = CORRIGE_ALTITUDES;
  progressionMax = 2 * nbPixels;
  indexProgression = 0;

  for (int colonne = 0; colonne < 2 * nbPixels; colonne++) {
    for (int ligne = 0; ligne < nbPixels + 1; ligne++) {
      index = colonne + 2 * ligne * nbPixels;
      couleur = imageAltitudes.pixels[index];
      //couleur = color(red(couleur), green(couleur),blue(couleur), red(couleur));
      couleur = (couleur & 0xFFFFFF) | (couleur & 0xFF0000) << 8;
      imageAltitudes.pixels[index] = couleur;
    }
    indexProgression++;
  }
  
  etape = CALCULE_DISTRIBUTION;

}


/** 
  * Troisième étape de l'initialisation :
  * Calcul de la distribution des altitudes.
  */
    
void calculeDistribution() {
  float altitude = 0;
  
  etape = CALCULE_DISTRIBUTION;
  progressionMax = 2 * nbPixels;
  indexProgression = 0;
  
  for (int colonne = 0; colonne < 2 * nbPixels; colonne++) {
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
    indexProgression++;
  }
  
}


void initialiseCamera() {
  r = (altitudeCamera + RAYON_MOYEN) * echelle * cos(radians(latitudeCamera));
  xCam = r * sin(radians(longitudeCamera));
  yCam = -(altitudeCamera + RAYON_MOYEN) * echelle * sin(radians(latitudeCamera));
  zCam = r * cos(radians(longitudeCamera));
 
  camera(xCam, yCam, zCam, 0, 0, 0, 0, 1, 0);
}