library(shiny)
library(igraph)


# Define the adjacency list / tree -> so we define the connections/directions between the nodes
graph <- list(
  A = c("B", "C"),
  B = c("D", "E"),
  C = c("F"),
  D = character(0),
  E = c("F"),
  F = character(0)
)


# User Interface (UI) -> Design buttons, plots, headlines, etc.
ui <- fluidPage(   
    titlePanel("Interactive DFS in R"),
    sidebarLayout(
    sidebarPanel(
      selectInput("startNode", "Select Starting Node:", choices = names(graph)),
      actionButton("nextStep", "Next Step"),
      actionButton("reset", "Reset"),
      verbatimTextOutput("visitedNodes"),
    ),
    mainPanel(
      plotOutput("graphPlot", height = "600px")
    )
  )
)


# Server logic -> Handles DFS simulation and interactions

# input: list-like object with all input values from the UI elements 
# output: list-like object where dynamic elements are assigned 
# (--> our tree plot and button box) that are displayed in the UI.
# session: current user session (managing reactivity, updating input controls)

server <- function(input, output, session) {
  
  # Reactive values for managing DFS state dynamically
  dfs_state <- reactiveValues(
    visited = character(0),      # Tracks the nodes that have been visited
    stack = character(0),        # Simulates the DFS stack (last-in, first-out behavior)
    time = 0,                    # Counter for discovery and finish times
    discovery_time = numeric(0), # Stores discovery times for each visited node
    finish_time = numeric(0),    # Stores finish times for each processed node
    current_node = NULL          # Node currently being processed
  )
   
  # Reset DFS state when the "Reset" button is clicked
  observeEvent(input$reset, {
    dfs_state$visited <- character(0)        
    dfs_state$stack <- character(0)          
    dfs_state$discovery_time <- numeric(0)   
    dfs_state$finish_time <- numeric(0)      
    dfs_state$time <- 0                      
    dfs_state$current_node <- NULL           
  })
  
  # Perform DFS step-by-step when the "Next Step" button is clicked
  
  observeEvent(input$nextStep, {
    
    # Initialize DFS if stack is empty and no node is currently being processed
    if (length(dfs_state$stack) == 0 && is.null(dfs_state$current_node)) {
      dfs_state$stack <- list(list(node = input$startNode, state = "discovery")) # Add the start node to the stack
                                                                                 # stack of list of node with state
      return()  # Exit after initializing DFS
    }
    
    # If stack is not empty, process the top (last) node --> given by length (last in first out)
    if (length(dfs_state$stack) > 0) {
      
      current_frame <- dfs_state$stack[[length(dfs_state$stack)]]  # Peek at the top of the stack
      node <- current_frame$node                                   # Extract the current node
      state <- current_frame$state                                 # Extract the current state ("discovery" or "processing")
      
      if (state == "discovery") {  # If the node is in the discovery phase
        
        # Check if the node has not been visited
        if (!(node %in% dfs_state$visited)) {                     
          dfs_state$time <- dfs_state$time + 1                    # Increment the time counter
          dfs_state$discovery_time[node] <- dfs_state$time        # Assign discovery time to the node
          dfs_state$visited <- c(dfs_state$visited, node)         # Mark the node as visited
        }
        
        # Get the neighbors of the current node
        neighbors <- graph[[node]]
        # Identify neighbors that have not been visited
        unvisited_neighbors <- setdiff(neighbors, dfs_state$visited) # difference of our two sets
        
        # Update the current node's state to "processing" and push it back onto the stack
        dfs_state$stack[[length(dfs_state$stack)]]$state <- "processing"
        
        # Add all unvisited neighbors to the stack in "discovery" state
        for (neighbor in rev(unvisited_neighbors)) { # reverse bc lifo
          dfs_state$stack <- append(dfs_state$stack, list(list(node = neighbor, state = "discovery")))
        } 
        
      } else if (state == "processing") {  # If the node is in the processing phase
        # Assign finish time to the node
        dfs_state$time <- dfs_state$time + 1
        dfs_state$finish_time[node] <- dfs_state$time
        # finish time = when all neighbors of the node have been processed
        
        # Remove the node from the stack as it is fully processed
        dfs_state$stack <- dfs_state$stack[-length(dfs_state$stack)]
      }
    }
  })
  
  # Display visited nodes and their discovery/finish times
  output$visitedNodes <- renderText({
    paste(
      "Visited Nodes:", paste(dfs_state$visited, collapse = " -> "), 
      "\nDiscovery Times:", paste(dfs_state$discovery_time[dfs_state$visited], collapse = " -> "),
      "\nFinish Times:", paste(dfs_state$finish_time[dfs_state$visited], collapse = " -> ")
    )
  })
  
  # Convert adjacency list into an igraph object for visualization
  edge_list <- do.call(rbind, lapply(names(graph), function(from) {
    if (length(graph[[from]]) > 0) {
      data.frame(from = from, to = graph[[from]], stringsAsFactors = FALSE)
    } else {
      NULL
    }
  }))
  
  all_nodes <- unique(c(edge_list$from, edge_list$to))  # Identify all unique nodes
  g <- graph_from_data_frame(d = edge_list, vertices = data.frame(name = all_nodes), directed = TRUE)
  
  # Plot the graph with visited nodes highlighted
  output$graphPlot <- renderPlot({
    node_colors <- ifelse(V(g)$name %in% dfs_state$visited, "lightblue", "gray")  # Highlight visited nodes
    plot(
      g,
      vertex.color = node_colors,      # Set node colors
      vertex.label.color = "black",    # Set label colors
      vertex.size = 30,                # Adjust node size
      edge.arrow.size = 0.5,           # Adjust arrow size
      main = "Interactive DFS Visualization"
    )
  })
}



# Run the app -> combines both functions from above -> session
shinyApp(ui = ui, server = server)
