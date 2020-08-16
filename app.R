library(shinydashboard)
library(shiny)
library(tidymodels)
library(tidyverse)

source("Data Cleaning Script.R")

Conmebol_model<- Conmebol %>% 
  select(-id, -name, -position) 

model <- readRDS('rf_final_model.rds')


# Defining User Interactivity section
ui <- dashboardPage(
    
    dashboardHeader(title =  "Conmebol Soccer"),
    
    
    # Sidebar Pages
    dashboardSidebar(
      
      # Extending the dashboard background to fit all variables
      tags$head(tags$style(HTML('.content-wrapper { height: 1400px !important;}'))),
      
      sidebarMenu(
        menuItem(
            'Statistical Model', 
            tabName = "soccer_tab", 
            icon = icon('dashboard')),
        
        menuItem('Graphs', 
                 tabName = 'graphs', 
                 icon = icon('bar-chart')),
        
        menuItem(
          "About",
          tabName = 'about',
          icon = icon('table'))
      )
        
    ),
    
    dashboardBody(
      tags$head(tags$style(HTML(".small-box {width: 245px}"))),
      
      tabItems(
        tabItem(
            tabName = 'soccer_tab',
            
            h2("Market Value Estimation of South American Soccer Players"),
            
            h4("\n\n Instructions:"),
            
            h5("\n\n Select all the characteristics of a player and we'll make our best value estimation for him"),
            
            box(valueBoxOutput('player_prediction')),
            
            box(selectInput('s_position', 
                           label = "Best Position",
                           choices = Conmebol_model$best_position,
                           selected = 'ST')),
            box(selectInput('s_foot', 
                            label = "Strong Foot",
                            choices = Conmebol_model$foot,
                            selected = 'Right')),
            box(selectInput('s_nationality', 
                            label = "Nationality",
                            choices = Conmebol_model$nationality,
                            selected = "Venezuela")),
            box(sliderInput('s_height', 
                            label = "Height",
                            min = min(Conmebol_model$height), 
                            max = max(Conmebol_model$height), 
                            value = mean(Conmebol_model$height),
                            step = 0.1)),
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
            box(sliderInput('s_control',
                            label = 'Control',
                            min = 10, max = 100, value = 60)),
            box(sliderInput('s_defense',
                            label = 'Defense',
                            min = 25, max = 270, value = 150)),
            box(sliderInput('s_totalgoalkeeping',
                            label = 'Total Goalkeeping',
                            min = 10, max = 450, value = 60)
                )),
        
        tabItem(tabName = 'graphs', 
                    h2("Nothing")
                    ),
        tabItem(tabName = 'about',
                 h2("Authors"),
                
                'This Shinyapp was developed by Nico and Luis...  \n\n The statistical model included in the 
                first tab *(Statistical Model)* is a tuned random forest model with an 
                Adjusted R-Squared of 0.88 and a Root Mean Squared Error of ~ EU 4,000,000 on new data ')
        
      )
    
    
))


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$player_prediction <- renderValueBox({
    

    prediction <- predict(
      model, tibble("best_position" = input$s_position,
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
                        "total_goalkeeping" = input$s_totalgoalkeeping,
                        "height" = input$s_height))
  
    
    valueBox(
      value = paste0('€ ', scales::comma(as.numeric(prediction))),
      subtitle = paste0("Player's Market Value Estimation")
    )
    
    

  })



}

# Run the application 
shinyApp(ui = ui, server = server)
