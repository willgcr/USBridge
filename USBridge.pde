/* 

DHTMonitor - v0.1, Copyright © 2018 Willian Gabriel Cerqueira da Rocha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
All rights reserved.


Willian Gabriel Cerqueira da Rocha
willianrocha[at]riseup[dot]net
https://wgrocha.github.io
   
*/

import processing.serial.*;

public class Button {
  private int width, height, x, y;
  private float xfactor, yfactor;
  private String label;
  private String function = label = "";
  private PFont font;
  public Button (String label, int x, int y, int width, int height, String function, float xfactor, float yfactor) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.function = function;
    this.xfactor = xfactor;
    this.yfactor = yfactor;
  }
  private boolean over () {
    if (mouseX >= this.x && mouseX <= this.x + this.width && mouseY >= this.y && mouseY <= this.y + this.height) {
      return true;
    } else {
      return false;
    }
  }
  public void update () {
    if (this.over ()) {
      this.highlight ();
    } else {
      restore ();
    } 
    if (mousePressed == true) {
      if (this.over ()) {
        method (function);
      }
    }
  }
  private void highlight () {
    stroke (127);
    fill (51);
    rect (this.x, this.y, this.width, this.height);
    font = createFont ("Arial", 18);
    textFont (font);
    fill (255);
    textAlign (LEFT);
    text (this.label, this.x + (this.width * this.xfactor), this.y + (this.height * this.yfactor));
    return;
  }
  private void restore () {
    stroke (127);
    fill (255);
    rect (this.x, this.y, this.width, this.height);
    font = createFont ("Arial", 18);
    textFont (font);
    fill (0);
    textAlign (LEFT);
    text (this.label, this.x + (this.width * this.xfactor), this.y + (this.height * this.yfactor));
    return;
  }
}

public class TextBox {
  private boolean selected = false;
  private int x;
  private int y;
  private int width;
  private int height;
  private String content = "";
  private PFont font;
  private float xfactor;
  private float yfactor;
  private int maxlength;
  public TextBox (int x, int y, int width, int height, int maxlength, float xfactor, float yfactor) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.maxlength = maxlength;
    this.xfactor = xfactor;
    this.yfactor = yfactor;
    return;
  }
  public void enable () {
    selected = true;
    return;
  }
  public void disable () {
    selected = false;
    return;
  }  
  private boolean over () {
    if (mouseX >= this.x && mouseX <= this.x + this.width && mouseY >= this.y && mouseY <= this.y + this.height) {
      return true;
    } else {
      return false;
    }
  }
  public void update () { 
    if (mousePressed == true) {
      if (this.over () == true) {
        this.enable ();
      } else if (this.over () == false) {
        this.disable ();
      }
    }
    fill (255);
    if (this.selected == true) {
      stroke (0xCC, 0x55, 0x55);
      rect (this.x, this.y, this.width, this.height);
    } else if (this.selected == false) {
      stroke (127);
      rect (this.x, this.y, this.width, this.height);
    }    
    font = createFont ("Arial", 18);
    textFont (font);
    textAlign (LEFT);
    fill (0);
    text (this.content, this.x + (this.width * this.xfactor), this.y + (this.height * this.yfactor));
    return;
  }
  public boolean selected () {
    return selected;
  }
  public void resetContent () {
    this.content = "";
    return;
  }
  public void backspace () {
    if ((this.content).length () > 0) {
      this.content = (this.content).substring (0, (this.content).length () - 1);
    }
    return;
  }
  public void updateContent (char key) {
    if ((this.content).length () >= this.maxlength) {
      return;
    } else {
      this.content = this.content + key;
      return;
    }
  }
  public String getContent () {
    return this.content;
  }
}

