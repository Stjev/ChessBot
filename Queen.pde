public class Queen extends Piece {
  public Queen(Boolean black) {
    super("queen", black, 79);
  }
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){
    return getMovesInDirection(whitePieces, blackPieces, new Coordinate[]{new Coordinate(1,1), 
                                                                          new Coordinate(1,0), 
                                                                          new Coordinate(1,-1), 
                                                                          new Coordinate(0,-1), 
                                                                          new Coordinate(-1,1),
                                                                          new Coordinate(-1,0), 
                                                                          new Coordinate(-1,-1),
                                                                          new Coordinate(0,1)});
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.QUEEN;
  }
  
  @Override
  public String toString(){
    return "Queen " + this.getCoordinate().toString();
  }
}
