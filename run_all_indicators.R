# =============================================================================
# BDA400 - Assignment 5: Technical Analysis using R
# File: run_all_indicators.R
# Purpose: Source every indicator script, build a data frame from the stock
#          dataset, and run/test each function so results can be verified
#          before submission.
# =============================================================================

# -----------------------------------------------------------------------------
# STEP 1: Load the dataset
# -----------------------------------------------------------------------------
# NOTE: Update paths (or use Session > Set Working Directory > To Source File
# Location in RStudio) so R can find the indicator scripts and your data.
#
# Two ways to get stock_data here - pick ONE:
#
# OPTION A (real data, requires internet + portfolio.txt):
#   source("build_stock_dataframes.R")
#   stock_data <- stock_dataframes[[names(stock_dataframes)[1]]]  # first symbol
#
# OPTION B (offline / synthetic fallback used for initial testing):
   stock_data <- read.csv("stock_data_AAPL.csv", stringsAsFactors = FALSE)
   stock_data$Date <- as.Date(stock_data$Date)

glimpse_data <- head(stock_data, 5)
print(glimpse_data)
cat("Total rows loaded:", nrow(stock_data), "\n\n")

# -----------------------------------------------------------------------------
# STEP 2: Source all indicator function files
# -----------------------------------------------------------------------------
source("sma.R")
source("ema.R")
source("macd.R")
source("stdev.R")
source("linreg.R")
source("rsi.R")
source("stoch_rsi.R")
source("crossover.R")
source("crossunder.R")

# -----------------------------------------------------------------------------
# STEP 3: Run and test each indicator against the Close price series
# -----------------------------------------------------------------------------
close_prices <- stock_data$Close

cat("===== SMA (period = 10) =====\n")
sma_result <- sma(close_prices, period = 10)
print(head(sma_result, 10))

cat("\n===== EMA (period = 10) =====\n")
ema_result <- ema(close_prices, period = 10)
print(head(ema_result, 10))

cat("\n===== MACD (short=12, long=26, signal=9) =====\n")
macd_result <- macd(close_prices, short_period = 12, long_period = 26, signal_period = 9)
print(head(macd_result$macd_line, 10))
print(head(macd_result$signal_line, 10))
print(head(macd_result$histogram, 10))

cat("\n===== Standard Deviation (full Close series) =====\n")
stdev_result <- stdev(close_prices)
print(stdev_result)

cat("\n===== Linear Regression (last 20 days, offset = 0) =====\n")
linreg_result <- linreg(close_prices, regressionLength = 20, regressionOffset = 0)
cat("Slope:", linreg_result$slope, "\n")
cat("Intercept:", linreg_result$intercept, "\n")
print(head(linreg_result$predicted_values, 10))

cat("\n===== RSI (period = 14) =====\n")
rsi_result <- rsi(close_prices, period = 14)
print(head(rsi_result[!is.na(rsi_result)], 10))

cat("\n===== Stochastic RSI (period=14, k=3, d=3) =====\n")
stoch_rsi_result <- stoch_rsi(close_prices, period = 14, k_period = 3, d_period = 3)
print(head(stoch_rsi_result$k_line, 10))
print(head(stoch_rsi_result$d_line, 10))

cat("\n===== Crossover: SMA(10) vs SMA(30) =====\n")
sma10 <- sma(close_prices, period = 10)
sma30 <- sma(close_prices, period = 30)
# Trim sma10 so both series are the same length before comparing
sma10_trimmed <- tail(sma10, length(sma30))
crossover_signals <- crossover(sma10_trimmed, sma30)
print(table(crossover_signals))

cat("\n===== Crossunder: SMA(10) vs SMA(30) =====\n")
crossunder_signals <- crossunder(sma10_trimmed, sma30)
print(table(crossunder_signals))

cat("\nAll indicators ran successfully.\n")
