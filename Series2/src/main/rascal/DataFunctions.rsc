/*
 * This file contains functions to generate and calculate specific data from our
 * clone class list, for the visualization.
 */

module DataFunctions

import IO;
import Set;
import List;
import Location;

import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Returns the amount of unique clone lines from our detected clones,
// by putting a tuple of path and line number in a set and calculating its size.
// Note that blank lines are currently counted.
int getTotalCloneLines(map[str, set[loc]] cloneClasses) {
    set[tuple[str, int]] uniqueLines = {};

    for (class <- cloneClasses) {
        for (clone <- cloneClasses[class]) {
            uniqueLines += toSet([<clone.path, line> | int line <- [clone.begin.line .. clone.end.line]]);
        }
    }

    return size(uniqueLines);
}

// Returns the clone line percentage of a project.
// Note that blank lines are currently counted for both the total project lines
// and the total unique clone lines.
int getCloneLinePercentage(int totalCloneLines, loc projectLocation) {
    int totalProjectLines = 0;

    M3 model = createM3FromMavenProject(projectLocation);
    projectFiles = [ f | f <- files(model.containment), isCompilationUnit(f)];

    for (f <- projectFiles) {
        list[str] fileLines = readFileLines(f);
        totalProjectLines += size(fileLines);
    }

    return toInt(toReal(totalCloneLines) / toReal(totalProjectLines) * 100);
}

// Returns the index of the class with the biggest clone, and the amount of lines
// the clone has.
// Note that blank lines are currently counted.
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