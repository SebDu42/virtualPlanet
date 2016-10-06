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

// Initialisation
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
    //etape = CHARGE_TEXTURES;
    //pourcentageEtapes[0] = 0;
    //pourcentageEtapes[1] = 0;
    //pourcentageEtapes[2] = 90;
    //pourcentageEtapes[3] = 5;
    //pourcentageEtapes[4] = 5;
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

// Boucle principale
void draw() {
  if ((width != imageArrierePlan2.width) || (height != imageArrierePlan2.height)) {
    imageArrierePlan2 = imageArrierePlan.copy();
    imageArrierePlan2.resize(width, height);
  }
  background(imageArrierePlan2);
  
  switch (etape) {
    
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
    case CALCULE_TEXTURES:
      for (int j = 0; j < PAS_CALCUL_ALTITUDE; j++) {
        calculeTexture(i);
        i = i + 1;
        if (i == 2 * nbPixels) {
          i = 0;
          etape = ENREGISTRE_TEXTURES;
          break;
        }
      }
      afficheProgression(CALCULE_TEXTURES, i, 2 * nbPixels);
      break;

    case ENREGISTRE_TEXTURES:
      if (i == 1) {
        imageTextureAvecFond.updatePixels();
        imageTextureAvecFond.save(NOM_TEXTURE_AVEC_FOND);
      }
      else if (i == 2) {
        imageTextureSansFond.updatePixels();
        imageTextureSansFond.save(NOM_TEXTURE_SANS_FOND);
      }
      else if (i== 3) {
        imageAltitudes.updatePixels();
        imageAltitudes.save(NOM_ALTITUDES);
      }
      else if (i > 3) {
        i = 0;
        etape = CALCULE_DISTRIBUTION;
      }
      i = i + 1;
      afficheProgression(ENREGISTRE_TEXTURES, i, 3);
      break;

    case CHARGE_TEXTURES:
      if (i == 1) {
        imageTextureAvecFond = loadImage(NOM_TEXTURE_AVEC_FOND);
        imageTextureAvecFond.loadPixels();
      }
      else if (i == 2) {
        imageTextureSansFond = loadImage(NOM_TEXTURE_SANS_FOND);
        imageTextureSansFond.loadPixels();
      }
      else if (i== 3) {
        imageAltitudes = loadImage(NOM_ALTITUDES);      
        imageAltitudes.loadPixels();
      }
      else if (i > 3) {
        i = -1;
        etape = CORRIGE_ALTITUDES;
      }
      i = i + 1;
      afficheProgression(CHARGE_TEXTURES, i, 3);
      break;
      
    case CORRIGE_ALTITUDES:
      for (int j = 0; j < PAS_CORRECTION_ALTITUDE; j++) {
        corrigeAltitude(i);
        i = i + 1;
        if (i == 2 * nbPixels) {
          i = 0;
          etape = CALCULE_DISTRIBUTION;
          break;
        }
      }
      afficheProgression(CORRIGE_ALTITUDES, i, 2 * nbPixels);
      break;
    
    case CALCULE_DISTRIBUTION:
      for (int j = 0; j < PAS_CORRECTION_ALTITUDE; j++) {
        calculeDistribution(i);
        i = i + 1;
        if (i == 2 * nbPixels) {
          i = 0;
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
      afficheProgression(CALCULE_DISTRIBUTION, i, 2 * nbPixels);
      
      break;
    case AFFICHE_PLANETE:
        
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
      
      if ((width != largeurFenetre) || (height != hauteurFenetre)) {
        largeurFenetre = width;
        hauteurFenetre = height;
        initialiseCamera();
      }
      
      pushMatrix();
      rotateY(radians(longitudeCamera));
      rotateX(radians(latitudeCamera));
      translate(-width / 10.0, -height / 10.0,  (altitudeCamera + RAYON_MOYEN) * echelle - (height/10.0) / tan(PI / 6));
      scale(1.0/5);
      if (montreAltitude) afficheAltitude();
      if (montreDistribution) afficheDistribution();
      if (montreInformations) {
        afficheInformations();
        afficheCurseurRelief();
      }
      if (montreViseur) {
        pushMatrix();
        translate(0, 0, 10);
        afficheViseur();
        popMatrix();
      }
      if (montreAide) {
        pushMatrix();
        translate(0, 0, 5);
        afficheAide();
        popMatrix();
      }
      popMatrix();
      

      
      //translate((width - 30) / 2, height / 2, -rayonMoyen * echelle);
      rotateY(angleRotation);
    
      dessinePlanete(resolution, RAYON_MOYEN, montreFond);
    
      if (rotation) angleRotation = (angleRotation + 0.1 / frameRate) % TWO_PI;
      
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
      //println(calculeAltitudePixel(0, 0), calculeAltitudePixel(0, 1), calculeAltitudePixel(0, nbPixels - 2), calculeAltitudePixel(0, nbPixels - 1));  
      break;
    default:
      println("Erreur !!!");
      break;
      
  }
    
}