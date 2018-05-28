
library(tidyverse)
improved <- readr::read_csv(file = "../haachicanoy/Repositories/CSmaster/_thesis/_occ_data_genesys/_improved/geo.csv")
landrace <- readr::read_csv(file = "../haachicanoy/Repositories/CSmaster/_thesis/_occ_data_genesys/_landraces/geo.csv")
improved$type <- "Improved material"
landrace$type <- "Landrace"
db <- rbind(improved, landrace); rm(improved, landrace)
db %>% arrange(desc(type)) %>% ggplot(aes(x = longitude, y = latitude, colour = type)) + geom_point(alpha = 0.1)
