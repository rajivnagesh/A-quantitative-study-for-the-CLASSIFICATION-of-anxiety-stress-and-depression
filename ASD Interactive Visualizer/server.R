#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(cluster)
library(ggplot2)
set.seed(5)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    set.seed(5)
    dataMain = read.csv('sdm_data_clean.csv')
    dataNoCountry = subset(dataMain, select = -c(country))
    data = subset(dataMain, select = c(Q5,Q7,Q11,Q12,Q13,Q21,Q22,Q28,Q36,Q40))
    #data = as.data.frame(scale(data))
    #c = kmeans(x = data, centers = 4)
    srt = sort(sample(nrow(data),nrow(data)*0.005))
    #x = kmeans(data, 4)
    
    average = reactive(
        {
            mean(c(input$sliderQ1,input$sliderQ2,input$sliderQ3,input$sliderQ4,input$sliderQ5,input$sliderQ6,input$sliderQ7,input$sliderQ8,input$sliderQ9,input$sliderQ10))
        }
    )
    
    usersInput = reactive({
        c(input$sliderQ1,input$sliderQ2,input$sliderQ3,input$sliderQ4,input$sliderQ5,input$sliderQ6,input$sliderQ7,input$sliderQ8,input$sliderQ9,input$sliderQ10)
    })
    
    userCluster = reactive({
        set.seed(5)
        tempData = data
        tempData[nrow(data)+1,] = usersInput()
        kmeans(x = tempData,centers = 4, iter.max = 500, nstart = 10)
    })
    
    imgName = reactive({
        #Cut-offs for a were determined through kmeans and aggregate functions
        a = average()
        if(a < 1.43){
            'Really_Happy_Face.png'
        }
        else if(a < 2.01){
            'Happy_Face.png'
        }
        else if(a < 2.73){
            'Sad_Face.png'
        }
        else{
            'Really_Sad_Face.png'
        }
    })
    
    imgDescription = reactive({
        #Cut-offs for a were determined through kmeans and aggregate functions
        a = average()
        if(a < 1.43){
            'You seem to be in a good place mentally.'
        }
        else if(a < 2.01){
            'You are doing well, but should talk to a friend about anything on your mind.'
        }
        else if(a < 2.73){
            'There are things you are struggling with,
          and that is ok. Just make sure to tell someone about it.'
        }
        else{
            'You may be in the need of more professional counselling,
          and that is perfectly fine.
          Reach out to a certified therapist in order to find the next best step.'
        }
    })
    
    output$avgASD = renderText({average()})
    output$diagnosis = renderText({imgDescription()})

    #output$plot1 = renderPlot({
    #    clusplot(x = data[srt,],
    #             clus = c$cluster[srt],
    #             lines = 0,
    #             shade = TRUE,
    #             color = TRUE,
    #             plotchar = FALSE,
    #             span = TRUE,
    #             labels = 4,
    #             xlab = "",
    #             ylab = "",
    #             main = "ASD Clusters")
    #})
    
    output$plot1 = renderPlot({
        set.seed(5)
        tempData = data
        tempData[nrow(data)+1,] = usersInput()
        clusplot(x = tempData[srt,],
                 clus = userCluster()$cluster[srt],
                 lines = 0,
                 shade = TRUE,
                 color = TRUE,
                 plotchar = FALSE,
                 span = TRUE,
                 labels = 4,
                 xlab = "",
                 ylab = "",
                 main = "ASD Clusters",
                 sub = ''
                 )
    })
    
    output$plot2 = renderPlot({
        set.seed(5)
        agg = aggregate(dataNoCountry, by = list(cluster = head(userCluster()$cluster, -1)), mean)
        #print(typeof(agg))
        agg_df = as.data.frame(agg)
        #print(agg_df)
        #barplot(agg$ASD_Score, xlab = 'Clusters', ylab = 'ASD Score')
        #print(agg_df$ASD_Score)
        ggplot(agg_df, aes(x = cluster, y = ASD_Score, fill=cluster)) +
          geom_bar(stat="identity")+
          geom_text(aes(label= round(ASD_Score, 3)), vjust=-0.3, size=5)+
          theme(legend.position="bottom")
    })
    
    output$img1 = renderImage({
        list(src = normalizePath(file.path('./www',imgName())),
             contentType = 'image/png',
             alt = "This is alternate text")
    }, deleteFile = FALSE)
    
})
