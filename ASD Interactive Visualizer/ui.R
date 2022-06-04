#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("ASD Calculation Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h5("Please input how much you agree with the statement, 1 being not at all and 4 being completely agree:"),
            sliderInput("sliderQ1", "I just couldn't seem to get going.", 1, 4, value = 1),
            sliderInput("sliderQ2", "I had a feeling of shakiness (eg, legs going to give way).", 1, 4, value = 1),
            sliderInput("sliderQ3", "I felt that I was using a lot of nervous energy.", 1, 4, value = 1),
            sliderInput("sliderQ4", "I felt sad and depressed.", 1, 4, value = 1),
            sliderInput("sliderQ5", "I found myself getting upset rather easily.", 1, 4, value = 1),
            sliderInput("sliderQ6", "I felt that life wasn't worthwhile.", 1, 4, value = 1),
            sliderInput("sliderQ7", "I found it hard to wind down.", 1, 4, value = 1),
            sliderInput("sliderQ8", "I felt I was close to panic.", 1, 4, value = 1),
            sliderInput("sliderQ9", "I felt terrified.", 1, 4, value = 1),
            sliderInput("sliderQ10", "I was worried about situations in which I might panic and make a fool of myself.", 1, 4, value = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h5("These four clusters represent an individuals mental state:"),
            #textOutput("avgASD"),
            plotOutput("plot1"),
            h5("These are the average ASD Scores for each cluster:"),
            plotOutput("plot2"),
            #img(src='Really_Happy_Face.png', height = 72, width = 72)
            h3("Observation:"),
            column(width = 6, imageOutput("img1", 72, 72, inline = TRUE)),
            column(width = 6, h3(textOutput("diagnosis")), align = 'left'),
            #imageOutput("img1", 72, 72, inline = TRUE),
            #fluidRow(h3(textOutput("diagnosis")), align = 'right')
            #fluidRow(textInput("text", "Enter your text here"), align = 'right')
        )
    )
))
