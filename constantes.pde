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


/*
 * Version de l'application
 */
final String VERSION = "1.0.1";


/*
 * Paramètres de la planète
 */
final float RAYON_MOYEN = 6371.0; // Rayon moyen de la Terre : 6371Kms
final float TAILLE_RELIEF = 0.5;  // Echelle en longitude/lattitude des reliefs
final float RESOLUTION_MIN = 10;  // Distance entre 2 points altimétrique au niveau de l'équateur

/*
 * Paramètres d'affichage
 */
// Nombres d'images par seconde : utilisés pour ajuster la résolution de la surface
final int FPSMax = 25; // Nombre maximal d'images par seconde
final int FPSMin = 20; // Nombre minimal d'images par seconde

/*
 * Code des touches (pour les touches non définies par défaut)
 */
final int PAGE_UP = 16;
final int PAGE_DOWN = 11;
final int F1 = 97;

/*
 * Etapes d'initialisation
 */
// Codes des étapes
final int CALCULE_TEXTURES = 0;
final int ENREGISTRE_TEXTURES = 1;
final int CHARGE_TEXTURES = 2;
final int CORRIGE_ALTITUDES = 3;
final int CALCULE_DISTRIBUTION = 4;
final int AFFICHE_PLANETE = 11;
final int NOUVELLE_PLANETE = 10;
// Texte pour l'écran de progression
final String[] TEXTE_ETAPES = {"Calcul des altitudes", 
                               "Enregistrement des textures",
                               "Chargement des textures",
                               "Calcul des altitudes",
                               "Calcul de la distribution"};
// Pas de calcul pour l'initialisation
final int PAS_CALCUL_ALTITUDE = 5;
final int PAS_CORRECTION_ALTITUDE = 100;
final int PAS_CALCUL_DISTRIBUTION = 100;

/*
 * Couleurs
 */
final color BLANC = color(255);
final color GRIS = color(128);
final color NOIR = color(0);
final color ROUGE = color(255, 0, 0);
final color VERT = color(0, 128, 0);
final color BLEU_CIEL = color(0, 192, 255);
final color BLEU_AZUR = color(0, 128, 255);
final color BLEU_NUIT = color(0, 0, 128);

/*
 * Noms des fichiers
 */
final String NOM_TEXTURE_AVEC_FOND = "data/texture_avec_fond.tiff";
final String NOM_TEXTURE_SANS_FOND = "data/texture_sans_fond.tiff";
final String NOM_ALTITUDES = "data/altitudes.tiff";
final String NOM_IMAGE_FOND = "data/background/ciel.jpg";