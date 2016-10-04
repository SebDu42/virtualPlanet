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

void keyPressed() {
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
      if ((key == 'f') || (key == 'F')) montreFond = !montreFond;
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
    initialiseCamera();
  }
  else if (etape == NOUVELLE_PLANETE) {
      if ((key == 'o') || (key == 'O')) {
        etape = CHARGE_TEXTURES;
        pourcentageEtapes[0] = 0;
        pourcentageEtapes[1] = 0;
        pourcentageEtapes[2] = 90;
        pourcentageEtapes[3] = 5;
        pourcentageEtapes[4] = 5;
     }
      if ((key == 'n') || (key == 'N')) {
        etape = CALCULE_TEXTURES;
        pourcentageEtapes[0] = 90;
        pourcentageEtapes[1] = 5;
        pourcentageEtapes[2] = 0;
        pourcentageEtapes[3] = 0;
        pourcentageEtapes[4] = 5;
      }
  }
  println(keyCode, " ", key, " ", key == CODED, " ", frameRate);
}

void keyReleased() {
  if (keyCode == SHIFT) pasAngleCamera = 5;
}