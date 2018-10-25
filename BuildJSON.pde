import java.util.Date;

void BuildJSON(int n) {
  String path = sketchPath() + "/data/models/";
  ArrayList<File> allFiles = listFilesRecursive(path);
  JSONArray modelsArray = new JSONArray();
  int i = 0;
  for (File f : allFiles) {
    println(f.getName());
    if (f.getName().contains(".mm")) {
      String p = "data/models/" + f.getName();
      String []data = loadStrings(p);
      println(p);
      JSONObject model = new JSONObject();
      model.setString("sprite", data[0]);
      model.setInt("type", 1);
      model.setFloat("bend", Float.parseFloat(data[1]));
      model.setFloat("height", Float.parseFloat(data[2]));
      if (data.length==6) {
        model.setInt("texAngle", Integer.parseInt(data[5]));
      } else {
        model.setInt("texAngle", 3);
      }
      modelsArray.setJSONObject(i, model);
    } 
    i++;
  }
  saveJSONArray(modelsArray, "MindyModels.json");
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    return null;
  }
}

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    return null;
  }
}

ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}