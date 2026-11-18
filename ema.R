# =============================================================================
# BDA400 - Assignment 5: Technical Analysis using R
# File: ema.R
# Function: ema() - Exponential Moving Average
# =============================================================================
#
# The Exponential Moving Average (EMA) gives more weight to recent data
# points than the Simple Moving Average does, making it more responsive to
# recent price movements.
#
# EMA(i) = (Price(i) - EMA(i-1)) * multiplier + EMA(i-1)
# multiplier = 2 / (period + 1)

ema <- function(data, period) {
  # Calculate the multiplier for EMA
  multiplier <- 2 / (period + 1)

  # Initialize an empty array to store EMA values
  ema_values <- numeric(length(data))

  # Loop through the data array
  for (i in 1:length(data)) {
    if (i == 1) {
      # Calculate EMA for the first data point
      ema_values[i] <- data[i]
    } else {
      # Calculate EMA for subsequent data points
      ema_values[i] <- (data[i] - ema_values[i - 1]) * multiplier + ema_values[i - 1]
    }
  }

  return(ema_values)
}

# -----------------------------------------------------------------------------
# Example usage / manual test
# -----------------------------------------------------------------------------
# data <- c(10, 12, 15, 20, 18, 22, 25, 24, 21)
# ema_result <- ema(data, period = 3)
# print(ema_result)
