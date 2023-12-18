PImage bg_img;
float black_bt_width;
float black_bt_height;
int white_width;
int cs_bt_x;
int cs_bt_y;
boolean cs_bt_over;
boolean cs_bt_pressed;
color bbt_over_color;
color bbt_pressed_color;
color bbt_default_color;

int[] bt;


import processing.serial.*; //import the Serial library
 
Serial myPort;  //the Serial port object
String val;

boolean firstContact = false;


int a = 0;

void setup() {
  size(751,436);
  
  //bg_img = loadImage("img/piano_bg.png");
  
  black_bt_width = 60;
  black_bt_height=60;
  white_width = 95;
  cs_bt_x = 155;
  cs_bt_y = 107;
  cs_bt_over = false;
  cs_bt_pressed = false;
  bt = new int[] {cs_bt_x, cs_bt_x + white_width,  cs_bt_x + 2 * white_width, cs_bt_x + 3 * white_width, cs_bt_x + 4 * white_width};
  
  bbt_over_color = color(105, 200, 194);
  bbt_pressed_color = color(50, 150, 160);
  bbt_default_color = color(0);
  
//  myPort = new Serial(this, Serial.list()[1], 9600);
//  myPort.bufferUntil('\n'); 


}

void draw() {
  background(255);
  //println("x=", mouseX, " y=", mouseY);
  update(mouseX, mouseY);
  
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text("count: " + a, width / 2, 300);
  
  
  textSize(20);
  fill(255);
  text("▲", 185, 140);
  
  textSize(20);
  fill(255);
  text("▼", 280, 145);
  
  textSize(20);
  fill(255);
  text("M1", 375, 145);
  
  textSize(20);
  fill(255);
  text("M2", 470, 145);
  
  textSize(20);
  fill(255);
  text("M3", 565, 145);
  
  noStroke();

}


  

boolean overButton(int x, int y) {
  if(mouseX >= x && mouseX <= x+black_bt_width && mouseY >= y && mouseY <=y+black_bt_height) {
    return true;
  } else {
    return false;
  }
}

void update(int x, int y) {
  
  for (int i = 0; i<bt.length; i++) { 
    fill(0);
    rect(bt[i], cs_bt_y, black_bt_width, black_bt_height);
  }
   for (int i = 0; i<bt.length; i++) { 
    if(cs_bt_pressed && overButton(bt[i], cs_bt_y)) {
        fill(bbt_pressed_color);
        rect(bt[i], cs_bt_y, black_bt_width, black_bt_height);
        myPort.write(str(i));        //send a 1
        println(i);
        break;
    }
    else if(overButton(bt[i], cs_bt_y)) {
      fill(bbt_over_color);
      rect(bt[i], cs_bt_y, black_bt_width, black_bt_height);
      
      cs_bt_over = true;
      break;
    } 
  else {
    
    cs_bt_over = false;
        
  }
  }
}

void mousePressed() {
  if(cs_bt_over) {
    println("CS Button Pressed");
    cs_bt_pressed = true;
  } else {
    cs_bt_pressed = false;
  }
}

void mouseReleased() {
  if(cs_bt_pressed) {
    println("CS Button Released");
    cs_bt_pressed = false;
  }
}

void serialEvent( Serial myPort) {
//put the incoming data into a String - 
//the '\n' is our end delimiter indicating the end of a complete packet

val = myPort.readStringUntil('\n');


//make sure our data isn't empty before continuing
if (val != null) {
  //trim whitespace and formatting characters (like carriage return)
  val = trim(val);
  println(val);

  //look for our 'A' string to start the handshake
  //if it's there, clear the buffer, and send a request for data
  if (firstContact == false) {
    if (val.equals("A")) {
      myPort.clear();
      firstContact = true;
      myPort.write("A");
      println("contact");
    }
  }
    if (val.equals("1")) {

      
      a++;

      } 

  else { //if we've already established contact, keep getting and parsing data
    println(val);
    // when you've parsed the data you have, ask for more:
    myPort.write("A");
    }
  }
}
