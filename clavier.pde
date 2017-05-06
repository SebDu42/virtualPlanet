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
  * Gestion du clavier
  */
void keyPressed() {
  // On ne gère pas le clavier pendant l'initialisation. On attend donc d'en 
  // être à l'étape d'affichage de la planète.
  if (etape == AFFICHE_PLANETE) {
    if (key == CODED) {
      if ((keyCode == UP) && (latitudeCamera + pasAngleCamera < 90)) latitudeCamera += pasAngleCamera;
      if ((keyCode == DOWN) && (latitudeCamera - pasAngleCamera > -90)) latitudeCamera -= pasAngleCamera;
      if (keyCode == LEFT) longitudeCamera -= pasAngleCamera;
      if (keyCode == RIGHT) longitudeCamera += pasAngleCamera;
      if (longitudeCamera < 0) longitudeCamera += 360;
      longitudeCamera = longitudeCamera % 360;
      if (keyCode == SHIFT) pasAngleCamera = 1;
    }
    else {
      if ((key == 'a') || (key == 'A')) montreAltitude = !montreAltitude;
      if ((key == 'd') || (key == 'D')) montreDistribution = !montreDistribution;
      if ((key == 'f') || (key == 'F')) montreFonds = !montreFonds;
      if ((key == 'i') || (key == 'I')) montreInformations = !montreInformations;
      if ((key == 'l') || (key == 'L')) lumiere = !lumiere;
      if ((key == 'r') || (key == 'R')) rotation = !rotation;
      if ((key == 'v') || (key == 'V')) montreViseur = !montreViseur;
      if (key == '+') echelleRelief += 10;
      if (key == '-') echelleRelief -= 10;
      echelleRelief = round(echelleRelief / 10) * 10; 
      if (echelleRelief < 1) echelleRelief = 1;
      if (echelleRelief > 100) echelleRelief = 100;
      if (key == ' ') { latitudeCamera = 0; longitudeCamera = 0; altitudeCamera = 7000; echelleRelief = 30.0; }
      if ((keyCode == PAGE_UP) && (altitudeCamera - pasAltitudeCamera >= 3000)) altitudeCamera -= 100;
      if ((keyCode == PAGE_DOWN) && (altitudeCamera + pasAltitudeCamera <= 20000)) altitudeCamera += 100;
      if (keyCode == F1) montreAide = !montreAide;
    }
    // On recalcule les paramètres de la caméra au cas ou ils auraient changé.
    // À faire : ne le faire que si les paramètres ont été changés.
    initialiseCamera();
  }
  // Au lancement du programme, si une planète a déja été  créée, on attend la 
  // réponse de l'utilisateur pour savoir s'il faut la garder ou non.
  else if (etape == NOUVELLE_PLANETE) {
      if ((key == 'o') || (key == 'O')) {
        pourcentageEtapes[0] = 0;
        pourcentageEtapes[1] = 0;
        pourcentageEtapes[2] = 0;
        pourcentageEtapes[3] = 90;
        pourcentageEtapes[4] = 5;
        pourcentageEtapes[5] = 5;
        thread("chargeTexture");
     }
      if ((key == 'n') || (key == 'N')) {
        pourcentageEtapes[0] = 0;
        pourcentageEtapes[1] = 90;
        pourcentageEtapes[2] = 5;
        pourcentageEtapes[3] = 0;
        pourcentageEtapes[4] = 0;
        pourcentageEtapes[5] = 5;
        thread("calculeTexture");
      }
  }
  println(keyCode, " ", key, " ", key == CODED, " ", frameRate);
}


/**
  * Change le pas de déplacement angulaire de la céméra lorsque l'on relâche la
  * touche Shift (Maj).
  */
void keyReleased() {
  if (keyCode == SHIFT) pasAngleCamera = 5;
}