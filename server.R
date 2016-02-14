# Johnny Edwards, February 2016
require(googleVis)
require(shiny)
require(plyr)
require(dplyr)
require(ggplot2)

library(plyr,       verbose=FALSE, warn.conflicts=FALSE)
library(dplyr,      verbose=FALSE, warn.conflicts=FALSE)
library(ggplot2,    verbose=FALSE, warn.conflicts=FALSE)


mysum=read.csv("data/weather.csv")

mysum.allyears =ddply(mysum,.(state,type), numcolwise(sum))
mysum.alltypes =ddply(mysum,.(year,state), numcolwise(sum))
mysum.allall   =ddply(mysum,.(state), numcolwise(sum))



    
shinyServer(function(input, output) {
    myYear <- reactive({
        input$Year
    })
    myType <- reactive({
        input$type
    })
    myVar <- reactive({
        input$var
    })

    
    myBarColor <- reactive({
        mybarcolor <- switch(input$var, 
                          "fatalities"  = "red",
                          "injuries"    = "orange",
                          "prop.damage" = "blue",
                          "crop.damage" = "green")
        mybarcolor
    })
    
    myColor <- reactive({
        mycolor <- switch(input$var, 
                          "fatalities"  = "{colors:['white', 'red']}",
                          "injuries"    = "{colors:['white', 'orange']}",
                          "prop.damage" = "{colors:['white', 'blue']}",
                          "crop.damage" = "{colors:['white', 'green']}")
        mycolor
    })

    output$maptitle1 <- renderText({
        paste("Total ", myVar(), " in 1996 thru 2011.")
    })

    output$maptitle2 <- renderText({
        if (myType()=="<ALL>") {
            "Summed over all weather types."
        } else {
            paste("Weather type: ", myType())
        }        
    })
    
    
    output$ggtotals <- renderPlot({
                
        c<-ggplot(data=mysum.allyears, aes_string(y=myVar(), x="type"))
        c<-c+geom_bar( fill=myBarColor(), stat="identity")
        c<-c+ coord_flip()
        c<-c  + xlab("Weather event")+ ylab(paste(myVar()," 1996-2011"))
        c<-c  + ggtitle(paste(myVar(), " due to severe weather"))
        print(c)
    })
    
    output$gvis <- renderGvis({

        if (myType()=="<ALL>") {
            myData <- mysum.allall
        } else {
            myData <- subset(mysum.allyears, type == myType())
        }        
        

        gvis<- gvisGeoChart(myData,
                            locationvar="state", colorvar=myVar(),
                            options=list(region="US", displayMode="regions", 
                                         resolution="provinces",
                                         width=500, 
                      colorAxis=myColor(),
                      title="My title"
                            ))     
        
        gvis 
    })


    
})
