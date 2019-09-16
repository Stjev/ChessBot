public abstract class Piece {
  private Coordinate coordinate;
  private PImage image;
  private Boolean black;
  private Boolean dead;
  private int value;
  
  public Piece(String imgString, Boolean black, int value) {
    // initialize the coordinate
    this.coordinate = new Coordinate();
    this.dead = false;
    this.value = value;
    this.black = black;
    this.image = loadImage("img/" + (black ? "b_" : "w_") + imgString + ".png");
  }
  
  public int getValue(){
    return this.value;  
  }
  
  public void simulateMoveTo(Coordinate c, HashMap<Coordinate, Piece> pieces) {
    pieces.remove(coordinate);    
    coordinate = new Coordinate(c);
    pieces.put(coordinate, this);
  }
  
  public void moveTo(Coordinate c, HashMap<Coordinate, Piece> pieces) {
    pieces.remove(coordinate);    
    coordinate = new Coordinate(c);
    pieces.put(coordinate, this);
  }
  
  public void addMove(int x, int y, ArrayList<Coordinate> cs, HashMap<Coordinate, Piece> mine){
    Coordinate move = new Coordinate(x, y);
    if(inRange(move) && ! mine.containsKey(move)) cs.add(move);
  }
  
  public void kill(HashMap<Coordinate, Piece> pieces) {
    pieces.remove(coordinate);
  }
  
  public boolean isBlack(){
    return this.black;
  }
  
  public Coordinate getCoordinate() {
    return coordinate;
  }
  
  public void draw(){
    if(! dead) image(image, 60*coordinate.x, 60*coordinate.y);
  }
  
  public boolean isKing() {return false;}
  
  @Override
  public abstract String toString();
  public abstract ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces);
  public abstract PieceType getPieceType();
  
  // Subclass private
  
  public boolean inRange(Coordinate c) {
    return c.x >= 0 && c.x < 8 && c.y >= 0 && c.y < 8;
  }
  
  public ArrayList<Coordinate> getMovesInDirection(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces, Coordinate[] dirs){
    ArrayList<Coordinate> cs = new ArrayList();
    HashMap<Coordinate, Piece> mine = isBlack()? blackPieces : whitePieces;
    HashMap<Coordinate, Piece> other = isBlack()? whitePieces : blackPieces;
    
    Coordinate c = getCoordinate();
    
    for(Coordinate dir : dirs) {
      Coordinate move = new Coordinate(c);
      move.add(dir);
      while(! mine.containsKey(move) && ! other.containsKey(move) && inRange(move)){
        cs.add(new Coordinate(move));
        move.add(dir);
      }
      
      if(other.containsKey(move)) cs.add(move);
    }
    
    return cs;
  }
}
