import java.util.ArrayList;
//A list of circle obstacles
int numObstacles = 0;
static int numObstaclesBox = 0;
Vec2 circlePos[] = new Vec2[numObstacles]; //Circle positions
float circleRad[] = new float[numObstacles];  //Circle radii

Vec2  boxTopLeftList[] = new Vec2[numObstaclesBox]; //Box positions, top left
Vec2 boxDimList[] = new Vec2[numObstaclesBox]; // w, h


//A box obstacle
Vec2 boxTopLeft = new Vec2(100,100);
float boxW = 100;
float boxH = 250;

Vec2 startPos = new Vec2(100,500);
Vec2 goalPos = new Vec2(500,200);
Vec2 dragInit;
Vec2 initPosObs;
String selectType = "Box";
int selectId = -1;
boolean obstacleChosen = false;
boolean NAVIGATE = false;
int curNodeID = -1;
int nextNodeID = -1;
Vec2 currentNodeLoc;
int maxAgent = 20;


ArrayList<Obstacle> obstacleList;
ArrayList<Agent> agentList;
PRM prm;


void placeRandomAgent(){
  agentList = new ArrayList<Agent>();

  for (int i = 0; i < maxAgent; i++){
    Vec2 randPos = new Vec2(random(10, width-10),random(10, height -10));
    while (pointInObstacleList(obstacleList, 10, randPos)){
      randPos = new Vec2(random(10, width-10),random(10, height -10));
    }
    Vec2 randGoal = new Vec2(random(10, width-10),random(10, height -10));
    while (pointInObstacleList(obstacleList, 10, randGoal)){
      randGoal = new Vec2(random(10, width-10),random(10, height -10));
    }
    agentList.add(new Agent(i+1, randPos, randGoal, new Vec2(0, 0)));
  }
}

void placePredefinedAgent(){
  agentList = new ArrayList<Agent>();
  float r = min(height/2, width/2) * random(0.4, 0.8);
  float theta0 = random(0, 90);
  int numAgent = int(random(2, 20));
  for (int i = 0; i < numAgent; i++){
    float theta = radians(180.0/numAgent * i + theta0);
    Vec2 randPos = new Vec2(width/2 + r * cos(theta) ,height/2 + r * sin(theta));
    Vec2 randGoal = new Vec2(width/2 - r * cos(theta) ,height/2 - r * sin(theta));
    agentList.add(new Agent(i+1, randPos, randGoal, new Vec2(0, 0)));
  }

}


void placeRandomObstacles(){
  //Initial obstacle position
  obstacleList = new ArrayList<Obstacle>();
  int obstacleNum = 0;
  for (int i = 0; i < numObstacles; i++){
    Vec2 circlePos = new Vec2(random(50,950),random(50,700));
    float circleRad = (10+40*pow(random(1),3));
    int ID = obstacleNum;
    String obstacleShape = "Circle";
    float[] obstacleInfo = {circlePos.x, circlePos.y, circleRad};
    Obstacle currentObstacle = new Obstacle(ID, obstacleShape, obstacleInfo);
    obstacleList.add(currentObstacle);
    obstacleNum = obstacleNum + 1;
  }
  for (int i = 0; i < numObstaclesBox; i++){
    Vec2 boxTopLeftList = new Vec2(random(50,950),random(50,700));
    Vec2 boxDimList = new Vec2(40+40*pow(random(1),3),40+40*pow(random(1),3));
    int ID = obstacleNum;
    String obstacleShape = "Box";
    float[] obstacleInfo = {boxTopLeftList.x, boxTopLeftList.y, boxDimList.x, boxDimList.y};
    Obstacle currentObstacle = new Obstacle(ID, obstacleShape, obstacleInfo);
    obstacleList.add(currentObstacle);
    obstacleNum = obstacleNum + 1;
  }
  
}

int strokeWidth = 2;
void setup(){
  size(1024,768);
  placeRandomObstacles();
  placeRandomAgent();

  for (Agent a: agentList){
    if (numObstacles + numObstaclesBox == 0){
      prm = new PRM(2, obstacleList);
    } else {
      prm = new PRM(numNodes, obstacleList);
    }
    prm.build(a);
    a.startNode = prm.findClosestNode(a.location);
    a.goalNode = prm.findClosestNode(a.goalPos);
    prm.runBFS(a.startNode, a.goalNode);
    a.path = prm.path;
    a.nodePos = prm.nodePos;
  }
}

