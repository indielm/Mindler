ScrollableList textureList;
int y = 5;
int yO = 15;
ArrayList<Slider> sliders = new ArrayList<Slider>();
boolean camDrag = false;
CColor green = new CColor(), red = new CColor();


void initUI() {
  green.setBackground(color(0, 55, 0));
  red.setBackground(color(55, 0, 0));
  addSlider("bend", 0.7, -0.5, 1.0);
  //addSlider("a", 0.0, -1.0, 1.0);
  addSlider("b", 1.0, 0.0, 3.0);
  //addSlider("c", 0.0, 0.0,3.0);
  //addSlider("f", 3.0, 2.0, 4.0);
  addSlider("h", 1.0, 0.0, 1.5);
  addSlider("scale2", 1.0, 0.5, 1.5);
  addSlider("texAngle", 0, 0, 3);
  cp5.addToggle("wireframe").setPosition(10, y+=yO).setSize(50, 10);
  cp5.addToggle("backFaceCulling").setPosition(70, y).setSize(50, 10); 
  cp5.addToggle("autoLoad").setPosition(150, y).setSize(50, 10);
  cp5.addButton("save").setPosition(10, y+=yO*2).setSize(50, 10);
  cp5.addButton("load").setPosition(70, y).setSize(50, 10);
  cp5.addButton("resetCam").setPosition(150, y).setSize(50, 10);
  textureList  = cp5.addScrollableList("textureList").setPosition(10, yO + (y+=yO)).setSize(120, 120);
  textureList.getCaptionLabel().set(texture);
  textureList.getCaptionLabel().setColor(0xffff0000);
  blockNames = productionNames.split(",");
  int i = 0;
  File f;
  for (String s : blockNames) {
    textureList.addItem(s, i);
    f = new File(sketchPath() +"/data/models/" +s + ".mm");
    textureList.getItem(i).put("color", f.exists() ? green : red);
    i++;
  }
}

void save(int n) {
  try {
    String []data = {texture, Float.toString(bend), Float.toString(b), Float.toString(h), Float.toString(scale2), Integer.toString(texAngle)};
    saveStrings("/data/models/" +texture + ".mm", data);
    textureList.getItem(index).put("color", green);
  }
  catch(Exception e) {
  }
}

void load() {
  load(0);
}

void load(int n) {
  try {
    File f = new File(sketchPath() +"/data/models/" + texture + ".mm");
    if (f.exists()) {
      String []data = loadStrings("/data/models/" +texture + ".mm");
      bend = Float.parseFloat(data[1]);
      b = Float.parseFloat(data[2]);
      h = Float.parseFloat(data[3]);
      scale2 = Float.parseFloat(data[4]);
      texAngle = Integer.parseInt(data[5]);
      sliders.get(0).setValue(bend);
      sliders.get(1).setValue(b);
      sliders.get(2).setValue(h);
      sliders.get(3).setValue(scale2);
      sliders.get(4).setValue(texAngle);
    }
  }
  catch(Exception e) {
  }
}

void resetCam(int n) {
  rot.set(0.7, 0.0, QUARTER_PI);
}

void mouseDragged() {
  if (camDrag) {
    rot.x+=(mouseY-pmouseY)*0.006;
    rot.y+=(mouseX-pmouseX)*0.006;
  }
}

void mousePressed() {
  if (mouseButton ==LEFT) {
    camDrag = ((mouseX> 250) || ( mouseY > 350));
  } else if (mouseButton ==RIGHT) {
    resetCam(0);
  }
}

void textureList(int n) {
  index = n;
  texture = (String)textureList.getItem(n).get("text");
  textureList.getCaptionLabel().set(texture);
  if (autoLoad) load();
  //textureList.close();
}

void addSlider(String varName, float initVal, float rangeLow, float rangeHigh, int ticks) {
  Slider s = cp5.addSlider(varName).setPosition(10, y+=yO).setSize(200, 5).setRange(rangeLow, rangeHigh).setValue(initVal).setNumberOfTickMarks(ticks);
  sliders.add(s);
}

void addSlider(String varName, float initVal, float rangeLow, float rangeHigh) {
  Slider s =  cp5.addSlider(varName).setPosition(10, y+=yO).setSize(200, 5).setRange(rangeLow, rangeHigh).setValue(initVal);
  sliders.add(s);
}