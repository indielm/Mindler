import controlP5.*;

ControlP5 cp5;

PShape model;
int tileSize = 8;
float bend = 0.7;
float scale2 = 1.000;
int texAngle = 0;
float a = 0, b = 1.0, c = 0.00, d = 1-bend, e = 2+bend, f = 3.00, h = 1.0;

PVector rot = new PVector(0.7, 0.0, QUARTER_PI);
String texture = "core";
boolean wireframe = false;
boolean backFaceCulling = false;
boolean autoLoad = true;

int index = 0;
int tab = 2;

void setup() {
  size(800, 800, P3D);
  ((PGraphicsOpenGL)g).textureSampling(2);
  cp5 = new ControlP5(this);
  initSprites();
  
  buildTabs = loadStrings("data/buildTab.csv");
  initUI();
  load();
}

void draw() {
  ortho();
  pushMatrix();
  clear();
  ambientLight(251, 249, 236);
  translate(481, 932, 227);
  initModel();
  scale(10, 10, 10);
  pushMatrix();
  translate(0, -50, -50);
  rotateX(rot.x);
  rotateY(rot.y);
  rotateZ(rot.z);
  shapeMode(CENTER);
  shape(model);
  popMatrix();
  popMatrix();
}

void initModel() {
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
  PVector uv = new PVector(0, 0);
  for (float[] p : modelVerts) {
    uv.set(scale2*p[0]/tiles-0.5, scale2*p[1]/tiles-0.5)
      .rotate(texAngle*HALF_PI)
      .add(0.5, 0.5);
    model.vertex(p[0]*scale, p[1]*scale, p[2]*scale*1.0, uv.x, uv.y);
  }
  model.endShape();
}