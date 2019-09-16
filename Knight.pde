public class Knight extends Piece {
  public Knight(Boolean black) {
    super("knight", black, 31);
  }
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){
    ArrayList<Coordinate> cs = new ArrayList();
    HashMap<Coordinate, Piece> mine = isBlack()? blackPieces : whitePieces;
    HashMap<Coordinate, Piece> other = isBlack()? whitePieces : blackPieces;
    
    Coordinate c = getCoordinate();
    
    addMove(c.x + 2, c.y - 1, cs, mine);
    addMove(c.x + 2, c.y + 1, cs, mine);
    addMove(c.x - 2, c.y - 1, cs, mine);
    addMove(c.x - 2, c.y + 1, cs, mine);
    addMove(c.x - 1, c.y - 2, cs, mine);
    addMove(c.x + 1, c.y - 2, cs, mine);
    addMove(c.x - 1, c.y + 2, cs, mine);
    addMove(c.x + 1, c.y + 2, cs, mine);
    
    return cs;
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.KNIGHT;
  }
  
  @Override
  public String toString(){
    return "Knight " + this.getCoordinate().toString();
  }
}
