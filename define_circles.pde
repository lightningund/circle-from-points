final float PICKUP_RADIUS = 20;

PVector[] points;

int selPoint = -1;

void setup(){
  size(800, 800);
  
  points = new PVector[3];
  points[0] = new PVector(400, 300);
  points[1] = new PVector(300, 400);
  points[2] = new PVector(500, 400);
}

void draw(){
  background(128);
  updatePoint();
  drawLines();
  drawPoints();
  findCenter();
}

void mousePressed(){
  if(selPoint == -1){
    for(int i = 0; i < points.length; i ++){
      if(dist(points[i].x, points[i].y, mouseX, mouseY) < PICKUP_RADIUS){
        selPoint = i;
        return;
      }
    }
  } else {
    selPoint = -1;
  }
}

void updatePoint(){
  if(selPoint == -1) return;
  points[selPoint].x = mouseX;
  points[selPoint].y = mouseY;
}

void drawPoints(){
  push();
  strokeWeight(5);
  stroke(255);
  for(PVector p : points){
    point(p.x, p.y);
  }
  pop();
}

void drawLines(){
  stroke(0);
  for(int i = 0; i < points.length; i ++){
    PVector pointA = points[i];
    PVector pointB = points[(i + 1) % points.length];
    float x = lerp(pointA.x, pointB.x, 0.5);
    float y = lerp(pointA.y, pointB.y, 0.5);
    PVector facing = PVector.fromAngle(PVector.sub(pointA, pointB).heading() + HALF_PI).mult(800);
    line(x - facing.x, y - facing.y, x + facing.x, y + facing.y);
  }
}

void findCenter(){
  float ax = points[0].x;
  float ay = points[0].y;
  float bx = points[1].x;
  float by = points[1].y;
  float cx = points[2].x;
  float cy = points[2].y;
  
  float gdx = bx - ax;
  float gdy = by - ay;
  float fdx = cx - bx;
  float fdy = cy - by;
  
  float gcx = ax + gdx / 2;
  float gcy = ay + gdy / 2;
  float fcx = bx + fdx / 2;
  float fcy = by + fdy / 2;
  
  float gm = -(gdx / gdy);
  float gc = gcy - (gcx * gm);
  float fm = -(fdx / fdy);
  float fc = fcy - (fcx * fm);
  
  float x = (gc - fc) / (fm - gm);
  float y = gm * x + gc;
  
  push();
  strokeWeight(5);
  stroke(255, 0, 0);
  point(x, y);
  pop();
  
  float rad = dist(x, y, points[0].x, points[0].y);
  
  push();
  stroke(0, 255, 0);
  noFill();
  circle(x, y, rad * 2);
  pop();
}
