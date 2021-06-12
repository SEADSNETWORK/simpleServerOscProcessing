/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
ArrayList<DataSender> senders = new ArrayList<DataSender>();

int PORT = 12345;

int   WINO_AMOUNT = 2;
float WINO_SPEED = 100000.0;

int   PLANT_AMOUNT = 2;
float PLANT_SPEED = 1000.0;

int   GAME_AMOUNT = 1;
int   GAME_SPEED = 1000;


public class DataSender {
  int ID;
  double value;
  int seed;
   
  public DataSender(int ID_){
    ID = ID_;
    seed = (int) random(12345);
  }
  
  void setValue(float v){
    value = v;
  }
  
  String type(){
    return "undefined";
  }
  
  String addr(){
   return "/"+type()+"/"+ID;
  }
  
  String message(){
    return addr() + "   " + value + "\n";
  }
   
  void update(){
  
    OscMessage myMessage = new OscMessage(addr());
    myMessage.add(value); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
}


public class Winogradsky extends DataSender {
   
  public Winogradsky(int ID_){
    super(ID_);
  }
  
  String type(){
    return "winogradsky";
  }
  
  void update(){
    setValue(noise(frameCount / WINO_SPEED + seed));
    super.update();
  } 
}

public class Plant extends DataSender {
   
  public Plant(int ID_){
    super(ID_);
  }
  
  String type(){
    return "plant";
  }
  
  void update(){
    setValue(noise(frameCount / PLANT_SPEED + seed));
    super.update();
  } 
}

public class GamePress extends DataSender {
   int target = 0;
  public GamePress(int ID_){
    super(ID_);
    setTarget();
  }
  
  void setTarget(){
    target = frameCount + (int)random(GAME_SPEED);
  }
  
  String type(){
    return "gamepress";
  }
  
  void update(){
    boolean check = (frameCount == target);
    
    value = check?1.0:0.0;
    if(check){
      setTarget();
    }
    
    super.update();
  }
  
  
  String message(){
    return addr() + "   " + target + "->" + frameCount +"\n";
  }
  
}

void setup() {
  size(800,200);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,1);
  myRemoteLocation = new NetAddress("127.0.0.1",PORT);
  frameRate(30);
  
  for (int i = 0; i < WINO_AMOUNT; i++){
     senders.add(new Winogradsky(i));
  }
  
  for (int i = 0; i < PLANT_AMOUNT; i++){
     senders.add(new Plant(i));
  }
  
  for (int i = 0; i < GAME_AMOUNT; i++){
     senders.add(new GamePress(i));
  }
}


void draw() {
  background(0);
  //OscMessage myMessage = new OscMessage("/sensor1");
  //myMessage.add(noise(frameCount)); /* add an int to the osc message */
  //oscP5.send(myMessage, myRemoteLocation);
  
  String text = "";
  
  for (int i = 0; i < senders.size(); i++){
      DataSender s = senders.get(i);
      s.update();
      text += s.message();
      rect(width/2, 18 + i*24, (float)s.value*width/2 + 3, 15);
    }
  
  
  textSize(15);
  text(text, 10, 30);
  
  
}
