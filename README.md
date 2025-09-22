
# Depth-First Search (DFS) and Applications

This project presents the **theoretical foundations** of the Depth-First Search (DFS) algorithm in graph theory, alongside a small Shiny application that visualizes DFS step by step for didactic purposes.
This was a group project for Computing 1 with Kurt Hornik for MSc. QFin @WU Wien

## Graphs

A graph is defined as $G = (V, E)$, where

* $V$ is the set of vertices,
* $E \subseteq V \times V$ is the set of directed or undirected edges.

Two standard representations are commonly used:

* **Adjacency list**: space requirement $\Theta(V+E)$, efficient for sparse graphs.
* **Adjacency matrix**: space requirement $\Theta(V^2)$, efficient for dense graphs.

## Depth-First Search

DFS explores a graph by advancing as far as possible along each branch before backtracking.

**Algorithmic properties:**

* Runs in $\Theta(V+E)$ time with adjacency list representation.
* Each vertex $u \in V$ receives two timestamps:

  * $d(u)$: *discovery time* when $u$ is first reached,
  * $f(u)$: *finish time* when exploration of all neighbors of $u$ is complete.

**Structural properties:**

* For any two vertices $u, v$, the intervals $[d(u), f(u)]$ and $[d(v), f(v)]$ are either disjoint or nested.
* Every edge $(u,v)$ falls into one of four categories:

  * *Tree edge*: leads to a previously unvisited vertex.
  * *Back edge*: points to an ancestor in the DFS tree.
  * *Forward edge*: points to a descendant already discovered.
  * *Cross edge*: connects vertices in different DFS trees.

DFS thereby constructs a **depth-first forest**, consisting of rooted DFS trees that reflect the structure of the graph.

## Interactive Component

A minimal **Shiny app** is included that allows DFS to be run step by step on a small graph, showing visited nodes and discovery/finish times. This is intended purely as a **teaching tool** to make the abstract theory tangible.

```r
install.packages(c("shiny", "igraph"))
```
