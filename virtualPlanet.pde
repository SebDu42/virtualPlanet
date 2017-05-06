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
  * Virtual Planet
  *
  * Cette application permet de générer puis d'afficher une planète aux 
  * reliefs aléatoires. Il est ensuite possible d'afficher des informations
  * altimétriques sur un point de la surface ciblé par un viseur.
  * Elle a été dévellopée pour être utilisée en lycée en cours de Sciences de la
  * Vie et de la Terre, afin de montrer que les reliefs de la Terre ne peuvent
  * pas être le résultat d'un processus aléatoire, car de tel processus donnent
  * une répartition gaussienne des altitudes.
  *
  * La résolution et d'un point altimétrique tous les 10kms au niveau de
  * l'équateur, avec un précision de l'altitude au mètre près.
  *
  * @author Sébastien Dupuis
  * @version 1.0.1
  */


/**
  * Initialisation
  */
void setup() {
  size(1024, 768, P3D);
  surface.setResizable(true);
  frameRate(60);

  noiseDetail(100, 0.5);
  imageTextureAvecFonds.loadPixels();
  imageTextureSansFonds.loadPixels();
  imageAltitudes.loadPixels();
  
  imageArrierePlan = loadImage(NOM_IMAGE_FOND);
  imageArrierePlan2 = imageArrierePlan.copy();

  if (fichiersExistent()) {
    etape = NOUVELLE_PLANETE;
  }
  else {
    pourcentageEtapes[0] = 0;
    pourcentageEtapes[1] = 90;
    pourcentageEtapes[2] = 9;
    pourcentageEtapes[3] = 0;
    pourcentageEtapes[4] = 0;
    pourcentageEtapes[5] = 1;
    thread("calculePlanete");
  }
}

/**
  * Boucle principale
  */
void draw() {
  // Redimenssionnement de l'arrière plan si la fenêtre est redimensionnée
  if ((width != imageArrierePlan2.width) || (height != imageArrierePlan2.height)) {
    imageArrierePlan2 = imageArrierePlan.copy();
    imageArrierePlan2.resize(width, height);
  }
  background(imageArrierePlan2);
  
  switch (etape) {
    // Si une planète a déjà été créée, on demande s'il faut la garder
    case NOUVELLE_PLANETE:
      afficheQuestion();
      break;

    // Première étape de l'initialisation si la planète est recalculée :
    // Calcul des textures et des altitudes.
    case CALCULE_ALTITUDES:
    case ENREGISTRE_FICHIERS:
    case CHARGE_FICHIERS:
    case CORRIGE_ALTITUDES:
      afficheProgression();
      break;
      
    // Troisième étape de l'initialisation :
    // Calcul de la distribution des altitudes.
    case CALCULE_DISTRIBUTION:
      calculeDistribution();
      etape = AFFICHE_PLANETE;
      //for (int j = 0; j < PAS_CORRECTION_ALTITUDE; j++) {
      //  calculeDistribution(indexProgression);
      //  indexProgression = indexProgression + 1;
      //  if (indexProgression == 2 * nbPixels) {
      //    indexProgression = 0;
      //    resolution = 100;
      //    nbFaces = ceil(PI * RAYON_MOYEN / resolution);
      //    angleFace = PI / nbFaces;
      //    for (int k = 0; k <= 2 * nbFaces; k++) {
      //      calculeAltitudes(k);
      //    }
      //    initialiseCamera();
      //    etape = AFFICHE_PLANETE;
      //    break;
      //  }
      //}
      resolution = 100;
      nbFaces = ceil(PI * RAYON_MOYEN / resolution);
      angleFace = PI / nbFaces;
      calculePrimitive();
      initialiseCamera();
      afficheProgression();
      break;
      
    // L'initialisation est terminée, on affiche la planète.
    case AFFICHE_PLANETE:
      
      // Eclairage de la scène
      if (lumiere) {
        directionalLight(240, 240, 240, -1, 0, -1);
        ambientLight(16, 16, 16);
      }
      else {
        directionalLight(128, 128,128, -1, 0, -1);
        ambientLight(128, 128, 128);
      }      
      lightFalloff(0.0001, 0, 0.00005);
      pointLight(255, 255, 255, xCam, yCam, zCam);
      
      // Si la fenêtre a été redimensionnée, on recalcule les paramètres de la caméra
      // pour en tenir compte.
      if ((width != largeurFenetre) || (height != hauteurFenetre)) {
        largeurFenetre = width;
        hauteurFenetre = height;
        initialiseCamera();
      }
      
      // Affichage des informations 
      pushMatrix();
      // Rotation pour tenir compte de la position de la camera.
      rotateY(radians(longitudeCamera));
      rotateX(radians(latitudeCamera));
      // Translation pour tenir compte de l'altitude de la camera.
      // On divise par 10 les distances pour que le texte soit devant la planète
      translate(-width / 10.0, -height / 10.0,  (altitudeCamera + RAYON_MOYEN) * echelle - (height/10.0) / tan(PI / 6));
      // On applique une échelle 1/5 pour tenir compte du raprochement
      scale(1.0/5);
      // Affichage de l'altitude du point visé
      if (montreAltitude) afficheAltitude();
      // Affichage de la distribution des altitudes
      if (montreDistribution) afficheDistribution();
      // Affichage des informations sur l'affichage
      if (montreInformations) {
        afficheInformations();
        afficheCurseurRelief();
      }
      // Affichage du viseur
      if (montreViseur) {
        pushMatrix();
        translate(0, 0, 10);
        afficheViseur();
        popMatrix();
      }
      // Affichage de l'aide
      if (montreAide) {
        pushMatrix();
        translate(0, 0, 5);
        afficheAide();
        popMatrix();
      }
      popMatrix();
      
      // Rotation de la planète
      rotateY(angleRotation);
      // Affichage de la planète
      dessinePlanete(RAYON_MOYEN, montreFonds);
      // Calcule du prochain angle de rotation en tenant compte du frameRate
      // pour que la vitesse de rotation soit constante.
      if (rotation) angleRotation = (angleRotation + 0.1 / frameRate) % TWO_PI;
      
      // Toute les 10 images, on vérifie de frameRate.
      // S'il est inférieur à FPSMin, on diminue la résolution
      // S'il est supérieur à FPSMax, on augmente la résolution
      compteur += 1;
      if (compteur >= 10) {
        compteur = 0;
        if (frameRate < FPSMin) {
          resolution += 10.0;
          nbFaces = ceil(PI * RAYON_MOYEN / resolution);
          angleFace = PI / nbFaces;
          calculePrimitive();
        }
        else if (frameRate > FPSMax) {
          resolution -= 10.0;
          if (resolution < 10) resolution = 10;
          nbFaces = ceil(PI * RAYON_MOYEN / resolution);
          angleFace = PI / nbFaces;
          calculePrimitive();
        }
      }
      break;

    default:
      println("Erreur !!!");
      break;
      
  }
    
}