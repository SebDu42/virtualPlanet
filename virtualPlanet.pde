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
  imageTextureAvecFond.loadPixels();
  imageTextureSansFond.loadPixels();
  imageAltitudes.loadPixels();
  
  imageArrierePlan = loadImage(NOM_IMAGE_FOND);
  imageArrierePlan2 = imageArrierePlan.copy();

  if (fichiersExistent()) {
    etape = NOUVELLE_PLANETE;
  }
  else {
    etape = CALCULE_TEXTURES;
    pourcentageEtapes[0] = 90;
    pourcentageEtapes[1] = 5;
    pourcentageEtapes[2] = 0;
    pourcentageEtapes[3] = 0;
    pourcentageEtapes[4] = 5;
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
    // Si une planète à déjà été créée, on demande s'il faut la garder
    case NOUVELLE_PLANETE:
      afficheTitre();
      afficheLicence();
      strokeWeight(2);
      textSize(20);
      stroke(BLANC);
      fill(BLANC);
      textAlign(CENTER, CENTER);
      text("Voulez-vous réutiliser la dernière planète générée (O/N) ?", width / 2, height / 2);
      break;

    // Première étape de l'initialisation si la planète est recalculée :
    // Calcul des textures et des altitudes.
    case CALCULE_TEXTURES:
      for (int j = 0; j < PAS_CALCUL_ALTITUDE; j++) {
        calculeTexture(indexProgression);
        indexProgression = indexProgression + 1;
        if (indexProgression == 2 * nbPixels) {
          indexProgression = 0;
          etape = ENREGISTRE_TEXTURES;
          break;
        }
      }
      afficheProgression(CALCULE_TEXTURES, indexProgression, 2 * nbPixels);
      break;
    
    // Deuxième étape de l'initialisation si la planète est recalculée :
    // Enregistrement des textures et des altitudes.
    case ENREGISTRE_TEXTURES:
      if (indexProgression == 1) {
        imageTextureAvecFond.updatePixels();
        imageTextureAvecFond.save(NOM_TEXTURE_AVEC_FOND);
      }
      else if (indexProgression == 2) {
        imageTextureSansFond.updatePixels();
        imageTextureSansFond.save(NOM_TEXTURE_SANS_FOND);
      }
      else if (indexProgression== 3) {
        imageAltitudes.updatePixels();
        imageAltitudes.save(NOM_ALTITUDES);
      }
      else if (indexProgression > 3) {
        indexProgression = 0;
        etape = CALCULE_DISTRIBUTION;
      }
      indexProgression = indexProgression + 1;
      afficheProgression(ENREGISTRE_TEXTURES, indexProgression, 3);
      break;
    
    // Première étape de l'initialisation si une planète est réutilisée :
    // Chargement des texture et des altitudes.
    case CHARGE_TEXTURES:
      if (indexProgression == 1) {
        imageTextureAvecFond = loadImage(NOM_TEXTURE_AVEC_FOND);
        imageTextureAvecFond.loadPixels();
      }
      else if (indexProgression == 2) {
        imageTextureSansFond = loadImage(NOM_TEXTURE_SANS_FOND);
        imageTextureSansFond.loadPixels();
      }
      else if (indexProgression== 3) {
        imageAltitudes = loadImage(NOM_ALTITUDES);      
        imageAltitudes.loadPixels();
      }
      else if (indexProgression > 3) {
        indexProgression = -1;
        etape = CORRIGE_ALTITUDES;
      }
      indexProgression = indexProgression + 1;
      afficheProgression(CHARGE_TEXTURES, indexProgression, 3);
      break;
      
    // Deuxième étape de l'initialisation si une planète est réutilisée :
    // Correction des altitudes.
    case CORRIGE_ALTITUDES:
      for (int j = 0; j < PAS_CORRECTION_ALTITUDE; j++) {
        corrigeAltitude(indexProgression);
        indexProgression = indexProgression + 1;
        if (indexProgression == 2 * nbPixels) {
          indexProgression = 0;
          etape = CALCULE_DISTRIBUTION;
          break;
        }
      }
      afficheProgression(CORRIGE_ALTITUDES, indexProgression, 2 * nbPixels);
      break;

    // Troisième étape de l'initialisation :
    // Calcul de la distribution des altitudes.
    case CALCULE_DISTRIBUTION:
      for (int j = 0; j < PAS_CORRECTION_ALTITUDE; j++) {
        calculeDistribution(indexProgression);
        indexProgression = indexProgression + 1;
        if (indexProgression == 2 * nbPixels) {
          indexProgression = 0;
          resolution = 100;
          nbFaces = ceil(PI * RAYON_MOYEN / resolution);
          angleFace = PI / nbFaces;
          for (int k = 0; k <= 2 * nbFaces; k++) {
            calculeAltitudes(k);
          }
          initialiseCamera();
          etape = AFFICHE_PLANETE;
          break;
        }
      }
      afficheProgression(CALCULE_DISTRIBUTION, indexProgression, 2 * nbPixels);
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
      dessinePlanete(resolution, RAYON_MOYEN, montreFond);
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
          for (int i=0; i<= 2 * nbFaces; i++) {
            calculeAltitudes(i);
          }
        }
        else if (frameRate > FPSMax) {
          resolution -= 10.0;
          if (resolution < 10) resolution = 10;
          nbFaces = ceil(PI * RAYON_MOYEN / resolution);
          angleFace = PI / nbFaces;
          for (int i=0; i<= 2 * nbFaces; i++) {
            calculeAltitudes(i);
          }
        }
      }
      break;

    default:
      println("Erreur !!!");
      break;
      
  }
    
}