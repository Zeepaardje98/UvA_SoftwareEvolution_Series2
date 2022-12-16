/*
 * This file contains functions to generate and calculate specific data from our
 * clone class list, for the visualization.
 */

module DataFunctions

import Set;
import Location;

// Returns the amount of lines there are in the clones that we found
// Note that in case clones from different classes overlap, this function can
// count the same duplicate lines multiple times.
int getTotalCloneLines(map[str, set[loc]] cloneClasses) {
    int totalLines = 0;

    for (class <- cloneClasses) {
        for (clone <- cloneClasses[class]) {
            // +1 because line numbers start at 1 and not zero
            int numLines = clone.end.line - clone.begin.line + 1;
            totalLines += numLines;
        }

    }

    return totalLines;
}

// Returns the index of the class with the biggest clone, and the amount of lines
// the clone has
tuple[int, int] getClassWithBiggestClone(map[str, set[loc]] cloneClasses) {
    int counter = 0;
    int index = 0;
    int mostLines = 0;

    for (class <- cloneClasses) {
        loc cloneLoc = toList(cloneClasses[class])[0];
        int numLines = cloneLoc.end.line - cloneLoc.begin.line + 1;

        if (numLines > mostLines) {
            mostLines = numLines;
            index = counter;
        }
        counter += 1;
    }

    return <index, mostLines>;
}

// Returns the index of the class with the highest amount of clones, and the amount
tuple[int, int] getClassWithMostClones(map[str, set[loc]] cloneClasses) {
    int counter = 0;
    int index = 0;
    int numClones = 0;

    for (class <- cloneClasses) {
        if (size(cloneClasses[class]) > numClones) {
            numClones = size(cloneClasses[class]);
            index = counter;
        }
        counter += 1;
    }

    return <index, numClones>;
}