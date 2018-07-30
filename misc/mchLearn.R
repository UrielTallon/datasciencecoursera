library(AppliedPredictiveModeling)
library(caret)
library(gbm)
library(rpart)
data(AlzheimerDisease)
adData <- data.frame(diagnosis, predictors)

set.seed(3433)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[inTrain, ]
testing <- adData[-inTrain, ]

set.seed(62433)
fit.rf <- train(diagnosis ~ ., method = "rf", data = training, prox = TRUE)
fit.gbm <- train(diagnosis ~ ., method = "gbm", data = training, verbose = FALSE)
fit.lda <- train(diagnosis ~ ., method = "lda", data = training)

pred.rf <- predict(fit.rf, testing)
pred.gbm <- predict(fit.gbm, testing)
pred.lda <- predict(fit.lda, testing)

predDF <- data.frame(pred.rf, pred.gbm, pred.lda, diagnosis = testing$diagnosis)

confusionMatrix(testing$diagnosis, pred.rf) #0.7683
confusionMatrix(testing$diagnosis, pred.gbm) #0.7927
confusionMatrix(testing$diagnosis, pred.lda) #0.7683

fit.combo <- train(diagnosis ~ ., method = "rf", data = predDF, prox = TRUE)
pred.combo <- predict(fit.combo, predDF)

confusionMatrix(testing$diagnosis, pred.combo) #0.8049

set.seed(3523)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(233)
x.lasso <- subset(training, select = -CompressiveStrength)
x.lasso <- as.matrix(x.lasso)
fit.enet <- enet(x.lasso, training$CompressiveStrength, lambda = 0)
plot.enet(fit.enet, xvar = "penalty", use.color = TRUE)

library(lubridate)
library(forecast)
dat <- read.csv("gaData.csv") #https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv
training <- dat[year(dat$date) < 2012,]
testing <- dat[(year(dat$date)) > 2011,]
tstrain <- ts(training$visitsTumblr)
fit.ts <- bats(tstrain)
pred.ts <- as.data.frame(forecast(fit.ts, h = 235))
same <- sum((testing$visitsTumblr >= pred.ts[, "Lo 95"]) & (testing$visitsTumblr <= pred.ts[, "Hi 95"]))
same / dim(testing)[1] #96%

library(e1071)
set.seed(3523)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(325)
fit.svm <- svm(CompressiveStrength ~ ., data = training)
pred.svm <- predict(fit.svm, testing)
sqrt(sum((testing$CompressiveStrength - pred.svm)^2)/dim(testing)[1]) # RMSE = 6.715

# Random Forest Optimization
library(AppliedPredictiveModeling)
library(caret)
library(randomForest)
library(dplyr)
data(AlzheimerDisease)
adData <- data.frame(diagnosis, predictors)

set.seed(3433)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[inTrain, ]
testing <- adData[-inTrain, ]

set.seed(62433)
fit.glob <- train(diagnosis ~ ., method = "rf", data = training, prox = TRUE)
pred.glob <- predict(fit.glob, testing)
confusionMatrix(testing$diagnosis, pred.glob) #0.7683

vimp <- as.data.frame(varImp(fit.glob)[1])
vimp <- tibble::rownames_to_column(vimp, var = "Features") %>% arrange(desc(Overall))

tst <- rfcv(subset(training, select = -diagnosis), training$diagnosis, scale = "log", step = 0.5)
tst$error.cv #32 variables yiels the lowest error

features_32 <- c("diagnosis", vimp[1:32, "Features"])
training.f32 <- subset(training, select = features_32)
fit.f32 <- train(diagnosis ~ ., method = "rf", data = training.f32, prox = TRUE)
pred.f32 <- predict(fit.f32, testing)
confusionMatrix(testing$diagnosis, pred.f32) #0.8293

features_16 <- c("diagnosis", vimp[1:16, "Features"])
training.f16 <- subset(training, select = features_16)
fit.f16 <- train(diagnosis ~ ., method = "rf", data = training.f16, prox = TRUE)
pred.f16 <- predict(fit.f16, testing)
confusionMatrix(testing$diagnosis, pred.f16) #0.8171

# Simple Optimization for decision trees
library(AppliedPredictiveModeling)
library(caret)
library(randomForest)
library(dplyr)
data(AlzheimerDisease)
adData <- data.frame(diagnosis, predictors)

set.seed(3433)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[inTrain, ]
testing <- adData[-inTrain, ]

set.seed(62433)
fit.tree <- train(diagnosis ~ ., method = "rpart", data = training)
pred.tree <- predict(fit.tree, testing)
confusionMatrix(testing$diagnosis, pred.tree) #0.7073

# Simple K-fold cross-validation
ctrl.rand <- trainControl(method = "LOOCV", search = "random")
fit.rand <- train(diagnosis ~ ., method = "rpart", data = training, trControl = ctrl.rand, tuneLength = 5)
pred.rand <- predict(fit.rand, testing)
confusionMatrix(testing$diagnosis, pred.rand) #0.7073

ctrl.grid <- trainControl(method = "cv", number = 6, search = "grid")
Grid <- expand.grid(cp = seq(0, 0.05, 0.005))
fit.grid <- train(diagnosis ~ ., method = "rpart", data = training, trControl = ctrl.grid, tuneGrid = Grid)
pred.grid <- predict(fit.grid, testing)
confusionMatrix(testing$diagnosis, pred.grid) #0.7195

library(UsingR)
library(rpart)
library(caret)
library(rattle)
library(rpart.plot)

data(Cushings)
set.seed(800)
idx <- createDataPartition(y = Cushings$Type, p = 0.8, list = FALSE)
training <- Cushings[idx,]
testing <- Cushings[-idx,]
fit <- train(Type ~ ., method = "rpart", data = training)
fit2 <- train(Type ~., method = "lda", data = training)
pred <- predict(fit, testing)
pred2 <- predict(fit2, testing)
confusionMatrix(testing$Type, pred)
confusionMatrix(testing$Type, pred2)
