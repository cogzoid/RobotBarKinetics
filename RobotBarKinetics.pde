
PVector start = new PVector(400, 400); // Start point of the arm
PVector goal = new PVector(400, 400); // Point to go on
Arm arm = new Arm(3, start, goal);

void setup()
{
  size(800, 800);
  
  // Set shafts length
  arm.setShaftLength(0, 180);
  arm.setShaftLength(1, 120);
  //arm.setShaftLength(2, 40);
  // init points
  arm.updatePoint();
  
}

void draw()
{
  background(0);
  stroke(255);
  
  // set goal to mouse pos
  goal = new PVector(mouseX, mouseY);
  
  // move points
  arm.fit(1);
  arm.setGoal(goal);

  // Draw goal in green
  strokeWeight(15);
  stroke(0, 0, 255);
  point(goal.x, goal.y);
  
  // Draw start in blue
  stroke(0, 255, 0);
  point(start.x, start.y);
  
  // Draw arm
  arm.draw();
}
