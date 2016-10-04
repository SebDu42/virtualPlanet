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

void afficheProgression(int numEtape, int progression, int maximum) {
  float pourcentTotale;
  float pourcentPartielle = (float) progression * 100 / maximum;
  int debutTotale = 0;
  
  for (int i=0; i< numEtape; i++) debutTotale += pourcentageEtapes[i];
  pourcentTotale = debutTotale + pourcentPartielle * pourcentageEtapes[numEtape] / 100;
  
  afficheTitre();
  afficheLicence();
  
  strokeWeight(2);
  textSize(20);
  stroke(BLANC);
  fill(BLANC);
  textAlign(CENTER, BOTTOM);
  text("Initialisation merci de patienter...", width / 2, (height / 2) - 75);
  text(TEXTE_ETAPES[numEtape], width / 2, (height / 2) - 50);
  textAlign(LEFT, BOTTOM);
  text("Progression totale : " + str(int(pourcentTotale)) + "%",5, (height / 2) - 25);
  noStroke();
  fill(BLEU_AZUR);
  rect(5, (height / 2) - 20, (width - 10) * pourcentTotale / 100, 20); 
  stroke(BLANC);
  noFill();
  rect(5, (height / 2) - 20, width - 10, 20); 
  fill(BLANC);
  text("Progression de l'étape : " + str(int(pourcentPartielle)) + "%",5, (height / 2) + 30);
  noStroke();
  fill(BLEU_AZUR);
  rect(5, (height / 2) + 35, (width - 10) * pourcentPartielle / 100, 20);
  stroke(BLANC);
  noFill();
  rect(5, (height / 2) + 35, width - 10, 20); 
  
  //println(frameRate);
}

void afficheTitre() {
  strokeWeight(2);
  textSize(40);
  stroke(BLANC);
  fill(BLANC);
  textAlign(CENTER, TOP);
  text("Virtual Planet " + VERSION, width / 2, height / 10);
}

void afficheLicence() {
  strokeWeight(2);
  textSize(12);
  stroke(BLANC);
  fill(BLANC);
  textAlign(LEFT, BOTTOM);
  text("Copyright (C) 2016 - Sébastien Dupuis", 5, height - 20);
  text("This is free software, distribut under the terms of the GNU General Public License version 3", 5, height - 5);
}

void afficheAide() {
  int largeur = 620;
  int hauteur = 315;
  int gauche = (width - largeur) / 2;
  int haut = (height - hauteur) / 2;
  int pasTexte = 20;
  
  strokeWeight(5);
  stroke(BLANC);
  fill(NOIR);
  rect(gauche, haut, largeur, hauteur);
  gauche += 5;
  haut += + 5;
  
  fill(BLANC);
  textAlign(LEFT, TOP);
  textSize(18);
  text("F1 : Ouvrir / Fermer cet écran", gauche, haut);
  haut += 2 * pasTexte;
  text("A", gauche, haut);
  text(": Bascule l'affichage de l'altitude", gauche + 20, haut);
  haut += pasTexte;
  text("D", gauche, haut);
  text(": Bascule l'affichage de la distribution", gauche + 20, haut);
  haut += pasTexte;
  text("F", gauche, haut);
  text(": Bascule l'affichage des fonds marin", gauche + 20, haut);
  haut += pasTexte;
  text("I", gauche, haut);
  text(": Bascule l'affichage des informations", gauche + 20, haut);
  haut += pasTexte;
  text("L", gauche, haut);
  text(": Bascule l'éclairage de la scène", gauche + 20, haut);
  haut += pasTexte;
  text("R", gauche, haut);
  text(": Bascule la rotation de la planète", gauche + 20, haut);
  haut += pasTexte;
  text("V", gauche, haut);
  text(": Bascule l'affichage du viseur", gauche + 20, haut);
  haut += 2 * pasTexte;
  text("Flêhes de direction", gauche, haut);
  text(": Rotation de la planète", gauche + 275, haut);
  haut += pasTexte;
  text("SHIFT + Flêhes de direction", gauche, haut);
  text(": Rotation lente de la planète", gauche + 275, haut);
  haut += pasTexte;
  text("PAGE HAUT, PAGE BAS", gauche, haut);
  text(": S'appocher / s'éloigner de la planète", gauche + 275, haut);
  haut += pasTexte;
  text("+ / -", gauche, haut);
  text(": Accentuer / Atténuer le relief", gauche + 275, haut);
  haut += pasTexte;
  text("ESPACE", gauche, haut);
  text(": Revenir à la situation initiale", gauche + 275, haut);
}

void afficheAltitude() {
  float longitude = longitudeCamera - degrees(angleRotation);
  float latitude = int(latitudeCamera * 10.0) / 10.0;
  String uniteLatitude;
  String uniteLongitude; 
  
  if (longitude < 0) longitude += 360;
  longitude = int((longitude % 360) * 10.0) / 10.0 - 180;
  int altitude = calculeAltitudePosition(longitude, latitude);
  
  if (latitude < 0) uniteLatitude = "° S";
  else uniteLatitude = "° N"; 
  if (longitude < 0) uniteLongitude = "° O";
  else uniteLongitude = "° E";
  
  stroke(255);
  strokeWeight(5);
  fill(0);
  rect(5, 5, 200, 70);
  fill(255);
  textSize(18);
  textAlign(LEFT, BOTTOM);
  text("Longitude", 10, 30);
  text("Latitude", 10, 50);
  text("Altitude", 10, 70);
  text(": " + str(int(latitude)) + uniteLatitude, 100, 30);
  text(": " + str(int(longitude)) + uniteLongitude, 100, 50);
  text(": " + str(altitude) + " m", 100, 70);
}

void afficheDistribution() {
  stroke(255);
  strokeWeight(5);
  textSize(18);
  textAlign(CENTER, BOTTOM);
  float pas = (float(width) - 60) / 21;
  for (int i = 0; i<=20; i++) {
    float hauteur = map(distribution[i], 0, maxDistribution, 0, height / 3);    
    fill(0, 86, 170);
    rect(30 + i * pas, height - hauteur - 5, pas, hauteur);
    fill(255);
    text(i - 10, 30 + (i + 0.5) * pas, height - 20);
  }
}

void afficheCurseurRelief() {
  stroke(255);
  strokeWeight(5);
  fill(0);
  rect (width - 25, 5, 20, height - 10);
  noStroke();
  fill(128);
  float haut = map(echelleRelief, 1, 100, height - 5, 5);
  float hauteur = map(echelleRelief, 1, 100, 0, height - 10);
  rect (width - 25, haut, 20, hauteur);
}

void afficheInformations() {
  stroke(255);
  strokeWeight(5);
  fill(0);
  rect(width - 230, 5, 200, 90);
  fill(255);
  textSize(18);
  textAlign(LEFT, BOTTOM);
  text("FPS : " + str(int(frameRate)), width - 225, 30);
  text("Résolution : " + str(int(resolution)) + " kms", width - 225, 50);
  text("Distance : " + str(int(altitudeCamera)) + " kms", width - 225, 70);
  text("Relief : x" + str(echelleRelief), width - 225, 90);
}

void afficheViseur() {
  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  ellipse(width / 2, height / 2, 40, 40);
  line(width / 2, height / 2 - 30, width / 2, height / 2 + 30);
  line(width / 2 - 30, height / 2, width / 2 + 30, height / 2);
}