void draw(){
  //println("FrameRate:",frameRate);
  noStroke();
  background(0); //Grey background
  stroke(0,0,0);

  fill(255,255,255);
  for (Obstacle o: obstacleList){
    String currentObstacleShape = o.obstacleShape;
    float[] currentObstacleInfo = o.obstacleInfo;
    switch(currentObstacleShape){
      case "Box": 
        rect(currentObstacleInfo[0], currentObstacleInfo[1], currentObstacleInfo[2], currentObstacleInfo[3]);
        break;
      case "Circle":
        circle(currentObstacleInfo[0], currentObstacleInfo[1], currentObstacleInfo[2] * 2);
        break;
      default:
        break;
    }
  }
  //fill(30, 30, 90);
  //circle(startPos.x, startPos.y, 10 * 2);
  //fill(90, 90, 30);
  //circle(goalPos.x, goalPos.y, 10 * 2);
  //for (Agent a: agentList){
  //  fill(30, 30, 90);
  //  circle(a.location.x, a.location.y, 10 * 2);
  //  fill(90, 90, 30);
  //  circle(a.goal.x, a.goal.y, 10 * 2);
  //}
  

  //fill(0);
  //for (int i = 0; i < numNodes; i++){
  //  circle(nodePos[i].x,nodePos[i].y,5);
  //}
  
  ////Draw graph
  //stroke(100,100,100);
  //strokeWeight(1);
  //for (int i = 0; i < numNodes; i++){
  //  for (int j : neighbors[i]){
  //    line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
  //  }
  //}
  
  //Draw Start and Goal
  for (Agent a: agentList){
    fill(20,60,250);
    circle(a.nodePos[a.startNode].x,a.nodePos[a.startNode].y,20);
    //circle(startPos.x,startPos.y,20);
    fill(250,30,50);
    circle(a.nodePos[a.goalNode].x,a.nodePos[a.goalNode].y,20);
  }
  
  for (Agent a: agentList){
    stroke(20,255,40,100);
    if (a.NAVIGATE == false){
      stroke(20,255,40,20);
    }
    
    strokeWeight(2);
    for (int i = 0; i < a.path.size()-1; i++){
      int curNode = a.path.get(i);
      int nextNode = a.path.get(i+1);
      line(a.nodePos[curNode].x,a.nodePos[curNode].y,a.nodePos[nextNode].x,a.nodePos[nextNode].y);
    }
  }
  
  
  
  for (Agent a: agentList){
    a.navigate(agentList);
  }
  for (Agent a: agentList){
    a.update(1/frameRate, obstacleList);
  }
  
  
  
  for (Agent a: agentList){
    strokeWeight(0);
    fill(20,250,60);
    if (a.NAVIGATE == false){
      fill(20,250,60,128);
    }
    circle(a.location.x, a.location.y,20);
    strokeWeight(2);
    stroke(10,10,10);
    Vec2 endNode = a.location.plus(a.velocity.normalized().times(10));
    line(a.location.x, a.location.y, endNode.x, endNode.y);
    //println("Agent id: ", a.ID, "  x: ", a.location.x);
  }
  
  
}

