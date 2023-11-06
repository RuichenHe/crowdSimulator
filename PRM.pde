public class PRM {
  public int numNodes;
  public Vec2[] nodePos;
  public ArrayList<Integer>[] neighbors;
  Boolean[] visited;
  int[] parent;
  ArrayList<Obstacle> oList;
  ArrayList<Integer> path;
  public PRM(int numNodes, ArrayList<Obstacle> oList){
    this.numNodes = numNodes;
    this.nodePos = new Vec2[this.numNodes];
    
    this.neighbors = new ArrayList[this.numNodes];
    this.visited = new Boolean[this.numNodes];
    this.parent = new int[this.numNodes];
    this.oList = oList;
  }
  
  public void generateRandomNodes(){
    for (int i = 0; i < this.numNodes - 2; i++){
      Vec2 randPos = new Vec2(random(10, width-10),random(10, height-10));
      while (pointInObstacleList(this.oList, 10, randPos)){
        randPos = new Vec2(random(10, width-10),random(10, height-10));
      }
      this.nodePos[i] = randPos;
    }
  }
  
  public void updateAgentInfo(Agent a){
    this.nodePos[this.numNodes - 2] = new Vec2(a.location.x, a.location.y);
    this.nodePos[this.numNodes - 1] = new Vec2(a.goalPos.x, a.goalPos.y);
  }
  
  public void connectNeighbors(){
    for (int i = 0; i < this.numNodes; i++){
      this.neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
      for (int j = 0; j < this.numNodes; j++){
        if (i == j) continue; //don't connect to myself 
        Vec2 dir = this.nodePos[j].minus(this.nodePos[i]).normalized();
        float distBetween = this.nodePos[i].distanceTo(this.nodePos[j]);
        hitInfo obstacleListCheck = rayObstacleListIntersect(this.oList, this.nodePos[i], dir, distBetween);
        if (this.numNodes == 2){
          if (!obstacleListCheck.hit){
            this.neighbors[i].add(j);
          }
        } else {
          if (!obstacleListCheck.hit && distBetween < 200){
            this.neighbors[i].add(j);
          }
        }
        
      }
    }
  }
  public void build(Agent a){
    this.generateRandomNodes();
    this.updateAgentInfo(a);
    this.connectNeighbors();
  }
  
  public int findClosestNode(Vec2 point){
    float dist = Float.MAX_VALUE;
    int id = -1;
    int i = -1;
    for (Vec2 center : this.nodePos){
      i = i + 1;
      Vec2 dir = center.minus(point).normalized();
      float distBetween = point.distanceTo(center);
      hitInfo obstacleListCheck = rayObstacleListIntersect(this.oList, point, dir, distBetween);
      
      float currentDist = point.distanceTo(center);
      if (!obstacleListCheck.hit && currentDist < dist){
        id = i;
        dist = currentDist;
      }
    }
    //TODO: Return the closest node the passed in point
    return id;
  }
  
  void runBFS(int startID, int goalID){
    
    startNode = startID;
    goalNode = goalID;
    ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
    this.path = new ArrayList(); //Reset path
    for (int i = 0; i < this.numNodes; i++) { //Clear visit tags and parent pointers
      this.visited[i] = false;
      this.parent[i] = -1; //No parent yet
    }
  
    //println("\nBeginning Search");
    
    this.visited[startID] = true;
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
      for (int i = 0; i < this.neighbors[currentNode].size(); i++){
        int neighborNode = this.neighbors[currentNode].get(i);
        if (!this.visited[neighborNode]){
          this.visited[neighborNode] = true;
          this.parent[neighborNode] = currentNode;
          fringe.add(neighborNode);
          //println("Added node", neighborNode, "to the fringe.");
          //println(" Current Fringe: ", fringe);
        }
      } 
    }
    
    //print("\nReverse path: ");
    int prevNode = this.parent[goalID];
    this.path.add(0,goalID);
    //print(goalID, " ");
    while (prevNode >= 0){
      //print(prevNode," ");
      this.path.add(0,prevNode);
      prevNode = this.parent[prevNode];
    }
    //print("\n");
  }
  
}
