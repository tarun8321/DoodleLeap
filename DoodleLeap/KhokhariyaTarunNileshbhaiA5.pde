/*
      KHOKHARIYA TARUN NILESHBHAI
      STUDENT ID :- 7974360
      COURSE :- COMP-1010-A01
      PROFESSOR :- POUYA AGHAHOSEIN
      ASSIGNMENT 5 QUESTION DOODLER GAME
      
      THIS IS THE DOODLER GAME IN WHICH THERE IS THE DOODLER WHOS TASK IS TO
      JUMP ON THE PLATEFORM AND REACH HIGHEST IT CAN THER ARE 4 DIFFERENT TYPE 
      OF PLATFORM WHICH HAVE DIFFERENT JUMP CAPACITY AND SOME CAN JUST USE ONE
      TIME TO JUMP ITS THE FUN GAME TO PLAY :)
*/

//Global variavble

PImage doodlerLeftImg;//Doodler left image
PImage doodlerRightImg;//Doodler right image

int doodlerSize = 50;
float doodlerX;//Doodler x coordinate
float doodlerY;//Doodler y coordinate
float doodlerYSpeed;//Doodler y speed
float doodlerXSpeed = 5;//Doodler x speed
int platformWidth = 50;//Plateform width
int platformHeight = 10;//Plateform height
int numOfPlatforms = 1000;//No. of plateform
float[] platformX;//Plateform x coordinate
float[] platformY;//Plateform y coordinate
boolean[] platformExists;//Plateform exists or not
int[] platformTypes;//Types of plateform
float[] platformSpeeds;//Plateform speed
float gravity = 0.35;//Gravity for the doodler
float scrollSpeed = 0;//Screen Scroll speed
//Plateform color
int[] platformColors = {
  #4aba00, // Green
  #3cbfd3, // Blue
  #8e5c22, // Brown
  #fbb311  // Orange
};
float[] platformSpeedRanges = { -2, 2 }; // Speed range for blue platforms

boolean gameStarted;//Game staring
boolean gameOver;//Game ending
boolean playAgainClicked;//GAme play again

void setup() {
  size(400, 700);//Canvas size
  frameRate(60);//Framerate to make scroll smooth
  gameStarted = false;
  gameOver = false;
  playAgainClicked = false;

  doodlerLeftImg = loadImage("doodleLeft.png");
  doodlerRightImg = loadImage("doodleRight.png");

  startGame();
}

void draw() {
  background(247, 239, 231);

  if (gameStarted) {
    drawGrid();
    moveDoodle();
    checkCollision();
    movePlatforms();
    drawPlatforms();
    if (doodlerY < height / 2) {
      scrollSpeed = 0;
    }
    if (doodlerY > height) {
      gameOver = true;
      gameStarted = false;
    }
  } else if (gameOver) {
    displayGameOver();
  }

  drawDoodle();
}

//This include the initalizition of array and staring of the game coodinate
void startGame() {
  doodlerX = random(0, width - platformWidth);
  doodlerY = height / 2;
  doodlerYSpeed = 0;

  platformX = new float[numOfPlatforms];
  platformY = new float[numOfPlatforms];
  platformExists = new boolean[numOfPlatforms];
  platformTypes = new int[numOfPlatforms];
  platformSpeeds = new float[numOfPlatforms];

  generatePlatforms();

  gameStarted = true;
  gameOver = false;
  playAgainClicked = false;

  scrollSpeed = 0;
}

//This generate the 1000 plateform
void generatePlatforms() {
  for (int i = 0; i < numOfPlatforms; i++) {
    platformX[i] = random(0, width - platformWidth);
    platformY[i] = height*4/5-i*(random(70, 80));
    platformExists[i] = true;
    int platformType = int(random(0, 4));
    platformTypes[i] = platformType;
    if (platformTypes[i] == 1) {
      platformSpeeds[i] = random(platformSpeedRanges[0], platformSpeedRanges[1]);
    } else {
      platformSpeeds[i] = 0;
    }
  }
}

//This draw the grid in the canvas
void drawGrid() {
  stroke(240, 216, 193);
  for (int i = 0; i <= height / 50; i++) {
    line(0, i * 50, width, i * 50);
  }
  for (int i = 0; i <= width / 50; i++) {
    line(i * 50, 0, i * 50, height);
  }
}

