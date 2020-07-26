library(shinydashboard)
library(shiny)
library(tidymodels)
library(tidyverse)

linear_model <- ('linear_model.rds')

# Define UI for application that draws a histogram
ui <- dashboardPage(
    
    dashboardHeader(title =  'South American Soccer Players Modelling'),
    
    dashboardSidebar(
        menuItem(
            'Conmebol',
            tabName = "soccer_tab"
        )
    ),
    
    dashboardBody(
        tabItem(
            tabName = 'soccer_tab',
            
            box(valueBoxOutput('player_prediction')),
            box(selectInput('s_position', 
                           label = "Best Position",
                           choices = conmebol$best_position,
                           selected = 'ST')),
            box(selectInput('s_foot', 
                            label = "Strong Foot",
                            choices = conmebol$foot,
                            selected = 'Right')),
            box(selectInput('s_nationality', 
                            label = "Nationality",
                            choices = conmebol$nationality,
                            selected = "Venezuela")),
            box(sliderInput('s_overall',
                            label = 'Overall',
                            min = 50, max = 100, value = 70)),
            box(sliderInput('s_attacking',
                            label = 'Attacking',
                            min = 40, max = 450, value = 300)),
            box(sliderInput('s_crossing',
                            label = 'Crossing',
                            min = 5, max = 90, value = 50)),
            box(sliderInput('s_finishing',
                            label = 'Finishing',
                            min = 5, max = 100, value = 50)),
            box(sliderInput('s_short_passing',
                            label = 'Short Passing',
                            min = 10, max = 100, value = 60)),
            box(sliderInput('s_skill',
                            label = 'Skill',
                            min = 50, max = 100, value = 65)),
            box(sliderInput('s_dribbling',
                            label = 'Dribbling',
                            min = 5, max = 100, value = 70)),
            box(sliderInput('s_long_passing',
                            label = 'Long Passing',
                            min = 10, max = 100, value = 60)),
            box(sliderInput('s_contol',
                            label = 'Control',
                            min = 10, max = 100, value = 60)),
            box(sliderInput('s_defense',
                            label = 'Defense',
                            min = 25, max = 270, value = 150)),
            box(sliderInput('s_defense',
                            label = 'Defense',
                            min = 25, max = 270, value = 150)),
            box(sliderInput('s_totalgoalkeeping',
                            label = 'Total Goalkeeping',
                            min = 10, max = 450, value = 60))
            
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  table <- reactive({
      
      
      table <- data.frame("best_position" = input$s_position,
                 "foot" = input$s_foot,
                 "nationality" = input$s_nationality,
                 "overall" = input$s_overall,
                 "attacking" = input$s_attacking,
                 "crossing" = input$s_crossing, 
                 'finishing' = input$s_finishing, 
                 'short_passing' = input$s_short_passing, 
                 'skill' = input$s_skill,
                 'dribbling' = input$s_dribbling,
                 'long_passing' = input$s_long_passing,
                 'control' = input$s_control,
                 'defense' = input$s_defense,
                 "total_goalkeeping" = input$s_total_goalkeeping)
  })
  
  prediction <- reactive({ predict(
      linear_fit, table())
      
      })

  
  output$player_prediction <- renderValueBox({
      
      valueBox(value = prediction())
  })
      

}

# Run the application 
shinyApp(ui = ui, server = server)