void keyPressed(){
  if (key == 'r'){
    NAVIGATE = false;
    maxAgent = int(random(2, 20));
    numObstacles = int(random(5, 15));
    placeRandomObstacles();
    placeRandomAgent();
    for (Agent a: agentList){
      if (numObstacles + numObstaclesBox == 0){
        prm = new PRM(2, obstacleList);
      } else {
        prm = new PRM(numNodes, obstacleList);
      }
      prm.build(a);
      a.startNode = prm.findClosestNode(a.location);
      a.goalNode = prm.findClosestNode(a.goalPos);
      prm.runBFS(a.startNode, a.goalNode);
      a.path = prm.path;
      a.nodePos = prm.nodePos;
    }
  }
  
  if (key == '1'){
    NAVIGATE = false;
    maxAgent = int(random(2, 20));
    obstacleList = new ArrayList<Obstacle>();
    
    placeRandomAgent();
    ArrayList<Agent> revAgentList = new ArrayList<Agent>();
    for (Agent a: agentList){
      prm = new PRM(2, obstacleList);
      prm.build(a);
      a.startNode = prm.findClosestNode(a.location);
      a.goalNode = prm.findClosestNode(a.goalPos);
      prm.runBFS(a.startNode, a.goalNode);
      a.path = prm.path;
      a.nodePos = prm.nodePos;
      Agent revA = a.reverse();
      revAgentList.add(revA);
    }
    for (Agent a: revAgentList){
      agentList.add(a);
    }
  }
  
  if (key == '2'){
    NAVIGATE = false;
    maxAgent = int(random(2, 20));
    obstacleList = new ArrayList<Obstacle>();
    placePredefinedAgent();
    ArrayList<Agent> revAgentList = new ArrayList<Agent>();
    for (Agent a: agentList){
      prm = new PRM(2, obstacleList);
      prm.build(a);
      a.startNode = prm.findClosestNode(a.location);
      a.goalNode = prm.findClosestNode(a.goalPos);
      prm.runBFS(a.startNode, a.goalNode);
      a.path = prm.path;
      a.nodePos = prm.nodePos;
      Agent revA = a.reverse();
      revAgentList.add(revA);
    }
    for (Agent a: revAgentList){
      agentList.add(a);
    }
  }
  
  if (key == 'd'){
    NAVIGATE = false;
    numObstacles = int(random(5, 15));
    maxAgent = int(random(2, 15));
    placeRandomObstacles();
    placeRandomAgent();
    ArrayList<Agent> revAgentList = new ArrayList<Agent>();
    for (Agent a: agentList){
      if (numObstacles + numObstaclesBox == 0){
        prm = new PRM(2, obstacleList);
      } else {
        prm = new PRM(numNodes, obstacleList);
      }
      prm.build(a);
      a.startNode = prm.findClosestNode(a.location);
      a.goalNode = prm.findClosestNode(a.goalPos);
      prm.runBFS(a.startNode, a.goalNode);
      a.path = prm.path;
      a.nodePos = prm.nodePos;
      Agent revA = a.reverse();
      revAgentList.add(revA);
    }
    
    for (Agent a: revAgentList){
      agentList.add(a);
    }
  }
  
  if (key == ' '){
    println("start node id", startNode);
    NAVIGATE = true;
    curNodeID = 0;
    nextNodeID = 1;
    println("Begin moving");
    currentNodeLoc = new Vec2(startPos.x,startPos.y);
    for (Agent a: agentList){
      a.reset();
    }
  }
}

void navigate(float dt){
  if (curNodeID == path.size()){
    println("Reach goal");
    NAVIGATE = false;
    return;
  }
  else if (curNodeID == path.size()-1){
    int curNode = path.get(curNodeID);
    Vec2 dis = goalPos.minus(nodePos[curNode]);
    Vec2 dir = dis.normalized();
    currentNodeLoc.add(dir.times(dt * 50));
    if (currentNodeLoc.minus(nodePos[curNode]).length() >= dis.length()){
      currentNodeLoc = new Vec2(goalPos.x, goalPos.y);
      curNodeID = nextNodeID;
      nextNodeID = curNodeID + 1;
      println("Reach current Node");
      agentList.get(0).location = new Vec2(currentNodeLoc.x, currentNodeLoc.y);
    }
  }
  else if (curNodeID > -1){
    int curNode = path.get(curNodeID);
    int nextNode = path.get(nextNodeID);
    Vec2 dis = nodePos[nextNode].minus(nodePos[curNode]);
    Vec2 dir = dis.normalized();
    currentNodeLoc.add(dir.times(dt * 50));
    if (currentNodeLoc.minus(nodePos[curNode]).length() >= dis.length()){
      currentNodeLoc = new Vec2(nodePos[nextNode].x, nodePos[nextNode].y);
      curNodeID = nextNodeID;
      nextNodeID = curNodeID + 1;
      println("Reach current Node");
    }
    agentList.get(0).location = new Vec2(currentNodeLoc.x, currentNodeLoc.y);
  } else {
    int nextNode = path.get(nextNodeID);
    Vec2 dis = nodePos[nextNode].minus(startPos);
    Vec2 dir = dis.normalized();
    currentNodeLoc.add(dir.times(dt * 50));
    if (currentNodeLoc.minus(startPos).length() >= dis.length()){
      currentNodeLoc = new Vec2(nodePos[nextNode].x, nodePos[nextNode].y);
      curNodeID = nextNodeID;
      nextNodeID = curNodeID + 1;
      println("Reach current Node");
    }
    agentList.get(0).location = new Vec2(currentNodeLoc.x, currentNodeLoc.y);
  }
}

