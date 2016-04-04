import std.stdio;
import std.file;
import std.getopt;
import std.algorithm;
import std.container;

import utils;
import ConwayCommon;

void writeListStateToFile(ConwayState state, File file) {
	auto range = Range2D(0, 10, 0, 10);
	int arrCols = range.maxCol - range.minCol + 1;

	byte[] asArr = state.getAsByteArray(range);

	for (int row=range.minRow; row<=range.maxRow; row++) {
		for (int col=range.minCol; col<=range.maxCol; col++) {
			byte cell = asArr[(row - range.minRow) * arrCols + (col - range.minCol)]; 
			file.write(cell == 1 ? '1' : '-');
		}
		file.writeln();
	}
}

void conwayStateFromCharArr(ConwayState state, char[] data) {
	int row=0, col=0;

	for (int i=0; i<data.length; i++)
		if (data[i] == '\n') {
			row ++;
			col = 0;
		}
		else if (data[i] != '\r') {
			if (data[i] == '1')
				state.setAlive(row, col);

			col ++;
		}
}

void main(string[] args) {
	string inputFilePath = "in.txt";
	string outputFilePath = "";
	int numIterations = 1;

	auto helpInformation = getopt(
		args,
		"input|i"                , &inputFilePath  ,
		"number-of-iterations|n" , &numIterations  ,
		"output|o"               , &outputFilePath
		);

	char[] data = cast(char[]) read(inputFilePath);

	File outFile = (outputFilePath != "" ? File(outputFilePath, "w") : stdout);

	auto state = new ConwayState();

	conwayStateFromCharArr(state, data);

	state.iterate(numIterations);
	writeListStateToFile(state, outFile);
}