public class Bishop extends Piece {
  public Bishop(Boolean black) {
    super("bishop", black, 33);
  }  
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){    
    return getMovesInDirection(whitePieces, blackPieces, new Coordinate[]{new Coordinate(1,1), 
                                                                          new Coordinate(1,-1), 
                                                                          new Coordinate(-1,1), 
                                                                          new Coordinate(-1,-1)});
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.BISHOP;
  }
  
  @Override
  public String toString(){
    return "Bishop " + this.getCoordinate().toString();
  }
}
