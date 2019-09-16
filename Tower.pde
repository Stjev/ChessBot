public class Tower extends Piece {
  public Tower(Boolean black) {
    super("tower", black, 50);
  }
  
  public ArrayList<Coordinate> getMoves(HashMap<Coordinate, Piece> whitePieces, HashMap<Coordinate, Piece> blackPieces){
    return getMovesInDirection(whitePieces, blackPieces, new Coordinate[]{new Coordinate(1,0), 
                                                                          new Coordinate(0,-1), 
                                                                          new Coordinate(-1,0), 
                                                                          new Coordinate(0,1)});
  }
  
  @Override
  public PieceType getPieceType(){
    return PieceType.TOWER;
  }
  
  @Override
  public String toString(){
    return "Tower " + this.getCoordinate().toString();
  }
}
