# Sourcing the data cleaning script
source("Wrangling_and_Cleaning/Data Cleaning Script.R")

source("simple_models.R")

if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")


# Loading necessary libraries to run the app
library(shinydashboard)
library(shiny)
library(tidymodels)
library(tidyverse)


# Bringing data into the Shiny App
Conmebol_model<- Conmebol %>% 
  select(-id, -name, -position) 

# Importing the random forest model to the app
model <- readRDS('final_rf_model.rds')


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
        icon = icon('folder-open'))
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
              
              h2("Market Value Visualizations"),
              
              fluidRow(box(selectInput("v_nationality", "Nationality", 
                                       choices = Conmebol %>% select(nationality) %>% 
                                         distinct() %>% 
                                         arrange(nationality) %>% 
                                         drop_na(),
                                       selected = 'Argentina',
                                       multiple = TRUE)),
              
              
              box(selectInput("v_position", "Position", 
                                       choices = Conmebol %>% select(position) %>% 
                                         distinct() %>% 
                                         arrange(position) %>% 
                                         drop_na(),
                                       selected = 'ATT',
                                       multiple = TRUE))),
              
              
              fluidRow(box(plotOutput("best_position_value")),box(plotOutput("position_nationality_value"))),
              fluidRow(box(plotOutput("average_value")),box(plotOutput("max_value"))),
              
      ),
      tabItem(tabName = 'about',
              h2("About this project"),
              
              'This Shinyapp was developed by Nicolas Kaswalder and Luis Noguera.
                The model included in the Statistical Model tab is a tuned random forest model with an 
                Adjusted R-Squared of 0.88 and a Root Mean Squared Error of ~ EU 4,000,000 on the validation set.',
              
              
              "Data has been scraped from the SoFiFa website and modeled using Tidymodels. To access the remote repository visit: https://github.com/lnoguera17/Conmebol-Analytics")
      
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
  
  
  
  output$best_position_value <- renderPlot( { 
    
    Conmebol %>% 
      drop_na() %>% 
      filter(nationality == input$v_nationality, position == input$v_position) %>% 
      mutate(best_position = fct_reorder(best_position, value)) %>% 
      ggplot(aes(best_position, value, fill = position)) +
      ggtitle("Value by Best Position") +
      geom_boxplot() +
      scale_y_continuous(labels = scales::dollar) +
      theme_minimal()+
      theme(legend.background = element_rect(fill="gray90", size=.5, linetype="dotted",))+
      theme(legend.justification=c(0,0.5))+
      theme(
        plot.title = element_text(color="black", size=14, face="bold"),
        axis.title.x = element_text(color="dark red", size=12, face="bold"),
        axis.title.y = element_text(color="dark red", size=12, face="bold"))+
      labs(x = 'Best Position', y = 'Value') +
      coord_flip()+
      scale_fill_discrete(name="Position")
    
  })
  
  output$position_nationality_value <- renderPlot({
    
    Conmebol %>% 
      drop_na() %>% 
      filter(nationality == input$v_nationality) %>% 
      mutate(nationality = fct_reorder(nationality, -value)) %>% 
      ggplot(aes(nationality, value, fill = position)) +
      ggtitle("Value per Position & Nationality") +
      geom_boxplot() +
      scale_y_continuous(labels = scales::dollar) +
      theme_minimal()+
      theme(legend.background = element_rect(fill="gray90", size=.5, linetype="dotted"))+
      theme(legend.justification=c(1,0), legend.position=c(1,0.6))+
      theme(
        plot.title = element_text(color="black", size=14, face="bold"),
        axis.title.x = element_text(color="dark red", size=12, face="bold"),
        axis.title.y = element_text(color="dark red", size=12, face="bold"))+
      labs(x = 'Nationality', y = 'Value') +
      scale_fill_discrete(name="Position")
  })
  
  output$average_value <- renderPlot({
    
    Conmebol %>% 
      drop_na() %>% 
      filter(nationality == input$v_nationality, position == input$v_position) %>%
      group_by(best_position) %>% 
      summarise(value=mean(value)) %>% 
      drop_na() %>% 
      mutate(best_position = fct_reorder(best_position, -value)) %>% 
      ggplot(aes(x= best_position, y = value, color = best_position))+
      geom_point(size = 5)+
      geom_segment(aes(x=best_position, xend = best_position, y = value, yend = 0))+
      theme_minimal()+
      ggtitle("Average Value Per Position") +
      theme(legend.position = "none")+
      theme(
        plot.title = element_text(color="black", size=14, face="bold"),
        axis.title.x = element_text(color="dark blue", size=12, face="bold"),
        axis.title.y = element_text(color="dark blue", size=12, face="bold"))+
      labs(x = 'Best Position', y = 'Value') +
      scale_y_continuous(n.breaks = 10,labels = scales::dollar)+
      scale_fill_discrete(name="Best Position")
  })
  
  output$max_value <- renderPlot({
    Conmebol %>% 
      drop_na() %>% 
      filter(nationality == input$v_nationality, position == input$v_position)%>%
      group_by(best_position) %>% 
      summarise(value=max(value)) %>% 
      drop_na() %>% 
      mutate(best_position = fct_reorder(best_position, -value)) %>% 
      ggplot(aes(x= best_position, y = value, color = best_position))+
      geom_point(size = 5)+
      geom_segment(aes(x=best_position, xend = best_position, y = value, yend = 0))+
      theme_minimal()+
      ggtitle("Max Value Per Position") +
      theme(legend.position = "none")+
      theme(
        plot.title = element_text(color="black", size=14, face="bold"),
        axis.title.x = element_text(color="dark blue", size=12, face="bold"),
        axis.title.y = element_text(color="dark blue", size=12, face="bold"))+
      labs(x = 'Best Position', y = 'Value') +
      scale_y_continuous(labels = scales::dollar)+
      scale_fill_discrete(name="Best Position")
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)