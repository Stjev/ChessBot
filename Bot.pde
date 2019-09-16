import java.util.HashSet;

public class Bot extends Player{
  public Bot(Boolean black) {
    super(black);
    this.doneMoves = 0;
  }
  
  // This will calculate the best move to make
  // V1: Look one step in the future and calculate what move has the biggest value
  public Move findBestMove1(HashMap<Coordinate, Piece> other) {
    HashMap<Coordinate, Piece> mine = this.getPieces();
    
    int maxVal = Integer.MIN_VALUE;
    Move move = new Move();
    
    ArrayList<Piece> values = new ArrayList(mine.values());
    
    // For every piece
    for(Piece piece : values) {
      for(Coordinate nextMove : piece.getMoves(other, mine)) {
        int score = 0;
        if(other.containsKey(nextMove)) {
          Piece toKill = other.get(nextMove);
          score = toKill.getValue();
        } 
        
        mine.remove(piece.getCoordinate());
        mine.put(nextMove, piece);
        
        ArrayList<Piece> ovalues = new ArrayList(other.values());
        
        for(Piece cPiece : ovalues){
          for(Coordinate cNextMove : cPiece.getMoves(other, mine)){
            
            int pieceScore = 0;
            
            if(mine.containsKey(cNextMove)){
              Piece cToKill = mine.get(cNextMove);
              pieceScore = cToKill.getValue();
              score -= pieceScore;
            }
            
            other.remove(cPiece.getCoordinate());
            other.put(cNextMove, cPiece);
            
            ArrayList<Piece> values2 = new ArrayList(mine.values());
            
            for(Piece ccPiece : values2){
              for(Coordinate ccNextMove : ccPiece.getMoves(other, mine)){
                if(mine.containsKey(ccNextMove)){
                  Piece ccToKill = other.get(ccNextMove);
                  score += ccToKill.getValue();
                  if(score > maxVal) {
                    maxVal = score;
                    move = new Move(piece, nextMove);
                  }
                  score -= ccToKill.getValue();
                }
              }
            }
            
            score += pieceScore;
            
            other.remove(cNextMove);
            other.put(cPiece.getCoordinate(), cPiece);
          }
        }
        
        mine.remove(nextMove);
        mine.put(piece.getCoordinate(), piece);
      }
    }
    
    return move;
  }
  
  // This method calculates the potential of every move.
  public Move potentialMethod(HashMap<Coordinate, Piece> other) {
    int maxPotential = Integer.MIN_VALUE;
    Move move = new Move();   
    
    for(Piece piece : new ArrayList<Piece>(this.getPieces().values())){
      for(Coordinate nextMove : piece.getMoves(other, this.getPieces())){
        this.getPieces().remove(piece.getCoordinate());
        this.getPieces().put(nextMove, piece);
        
        int thisPotential = 0;
        
        MoveScoreDTO ms;
        
        if(other.containsKey(nextMove)){
          Piece killed = other.get(nextMove);
          other.remove(nextMove);
          
          ms = recursivePotential(other, 3, 0, new Move(piece, nextMove), false);
          thisPotential += 3 * killed.getValue();
          
          other.put(nextMove, killed);
        } else {
          ms = recursivePotential(other, 3, 0, new Move(piece, nextMove), false);
        }
        
        if(ms.score + thisPotential > maxPotential) {
          maxPotential = ms.score + thisPotential;
          move = new Move(piece, nextMove);
        }
        
        this.getPieces().remove(nextMove);
        this.getPieces().put(piece.getCoordinate(), piece);
      }
    }
    
    return move;
  }
  
