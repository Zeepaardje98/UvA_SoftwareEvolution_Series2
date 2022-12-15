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
    int numCloneClasses = size(cloneClasses);
    int numClones = size(union(range((cloneClasses))));
    int biggestClass = getBiggestCloneClass(cloneClasses);
    int biggestClone = getBiggestClone(cloneClasses);

    list[map[str, value]] cloneStats =
    [
        (
            "title": "total clone classes",
            "value": numCloneClasses,
            "btnRoute": "/classes",
            "btnText": "show all classes"
        ),
        (
            "title": "total clones",
            "value": numClones,
            "btnRoute": "/clones",
            "btnText": "show all clones"
        ),
        (
            "title": "biggest clone class",
            "value": "<biggestClass> clones",
            "btnRoute": "/classes",
            "btnText": "show biggest clone class"
        ),
        (
            "title": "biggest clone",
            "value": "<biggestClone> lines",
            "btnRoute": "/clones",
            "btnText": "show biggest clone"
        )
    ];

    writeJSON(|file:///home/michelle/Documents/master-se/software-evolution/UvA_SoftwareEvolution_Series2/front-end/clone-app/src/cloneStats.json|, cloneStats, indent=1);
}

// Returns the highest amount of clones in one clone class
int getBiggestCloneClass(map[str, set[loc]] cloneClasses) {
    int biggestClass = 0;

    for (class <- cloneClasses) {
        if (size(cloneClasses[class]) > biggestClass) {
            biggestClass = size(cloneClasses[class]);
        }
    }

    return biggestClass;
}

// Returns the highest amount of lines in one clone
int getBiggestClone(map[str, set[loc]] cloneClasses) {
    int biggestClone = 0;

    for (class <- cloneClasses) {
        str cloneString = getContent(toList(cloneClasses[class])[0]);
        list[str] cloneLines = split("\n", cloneString);

        if (size(cloneLines) > biggestClone) {
            biggestClone = size(cloneLines);
        }
    }

    return biggestClone;
}