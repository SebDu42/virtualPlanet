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
  * Retourne vrai si tous les fichiers nécessaire pour charger la planètre
  * générée lors du dernier chargement sont présents.
  */
boolean fichiersExistent() {
  File fichier;
  
  fichier = new File(sketchPath(NOM_TEXTURE_AVEC_FONDS));
  if (!fichier.exists()) return false;

  fichier = new File(sketchPath(NOM_TEXTURE_SANS_FONDS));
  if (!fichier.exists()) return false;
  
  fichier = new File(sketchPath(NOM_ALTITUDES));
  if (!fichier.exists()) return false;
  
  return true;
}


/**
  * Retourne la couleur correspondant à l'altitude passée en parmètre, en tenant
  * compte également de la profondeur des fonds marins.
  */
color couleurAltitudeAvecFond(float altitude) {
  int r, v, b;
  
  if (altitude > 10) { r = 255; v = 0; b = 0; }
  else if (altitude > 5) { r = 255; v = 255; b = 255; }
  else if (altitude > 2.5) { r = 128; v = 128; b = 128; }
  else if (altitude >= 0) { r = 0; v = 128; b = 0; }
  else if (altitude > -2.5) { r = 0; v = 192; b = 255; }
  else if (altitude > -5) { r = 0; v = 128; b = 255; }
  else if (altitude > -10) { r = 0; v = 0; b = 128; }
  else { r = 255; v = 0; b = 0; }
  
  return r * 65536 + v * 256 + b;
}


/**
  * Retourne la couleur correspondant à l'altitude passée en parmètre, sans
  * tenir compte la profondeur des fonds marins (une seule couleur pour les
  * fonds).
  */
color couleurAltitudeSansFond(float altitude) {
  int r, v, b;
  
  if (altitude > 10) { r = 255; v = 0; b = 0; }
  else if (altitude > 5) { r = 255; v = 255; b = 255; }
  else if (altitude > 2.5) { r = 128; v = 128; b = 128; }
  else if (altitude >= 0) { r = 0; v = 128; b = 0; }
  else { r = 0; v = 128; b = 255; }
  
  return r * 65536 + v * 256 + b;
}

int calculeAltitudePosition(float longitude, float latitude) {
  int x = round((longitude + 180) / degrees(anglePixel));
  int y = round((90 - latitude) / degrees(anglePixel));
  
  return calculeAltitudePixel(x ,y);
}


/**
  * Retourne l'altitude du pixel situé aux corrdonnées (x,y) de l'image
  */
int calculeAltitudePixel(int x, int y) {
 
  if (x < 0) x = 0;
  else if (x >= 2 * nbPixels) x = 2 * nbPixels - 1;
  if (y < 0) y = 0;
  else if (y > nbPixels) y = nbPixels;
  
  color couleur = imageAltitudes.pixels[x + 2 * y * nbPixels];
  //println(x, y, couleur);
  
  return couleur;
}