  private MoveScoreDTO recursivePotential(HashMap<Coordinate, Piece> other, int depth, int score, Move move, boolean botTurn) {
    if(depth == 0) return new MoveScoreDTO(move, score);
    
    HashMap<Coordinate, Piece> current = botTurn ? this.getPieces() : other;
    HashMap<Coordinate, Piece> opponent = !botTurn ? this.getPieces() : other;
    
    int potential = 0;
    
    for(Piece piece : new ArrayList<Piece>(current.values())){
      for(Coordinate nextMove : piece.getMoves(other, this.getPieces())){
        current.remove(piece.getCoordinate());
        current.put(nextMove, piece);
        
        if(opponent.containsKey(nextMove)){
          Piece killed = opponent.get(nextMove);
          opponent.remove(nextMove);
          
          score += botTurn ? killed.getValue() : -killed.getValue();
          
          if(killed.getValue() != 50000) {
            MoveScoreDTO ms = recursivePotential(other, depth - 1, score, move, !botTurn);
            potential += depth * ms.score;
          } else {
            potential = depth * (botTurn ? killed.getValue() / 10 : -killed.getValue());
          }
          
          score -= botTurn ? killed.getValue() : -killed.getValue();
          opponent.put(nextMove, killed);
        } else {
          MoveScoreDTO ms = recursivePotential(other, depth - 1, score, move, !botTurn);
          potential += ms.score;
        }
        
        current.remove(nextMove);
        current.put(piece.getCoordinate(), piece);
      }
    }
    
    return new MoveScoreDTO(move, potential);
  }
  
  
  public Move minMaxMethod(HashMap<Coordinate, Piece> other) {
    int best = Integer.MIN_VALUE;
    Move move = new Move();
    
    for(Piece piece : new ArrayList<Piece>(this.getPieces().values())){
      for(Coordinate nextMove : piece.getMoves(other, this.getPieces())){
        this.getPieces().remove(piece.getCoordinate());
        this.getPieces().put(nextMove, piece);
        
        if(other.containsKey(nextMove)){
          Piece killed = other.get(nextMove);
          
          if(killed.isKing()) { // If this move kills the king, do this move
            this.getPieces().remove(nextMove);
            this.getPieces().put(piece.getCoordinate(), piece);
            
            return new Move(piece, nextMove);
          }
          
          other.remove(nextMove);
        
          int thisScore = recursiveMinMax(other, DEPTH, false);
        
          if(best < thisScore) {
            best = thisScore;
            move = new Move(piece, nextMove);
          }
        
          other.put(nextMove, killed);
        } else {
          int thisScore = recursiveMinMax(other, DEPTH, false);
        
          if(best < thisScore) {
            best = thisScore;
            move = new Move(piece, nextMove);
          }
        }
        
        this.getPieces().remove(nextMove);
        this.getPieces().put(piece.getCoordinate(), piece);
      }
    }
    
    System.out.println(best);
    
    return move;
  }
  
  private int recursiveMinMax(HashMap<Coordinate, Piece> other, int depth, boolean botTurn) {
    if(depth == 0) return calculateBoardValue(this.getPieces(), other);
    
    HashMap<Coordinate, Piece> current  =  botTurn ? this.getPieces() : other;
    HashMap<Coordinate, Piece> opponent = !botTurn ? this.getPieces() : other;
    
    int best = botTurn? Integer.MIN_VALUE : Integer.MAX_VALUE;
    
    for(Piece piece : new ArrayList<Piece>(current.values())){
      for(Coordinate nextMove : piece.getMoves(other, this.getPieces())){
        current.remove(piece.getCoordinate());
        current.put(nextMove, piece);
        
        if(opponent.containsKey(nextMove)){
          Piece killed = opponent.get(nextMove);
          
          if(killed.isKing()) { // If this move kills the king, this is the last move and has a very high value
            current.remove(nextMove);
            current.put(piece.getCoordinate(), piece);
            
            return depth * (botTurn? killed.getValue() : -killed.getValue());
          }
          
          opponent.remove(nextMove);
        
          int thisScore = recursiveMinMax(other, depth - 1, !botTurn);
        
          if((best < thisScore && botTurn) || (best > thisScore && ! botTurn)) {
            best = thisScore;
          }
        
          opponent.put(nextMove, killed);
        } else {
          int thisScore = recursiveMinMax(other, depth - 1, !botTurn);
        
          if((best < thisScore && botTurn) || (best > thisScore && ! botTurn)) {
            best = thisScore;
          }
        }
        
        current.remove(nextMove);
        current.put(piece.getCoordinate(), piece);
      }
    }
    
    return best;
  }
  
  private int calculateBoardValue(HashMap<Coordinate, Piece> mine, HashMap<Coordinate, Piece> other) {
    int value = 0;
    
    for(Piece p : new HashSet<Piece>(mine.values()))  value += p.isKing() ? 0 : p.getValue();
    for(Piece p : other.values()) value -= p.isKing() ? 0 : p.getValue();
    
    return value;
  }
  
