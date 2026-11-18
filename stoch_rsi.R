# =============================================================================
# BDA400 - Assignment 5: Technical Analysis using R
# File: stoch_rsi.R
# Function: stoch_rsi() - Stochastic RSI
# =============================================================================
#
# StochRSI = (RSI - RSI_lowest) / (RSI_highest - RSI_lowest)
# %K = StochRSI values
# %D = k_period-day SMA of %K, further smoothed by a d_period-day SMA
#
# This function depends on rsi() (rsi.R) and sma() (sma.R).
#
# Note: rsi() returns NA for the first 'period' entries (there isn't enough
# history yet to compute them). Those NAs are dropped before computing
# min/max and before calling sma(), since sma() (per the assignment's own
# template) does not handle NA values - this mirrors how the pseudocode's
# min()/max() are implicitly assumed to operate on valid RSI values only.

if (!exists("rsi")) {
  source("rsi.R")
}
if (!exists("sma")) {
  source("sma.R")
}

stoch_rsi <- function(data, period, k_period, d_period) {
  # Calculate the RSI
  rsi_values <- rsi(data, period)

  # Drop the leading NA values before computing StochRSI
  valid_rsi <- rsi_values[!is.na(rsi_values)]

  # Calculate the StochRSI
  min_rsi <- min(valid_rsi)
  max_rsi <- max(valid_rsi)
  k_values <- (valid_rsi - min_rsi) / (max_rsi - min_rsi)

  # Calculate the %K line (StochRSI, smoothed with an SMA)
  k_line <- sma(k_values, k_period)

  # Calculate the %D line (SMA of %K)
  d_line <- sma(k_line, d_period)

  # Return the %K and %D lines as a list
  result <- list(
    k_line = k_line,
    d_line = d_line
  )

  return(result)
}

# -----------------------------------------------------------------------------
# Example usage / manual test
# -----------------------------------------------------------------------------
# data <- c(45, 50, 48, 55, 52, 49, 58, 60, 65, 62)
# stoch_rsi_result <- stoch_rsi(data, period = 5, k_period = 3, d_period = 3)
# print(stoch_rsi_result)
