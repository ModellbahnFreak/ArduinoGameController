import java.util.Comparator;

class PosComparator implements Comparator<int[]>{
  int compare(int[] pos1, int[] pos2) {
    if (pos1.length < pos2.length) {
      return -1;
    } else if (pos1.length > pos2.length) {
      return 1;
    } else if (pos1.length == 2 && pos2.length == 2) {
      if (pos1[0] == pos2[0] && pos1[1] == pos2[1]) {
        return 0;
      }
    }
    return -2;
  }
}