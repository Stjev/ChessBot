public class Move{
  public Piece piece;
  public Coordinate move;
  
  public Move(){};
  
  public Move(Piece piece, Coordinate move) {
    this.piece = piece;
    this.move = move;
  }
}
