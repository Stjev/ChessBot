public class King extends Piece {
  public King(Boolean black) {
    super("king", black, 50000);
  }
  
  @Override
  public boolean isKing() {
    return true;
  }
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){
    ArrayList<Coordinate> cs = new ArrayList();
    HashMap<Coordinate, Piece> mine = isBlack()? blackPieces : whitePieces;
    HashMap<Coordinate, Piece> other = isBlack()? whitePieces : blackPieces;
    
    Coordinate c = getCoordinate();
    
    addMove(c.x + 1, c.y, cs, mine);
    addMove(c.x + 1, c.y + 1, cs, mine);
    addMove(c.x + 1, c.y - 1, cs, mine);
    addMove(c.x - 1, c.y, cs, mine);
    addMove(c.x - 1, c.y + 1, cs, mine);
    addMove(c.x - 1, c.y - 1, cs, mine);
    addMove(c.x, c.y + 1, cs, mine);
    addMove(c.x, c.y - 1, cs, mine);
    
    if(canCastle(mine, other, true)) {
      Coordinate c1 = new Coordinate(c.x - 2, c.y);
      c1.setCastling(mine.get(new Coordinate(0, isBlack()? 0 : 7)));
      cs.add(c1);
    }
    if(canCastle(mine, other, false)) {
      Coordinate c1 = new Coordinate(c.x + 2, c.y);
      c1.setCastling(mine.get(new Coordinate(7, isBlack()? 0 : 7)));
      cs.add(c1);
    }
    
    return cs;
  }
  
  private boolean canCastle(HashMap<Coordinate, Piece> mine, HashMap<Coordinate, Piece> other, boolean left) {
    int y = isBlack()? 0 : 7;
    
    if(!getCoordinate().equals(new Coordinate(4, y))) return false;
    
    if(left) {
      Piece tower = mine.get(new Coordinate(0, y));
      Coordinate empty1 = new Coordinate(1, y);
      Coordinate empty2 = new Coordinate(2, y);
      Coordinate empty3 = new Coordinate(3, y);
      
      return tower != null && mine.get(empty1) == null && mine.get(empty2) == null && mine.get(empty3) == null &&
                          other.get(empty1) == null && other.get(empty2) == null && other.get(empty3) == null;
    } else {
      Piece tower = mine.get(new Coordinate(7, y));
      Coordinate empty1 = new Coordinate(5, y);
      Coordinate empty2 = new Coordinate(6, y);
      
      return tower != null && mine.get(empty1) == null && mine.get(empty2) == null && 
                          other.get(empty1) == null && other.get(empty2) == null;
    }
  }
  
  @Override
  public void moveTo(Coordinate c, HashMap<Coordinate, Piece> pieces) {
    if(c.isCastling()) {
      Piece tower = c.getCastleTower();
      if(tower.getCoordinate().equals(new Coordinate(0, tower.isBlack()? 0 : 7))) {
        tower.moveTo(new Coordinate(3, tower.isBlack()? 0 : 7), pieces);
      } else {
        tower.moveTo(new Coordinate(5, tower.isBlack()? 0 : 7), pieces);
      }
    }
    super.moveTo(c, pieces);
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.KING;
  }
  
  @Override
  public String toString(){
    return "King " + this.getCoordinate().toString();
  }
}