public class Console {
  ArrayList<String> content = new ArrayList<String> ();
  private int x;
  private int y;
  private int width;
  private int height;
  private PFont font;
  private float xfactor;
  private float yfactor;
  public Console (int x, int y, int width, int height, float xfactor, float yfactor) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.xfactor = xfactor;
    this.yfactor = yfactor;
    return;
  }
  public void update () {
    if (!comPort.equals ("N/N")) {
      if (serialPort.available () > 0) {
        String serialData = serialPort.readStringUntil ('\n');
        if (content.size () < 4) {
          content.add (serialData);
        } else if (content.size () >= 4) {
          content.remove (0);
          content.add (serialData);
        }
      }
    }
    fill (255);
    stroke (127);
    rect (this.x, this.y, this.width, this.height);
    stroke (255);
    fill (0);
    textAlign (LEFT);
    font = createFont ("Lucida Console", 12);
    textFont (font);
    int ht = this.height;
    for (String text : content) {
      text (text, this.x + (this.width * this.xfactor), this.y + (ht * this.yfactor));
      ht += 80;
    }
    return;
  }
  public void write (String data) {
      if (content.size () < 4) {
        content.add (data);
      } else if (content.size () >= 4) {
        content.remove (0);
        content.add (data);
      }
      return;
  }
}

Button submit, portSetup;
TextBox textbox;
Console console;
String comPort = "N/N";
Serial serialPort;

public void setup () {
  size (500, 250);
  submit = new Button ("Send", 400, 50, 90, 30, "submit", 0.28, 0.7);
  portSetup = new Button ("Change", 400, 10, 90, 35, "setupCOMPort", 0.17, 0.7);
  textbox = new TextBox (10, 50, 380, 30, 25, 0.03, 0.7);
  console = new Console (10, 115, 480, 70, 0.02, 0.21); 
  textbox.enable ();
}

public void draw () {
  drawContainers ();
  submit.update ();
  textbox.update ();
  portSetup.update ();
  console.update ();
}

public void drawContainers () {
  //BACKGROUND
  fill (230);
  rect (-1, -1, 501, 251);
  PFont font;
  stroke (127);
  fill (255);
  //TITTLE CONTAINER
  rect (5, 5, 490, 80);
  //CONSOLE CONTAINER
  rect (5, 88, 490, 102);
  //COPYRIGHT CONTAINER
  rect (5, 193, 490, 52);
  //comPort CONTAINER
  rect (330, 25, 60, 20);

  fill (0);
  font = createFont ("Century Gothic", 25);
  textFont (font);
  text ("USBridge", 185, 35);
  
  font = createFont ("Lucida Console", 9);
  textFont (font);
  text ("Type your text here:", 18, 47); 

  font = createFont ("Lucida Console", 16);
  textFont (font);
  text ("Console:", 18, 107); 

  font = createFont ("Century Gothic", 14);
  textFont (font);
  text ("Port:", 340, 22);
  text (comPort, 340, 40);

  font = createFont ("Century Gothic", 12);
  textAlign (CENTER);
  textFont (font);
  text ("Copyright © 2018 by Willian Gabriel Cerqueira da Rocha.\nAll rights reserved - GNU GPL v3.0", width * 0.5, 212);
}

public void submit () {
  if (!comPort.equals ("N/N")) {
    serialPort.write (textbox.getContent());
    delay (200);
  } else {
    console.write ("[INFO] Porta inválida");
    delay (200);
  }
  textbox.resetContent ();
  return;
}

public void setupCOMPort () {
  int comNumber = Serial.list().length;
  if (comPort.equals("N/N")) {
    if (comNumber > 0) {
      serialPort = new Serial (this, Serial.list()[0], 9600);
      comPort = Serial.list()[0];
      return;
    }
  }
  for (int i = 0; i < comNumber; i++) {
    if (comPort.equals (Serial.list()[i])) {
      if (i + 1 < comNumber) {
        serialPort.stop();
        serialPort = new Serial (this, Serial.list()[i+1], 9600);
        comPort = Serial.list()[i+1];
        return;
      } else if (i + 1 == comNumber) {
        serialPort.stop();
        serialPort = new Serial (this, Serial.list()[0], 9600);
        comPort = Serial.list()[0];
        return;
      }
    }
  }
  return;
}

public void keyPressed() { 
  if (textbox.selected () == true) {
    if (key == 8) {
      textbox.backspace ();
    } else if (key == '\n') {
      //textbox.disable ();
      submit ();
    } else {
      textbox.updateContent (key);
    }
  }
  return;
}
