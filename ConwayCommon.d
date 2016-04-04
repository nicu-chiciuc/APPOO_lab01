module ConwayCommon;

import std.stdio;
import std.container;

struct Position {
	int row;
	int col;
}

SList!Position conwayStateFromCharArr(char[] data) {
	int row=0, col=0;
	SList!Position list;

	for (int i=0; i<data.length; i++)
		if (data[i] == '\n') {
			row ++;
			col = 0;
		}
		else if (data[i] != '\r') {
			if (data[i] == '1')
				list.insert(Position(row, col));

			col ++;
		}

	return list;
}


class ConwayState {
	struct NextInfo {
		bool wasAlive;
		int neighbors;
	}

	

}