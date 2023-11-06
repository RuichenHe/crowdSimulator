public class Obstacle {
  private int ID;
  private String obstacleShape = "";
  private float[] obstacleInfo;

  public Obstacle(int ID, String obstacleShape, float[] obstacleInfo){
    this.ID = ID;
    this.obstacleShape = obstacleShape;
    this.obstacleInfo = obstacleInfo;
  }
  
  public void printInfo(){
    println("Current Obstacle ID: ", this.ID);
    println("Current Obstacle Shape: ", this.obstacleShape);
    println("Current Obstacle Info: ", this.obstacleInfo);
  }
  
}
