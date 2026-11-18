# =============================================================================
# BDA400 - Assignment 5: Technical Analysis using R
# File: build_stock_dataframes.R
# Purpose: Step 1 of Assignment 5 - "build data frames for each stock symbol,
#          containing information such as date, open, high, low, close, and
#          volume." This takes the output of load_stock_data.R (a list of
#          quantmod xts objects, one per symbol) and converts each into a
#          plain data frame that our indicator functions (sma, ema, etc.) can
#          work with directly.
# =============================================================================

library(quantmod)

# Load the stock_list using your existing Assignment 1 script.
# This pulls live data from Yahoo Finance via quantmod::getSymbols(), so it
# requires an internet connection and a valid portfolio.txt path.
source("load_stock_data.R")
# NOTE: load_stock_data.R already runs load_stock_data() and creates the
# 'stocks' variable when sourced (see its last lines). If you've renamed
# that variable, adjust the line below to match.

# -----------------------------------------------------------------------------
# Convert each xts object in stocks into a plain, standardized data frame
# -----------------------------------------------------------------------------
# quantmod stores each stock's OHLCV data as columns named like
# "AAPL.Open", "AAPL.High", etc. This function strips the symbol prefix and
# returns a clean data frame with consistent column names: Date, Open, High,
# Low, Close, Volume.

xts_to_dataframe <- function(stock_xts, symbol) {
  df <- data.frame(
    Date   = as.Date(index(stock_xts)),
    Open   = as.numeric(stock_xts[, paste0(symbol, ".Open")]),
    High   = as.numeric(stock_xts[, paste0(symbol, ".High")]),
    Low    = as.numeric(stock_xts[, paste0(symbol, ".Low")]),
    Close  = as.numeric(stock_xts[, paste0(symbol, ".Close")]),
    Volume = as.numeric(stock_xts[, paste0(symbol, ".Volume")])
  )
  return(df)
}

# Build a named list of clean data frames, one per stock symbol
stock_dataframes <- list()
for (symbol in names(stocks)) {
  stock_dataframes[[symbol]] <- xts_to_dataframe(stocks[[symbol]], symbol)
}

# -----------------------------------------------------------------------------
# Quick check: preview the first data frame
# -----------------------------------------------------------------------------
first_symbol <- names(stock_dataframes)[1]
cat("Preview of", first_symbol, "data frame:\n")
print(head(stock_dataframes[[first_symbol]]))
cat("\nRows loaded for", first_symbol, ":", nrow(stock_dataframes[[first_symbol]]), "\n")

# -----------------------------------------------------------------------------
# Optional: save each data frame to CSV so it can be reused without
# re-downloading from Yahoo Finance every time
# -----------------------------------------------------------------------------
for (symbol in names(stock_dataframes)) {
  write.csv(stock_dataframes[[symbol]],
            paste0("stock_data_", symbol, ".csv"),
            row.names = FALSE)
}
cat("\nSaved one CSV per symbol (stock_data_<SYMBOL>.csv) for reuse.\n")
