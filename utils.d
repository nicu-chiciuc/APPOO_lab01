module utils;

struct Position {
	int row;
	int col;
}

struct Range2D {
	int minRow;
	int maxRow;

	int minCol;
	int maxCol;

	bool isInside(Position pos) {
		return (pos.row >= minRow && pos.row <= maxRow &&
				pos.col >= minCol && pos.col <= maxCol);
	}
}