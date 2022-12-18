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

import util::Math;
import lang::json::IO;

// Function to export all clone data that is needed for the visualization to JSON files
void exportCloneData(loc projectLocation) {
    map[str, set[loc]] cloneClasses = getCloneClasses();
    exportStatistics(cloneClasses, projectLocation);
    exportCloneClasses(cloneClasses);
    exportCloneFiles(cloneClasses);
}

// Function to export clone statistics to a JSON file
void exportStatistics(map[str, set[loc]] cloneClasses, loc projectLocation) {
    int numCloneClasses = size(cloneClasses);
    int numClones = size(union(range((cloneClasses))));
    tuple[int, int] biggestCloneClass = getClassWithBiggestClone(cloneClasses);
    tuple[int, int] mostClonesClass = getClassWithMostClones(cloneClasses);
    int totalCloneLines = getTotalCloneLines(cloneClasses);
    int cloneLinePercentage = getCloneLinePercentage(totalCloneLines, projectLocation);

    list[map[str, value]] cloneStats =
    [
        (
            "title": "clones",
            "value": numClones,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "clone classes",
            "value": numCloneClasses,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "clone lines",
            "value": totalCloneLines,
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "clone line percentage",
            "value": "<cloneLinePercentage>%",
            "btnRoute": "/classes",
            "btnText": "show all clone classes"
        ),
        (
            "title": "biggest clone (lines)",
            "value": biggestCloneClass[1],
            "btnRoute": "/class?id=<biggestCloneClass[0]>",
            "btnText": "show clone class"
        ),
        (
            "title": "biggest class (members)",
            "value": <mostClonesClass[1]>,
            "btnRoute": "/class?id=<mostClonesClass[0]>",
            "btnText": "show clone class"
        )
    ];

    writeJSON(|cwd:///../../../../front-end/clone-app/src/data/stats.json|, cloneStats, indent=1);
}

// Function to export data about the clone classes to a JSON file
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
            cloneSize = size(getCodeLineNumbers(clone));
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
                classTitle += " & more ...";
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

void exportCloneFiles(map[str, set[loc]] cloneClasses) {
    map[str, list[map[str, value]]] filesMap = ();
    list[map[str, value]] filesData = [];
    int index = 0;

    for (hash <- cloneClasses) {
        for (clone <- cloneClasses[hash]) {
            map[str, value] cloneData = (
                "cloneClass" : hash,
                "startLineNumber": clone.begin.line,
                "endLineNumber": clone.end.line
            );
            if (clone.path in filesMap) {
                filesMap[clone.path] += cloneData;
            }
            else {
                filesMap[clone.path] = [cloneData];
            }
        }
    }

    for (file <- filesMap) {
        // list[int] labels = getFileChartLabels(filesMap[file]);
        filesData += (
            "fileName": file,
            "clones": filesMap[file],
            "id": index,
            "numClones": size(filesMap[file])
            // "labels": labels,
            // "chartData": getFileChartData(filesMap[file], labels)
        );
        index += 1;
    }

    writeJSON(|cwd:///../../../../front-end/clone-app/src/data/cloneFiles.json|, filesData, indent=1);
}

// list[int] getFileChartLabels(list[map[str, value]] clones) {
//     int startLineNumber = 0;
//     int endLineNumber = 0;

//     for (clone <- clones) {
//         if (clone["endLineNumber"] > toInt(endLineNumber)) {
//             endLineNumber = toInt(clone["endLineNumber"]);
//         }
//     }

//     return [startLineNumber .. endLineNumber];
// }

// list[int] getFileChartData(list[map[str, value]] clones, list[int] labels) {
//     list[int] chartData = [];
//     numLabels = size(labels);

//     for (i <- [0.. (numLabels - 1)]) {
//         chartData[i] = 0;
//     }

//     for (clone <- clones) {
//         int startLine = toInt(clone["startLineNumber"]);
//         int endLine = toInt(clone["startLineNumer"]);
//         for (i <- [startLine .. endLine]) {
//             chartData[i] = 100;
//         }
//     }
//     return chartData;
// }