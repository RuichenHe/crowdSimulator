public class Agent {
  public int ID;
  public Vec2 location;
  public Vec2 goalPos;
  public Vec2 startPos;
  public Vec2 velocity;
  public Vec2 goalVelocity;
  public int curNodeID;
  public int nextNodeID;
  public float radius;
  
  
  public int startNode;
  public int goalNode;
  public boolean NAVIGATE;
  public ArrayList<Integer> path;
  public Vec2[] nodePos;
  public Vec2 force;
  
  public Agent(int ID, Vec2 location, Vec2 goal, Vec2 velocity){
    this.ID = ID;
    this.location = location;
    this.goalPos = goal;
    this.startPos = location;
    this.velocity = velocity;
    this.NAVIGATE = false;
    this.radius = 10;
  }
  
  public void reset(){
    this.curNodeID = 0;
    this.nextNodeID = 1;
    this.location = new Vec2(this.startPos.x,this.startPos.y);
    this.NAVIGATE = true;
  }
  
  public Agent reverse(){
    
    Agent a = new Agent(-ID, new Vec2(this.goalPos.x, this.goalPos.y), new Vec2(this.location.x, this.location.y), new Vec2(this.velocity.x, this.velocity.y));
    a.path = new ArrayList();
    for (int i = this.path.size() - 1; i > -1; i--){
      int currentPathId = this.path.get(i);
      a.path.add(currentPathId);
    }
    a.nodePos = new Vec2[this.nodePos.length];
    int i = 0;
    for (Vec2 n: this.nodePos){
      a.nodePos[i] = new Vec2(n.x, n.y);
      i = i + 1;
    }
    a.startNode = this.goalNode;
    a.goalNode = this.startNode;
    return a;
    
    
  }
  
  public void calculateGoalSpeed(){
    if (this.curNodeID == this.path.size() - 1){
      //println("Reach goal");
      //this.goalVelocity = new Vec2(0, 0);
      Vec2 dis = this.goalPos.minus(this.location);
      Vec2 dir = dis.normalized();
      this.goalVelocity = dir.times(50);
    } else {
      int nextNode = this.path.get(this.nextNodeID);
      Vec2 dis = this.nodePos[nextNode].minus(this.location);
      Vec2 dir = dis.normalized();
      this.goalVelocity = dir.times(50);
    }
  }
  
  public void updateVelocity(float dt){
    //this.velocity = new Vec2(this.goalVelocity.x, this.goalVelocity.y);
    this.velocity.add(this.force.times(dt));
    if (this.velocity.length() > 50){
      this.velocity.mul(50 / this.velocity.length());
    }
    //println(this.velocity.x, this.velocity.y);
  }
  
  public void updateLocation(float dt){
    this.location.add(this.velocity.times(dt));
  }
  public void moveAwayFromObstacle(Obstacle o){
    Vec2 obs_center;
    Vec2 dir;
    switch (o.obstacleShape){
      case "Circle":
        obs_center = new Vec2(o.obstacleInfo[0], o.obstacleInfo[1]);
        float dis = 10 + o.obstacleInfo[2] - obs_center.minus(this.location).length();
        if (dis < 0){
          break;
        }
        dir = obs_center.minus(this.location).normalized();
        //println("Dis: ", dis);
        this.location.subtract(dir.times(dis));
        //println("Dir velocity", abs(dot(dir,this.velocity)));
        this.velocity.subtract(dir.times(abs(dot(dir,this.velocity))));
        break;
      default:
        obs_center = new Vec2(o.obstacleInfo[0], o.obstacleInfo[1]);
        dir = obs_center.minus(this.location).normalized();
        this.location.subtract(dir.times(random(1, 3)));
        this.velocity.subtract(dir.times(abs(dot(dir,this.velocity))));
        break;
    }
    //println("New velocity", this.velocity.length());
    
  }
  public void updateObstacles(ArrayList<Obstacle> oList){
    for (Obstacle o: oList){
      if (pointInObstacle(o, 10, this.location)){
        //println("Collide with obstacle: ", o.ID);
        this.moveAwayFromObstacle(o);
      }
    }
  }
  
  public void updateGoal(){
    if (this.curNodeID == this.path.size() - 1){
      if (this.location.minus(this.goalPos).length() <= 1){
        this.location = new Vec2(this.goalPos.x, this.goalPos.y);
        //println("Reach goal");
        this.NAVIGATE = false;
      }
      
    } else {
      int nextNode = this.path.get(this.nextNodeID);
      if (this.location.minus(this.nodePos[nextNode]).length() <= 10){
        //this.location = new Vec2(this.nodePos[nextNode].x, this.nodePos[nextNode].y);
        Vec2 dis = this.nodePos[nextNode].minus(this.location);
        Vec2 dir = dis.normalized();
        this.velocity = dir.times(this.velocity.length());
        this.goalVelocity = dir.times(50);
        this.curNodeID = this.nextNodeID;
        this.nextNodeID = this.curNodeID + 1;
      } else if (this.nextNodeID + 1 < this.path.size() - 1 && this.location.minus(this.nodePos[this.path.get(this.nextNodeID + 1)]).length() + 5 <  this.nodePos[nextNode].minus(this.nodePos[this.path.get(this.nextNodeID + 1)]).length()){
        //this.location = new Vec2(this.nodePos[nextNode].x, this.nodePos[nextNode].y);
        Vec2 dis = this.nodePos[nextNode].minus(this.location);
        Vec2 dir = dis.normalized();
        this.velocity = dir.times(this.velocity.length());
        this.goalVelocity = dir.times(50);
        this.curNodeID = this.nextNodeID;
        this.nextNodeID = this.curNodeID + 1;
      }
    }
  }
  
  public void navigate(ArrayList<Agent> aList){
    if (this.NAVIGATE == false){
      return;
    } else {
      this.calculateGoalSpeed();
      this.force = this.goalVelocity.minus(this.velocity).times(2); //Compute goal force
      for (Agent a: aList){
        if (a.ID != this.ID && a.NAVIGATE == true){
          float t = this.ttc(a);
          Vec2 FAvoid = new Vec2(0, 0);
          float tH = 5;
          float mag = 0;
          if (t >= 0 && t <= tH){
            mag = (tH-t)/(t + 0.001);
            //println("mag");
            //println(mag);
          }
          float maxF = 10;
          if (mag > maxF){
            mag = maxF;
          }
          if (t >= 0 && t <= tH){
            FAvoid = this.location.plus(this.velocity.times(t)).minus(a.location.plus(a.velocity.times(t)));
            if (FAvoid.x != 0 || FAvoid.y != 0){
              FAvoid.normalize();
            }
           
          }
          FAvoid.mul(mag*40);
          //println("Avoid force");
          println(this.ID);
          println(FAvoid.x, FAvoid.y);
          this.force.add(FAvoid);
        }
        
      }
    }
  }
  
  public void update(float dt, ArrayList<Obstacle> oList){
    if (this.NAVIGATE == false){
      return;
    }
    this.updateVelocity(dt);
    this.updateLocation(dt);
    this.updateObstacles(oList);
    this.updateGoal();
  }
  
  
  public float ttc(Agent a){
    //http://www.gameaipro.com/GameAIPro2/GameAIPro2_Chapter19_Guide_to_Anticipatory_Collision_Avoidance.pdf
    float r = this.radius +  a.radius;
    Vec2 w = a.location.minus(this.location);
    float c = dot(w, w) - pow(r, 2);
    if (c < 0){
      //agents are colliding
      return 0;
    }   
    Vec2 v = this.velocity.minus(a.velocity);
    float b = dot(w, v);
    float discr = pow(b, 2) - dot(v, v)*c;
    if (discr <= 0){
      return Float.MAX_VALUE;
    }
    float tau = (b - sqrt(discr))/dot(v, v);
    if (tau < 0){
      return Float.MAX_VALUE;
    }
    return tau;
  }
    
  
}