int closestNode(Vec2 point){
  float dist = Float.MAX_VALUE;
  int id = int(random(numNodes));
  int i = -1;
  for (Vec2 center : nodePos){
    i = i + 1;
    Vec2 dir = center.minus(point).normalized();
    float distBetween = point.distanceTo(center);
    hitInfo obstacleListCheck = rayObstacleListIntersect(obstacleList, point, dir, distBetween);
    
    float currentDist = point.distanceTo(center);
    if (!obstacleListCheck.hit && currentDist < dist){
      id = i;
      dist = currentDist;
    }
  }
  //TODO: Return the closest node the passed in point
  return id;
}

void mousePressed(){
  goalPos = new Vec2(mouseX, mouseY);
  if (checkSelection(goalPos)){
    println("inside obs");
    obstacleChosen = true;
    dragInit = goalPos;
    switch (selectType){
      case "Box":
        initPosObs = boxTopLeftList[selectId];;
        break;
      case "Circle":
        initPosObs = circlePos[selectId];
        break;
      default:
        break;
    }
    
  } else{
    println("New Goal is",goalPos.x, goalPos.y);
    runBFS(closestNode(startPos),closestNode(goalPos));
    obstacleChosen = false;
  }
  
}

void mouseReleased(){
  if (obstacleChosen){
    obstacleChosen = false;
    println("Obstacles released");
  }
}


