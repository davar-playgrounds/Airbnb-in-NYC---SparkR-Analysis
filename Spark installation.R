system("sudo apt install openjdk-8-jdk")
install.packages("sparklyr")

library(sparklyr)
spark_install(version = "2.2")

# Install packages H2O depends on
pkgs = c("methods", "statmod", "stats", "graphics", "RCurl", "jsonlite", "tools", "utils")
for (pkg in pkgs) {
  install.packages(pkgs)
}

install.packages("h2o", "3.28.0.3")

install.packages("rsparkling", type = "source", repos = "http://h2o-release.s3.amazonaws.com/sparkling-water/spark-2.2/3.28.0.3-1-2.2/R")

library(sparklyr)
library(rsparkling)
sc = spark_connect(master = "local", version = "2.2.1")
hc = H2OContext.getOrCreate(sc)
hc$openFlow()

library(dplyr)
mtcars_tbl <- copy_to(sc, mtcars, overwrite = TRUE)

mtcars_hf <- hc$asH2OFrame(mtcars_tbl)

library(h2o)

y <- "mpg"
x <- setdiff(names(mtcars_hf), y)

splits <- h2o.splitFrame(mtcars_hf, ratios = 0.7, seed = 1)

fit <- h2o.gbm(x = x,
               y = y,
               training_frame = splits[[1]],
               min_rows = 1,
               seed = 1)
print(fit)



