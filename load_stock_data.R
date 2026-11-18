# Load required package
library(quantmod)

# Function to load stock data
load_stock_data <- function(file_name) {
  
  # Read stock symbols from portfolio.txt
  symbols <- readLines(file_name)
  
  # Create an empty list
  stock_list <- list()
  
  # Download stock data
  for(symbol in symbols) {
    
    cat("Downloading:", symbol, "\n")
    
    stock <- getSymbols(symbol,
                        src = "yahoo",
                        auto.assign = FALSE)
    
    stock_list[[symbol]] <- stock
  }
  
  return(stock_list)
}

# Load stocks from portfolio.txt
# (relative path - portfolio.txt should sit in the same folder as this
# script / your working directory, so this works regardless of whose
# machine the project is run on, e.g. after cloning the GitHub repo)
stocks <- load_stock_data("portfolio.txt")

# Display loaded data
print(stocks)