void mouseDragged(){
  println(dragInit.x, dragInit.y);
  if (obstacleChosen){
    Vec2 currentLoc = new Vec2(mouseX, mouseY);
    switch (selectType){
      case "Box":
        boxTopLeftList[selectId] = initPosObs.plus(currentLoc.minus(dragInit));
        break;
      case "Circle":
        circlePos[selectId] = initPosObs.plus(currentLoc.minus(dragInit));
        break;
      default:
        break;
    }
    buildPRM();
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
}



/////////
// Point Intersection Tests
/////////



boolean checkSelection(Vec2 pointPos){
  for (int i = 0; i < numObstaclesBox; i++){
    Vec2 center =  boxTopLeftList[i];
    float w = boxDimList[i].x;
    float h = boxDimList[i].y;
    if (pointInBox(center, w, h, pointPos)){
      selectType = "Box";
      selectId = i;
      return true;
    }
  }
  
  for (int i = 0; i < numObstacles; i++){
    Vec2 center =  circlePos[i];
    float r = circleRad[i];
    if (pointInCircle(center,r,pointPos)){
      selectType = "Circle";
      selectId = i;
      return true;
    }
  }
  
  return false;
}

boolean pointInObstacle(Obstacle o, float agentR, Vec2 pointPos){
  String currentObstacleShape = o.obstacleShape;
  float[] currentObstacleInfo = o.obstacleInfo;
  switch(currentObstacleShape){
    case "Box":
      if (pointPos.x > currentObstacleInfo[0] - agentR && pointPos.x < currentObstacleInfo[0] + currentObstacleInfo[2] + agentR&& pointPos.y > currentObstacleInfo[1] - agentR && pointPos.y < currentObstacleInfo[1] + currentObstacleInfo[3] + agentR){
        return true;
      }
      return false;
    case "Circle":
      Vec2 currentCenter = new Vec2(currentObstacleInfo[0], currentObstacleInfo[1]);
      float dist = pointPos.distanceTo(currentCenter);
      if (dist < currentObstacleInfo[2]+2+agentR){ //small safety factor
        return true;
      }
      return false;
    default:
      return false;
  }
}

boolean pointInObstacleList(ArrayList<Obstacle> oList, float agentR, Vec2 pointPos){
  for (Obstacle o: oList){
    if (pointInObstacle(o, agentR, pointPos)){
      return true;
    }
  }
  return false;
}

//Returns true if the point is inside a box
boolean pointInBox(Vec2 boxTopLeft, float boxW, float boxH, Vec2 pointPos){
  if (pointPos.x > boxTopLeft.x - 10 && pointPos.x < boxTopLeft.x + boxW + 10&& pointPos.y > boxTopLeft.y - 10 && pointPos.y < boxTopLeft.y + boxH + 10){
    return true;
  }
  //TODO: Return true if the point is actually inside the box
  return false;
}

boolean pointInBoxList(Vec2[] centers, Vec2[] whs, Vec2 pointPos){
  for (int i = 0; i < numObstaclesBox; i++){
    Vec2 center =  centers[i];
    float w = whs[i].x;
    float h = whs[i].y;
    if (pointInBox(center, w, h, pointPos)){
      return true;
    }
  }
  return false;
}

//Returns true if the point is inside a circle
boolean pointInCircle(Vec2 center, float r, Vec2 pointPos){
  float dist = pointPos.distanceTo(center);
  if (dist < r+2+10){ //small safety factor
    return true;
  }
  return false;
}

//Returns true if the point is inside a list of circle
boolean pointInCircleList(Vec2[] centers, float[] radii, Vec2 pointPos){
  for (int i = 0; i < numObstacles; i++){
    Vec2 center =  centers[i];
    float r = radii[i];
    if (pointInCircle(center,r,pointPos)){
      return true;
    }
  }
  return false;
}

/////////////////////////////////
// A Probabilistic Roadmap (PRM)
////////////////////////////////

int numNodes = 100;

//The optimal path found along the PRM
ArrayList<Integer> path = new ArrayList();
int startNode, goalNode; //The actual node the PRM tries to connect do

//Represent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node

//The PRM uses the above graph, along with a list of node positions
Vec2[] nodePos = new Vec2[numNodes];

//Generate non-colliding PRM nodes
void generateRandomNodes(){
  for (int i = 0; i < numNodes - 2; i++){
    Vec2 randPos = new Vec2(random(10, width-10),random(10, height-10));
    while (pointInObstacleList(obstacleList, 10, randPos)){
      randPos = new Vec2(random(10, width-10),random(10, height-10));
      //insideAnyCircle = pointInCircleList(circleCenters,circleRadii,randPos);
      //insideAnyBox = pointInBoxList(boxList, whList, randPos);
    }
    nodePos[i] = randPos;
  }
  nodePos[numNodes - 2] = new Vec2(startPos.x, startPos.y);
  nodePos[numNodes - 1] = new Vec2(goalPos.x, goalPos.y);
}


//Set which nodes are connected to which neighbors based on PRM rules
void connectNeighbors(){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      hitInfo obstacleListCheck = rayObstacleListIntersect(obstacleList, nodePos[i], dir, distBetween);
      if (!obstacleListCheck.hit && distBetween < 200){
        neighbors[i].add(j);
      }
    }
  }
}

//Build the PRM
// 1. Generate collision-free nodes
// 2. Connect mutually visible nodes as graph neighbors
void buildPRM(){
  generateRandomNodes();
  connectNeighbors();
}

//BFS
void runBFS(int startID, int goalID){
  startNode = startID;
  goalNode = goalID;
  ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
  path = new ArrayList(); //Reset path
  for (int i = 0; i < numNodes; i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }

  //println("\nBeginning Search");
  
  visited[startID] = true;
  fringe.add(startID);
  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fring: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goalID){
      println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
      }
    } 
  }
  
  //print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(0,goalID);
  //print(goalID, " ");
  while (prevNode >= 0){
    //print(prevNode," ");
    path.add(0,prevNode);
    prevNode = parent[prevNode];
  }
  //print("\n");
}
