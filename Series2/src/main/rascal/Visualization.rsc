/*
 * This file contains the functions that relate to the clone visualization.
*/

module Visualization

import List;
import Map;
import Set;
import Location;

import ClonePairs;
import DataFunctions;

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
        int cloneCounter = 0;
        str classTitle = "";
        int cloneSize = 0;
        list[map[str, value]] clones = [];
        for (loc clone <- toList(cloneClasses[hash])) {
            str fileName = clone.path;
            str cloneString = getContent(clone);
            int startLineNumber = clone.begin.line;
            // + 1 because line numbers start at 1 not zero
            cloneSize = clone.end.line - clone.begin.line + 1;
            clones +=
            (
                "fileName": fileName,
                "lines": cloneString,
                "startLineNumber": startLineNumber
            );
            if (cloneCounter == 0) {
                classTitle += fileName;
            }
            if (cloneCounter == 1) {
                classTitle += ", <fileName>";
            }
            if (cloneCounter == 2) {
                classTitle += ", ...";
            }
            cloneCounter += 1;
        }
        classes +=
        (
            "id": counter,
            "clones": clones,
            "title": classTitle,
            "numClones": cloneCounter,
            "cloneSize": cloneSize
        );
        counter += 1;
    }
    writeJSON(|cwd:///../../../../front-end/clone-app/src/data/cloneClasses.json|, classes, indent=1);
}

void exportStatistics(map[str, set[loc]] cloneClasses) {
    int numCloneClasses = size(cloneClasses);
    int numClones = size(union(range((cloneClasses))));
    tuple[int, int] biggestCloneClass = getClassWithBiggestClone(cloneClasses);
    tuple[int, int] mostClonesClass = getClassWithMostClones(cloneClasses);
    int totalCloneLines = getTotalCloneLines(cloneClasses);

    list[map[str, value]] cloneStats =
    [
        (
            "title": "total clones",
            "value": numClones,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "total clone classes",
            "value": numCloneClasses,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "total clone lines",
            "value": totalCloneLines,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "total files with clones",
            "value": "?",
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

    writeJSON(|cwd:///../../../../front-end/clone-app/src/data/stats.json|, cloneStats, indent=1);
}

