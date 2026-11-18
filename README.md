# BDA400 Assignment 5 - Technical Analysis using R (Development Phase)

**Author:** Ibukun_Fawole

**Status:** All 9 indicators have been run and verified successfully against
real Yahoo Finance data for AAPL (2007-present, 4,920 rows), pulled live via
`quantmod::getSymbols()`.

## Files in this repository

| File | Description |
|---|---|
| `load_stock_data.R` | Assignment 1 script - pulls live OHLCV data from Yahoo Finance via `quantmod::getSymbols()` for each ticker in `portfolio.txt` |
| `portfolio.txt` | List of 8 ticker symbols (AAPL, MSFT, GOOGL, AMZN, TSLA, META, NVDA, NFLX) used by `load_stock_data.R` |
| `build_stock_dataframes.R` | Converts the quantmod `xts` output from `load_stock_data.R` into clean `Date, Open, High, Low, Close, Volume` data frames (one per symbol), and saves each as its own CSV |
| `stock_data_AAPL.csv`, `stock_data_MSFT.csv`, etc. | Real daily OHLCV data (Date, Open, High, Low, Close, Volume) for all 8 portfolio symbols, pulled from Yahoo Finance and saved by `build_stock_dataframes.R` |
| `sma.R` | Simple Moving Average |
| `ema.R` | Exponential Moving Average |
| `macd.R` | MACD line, signal line, histogram (depends on `ema.R`) |
| `stdev.R` | Standard Deviation |
| `linreg.R` | Linear Regression (slope, intercept, predicted values) |
| `rsi.R` | Relative Strength Index |
| `stoch_rsi.R` | Stochastic RSI (depends on `rsi.R` and `sma.R`) |
| `crossover.R` | Detects an upward crossover between two series |
| `crossunder.R` | Detects a downward crossover between two series |
| `run_all_indicators.R` | Sources every indicator file and runs/tests each one against the stock dataset |
| `Ibukun_Fawole_indicator_explanations.docx` | Brief write-up explaining each implementation |

## How to run this project

1. Make sure `quantmod` is installed: `install.packages("quantmod")`
2. Make sure all files in this repository are in the same folder (cloning
   the repo does this automatically).
3. Open RStudio, set your working directory to this folder.
4. Open `build_stock_dataframes.R` and click **Source**. This downloads live
   OHLCV data for all 8 symbols in `portfolio.txt` from Yahoo Finance,
   converts each into a clean data frame, and saves one CSV per symbol.
5. Open `run_all_indicators.R` (OPTION A active by default) and click
   **Source**. This runs all 9 indicators against the AAPL data and prints
   results to the console.

The console will print, in order: a preview of the loaded dataset, then the
output of each indicator (SMA, EMA, MACD, standard deviation, linear
regression, RSI, Stochastic RSI, crossover, and crossunder signals), ending
with "All indicators ran successfully."

No external R packages are required for the indicator functions themselves -
every one of the 9 functions is implemented using only base R, per the
assignment's constraints. `quantmod` is only used for the data-loading step
(Assignment 1 / Step 1 of Assignment 5), not for any indicator calculation.

If you don't have internet access or want to test offline, you can instead
point `run_all_indicators.R` at a previously-saved `stock_data_<SYMBOL>.csv`
without re-running `build_stock_dataframes.R`.

## Notes on implementation choices

- **MACD** and **Stochastic RSI** call `ema()`/`rsi()`/`sma()` internally, so
  those scripts `source()` their dependencies automatically if not already
  loaded in the session.
- **RSI** and **Stochastic RSI**: the pseudocode in the assignment sheet
  stores a gain OR a loss per step, leaving the other value unset (NA in R).
  Since that breaks averaging, this implementation records an explicit 0 on
  the "other side" at each step instead, and drops the leading NA values
  from `rsi()`'s output before feeding them into `sma()` inside
  `stoch_rsi()`. This preserves the pseudocode's logic while making it
  actually run in R.
