library(e1071)
library(shiny)
library(miniUI)
library(ggplot2)
library(WDI)
library(plyr)
library(googleVis)
library(caret)
library(ROCR)
library(xgboost)
library(plotly)
library(shinycssloaders)
library(randomForest)#wired.need to load individual ML packages for deploying on shinyapp.io
library(e1071)
library(nnet)
library(xgboost)

#options(shiny.port = 7775)
#options(shiny.host = "192.168.178.29")
#https://shiny.rstudio.com/tutorial/lesson5/
#The server.R script is run once, when you launch your app
#The unnamed function inside shinyServer is run once each time a user visits your app
#The R expressions inside render* functions are run many times. Shiny runs them once each time a user changes a widget.



shinyServer(function(input,output){
 
  
  output$plot1 <- renderPlotly({
    newDT <- data.frame(buying_price=as.factor(input$buying_price),maintenance_cost=as.factor(input$maintenance_cost),
                        doors=as.factor(input$doors),passenger_capacity=as.factor(input$passenger_capacity),
                        luggage_capacity=as.factor(input$luggage_capacity),safety=as.factor(input$safety))
    Pred <- data.frame(Algorithm=character(),Acceptance=character())
    if(input$SVM){
      SVMPred <- predict(SVMmodel,newdata=newDT)
      Pred <- rbind(Pred,data.frame(Algorithm="SVM", Acceptance=SVMPred))
    }
    if(input$RF){
      RFPred <- predict(RFmodel,newdata=newDT)
      Pred <- rbind(Pred,data.frame(Algorithm="RF", Acceptance=RFPred))
    }
    if(input$XGBoost){
      XGBoostPred <- predict(xgbmodel,newdata=newDT)
      Pred <- rbind(Pred,data.frame(Algorithm="XGBoost", Acceptance=XGBoostPred))
    }
    if(input$ANN){
      ANNPred <- predict(ANNmodel,newdata=newDT)
      Pred <- rbind(Pred,data.frame(Algorithm="ANN", Acceptance=ANNPred))
    }
    
    
    AlgAll <- c("SVM","RF","XGBoost","ANN")
    Alg <- AlgAll[c(input$SVM,input$RF,input$XGBoost,input$ANN)]
    if(length(Alg)>0){
      Pred$Acceptance <- factor(Pred$Acceptance,levels = c("unacc","acc","good","vgood"))
      g <- ggplot(Pred, aes(Algorithm,Acceptance,fill=Algorithm))+geom_bar(stat = "identity",width=0.5)+theme_bw()+ylab("Acceptance")+ylim(c("unacc","acc","good","vgood"))
      ggplotly(g,width = 600, height = 260)
    }
  })
  
  output$plot2 <- renderPlotly({
    AlgAll <- c("SVM","RF","XGBoost","ANN")
    Alg <- AlgAll[c(input$SVM,input$RF,input$XGBoost,input$ANN)]
    if(length(Alg)>0){
      AccuracyRender <- subset(Accuracy,Algorithm %in% Alg)
      g <- ggplot(AccuracyRender,aes(Algorithm, Accuracy,color=Algorithm))+geom_point()+geom_errorbar(aes(ymin = AccuracyLower, ymax = AccuracyUpper,width=0.5))+theme_bw()+ylab("Accuracy (%)")
      ggplotly(g,width = 600, height = 260)
    }
  })
  
  output$plot3 <- renderPlotly({
    AlgAll <- c("SVM","RF","XGBoost","ANN")
    Alg <- AlgAll[c(input$SVM,input$RF,input$XGBoost,input$ANN)]
    if(length(Alg)>0){
      SNSRender <- subset(SNS,Algorithm %in% Alg)
      g <- ggplot(SNSRender,aes(Class, Sensitivity,fill=Algorithm))+geom_bar(stat = "identity",position=position_dodge(),width=0.5)+theme_bw()+ylab("Sensitivity (%)")+xlab("Acceptance")
      ggplotly(g,width = 600, height = 260)
    }
  })
  
  output$plot4 <- renderPlotly({
    AlgAll <- c("SVM","RF","XGBoost","ANN")
    Alg <- AlgAll[c(input$SVM,input$RF,input$XGBoost,input$ANN)]
    if(length(Alg)>0){
      SNSRender <- subset(SNS,Algorithm %in% Alg)
      g <- ggplot(SNSRender,aes(Class, Specificity,fill=Algorithm))+geom_bar(stat = "identity",position=position_dodge(),width=0.5)+theme_bw()+ylab("Specificity (%)")+xlab("Acceptance")
      ggplotly(g,width = 600, height = 260)
    }
  })

  output$plot5 <- renderPlotly({
    AlgAll <- c("SVM","RF","XGBoost","ANN")
    Alg <- AlgAll[c(input$SVM,input$RF,input$XGBoost,input$ANN)]
    if(length(Alg)>0){
      TimeRender <- subset(Time,Algorithm %in% Alg)
      g <- ggplot(TimeRender,aes(Algorithm,get('Training Time'),fill=Algorithm))+geom_bar(stat = "identity",position=position_dodge(),width=0.5)+theme_bw()+ylab("Time (s)")+xlab("Algorithm")
      ggplotly(g,width = 600, height = 260)
    }
  })

})

