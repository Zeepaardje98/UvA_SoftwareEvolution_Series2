
// map[node, node] findClones(map[str, list[node]] subtrees, real similarityThreshold, int massThreshold) {
//     // println("Num hashes: <size(subtrees)>");
//     map[node, node] clones = ();
//     map[value, value] cloneSources = (); // for testing purposes, remove eventually
//     for (hash <- subtrees) {
//         list[node] nodes = subtrees[hash];
//         for (i <- nodes) {
//             for (j <- nodes) {
//                 if (i != j && isSimilar(i, j, similarityThreshold)) {
//                     bool isSubset = false;
//                     visit (i) {
//                         case node n: {
//                             if (n == j) {
//                                 isSubset = true;
//                             }
//                             if (n in domain(clones)) {
//                                 delete(clones, n);
//                             }
//                         }
//                     }
//                     visit (j) {
//                         case node n: {
//                             if (n == i) {
//                                 isSubset = true;
//                             }
//                             if (n in domain(clones)) {
//                                 delete(clones, n);
//                             }
//                         }
//                     }
//                     if (!(j in domain(clones) && clones[j] == i) && !isSubset) {
//                         clones[i] = j;
//                         cloneSources[i.src] = j.src;
//                     }
//                 }
//             }
//         }
//     }
//     // println(cloneSources);
//     return clones;
// }

// list[map[str, value]] scoreStats =
// [
//     (
//         "title": "duplicate lines",
//         "value": numDuplicateLines
//     ),
//     (
//         "title": "duplication score",
//         "value": "?"
//     )
// ];



// public bool uniqueCloneClass(list[loc] clones, loc cloneSrc0, loc cloneSrc1) {
//     bool clone0Unique = true;
//     bool clone1Unique = true;
//     for (clone <- clones) {
//         if (isContainedIn(cloneSrc0, clone)) {
//             clone0Unique = false;
//         }
//         if (isContainedIn(clone, cloneSrc1)) {
//             clone1Unique = false;
//         }
//     }
//     return (clone0Unique || clone1Unique);

// // Find the number of shared and unique nodes for 2 trees.
// tuple[real S, real L, real R] sharedUniqueNodes(node subtree1, node subtree2) {
//     list[node] uniqueNodes1 = [];
//     list[node] uniqueNodes2 = [];
//     list[node] sharedNodes = [];

//     // First put all nodes of subtree 1 in uniqueNodes1
//     visit (subtree1) {
//         case node n: uniqueNodes1 += unsetRec(n);
//     }

//     // Go through nodes of subtree 2 and fill the three node lists appropriately
//     visit (subtree2) {
//         case node n: {
//             if (unsetRec(n) in uniqueNodes1) {
//                 uniqueNodes1 -= unsetRec(n);
//                 sharedNodes += unsetRec(n);
//             }
//             else {
//                 uniqueNodes2 += unsetRec(n);            
//             }
//         }
//     }

//     real S = toReal(size(sharedNodes));
//     real L = toReal(size(uniqueNodes1));
//     real R = toReal(size(uniqueNodes2));

//     return <S, L, R>;
// }