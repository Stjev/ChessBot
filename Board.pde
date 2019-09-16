public class Board {
  public void draw() {
    noStroke();
    for(int y = 0; y < 8; y += 1) {
      for(int x = 0; x < 8; x += 1) {
        fill((x + y + 1) % 2 == 0? 100 : 255);
        rect(x * 60, y * 60, 60, 60);
      }
    }
  }
}
