/*
 * This file contains the functions that relate to the clone visualization.
*/

module Visualization

import IO;
import List;
import Map;
import Set;
import Location;
import String;

import ClonePairs;

import lang::json::IO;

void exportCloneData() {
    map[str, set[loc]] cloneClasses = getCloneClasses();
    exportStatistics(cloneClasses);
    exportCloneClasses(cloneClasses);
    writeJSON(|project://Series2/cloneClasses.json|, cloneClasses, indent=1);
}

void exportCloneClasses(map[str, set[loc]] cloneClasses) {
    int counter = 0;
    list[map[str, value]] classes = [];
    for (hash <- cloneClasses) {
        list[map[str, value]] clones = [];
        for (loc clone <- toList(cloneClasses[hash])) {
            str fileName = clone.path;
            str cloneString = getContent(clone);
            int startLineNumber = clone.begin.line;
            clones +=
            (
                "fileName": fileName,
                "lines": cloneString,
                "startLineNumber": startLineNumber
            );
        }
        classes +=
        (
            "id": counter,
            "clones": clones
        );
        counter += 1;
    }
    writeJSON(|project://front-end/clone-app/src/data/cloneClasses.json|, classes, indent=1);
}

void exportStatistics(map[str, set[loc]] cloneClasses) {
    int numCloneClasses = size(cloneClasses);
    int numClones = size(union(range((cloneClasses))));
    tuple[int, int] biggestCloneClass = getClassWithBiggestClone(cloneClasses);
    tuple[int, int] mostClonesClass = getClassWithMostClones(cloneClasses);

    list[map[str, value]] cloneStats =
    [
        (
            "title": "total clone classes",
            "value": numCloneClasses,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "total clones",
            "value": numClones,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "biggest clone",
            "value": "<biggestCloneClass[1]> lines",
            "btnRoute": "/class?id=<biggestCloneClass[0]>",
            "btnText": "show clone class"
        ),
        (
            "title": "most clones in one class",
            "value": "<mostClonesClass[1]> clones",
            "btnRoute": "/class?id=<mostClonesClass[0]>",
            "btnText": "show clone class"
        )
    ];

    writeJSON(|project://front-end/clone-app/src/data/cloneStats.json|, cloneStats, indent=1);
}



// Returns the index of the class with the biggest clones, and the amount of lines
// the clones have
tuple[int, int] getClassWithBiggestClone(map[str, set[loc]] cloneClasses) {
    int counter = 0;
    int index = 0;
    int numLines = 0;

    for (class <- cloneClasses) {
        str cloneString = getContent(toList(cloneClasses[class])[0]);
        list[str] cloneLines = split("\n", cloneString);

        if (size(cloneLines) > numLines) {
            numLines = size(cloneLines);
            index = counter;
        }
        counter += 1;
    }

    return <index, numLines>;
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