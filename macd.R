# =============================================================================
# BDA400 - Assignment 5: Technical Analysis using R
# File: macd.R
# Function: macd() - Moving Average Convergence Divergence
# =============================================================================
#
# MACD Line   = EMA_short - EMA_long
# Signal Line = EMA of the MACD Line
# Histogram   = MACD Line - Signal Line
#
# This function depends on ema(), defined in ema.R. When running this file on
# its own, make sure ema.R is sourced first (see source() call below).

# Bring in the ema() function this file depends on
if (!exists("ema")) {
  source("ema.R")
}

macd <- function(data, short_period, long_period, signal_period) {
  # Calculate the short-term and long-term exponential moving averages (EMA)
  short_ema <- ema(data, short_period)
  long_ema <- ema(data, long_period)

  # Calculate the MACD line
  macd_line <- short_ema - long_ema

  # Calculate the signal line (EMA of the MACD line)
  signal_line <- ema(macd_line, signal_period)

  # Calculate the histogram (the difference between the MACD line and the signal line)
  histogram <- macd_line - signal_line

  # Return the MACD line, signal line, and histogram as a list
  result <- list(
    macd_line = macd_line,
    signal_line = signal_line,
    histogram = histogram
  )

  return(result)
}

# -----------------------------------------------------------------------------
# Example usage / manual test
# -----------------------------------------------------------------------------
# data <- c(100, 105, 110, 115, 120, 125, 130)
# macd_result <- macd(data, short_period = 3, long_period = 5, signal_period = 2)
# print(macd_result)
