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

void mouseDragged() {
  if ((mouseX > width - 25) && (mouseX < width - 5) && (mouseY > 5) && (mouseY < height - 5)) {
    echelleRelief = map(mouseY, 5, height - 5, 100, 1);
  }
}

void mouseClicked() {
  mouseDragged();
}