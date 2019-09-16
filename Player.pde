public class Player{
  private Boolean black;
  private Pawn pawns[];
  private Knight knights[];
  private Tower towers[];
  private Bishop bishops[];
  private Queen queen;
  private King king;
  
  private HashMap<Coordinate, Piece> pieces;
  
  public Player(Boolean black) {
    this.black = black;
    this.pieces = new HashMap<Coordinate, Piece>();
    
    generatePawns(black);
    generateKnights(black);
    generateBishops(black);
    generateTowers(black);
    generateKing(black);
    generateQueen(black);
  }
  
  public void draw() {
    for(Piece piece : this.pieces.values()) {
      piece.draw();
    }
  }
  
  private void generatePawns(Boolean black) {
    this.pawns = new Pawn[8];
    
    for(int i = 0; i < 8; i+=1) {
      Pawn pawn = new Pawn(black);
      pawn.getCoordinate().setxy(i, black ? 1 : 6);
      
      this.pawns[i] = pawn;
      this.pieces.put(pawn.getCoordinate(), pawn);
    }
  }
  
  private void generateKnights(Boolean black) {
    this.knights = new Knight[2];
    
    int xs[] = new int[]{1, 6};
    int i = 0;
    
    for(int x : xs) {
      Knight knight = new Knight(black);
      knight.getCoordinate().setxy(x, black ? 0 : 7);
      
      this.pieces.put(knight.getCoordinate(), knight);
      knights[i++] = knight;
    }  
  }
  
  private void generateBishops(Boolean black) {
    this.bishops = new Bishop[2];
    
    int xs[] = new int[]{2, 5};
    int i = 0;
    
    for(int x : xs) {
      Bishop bishop = new Bishop(black);
      bishop.getCoordinate().setxy(x, black ? 0 : 7);
      bishop.draw();
      
      this.pieces.put(bishop.getCoordinate(), bishop);
      bishops[i++] = bishop;
    } 
  }
  
  private void generateTowers(Boolean black) {
    this.towers = new Tower[2];
    
    int xs[] = new int[]{0, 7};
    int i = 0;
    
    for(int x : xs) {
      Tower tower = new Tower(black);
      tower.getCoordinate().setxy(x, black ? 0 : 7);
      
      this.pieces.put(tower.getCoordinate(), tower);
      towers[i++] = tower;
    } 
  }
  
  private void generateQueen(Boolean black) {
    this.queen = new Queen(black);
    this.queen.getCoordinate().setxy(3, black ? 0 : 7);
    this.pieces.put(this.queen.getCoordinate(), this.queen);
  }
  
  private void generateKing(Boolean black) {
    this.king = new King(black);
    this.king.getCoordinate().setxy(4, black ? 0 : 7);
    this.pieces.put(this.king.getCoordinate(), this.king);
  }
  
  public HashMap<Coordinate, Piece> getPieces() {
    return this.pieces;
  }
}
