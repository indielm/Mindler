import controlP5.*;

ControlP5 cp5;

PShape model;
int tileSize = 9;
float bend = 0.7;
float scale2 = 1.000;

int y = 30;
int yO = 15;
float a = 0, b = 1.0, c = 0.00, d = 1-bend, e = 2+bend, f = 3.00, h = 1.0;

float rotX = 0.63, rotY = 0.0, rotZ = 0.5;

String texture = "core";
boolean wireframe = false;
boolean backFaceCulling = false;


ListBox textureList;
void setup() {
  size(800, 800, P3D);
  ((PGraphicsOpenGL)g).textureSampling(2);
  initSprites();
  cp5 = new ControlP5(this);

  addSlider("bend", 0.7, -0.5, 1.0);
  //addSlider("a", 0.0, -1.0, 1.0);
  addSlider("b", 1.0, 0.0, 3.0);
  //addSlider("c", 0.0, 0.0,3.0);
  //addSlider("f", 3.0, 2.0, 4.0);
  addSlider("h", 1.0, 0.0, 1.5);
  addSlider("scale2", 1.0, 0.5, 1.5);
  addSlider("rotX", 0.7, 0.5, 1.5);
  addSlider("rotY", 0.0, 0.0, 1.5);
  addSlider("rotZ", QUARTER_PI, 0.0, 1.5);

  cp5.addToggle("wireframe").setPosition(10, y+=yO).setSize(50, 10);
  cp5.addToggle("backFaceCulling").setPosition(80, y).setSize(50, 10); 
  cp5.addButton("resetCam").setPosition(150, y).setSize(50, 10);
  cp5.addButton("save").setPosition(10, y+=yO*2).setSize(50, 10);
  cp5.addButton("load").setPosition(80, y).setSize(50, 10);
  textureList  = cp5.addListBox("textureList").setPosition(10, yO + (y+=yO)).setSize(120, 120);

  textureList.getCaptionLabel().set(texture);
  textureList.getCaptionLabel().setColor(0xffff0000);

  int i = 0;

  blockNames = productionNames.split(",");
  for (String s : blockNames) {
    textureList.addItem(s, i);
    i++;
  }
  /*for (String s : spritesAtlas.keySet()) {
   textureList.addItem(s, i);
   i++;
   }*/
}

void addSlider(String varName, float initVal, float rangeLow, float rangeHigh) {
  cp5.addSlider(varName).setPosition(10, y+=yO).setSize(200, 5).setRange(rangeLow, rangeHigh).setValue(initVal);
}

void draw() {
  ortho();
  pushMatrix();
  clear();
  ambientLight(251, 249, 236);
  translate(481, 932, 227);
  initShape();
  scale(10, 10, 10);
  pushMatrix();
  translate(0, -50, -50);
  //shape(model);
  rotateX(rotX);
  rotateY(rotY);
  rotateZ(rotZ);
  shapeMode(CENTER);
  shape(model);
  popMatrix();
  popMatrix();
  gui();
}

void save(int n) {
  try {
    String []data = {texture, Float.toString(bend), Float.toString(b), Float.toString(h), Float.toString(scale2)};
    saveStrings("/data/models/" +texture + ".mm", data);
  }
  catch(Exception e) {
  }
}

void load(int n ) {
  try {
    String []data = loadStrings("/data/models/" +texture + ".mm");
    bend = Float.parseFloat(data[1]);
    b = Float.parseFloat(data[2]);
    h = Float.parseFloat(data[3]);
    scale2 = Float.parseFloat(data[4]);
  }
  catch(Exception e) {
  }
}

void resetCam(int n) {
  rotZ = QUARTER_PI;
  rotX = 0.7;
  rotY = 0;
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  //cam.beginHUD();
  cp5.draw();
  //cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void textureList(int n) {
  texture = (String)textureList.getItem(n).get("text");
  textureList.getCaptionLabel().set(texture);
  //textureList.close();
}

void mouseDragged() {
  if ((mouseX> 250) || ( mouseY > 300)) {
    rotX+=(mouseY-pmouseY)*0.01;
    rotZ+=(mouseX-pmouseX)*0.01;
  }
}

void initShape() {
  float d = h-bend, e = 3-h+bend;
  float [][]modelVerts;
  if (backFaceCulling) {
    float [][] culled = {{f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
    modelVerts = culled;
  } else {
    float [][] full =  {{c, c, a}, {d, d, b}, {f, c, a}, {e, d, b}, {f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
    modelVerts = full;
  }

  model = createShape();
  model.beginShape(TRIANGLE_STRIP);
  model.textureMode(NORMAL);
  model.texture(getSprite(texture));
  if (wireframe) model.stroke(255);
  else model.noStroke();
  model.translate(-3*tileSize, -tileSize, 0);
  model.rotate(-HALF_PI);
  float tiles = 3;
  float scale = tileSize;
  for (float[] p : modelVerts) {
    model.vertex(p[0]*scale, p[1]*scale, p[2]*scale*1.0, scale2*p[0]/tiles, scale2*p[1]/tiles);
  }
  model.endShape();
}