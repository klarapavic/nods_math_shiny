
# Interactive Depth-First Search (DFS) in R

This project provides an **interactive visualization of the Depth-First Search (DFS) algorithm** using R and Shiny. It is designed both as a teaching tool for graph theory and as a demonstration of algorithmic simulation.

## Mathematical Background

**Graphs** are formalized as $G = (V, E)$, where:

* $V$ is the set of vertices (nodes),
* $E \subseteq V \times V$ is the set of directed edges.

In a DFS, the algorithm explores as deeply as possible along one branch before backtracking. The process can be defined as:

1. **Initialization**: Start at a source vertex $s \in V$.
2. **Discovery**: When a node $u$ is first visited, record its *discovery time* $d(u)$.
3. **Recursion / Stack Expansion**: Visit each neighbor $v \in Adj(u)$ that has not been discovered yet.
4. **Finish**: When all neighbors of $u$ have been fully explored, record its *finish time* $f(u)$.

DFS induces a **depth-first forest** (a collection of depth-first trees), and assigns each vertex a pair $(d(u), f(u))$ that characterizes when it was discovered and finished. These times satisfy important mathematical properties:

* For every edge $(u,v) \in E$, either

  * $d(u) < d(v) < f(v) < f(u)$ (a *tree* or *forward* edge), or
  * $d(v) < d(u) < f(u) < f(v)$ (a *back* edge).

* The intervals $[d(u), f(u)]$ and $[d(v), f(v)]$ are either **nested** or **disjoint**.

This structure underlies proofs of correctness and applications of DFS in:

* **Topological sorting** (linear ordering of DAGs),
* **Detecting cycles** in directed graphs,
* **Strongly connected components** (via Kosaraju/Tarjan algorithms).

## The Shiny App

This app simulates the above mathematics interactively:

* A directed graph is defined by an **adjacency list**.
* DFS is executed step-by-step with a **stack** (LIFO).
* At each step:

  * Discovery and finish times are updated,
  * The visited path is displayed,
  * The graph visualization highlights visited nodes.

### User Controls

* **Start Node**: choose where DFS begins.
* **Next Step**: advance the algorithm by one step.
* **Reset**: restart the process.

### Outputs

* **Visited order** of nodes,
* **Discovery/finish times**,
* **Graph plot** (visited nodes in light blue, others in gray).

## Requirements

```r
install.packages(c("shiny", "igraph"))
```

## Running the App

```r
library(shiny)
library(igraph)

shinyApp(ui = ui, server = server)
```

The app will open in your browser and allow you to interactively explore DFS.

## Notes

* This implementation is primarily for **pedagogical purposes**: it makes the stack mechanism and discovery/finish times visible step by step.
* The code can be adapted for larger graphs or to illustrate related algorithms (BFS, topological sorting, SCC decomposition).
