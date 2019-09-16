public class Coordinate {
  public int x;
  public int y;
  
  // fields for castling
  private boolean castling;
  private Piece tower; 
  
  public Coordinate() {}  
  
  public Coordinate(int x, int y) {
    this.x = x;
    this.y = y;
    this.castling = false;
  }
  
  public void setCastling(Piece p) {
    this.castling = true;
    this.tower = p;
  }
  
  public boolean isCastling() {
    return this.castling;
  }
  
  public Piece getCastleTower() {
    this.castling = false;
    return this.tower;
  }
  
  public Coordinate(Coordinate c) {
    this.x = c.x;
    this.y = c.y;
  }
  
  public void setxy(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void add(Coordinate c) {
    this.x += c.x;
    this.y += c.y;
  }
  
  public boolean isCenter(){
    return this.equals(new Coordinate(3, 3)) || 
           this.equals(new Coordinate(3, 4)) || 
           this.equals(new Coordinate(4, 3)) || 
           this.equals(new Coordinate(4, 4));
  }
  
  @Override
  public String toString(){
    return "(" + this.x + ", " + this.y + ")";
  }
  
  @Override
  public int hashCode() {
    return this.x * 133 + this.y;
  }
  
  @Override
  public boolean equals(Object o) {
    // this instance check
    if (o == null) return false;
    if (o instanceof Coordinate && o.hashCode() == this.hashCode()){
      return true;
    } else return false;
  }
}
