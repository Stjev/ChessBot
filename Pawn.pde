public class Pawn extends Piece {
  private Boolean firstMove;
  
  public Pawn(Boolean black) {
    super("pawn", black, 7);
    this.firstMove = true;
  }
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){
    ArrayList<Coordinate> cs = new ArrayList();
    HashMap<Coordinate, Piece> mine = isBlack()? blackPieces : whitePieces;
    HashMap<Coordinate, Piece> other = isBlack()? whitePieces : blackPieces;
    
    Coordinate c = getCoordinate();
    int b = isBlack() ? 1 : -1;
    
    Coordinate move = new Coordinate();
    
    if(firstMove) { // The first move can be two steps
      move.setxy(c.x, c.y + b*2);
      Coordinate move2 = new Coordinate(c.x, c.y + b*1);
      if(! mine.containsKey(move) && ! other.containsKey(move) && ! mine.containsKey(move2) && ! other.containsKey(move2)){  
        cs.add(new Coordinate(move));
      } 
    } 
    
    move.setxy(c.x, c.y + b*1);
    if(! mine.containsKey(move) && ! other.containsKey(move) && inRange(move)) {
      cs.add(new Coordinate(move)); 
    }
    
    move.setxy(c.x + 1, c.y + b*1);
    if(other.containsKey(move)) cs.add(new Coordinate(move));
    move.setxy(c.x - 1, c.y + b*1);
    if(other.containsKey(move)) cs.add(new Coordinate(move));
    
    return cs;
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.PAWN;
  }
  
  @Override
  public void moveTo(Coordinate c, HashMap<Coordinate, Piece> pieces) {
    super.moveTo(c, pieces);
    firstMove = false;
  }
  
  @Override
  public String toString(){
    return "Pawn " + this.getCoordinate().toString();
  }
}
