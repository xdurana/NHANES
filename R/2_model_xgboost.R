library(xgboost)
library(caret)
library(pROC)

outcome <- c('is_diabetic')
predictors <- names(diabetes)[!names(diabetes) %in% outcome]

mx.diabetes <- as.matrix(diabetes, rownames.force = NA)

train_dmatrix <- xgb.DMatrix(data = mx.diabetes[, predictors], label = mx.diabetes[, outcome] )

fit.xgb <- xgboost(
  data = train_dmatrix,
  nrounds = 10,
  objective = "binary:logistic"
)

xgb.dump(fit.xgb)

predictions <- predict(fit.xgb, as.matrix(diabetes[, predictors]))

mean(as.numeric(predictions > 0.5) != diabetes[, outcome])

confusionMatrix(
  as.numeric(predictions > 0.1),
  diabetes[, outcome],
  mode = "everything"
)

plot.roc(
  as.numeric(predictions > 0.5),
  diabetes[, outcome],
  main = "Confidence intervals",
  percent = TRUE,
  ci = TRUE,
  print.auc=TRUE
)

# feature importance

importance_matrix <- xgb.importance(feature_names = predictors, model = fit.xgb)
xgb.plot.importance(importance_matrix[1:10,])
head(importance_matrix)
