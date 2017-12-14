#############w1#############
#shiny is a web-development framework based on R for data products 
library(shiny)
library(shinycssloaders)
data("Titanic")
#see builder for html elements
?builder



  
shinyUI(fluidPage(
    align="center",
    tags$head(tags$style(
      HTML('
           #sidebar {
           background-color: blue
           }')
  )),
  fluidRow(tags$h3("Predicting Car Acceptance",align="center")),
  br(),
  fluidRow(tags$p("This application predicts car acceptance level using features such as price, maintenance cost, number of doors, capacity and safety.",align="center")),
  fluidRow(tags$p("First, select the input values and ML algorithms from the left panel and click apply",align="center")),
  fluidRow(tags$p("Next, you could investigate the prediction and performance metrics from the right panel",align="center")),
  br(),
  fluidRow(
    #column(1),
    column(5,div(style = "",
           tabsetPanel(
             type = "tabs",
             tabPanel("Car Information",
                      column(6,tags$div(align="left",
                                        selectInput("buying_price", "Price:",choices=unique(DT_raw$buying_price),selected = "high"),
                                        selectInput("maintenance_cost", "Maintenance Cost:",choices=unique(DT_raw$buying_price),selected = "med"),
                                        selectInput("doors", "Doors:",choices=unique(DT_raw$doors),selected="5more"))
                      ),
                      column(6,tags$div(align="left",
                                        selectInput("passenger_capacity", "Passenger Capacity:",choices=unique(DT_raw$passenger_capacity),selected = "more"),
                                        selectInput("luggage_capacity", "Luggage Capacity:",choices=unique(DT_raw$luggage_capacity),selected = "small"),
                                        selectInput("safety", "Safety:",choices=unique(DT_raw$safety),selected = "med"))
                      ),
                      style='height: 260px'
             ),
             tabPanel("Algorithm",
                      column(3),
                      column(8,tags$div(align="left",
                                        br(),
                                        checkboxInput("SVM","Support Vector Machine (SVM)",value = TRUE),
                                        checkboxInput("RF","Random Forest (RF)",value=TRUE),
                                        checkboxInput("XGBoost","XGBoost Tree (XGBoost)",value = TRUE),
                                        checkboxInput("ANN","Artificial Neural Network (ANN)",value = TRUE)
                      )),
                      column(1),
                      style='height: 260px'
             )
             
             
          )),
          
          tags$div(align="center",submitButton("Apply"))
    ),
    column(7,
           tabsetPanel(
              type = "tabs",
              tabPanel("Prediction",
                 div(withSpinner(plotlyOutput("plot1"),type=8),align="center")
              ),
              tabPanel("Accuracy",style='height: 260px',
                    div(withSpinner(plotlyOutput("plot2"),type=8),align="center")
              ),
              tabPanel("Sensitivity",
                       div(withSpinner(plotlyOutput("plot3"),type=8),align="center")
              ),
              tabPanel("Specificity",
                       div(withSpinner(plotlyOutput("plot4"),type=8),align="center")
              ),
              tabPanel("Training Time",
                       div(withSpinner(plotlyOutput("plot5"),type=8),align="center")
              ),
              tabPanel("Workflow",
                       br(),
                       div(img(src = "Flow.png",height = '250px'),align="center")
              )
           )
    )
    #column(1)

 )

))