  private static final int DEPTH = 4;
  private Piece lastPiecesMoved[] = new Piece[2];
  private int doneMoves;
  
  public Move minMax2(HashMap<Coordinate, Piece> other) {
    Move move = new Move();
    
    int best = Integer.MIN_VALUE;
    
    System.out.println("-------------------------");
    
    for(Piece piece : new ArrayList<Piece>(this.getPieces().values())){
      for(Coordinate nextMove : piece.getMoves(other, this.getPieces())){
        Coordinate c = piece.getCoordinate();
        piece.simulateMoveTo(nextMove, this.getPieces());
        
        int score = 0;
        
        score += tactics(piece, nextMove, true);
        
        if(other.containsKey(nextMove)){
          Piece killed = other.get(nextMove);
          other.remove(nextMove);
          
          if(killed.isKing()) {
            score = Integer.MAX_VALUE;          
          } else {
            score += killed.getValue();
            int ts = recursiveMinMax2(other, this.getPieces(), DEPTH - 1, false);
            score += ts;
            System.out.println("TS: " + ts + " SCORE: " + score + "\t" + piece + " -> " + nextMove);
          }
          
          other.put(nextMove, killed);
        } else {
          score += recursiveMinMax2(other, this.getPieces(), DEPTH - 1, false);
          System.out.println("NO: " + score + "\t" + piece + " -> " + nextMove);
        }
        
        if(best < score) {
          System.out.println("*NEW BEST*: " + score);
          best = score;
          move = new Move(piece, nextMove);
        }
        
         piece.simulateMoveTo(c, this.getPieces());
      }
    }
    
    System.out.println(best);
    
    updateTacticData(move);
    
    return move;
  }
  
  private int recursiveMinMax2(HashMap<Coordinate, Piece> current, HashMap<Coordinate, Piece> opponent, int depth, boolean botTurn){
    if(depth == 0) return 0;
    
    int best = botTurn? Integer.MIN_VALUE : Integer.MAX_VALUE;
    
    for(Piece piece : new ArrayList<Piece>(current.values())){
      for(Coordinate nextMove : piece.getMoves(botTurn? opponent : current, !botTurn? opponent : current)){
        Coordinate c = piece.getCoordinate();
        piece.simulateMoveTo(nextMove, current);
        
        int score = 0;
        
        score += botTurn ? tactics(piece, nextMove, botTurn) : 0;
        
        if(opponent.containsKey(nextMove)){
          Piece killed = opponent.get(nextMove);
          opponent.remove(nextMove);
          
          if(killed.isKing()) {
            score = botTurn ? Integer.MIN_VALUE : Integer.MAX_VALUE;
          } else {
            score += botTurn ? killed.getValue() : -killed.getValue();
            score += recursiveMinMax2(opponent, current, depth - 1, ! botTurn);
          }
          
          opponent.put(nextMove, killed);
        } else {
          score += recursiveMinMax2(opponent, current, depth - 1, ! botTurn);
        }
        
        if((best < score && botTurn) || (best > score && ! botTurn)) {
          best = score;
        }
        
        piece.simulateMoveTo(c, current);
      }
    }
    
    return best;
  }
  
  private void updateTacticData(Move move) {
    // Set the last moved piece
    lastPiecesMoved[1] = lastPiecesMoved[0];
    lastPiecesMoved[0] = move.piece;
    
    this.doneMoves += 1;
  }
  
  private int tactics(Piece p, Coordinate c, boolean bot){
    int score = 0;
    if(c.isCenter()) score += 1; // Check if piece is controlling the center
    
    for(Piece p1 : lastPiecesMoved) // Check if this piece was moved in the last two moves for the beginning (first 10 moves) of the game
      if(p.equals(p1)) score -= 1;
    
    if(c.isCastling()) score += 2; // Castling is generally a good move, this surrounds the king
    if(p.getPieceType().equals(PieceType.QUEEN) && p.getCoordinate().equals(new Coordinate(3, p.isBlack()? 0 : 7))) {score -= 1;} // The queen should only be moved when a piece can be taken
    
    return score;
  }

  class MoveScoreDTO {
    public Move move;
    public int score;
    
    public MoveScoreDTO(Move move, int score){
      this.move = move;
      this.score = score;
    }
  }
}
