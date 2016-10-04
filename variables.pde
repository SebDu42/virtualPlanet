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

// =======================  
// Paramètres des la Terre
// =======================

float echelleRelief = 30.0;
float resolution = 10;
int nbFaces = ceil(PI * RAYON_MOYEN / resolution);
float angleFace = PI / nbFaces;
float angleRotation = 0.0;
float echelle = 1.0 / 10.0;

float[][] altitudes = new float[2 * nbFaces][nbFaces + 1];
float[][] x = new float[2 * nbFaces][nbFaces + 1];
float[][] y = new float[2 * nbFaces][nbFaces + 1];
float[][] z = new float[2 * nbFaces][nbFaces + 1];

int[] distribution = new int[21];
int maxDistribution = 0;

boolean montreAide = false;
boolean montreAltitude = false;
boolean montreDistribution = false;
boolean montreFond = false;
boolean montreInformations = false;
boolean montreViseur = false;
boolean rotation = true;
boolean lumiere = true;

int nbPixels = ceil(PI * RAYON_MOYEN / RESOLUTION_MIN);
float anglePixel = PI / nbPixels;
PImage imageTextureAvecFond = createImage(2 * nbPixels, nbPixels + 1, RGB);
PImage imageTextureSansFond = createImage(2 * nbPixels, nbPixels + 1, RGB);
PImage imageAltitudes = createImage(2 * nbPixels, nbPixels + 1, RGB);
PImage imageArrierePlan;
PImage imageArrierePlan2;

float longitudeCamera = 0.0;
float latitudeCamera = 0.0;
float altitudeCamera = 7000.0;
float pasAngleCamera= 5.0;
float pasAltitudeCamera = 100.0;
float r = (altitudeCamera + RAYON_MOYEN) * echelle * cos(radians(latitudeCamera));
float xCam = r * sin(radians(longitudeCamera));
float yCam = -(altitudeCamera + RAYON_MOYEN) * echelle * sin(radians(latitudeCamera));
float zCam = r * cos(radians(longitudeCamera));

float largeurFenetre;
float hauteurFenetre;

int compteur = 0;
int i = 0;

int etape = 0;
int nbEtapes = 5;
int[] pourcentageEtapes = new int[5];
//int maxProgressionTotale = 2 * nbPixels + 2 * nbFaces + 3;
//int maxProgressionPartielle; 