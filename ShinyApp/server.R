library(shiny)
library(ggplot2)
library(randomForest)
library(rpart)
library(e1071)
library(caret)
library(lattice)
library(plotly)


wines <- read.csv("data/winewithnames.csv", stringsAsFactors = FALSE)

shinyServer(
  function(input, output) {
    output$xvarSelect <- renderUI({
      lbs <- colnames(wines)
      lbs <- lbs[!lbs %in% c("cultivar")]
      selectInput("xvar", "Select X variable", lbs)
    })
    output$yvarSelect <- renderUI({
      lbs <- colnames(wines)
      lbs <- lbs[!lbs %in% c("cultivar")]
      selectInput("yvar", "Select Y variable", lbs)
    })
    dat <- eventReactive(input$draw, {
      set.seed(input$seed)
      v <- wines[, c(input$xvar, input$yvar, "cultivar")]
      inTrain <- createDataPartition(y = v$cultivar, p = 0.7, list = FALSE)
      training <- v[inTrain, ]
      testing <- v[-inTrain, ]
      km <- kmeans(subset(training, select = -c(cultivar)), centers = 3)
      training$clusters <- as.factor(km$cluster)
      fit <- train(clusters ~ .,
                   data = subset(training, select = -c(cultivar),
                   method = "rpart"))
      testing$pred <- predict(fit, testing)
      testing$res <- as.factor(ifelse(testing$cultivar == testing$pred, 1, 0))
      acc <- unname(confusionMatrix(testing$cultivar, testing$pred)$overall[1])
      list("df" = testing, "accuracy" = round(acc, 2))
    })
    
    output$thePlot <- renderPlotly({
      p <- ggplot(dat()$df, aes_string(x = colnames(dat()$df)[1],
                                       y = colnames(dat()$df)[2],
                                       color = colnames(dat()$df[5]))) +
                  geom_point() +
                  theme_bw() +
                  theme(panel.border = element_blank(),
                        panel.background = element_blank()) +
                  scale_colour_discrete(name = "Class", labels = c("false", "true")) +
                  ggtitle("Classification Results")
      ggplotly(p)
    })
    
    output$acc <- renderText(paste(dat()$accuracy))
  }
)