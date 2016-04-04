module ConwayCommon;

import utils;
import std.stdio;
import std.container;

class ConwayState {
	private struct CellInfo {
		bool wasAlive;
		int neighbors;
	}

	alias CellDict = CellInfo[Position];

	public CellDict cellDict;

	public int getMaxRow() {
		int maxRow = -100000;
		foreach (pos, _; cellDict)
			if (pos.row > maxRow)
				maxRow = pos.row;
		return maxRow;
	}

	public int getMaxCol() {
		int maxCol = -100000;
		foreach (pos, _; cellDict)
			if (pos.col > maxCol)
				maxCol = pos.col;
		return maxCol;
	}

	public int getMinRow() {
		int minRow = 100000;
		foreach (pos, _; cellDict)
			if (pos.row < minRow)
				minRow = pos.row;
		return minRow;
	}

	public int getMinCol() {
		int minCol = 100000;
		foreach (pos, _; cellDict)
			if (pos.col < minCol)
				minCol = pos.col;
		return minCol;
	}

	public void setAlive(int row, int col) {
		auto newPos = Position(row, col);

		if ((newPos in cellDict) == null)
			cellDict[newPos] = CellInfo(true, 0);
	}

	void initBeforeIteration() {
		foreach (key, _; cellDict) {
			cellDict[key].neighbors = 0;
			cellDict[key].wasAlive = true;
		}
	}

	void addNeighbor(Position pos) {
		CellInfo * infoNow = pos in cellDict;

		if (infoNow is null) {
			cellDict[pos] = CellInfo(false, 1);
		}
		else
			infoNow.neighbors ++;
	}

	private void populateNeighbors() {
		foreach(pos; cellDict.keys) {
			addNeighbor(Position(pos.row-1, pos.col-1));
			addNeighbor(Position(pos.row-1, pos.col  ));
			addNeighbor(Position(pos.row-1, pos.col+1));

			addNeighbor(Position(pos.row  , pos.col-1));

			addNeighbor(Position(pos.row  , pos.col+1));

			addNeighbor(Position(pos.row+1, pos.col-1));
			addNeighbor(Position(pos.row+1, pos.col  ));
			addNeighbor(Position(pos.row+1, pos.col+1));
		}
	}

	private void filterConwayRules() {
		foreach(key, value; cellDict) {
			if (value.wasAlive) {
				if (value.neighbors < 2 || value.neighbors > 3)
					cellDict.remove(key);
			}
			else {
				if (value.neighbors != 3)
					cellDict.remove(key);
			}
		}
	}

	public void iterateOnce() {
		initBeforeIteration();

		populateNeighbors();

		filterConwayRules();
	}

	public void iterate(int numIterations) {
		while (numIterations --> 0) {
			iterateOnce();
		}
	}

	byte[] getAsByteArray(Range2D range) {
		int arrCols = (range.maxCol - range.minCol + 1);
		int arrRows = (range.maxRow - range.minRow + 1);

		byte[] asArr = new byte[arrRows*arrCols];

		foreach (key, _; cellDict) {
			if (range.isInside(key)) {
				asArr[(key.row - range.minRow)*arrCols + (key.col - range.minCol)] = cast(byte)1;
			}
		}

		return asArr;
	}
}