//This will draw the plateform at the located coordinate
void drawPlatforms() {
  for (int i = 0; i < numOfPlatforms; i++) {
    if (platformExists[i]) {
      int platformType = platformTypes[i];
      fill(platformColors[platformType]);
      rect(platformX[i], platformY[i] - scrollSpeed, platformWidth, platformHeight);
    }
  }
}

//This will move the blue plateform and other plateform will be steady
void movePlatforms() {
  for (int i = 0; i < numOfPlatforms; i++) {
    if (platformExists[i]) {
      if (platformTypes[i] == 1) {
        platformX[i] += platformSpeeds[i];
        if (platformX[i] < 0 || platformX[i] > width - platformWidth) {
          platformSpeeds[i] *= -1;
        }
      }
      platformY[i] += scrollSpeed;
    }
  }
}

//This will help to move the doodler and make is move left to right in the canvas
void moveDoodle() {
  doodlerY += doodlerYSpeed;
  doodlerYSpeed += gravity;

  if (doodlerYSpeed < 0) {
    scrollSpeed = -doodlerYSpeed;
    scroll();
  }

  if (doodlerXSpeed < 0 && doodlerX + doodlerSize < 0) {
    doodlerX = width;
  } else if (doodlerXSpeed > 0 && doodlerX > width) {
    doodlerX = -doodlerSize;
  } else {
    doodlerX += doodlerXSpeed;
  }
}

//This will scrool the screen when the doodler is above the top of the canvas
void scroll() {
  if (scrollSpeed > 0) {
    for (int i = 0; i < numOfPlatforms; i++) {
      platformY[i] += scrollSpeed / 60; // Divide by frameRate to ensure smooth scrolling
    }
    scrollSpeed -= scrollSpeed / 60; // Divide by frameRate to gradually reduce scroll speed
  }
}

//This will draw the doodler left image and right image when key A and D is pressed
void drawDoodle() {
  if (doodlerXSpeed < 0) {
    image(doodlerLeftImg, doodlerX, doodlerY, doodlerSize, doodlerSize);
  } else {
    image(doodlerRightImg, doodlerX, doodlerY, doodlerSize, doodlerSize);
  }
}

//This will check the the collision of the doodler with the plateform and make the doodler jump according to the plateform color
void checkCollision() {
  for (int i = 0; i < numOfPlatforms; i++) {
    if (platformExists[i]) {
      float platX = platformX[i];
      float platY = platformY[i];

      if (doodlerX < platX + platformWidth &&
          doodlerX + doodlerSize > platX &&
          doodlerY + doodlerSize > platY &&
          doodlerY < platY + platformHeight &&
          doodlerYSpeed > 0) {
        int platformType = platformTypes[i];
        if (platformType == 0) {
          doodlerYSpeed = -10;
        } else if (platformType == 1) {
          doodlerYSpeed = -10;
          doodlerXSpeed = platformSpeeds[i];
        } else if (platformType == 2) {
          platformExists[i] = false;
          doodlerYSpeed = -10;
        } else if (platformType == 3) {
          doodlerYSpeed = -10 + random(0, 3) * (doodlerY - height / 2) / (height / 2);
          scrollSpeed = 3 * doodlerYSpeed;
        }
      }
    }
  }
}

//This will display the game over message when the game is over
void displayGameOver() {
  String playAgain = "Click here to play again";
  textAlign(CENTER);
  textSize(30);
  fill(0);
  text("Game Over", width / 2, height / 2 - 50);

  textSize(20);
  shapeMode(CENTER);
  fill(255);
  rect(width/2-100, height / 2, 200, 30);
  fill(0);
  text(playAgain, width / 2, height / 2 + 20);
}

//This will restet the seeting to the initial coordinate of the game
void restartGame(){
  startGame();
}

//Control the doodler with a, A, d & D
void keyPressed() {
  if ((key == 'a'|| key == 'A') && gameStarted) {
    doodlerXSpeed = -5;
  } else if ((key == 'd'|| key == 'D') && gameStarted) {
    doodlerXSpeed = 5;
  }
}

//Control the speed of doodler when key is released
void keyReleased() {
  if (((key == 'a'|| key == 'A') || (key == 'd'|| key == 'D')) && gameStarted) {
    doodlerXSpeed = 0;
  }
}

//Control the play again button
void mousePressed() {
  if (gameOver && mouseX > width / 2 - 100 
      && mouseX < width / 2 + 100 && mouseY > height / 2 
      && mouseY < height / 2 + 30) {
    playAgainClicked = true;
    restartGame();
  }
}
