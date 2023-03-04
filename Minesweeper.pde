import de.bezier.guido.*;

private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make(this);

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  setMines();
}

public void setMines() {
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  for (int i = 0; i < 50; i++) {
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
      row = (int)(Math.random()*NUM_ROWS);
      col = (int)(Math.random()*NUM_COLS);
    } else {
      row = (int)(Math.random()*NUM_ROWS);
      col = (int)(Math.random()*NUM_COLS);
    }
  }
}

public void draw () {
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
    noLoop();
  }
  for(int i = 0; i < mines.size(); i++) {
    if(mines.get(i).clicked && !mines.get(i).isFlagged()) {
      displayLosingMessage();
      noLoop();
    }
  }
}

public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked && !mines.contains(buttons[r][c])) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() {  
  buttons[9][6].setLabel(" ");
  buttons[9][7].setLabel(" ");
  buttons[9][8].setLabel(" ");
  buttons[9][11].setLabel(" ");
  buttons[9][12].setLabel(" ");
  buttons[9][13].setLabel(" ");
  buttons[11][6].setLabel(" ");
  buttons[11][7].setLabel(" ");
  buttons[11][8].setLabel(" ");
  buttons[11][9].setLabel(" ");
  buttons[11][11].setLabel(" ");
  buttons[11][12].setLabel(" ");
  buttons[11][13].setLabel(" ");
  
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
  buttons[11][5].setLabel("T");
  buttons[11][6].setLabel("R");
  buttons[11][7].setLabel("Y");
  buttons[11][10].setLabel("A");
  buttons[11][11].setLabel("G");
  buttons[11][12].setLabel("A");
  buttons[11][13].setLabel("I");
  buttons[11][14].setLabel("N");
  
  for(int r = 0; r < NUM_ROWS; r++) {
    for(int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setClicked();
      buttons[r][c].endGame();
    }
  }
}

public void displayWinningMessage() {
  buttons[9][6].setLabel(" ");
  buttons[9][7].setLabel(" ");
  buttons[9][8].setLabel(" ");
  buttons[9][10].setLabel(" ");
  buttons[9][11].setLabel(" ");
  buttons[9][12].setLabel(" ");
  buttons[9][13].setLabel(" ");
  buttons[11][5].setLabel(" ");
  buttons[11][6].setLabel(" ");
  buttons[11][7].setLabel(" ");
  buttons[11][10].setLabel(" ");
  buttons[11][11].setLabel(" ");
  buttons[11][12].setLabel(" ");
  buttons[11][13].setLabel(" ");
  buttons[11][14].setLabel(" ");
  
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][11].setLabel("W");
  buttons[9][12].setLabel("I");
  buttons[9][13].setLabel("N");
  buttons[11][6].setLabel("N");
  buttons[11][7].setLabel("I");
  buttons[11][8].setLabel("C");
  buttons[11][9].setLabel("E");
  buttons[11][11].setLabel("J");
  buttons[11][12].setLabel("O");
  buttons[11][13].setLabel("B");
}

public boolean isValid(int r, int c) {
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  } else {
    return false;
  }
}

public int countMines(int row, int col) {
  int numMines = 0;
  if (isValid(row-1, col) && mines.contains(buttons[row-1][col])) {
    numMines++;
  }
  if (isValid(row, col-1) && mines.contains(buttons[row][col-1])) {
    numMines++;
  }
  if (isValid(row+1, col) && mines.contains(buttons[row+1][col])) {
    numMines++;
  }
  if (isValid(row, col+1) && mines.contains(buttons[row][col+1])) {
    numMines++;
  }
  if (isValid(row-1, col-1) && mines.contains(buttons[row-1][col-1])) {
    numMines++;
  }
  if (isValid(row+1, col+1) && mines.contains(buttons[row+1][col+1])) {
    numMines++;
  }
  if (isValid(row-1, col+1) && mines.contains(buttons[row-1][col+1])) {
    numMines++;
  }
  if (isValid(row+1, col-1) && mines.contains(buttons[row+1][col-1])) {
    numMines++;
  }
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton (int row, int col) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged) {
        flagged = false;
        clicked = false;
      } else {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow-1; r <= myRow+1; r++) {
        for (int c = myCol-1; c <= myCol+1; c++) {
          if (isValid(r, c) && !buttons[r][c].clicked) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }

  public void draw () {    
    if (flagged) {
      fill(0);
    } else if (clicked && mines.contains(this)) {
      fill(255, 0, 0);
    } else if (clicked) {
      fill(200);
    } else {
      fill(100);
    }
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }
  
  public void setClicked() {
    clicked = true;
  }
  
  public void endGame() {
    if (clicked) {
      fill(200);
    } else {
      fill(100);
    }
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
}
