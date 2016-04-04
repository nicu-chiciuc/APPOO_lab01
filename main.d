import std.stdio;
import std.file;
import std.getopt;
import std.algorithm;
import std.container;

import ConwayCommon;

struct positionOfSomething {
	int row;
	int col;
}

void test() {
	int[positionOfSomething] aa;

	positionOfSomething ss = {3, 2};

	aa[ss] = 5;

	writeln(aa[positionOfSomething(1, 1)] = 3);
	writeln(aa[positionOfSomething(3, 2)]);
	//writeln()

	//writeln(aa["other"]);
}

int[] arr () {

	int[] t = [2, 3, 4];


	return t;
}

void arr2 (int[] my) {
	my[0] = 5;
}

alias PosListDict = NextInfo[Position];

void addToNext(ref PosListDict posNext, Position pos) {
	if ((pos in posNext) is null) {
		posNext[pos] = NextInfo(false, 0);
	}

	posNext[pos].neighbors ++;
}

void writeListStateToFile(Position[] state, string fileName) {
	

	int minRow =  0;
	int minCol =  0;
	int maxRow = -100000;
	int maxCol = -100000;

	foreach (pos; state) {
		
		if (pos.row > maxRow)
			maxRow = pos.row;
		if (pos.col > maxCol)
			maxCol = pos.col;

		//if (pos.row < minRow)
		//	minRow = pos.row;
		//if (pos.col < minCol)
		//	minCol = pos.col;
	}

	maxRow++;
	maxCol++;

	
	writeln(state);

	byte[] asArr = new byte[maxRow*maxCol];

	//writeln(pos)

	foreach (pos; state) {
		asArr[pos.row*maxCol + pos.col] = cast(byte)1;
	}

	auto f = File(fileName, "w");

	for (int row=0; row<maxRow; row++) {
		for (int col=0; col<maxCol; col++) {
			byte cell = asArr[row * maxCol + col]; 
			f.write(cell == 1 ? '1' : '0');
		}
		f.writeln();
	}

}

struct NextInfo {
	bool wasAlive;
	int neighbors;
}

void main(string[] args) {
	string inputFilePath = "in.txt";
	string outputFilePath;
	int numIterations = 1;

	auto helpInformation = getopt(
		args,
		"input|i"                , &inputFilePath  ,
		"number-of-iterations|n" , &numIterations  ,
		"output|o"               , &outputFilePath
		);

	char[] data = cast(char[]) read(inputFilePath);

	auto state = new ConwayState();

	auto statelist = conwayStateFromCharArr(data);

	foreach(pos; statelist)
		writeln(pos);

	PosListDict posNext;

	// Add neighbors number
	foreach(pos; statelist) {
		addToNext(posNext, Position(pos.row-1, pos.col-1));
		addToNext(posNext, Position(pos.row-1, pos.col  ));
		addToNext(posNext, Position(pos.row-1, pos.col+1));

		addToNext(posNext, Position(pos.row  , pos.col-1));

		addToNext(posNext, Position(pos.row  , pos.col+1));

		addToNext(posNext, Position(pos.row+1, pos.col-1));
		addToNext(posNext, Position(pos.row+1, pos.col  ));
		addToNext(posNext, Position(pos.row+1, pos.col+1));
	}

	// Set was alive value
	foreach(pos; statelist)
		if ((pos in posNext) != null)
			posNext[pos].wasAlive = true;

	foreach(key, value; posNext)
		writeln(key, " ", value);

	foreach(key, value; posNext) {
		if (value.wasAlive) {
			if (value.neighbors < 2 || value.neighbors > 3)
				posNext.remove(key);
		}
		else {
			if (value.neighbors != 3)
				posNext.remove(key);
		}
	}

	writeln("---");

	foreach(key, value; posNext)
		writeln(key, " ", value);

	writeListStateToFile(posNext.keys, "out.txt");
}