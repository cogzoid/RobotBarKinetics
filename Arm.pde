class Arm {
  private int num; // Number of points on the arm
  PVector start; // Start point of the arm
  PVector goal; // Point to go on
  float[] lines; // Length of all shafts connecting points
  float[] angles; // Angles of all shaft (counter-clockwise from the +x axis) //CCW from the previous angle
  PVector[] points; // Points of the arm
  
  public Arm(int segments, PVector startPoint, PVector goalPoint) {
    num = segments;
    start = startPoint.copy();
    goal = goalPoint.copy();
    lines = new float[num - 1];
    angles = new float[num - 1];
    points = new PVector[num];
    
    for (int i = 0; i < num - 1; ++i)
      lines[i] = 10;
    
    for (int i = 0; i < num - 1; ++i)
      angles[i] = 0;
  } 
  
  /*
  Calculate point position from lengths and angles
  May be used if angles and lengths are known from a servo
  In this example, it is more a way to init points
  */
  public void updatePoint() {
    points[0] = start.copy(); // First point at the start
    for (int i = 1; i < num; ++i) {
      /*
      dir is the vector representing the shaft at its angle
      add this vector to the previous position to find the current point
      */
      PVector dir = new PVector(cos(angles[i - 1]), sin(angles[i - 1])).mult(lines[i - 1]);
      points[i] = points[i - 1].copy().add(dir);
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
      PVector a = points[i].copy();
      PVector b = points[i + 1].copy();
    
      PVector dir = b.sub(a);
      angles[i] = atan2(dir.y, dir.x); // atan2 is used to have an angle [0, 2*pi] whereas tan is [-pi/2, pi/2]
    }
  }
  
  /*
  Start from the goal and adjust point position to the start point
  */
  void backward() {
    //points[num - 1] = goal.copy(); // Set last point on goal
    for (int i = num; i > 0; --i) {
      
      //calculate angle from goal to last point
      //move angle in direction to decrease goal angle difference
      //go to next angle.
      //testing git
      
      PVector a = points[i].copy();
      PVector b = points[i-1].copy();

      PVector dir = b.copy().sub(a).normalize().mult(lines[i - 1]);
      
    
      points[i - 1] = a.add(dir);
    }
  }
  /*
  Start from the start and adjust point position to the goal point
  */
  public void forward() {
    /*
    Same thing as backward() but forward
    */
    points[0] = start.copy();
    for (int i = 1; i < num; ++i) {
      PVector a = points[i-1].copy();
      PVector b = points[i].copy();
      
      PVector dir = b.copy().sub(a).normalize().mult(lines[i - 1]);
      points[i] = a.add(dir);
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
