/*
 * This file contains helper functions for our clone detection tool.
 */

module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;
import util::Math;

import IO;
import Node;
import List;
import Set;
import String;
import Location;

// Get the ASTs of a project.
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

// Print the locations of a list of nodes
void printNodes(list[node] nodes) {
    for (n <- nodes) {
        println(n.src);
    }
    return;
}

// Function that combines the locations from consecutive nodes in a clone sequence
// into one location for the whole code block.
loc combineLocations(list[node] nodes) {
    list [loc] nodeSrc = [];

    for (n <- nodes) {
        nodeSrc += n.src;
    }

    loc cloneSrc = cover(nodeSrc);

    return cloneSrc;
}

// Function that computes the mass (amount of nodes) of a subtree
int mass(node root, int threshold=0) {
    int mass = 0;
    visit(root) {
        case node n: {
            mass += 1;
            if (threshold != 0 && mass >= threshold) {
                return mass;
            }
        }
    }
    return mass;
}

// Function that checks whether a node is a leaf
bool isLeaf(node root) {
    // bottom-up visit, so a leaf should be the first node visited
    visit(root) {
        case node n:
            if (n != root) {
                return false;
            }
            else {
                return true;
            }
    }
}

// Function that checks whether tree2 is a subset of tree1.
bool isSubset(node tree1, node tree2) {
    visit(tree1) {
        case node n: if (n == tree2) {return true;}
    }
    return false;
}

// Function that checks whether a list is a subsequence of another.
bool isSubsequence(list[value] List, list[value] subList) {
    for (i <- [0..size(List)]) {
        int j = i + size(subList);
        if (List[i..j] == subList) {
            return true;
        }
    }
    return false;
}

// Function that checks whether one node sequence is a subset of another.
bool isSubset(list[node] rootSequence, list[node] subSequence) {
    // If the root sequence entails the sub-sequence, it is a subset.
    if (isSubsequence(rootSequence, subSequence)) {
        return true;
    }

    // For every sequence node in the root, visit the subtree. If this subtree
    // has a sequence which entails our subsequence, it is a subset.
    for (node n <- rootSequence) {
        visit(n) {
            // subsequence is contained in sequence of the current node.
            case \block(statements): {
                list[node] sequence = statements;
                if (isSubsequence(statements, subSequence)) {
                    return true;
                }
            }
            // subsequence is contained in the current node
            case node n: {
                if (size(subSequence) == 1 && subSequence[0] == n) {
                    return true;
                }
            }
        }
    }
    return false;
}

// Function that gets the direct children of a node, while also specifying the
// nodes location
list[node] directChildren(node root) {
    list[node] children = [n | node n <- getChildren(root), n.src?];
    return children;
}

// Function that gets the direct children of a node
list[node] directChildren2(node root) {
    list[node] children = [n | node n <- getChildren(root)];
    return children;
}

// NOTE: Does not really return similar, uniqueleft, uniqueright nodes. Instead
//       it returns the amount of similar and unique nodes. A tuple of size 3
//       is returned so this function can easily replace the sharedUniqueNodes
//       function that was created before, as it is used in the similarity
//       function.
tuple[int S, int L, int R] sharedUniqueNodes(node subtree1, node subtree2) {
    map[node, int] nodeCounter = ();
    visit(subtree1) {
        case node n: nodeCounter[unsetRec(n)]?0 += 1;
    }
    visit(subtree2) {
        case node n: nodeCounter[unsetRec(n)]?0 += 1;
    }

    list[int] SLR = [0,0,0];
    for (m <- nodeCounter) {
        if (nodeCounter[m] > 1) {
            SLR[0] += nodeCounter[m];
        } else {
            SLR[1] += 1;
        }
    }

    return <SLR[0], SLR[1], 0>;

}


// Calculate similarity score for 2 trees
real similarity(node subtree1, node subtree2) {
    tuple[int S, int L, int R] SLR = sharedUniqueNodes(subtree1, subtree2);

    real similarity = 2.0 * toReal(SLR[0]) / (2.0 * toReal(SLR[0]) + toReal(SLR[1]) + toReal(SLR[2]));
    return similarity;
}

// Calculate similarity score for 2 lists of trees
real similarity(list[node] subtrees1, list[node] subtrees2) {
    list[real] SLR = [0.0, 0.0, 0.0];
    for (i <- [0..size(subtrees1)]) {
        tuple[int S, int L, int R] currentSLR = sharedUniqueNodes(subtrees1[i], subtrees2[i]);
        SLR[0] += toReal(currentSLR[0]);
        SLR[1] += toReal(currentSLR[1]);
        SLR[2] += toReal(currentSLR[2]);
    }

    real similarity = 2.0 * SLR[0] / (2.0 * SLR[0] + SLR[1] + SLR[2]);
    return similarity;
}

// Check if a line is a blank line using RegEx, from Series1
bool isBlankLine(str line) {
    if (/^[\s\t\n]*$/ := line) {
        return true;
    }
    return false;
}

// Check if a line is a comment using RegEx, from Series1
bool isCommentLine(str line) {
    switch (trim(line)) {
        case /(^\/\/(\/*))/ :   // trimmed line starts with 2+ slashes
            return true;
        case /(^\*)/ :          // trimmed line starts with a * (not fully theoretically sound)
            return true;
        case /(^\/\*)/ :        // trimmed line starts with a /*
            return true;
        case /(\*\/$)/ :        // trimmed line ends with a */
            return true;
        default :
            return false;
    }
}