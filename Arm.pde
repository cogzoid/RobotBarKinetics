class Arm {
  private int num; // Number of points on the arm
  PVector start; // Start point of the arm
  PVector goal; // Point to go on
  float[] lines; // Length of all shafts connecting points
  float[] angles; // Angles of all shaft (counter-clockwise from the +x axis) //CCW from the previous angle
  float[] goalAngles; //Angles that everything wants to move towards.
  PVector[] points; // Points of the arm
  PVector[] goalPoints; //Goal Points of the Arm
  
  public Arm(int segments, PVector startPoint, PVector goalPoint) {
    num = segments;
    start = startPoint.copy();
    goal = goalPoint.copy();
    lines = new float[num - 1];
    angles = new float[num - 1];
    goalAngles = new float[num - 1];
    points = new PVector[num];
    goalPoints = new PVector[num];
    
    
    for (int i = 0; i < num - 1; ++i)
      lines[i] = 10;
    
    for (int i = 0; i < num - 1; ++i)
      angles[i] = 0;
      
    for (int i = 0; i < num - 1; ++i)
      goalAngles[i] = 0;  
  } 
  
  /*
  Calculate point position from lengths and angles
  May be used if angles and lengths are known from a servo
  In this example, it is more a way to init points
  */
  public void updatePoint() {
    points[0] = start.copy(); // First point at the start
    goalPoints[0] = start.copy();
    for (int i = 1; i < num; ++i) {
      /*
      dir is the vector representing the shaft at its angle
      add this vector to the previous position to find the current point
      */
      PVector dir = new PVector(cos(angles[i - 1]), sin(angles[i - 1])).mult(lines[i - 1]);
      points[i] = points[i - 1].copy().add(dir);
      goalPoints[i] = goalPoints[i - 1].copy().add(dir);
      
    }
  }
  
  /*
  Calculate angles from points position
  May be used to write position of servos
  In this example, it is NOT used
  */
  public void updateAngles() {
    for (int i = 0; i < num - 1; ++i) {
      /*
      Take two consecutive points
      Calculate the vector in between
      Then calculate the angle
      */
      
      PVector a = goalPoints[i].copy();
      PVector b = goalPoints[i + 1].copy();
    
      PVector Goaldir = b.sub(a);
      
      PVector c = points[i].copy();
      PVector d = points[i+1].copy();
      
      PVector dir = d.sub(c);
      
      //CHANGE  This will set the angle to [0,2*pi] and I might need it to be + or -, etc.
      goalAngles[i] = atan2(Goaldir.y, Goaldir.y);
      angles[i] = atan2(dir.y, dir.x); // atan2 is used to have an angle [0, 2*pi] whereas tan is [-pi/2, pi/2]
      
      angles[i] = angles[i] + min(abs(goalAngles[i]-angles[i]),.1) * (goalAngles[i]-angles[i])/abs(goalAngles[i]-angles[i]);
    }
  }
  
  /*
  Start from the goal and adjust point position to the start point
  */
  void backward() {
    goalPoints[num - 1] = goal.copy(); // Set last point on goal
    for (int i = num-1; i > 0; --i) {
      
      //calculate angle from goal to last point
      //move angle in direction to decrease goal angle difference
      //go to next angle.
      
      PVector a = goalPoints[i].copy();
      PVector b = goalPoints[i-1].copy();

      PVector dir = b.copy().sub(a).normalize().mult(lines[i - 1]);
      //float backAngle[i] = PVector.angleBetween(a,b);
    
      goalPoints[i - 1] = a.add(dir);
    }
  }
  /*
  Start from the start and adjust point position to the goal point
  */
  public void forward() {
    /*
    Same thing as backward() but forward
    */
    goalPoints[0] = start.copy();
    for (int i = 1; i < num; ++i) {
      PVector a = goalPoints[i-1].copy();
      PVector b = goalPoints[i].copy();
      
      PVector dir = b.copy().sub(a).normalize().mult(lines[i - 1]);
      goalPoints[i] = a.add(dir);
    }
  }
  
  /*
  Run backward and forward 'times' times
  */
  public void fit() { fit(1); }
  public void fit(int times)
  {
    for (int i = 0; i < times; ++i)
    {
      backward();
      forward();
    }
    updateAngles();
    for (int j = 0; j < num; j++){
      println(j, " ", points[j]);
    }
    
    updatePoint();
  }
  
  public void setShaftLength(int index, float length) {
    if (index < num)
    {
      lines[index] = length;
    }
  }
  
  public void setGoal(PVector point) {
    goal = point.copy();
  }
  
  public void setStart(PVector point) {
    start = point.copy();
  }
  
  public void draw() {
    for (int i = 0; i < num - 1; ++i) {
      PVector a = points[i].copy();
      PVector b = points[i+1].copy();
        
      strokeWeight(10);
      stroke(255, 0, 0);
      point(a.x, a.y);
      point(b.x, b.y);
        
      strokeWeight(1);
      stroke(255);
      line(a.x, a.y, b.x, b.y);
    }
  }
}
