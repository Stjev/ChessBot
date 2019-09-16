PImage img; 
Board board;
Bot black;
Player white;
boolean blackTurn;
boolean gameOver;
boolean blackWon;

ArrayList<Coordinate> botMoves;
ArrayList<Coordinate> possibleMoves;
Piece selected;

void setup() {
  size(481, 481);
  background(255);
  
  blackTurn = false;
  board = new Board();
  black = new Bot(true);
  white = new Player(false);
  possibleMoves = new ArrayList();
  botMoves = new ArrayList();
  blackWon = true;
}

void draw(){
  board.draw();
  paintBotMoves();
  paintPossibleMoves();
  black.draw();
  white.draw();
  
  if(gameOver) {
    printGameOver();
  }
}

void printGameOver() {
  fill(100, 100, 100, 200);
  rect(-1, -1, 482, 482);
  textSize(65);
  fill(255, 255, 255);
  text("Game Over", 60, 200);
  textSize(40);
  if(!blackWon) {
    text("You won", 150, 250);
  } else {
    text("Bot won get fuckd", 60, 250);
  }
}

void paintPossibleMoves() {    
  stroke(0);
  fill(0, 100, 0);
  for(Coordinate c : possibleMoves){
    rect(c.x * 60,c.y * 60,60,60);
  }
}

void paintBotMoves(){
  stroke(0);
  fill(52, 79, 217);
  for(Coordinate c : botMoves){
    rect(c.x * 60,c.y * 60,60,60);
  }
}

void mouseClicked(MouseEvent event){
  if(gameOver) return;
  int x = (event.getX() - event.getX() % 60) / 60;
  int y = (event.getY() - event.getY() % 60) / 60;
  
  Coordinate c = new Coordinate(x, y);
  
  HashMap<Coordinate, Piece> blackPieces = black.getPieces();
  HashMap<Coordinate, Piece> whitePieces = white.getPieces();
  HashMap<Coordinate, Piece> pieces, other;
  
  if(!blackTurn) {
    pieces = whitePieces;
    other = blackPieces;
    
    // A piece was found with this coordinate
    if(pieces.containsKey(c)) {
      selected = pieces.get(c);
      possibleMoves = selected.getMoves(whitePieces, blackPieces);
    }
    
    // A possible move was clicked
    if(possibleMoves.contains(c)){
      for(Coordinate c1 : possibleMoves) if(c1.equals(c)) c = c1;
      selected.moveTo(c, pieces);
      if(other.containsKey(c)) {
        Piece k = other.get(c);
        k.kill(other);
        if(k.getPieceType().equals(PieceType.KING)) {
          gameOver = true;
          blackWon = false;
        }
      }
      selected = null;
      possibleMoves = new ArrayList();
      blackTurn = true;
      
      botMoves = new ArrayList();
      
      // Do the bots move
      Move move = black.minMax2(whitePieces);
      botMoves.add(move.move);
      botMoves.add(new Coordinate(move.piece.getCoordinate()));
      move.piece.moveTo(move.move, blackPieces);
      if(pieces.containsKey(move.move)) {
        Piece k = pieces.get(move.move);
        k.kill(pieces);
        if(k.getPieceType().equals(PieceType.KING)) {
          gameOver = true;
        }
      }
      
      blackTurn = false;
    }
  }
}
