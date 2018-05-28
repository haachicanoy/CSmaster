
## R options
g <- gc(reset = T); rm(list = ls()); options(warn = -1); options(scipen = 999)

## Load packages
library(pacman)
pacman::p_load(rsample, randomForest, ranger, caret, h2o)

set.seed(123)
ames_split <- initial_split(AmesHousing::make_ames(), prop = .7)
ames_train <- training(ames_split)
ames_test  <- testing(ames_split)

# for reproduciblity
set.seed(123)

# default RF model
m1 <- randomForest(
  formula = Sale_Price ~ .,
  data    = ames_train
)

m1

# number of trees with lowest MSE
which.min(m1$mse)

# RMSE of this optimal random forest
sqrt(m1$mse[which.min(m1$mse)])

# create training and validation data 
set.seed(123)
valid_split <- initial_split(ames_train, .8)

# training data
ames_train_v2 <- analysis(valid_split)

# validation data
ames_valid <- assessment(valid_split)
x_test <- ames_valid[setdiff(names(ames_valid), "Sale_Price")]
y_test <- ames_valid$Sale_Price

rf_oob_comp <- randomForest(
  formula = Sale_Price ~ .,
  data    = ames_train_v2,
  xtest   = x_test,
  ytest   = y_test
)

# extract OOB & validation errors
oob <- sqrt(rf_oob_comp$mse)
validation <- sqrt(rf_oob_comp$test$mse)

# compare error rates
tibble::tibble(
  `Out of Bag Error` = oob,
  `Test error` = validation,
  ntrees = 1:rf_oob_comp$ntree
) %>%
  gather(Metric, RMSE, -ntrees) %>%
  ggplot(aes(ntrees, RMSE, color = Metric)) +
  geom_line() +
  scale_y_continuous(labels = scales::dollar) +
  xlab("Number of trees")

# names of features
features <- setdiff(names(ames_train), "Sale_Price")

set.seed(123)

m2 <- tuneRF(
  x          = ames_train[features],
  y          = ames_train$Sale_Price,
  ntreeTry   = 500,
  mtryStart  = 5,
  stepFactor = 1.5,
  improve    = 0.01,
  trace      = FALSE      # to not show real-time progress 
)

# randomForest speed
system.time(
  ames_randomForest <- randomForest(
    formula = Sale_Price ~ ., 
    data    = ames_train, 
    ntree   = 500,
    mtry    = floor(length(features) / 3)
  )
)

# ranger speed
system.time(
  ames_ranger <- ranger(
    formula   = Sale_Price ~ ., 
    data      = ames_train, 
    num.trees = 500,
    mtry      = floor(length(features) / 3)
  )
)

hyper_grid <- expand.grid(
  mtry       = seq(20, 30, by = 2),
  node_size  = seq(3, 9, by = 2),
  sampe_size = c(.55, .632, .70, .80),
  OOB_RMSE   = 0
)

# total number of combinations
nrow(hyper_grid)

for(i in 1:nrow(hyper_grid)) {
  
  # train model
  model <- ranger(
    formula         = Sale_Price ~ ., 
    data            = ames_train, 
    num.trees       = 500,
    mtry            = hyper_grid$mtry[i],
    min.node.size   = hyper_grid$node_size[i],
    sample.fraction = hyper_grid$sampe_size[i],
    seed            = 123
  )
  
  # add OOB error to grid
  hyper_grid$OOB_RMSE[i] <- sqrt(model$prediction.error)
}

hyper_grid %>% 
  dplyr::arrange(OOB_RMSE) %>%
  head(10)
