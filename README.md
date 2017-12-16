Analysis of the Away Goals Rule in Major League Soccer
================
Cooper Schumacher
December, 2017

| **Primary skills**       | **Primary Programs**                                                     |
|--------------------------|--------------------------------------------------------------------------|
| Web Scraping and Parsing | Python (Selenium library)                                                |
| Data Visualization       | [**D3.js**](https://bl.ocks.org/coop16/651c862765c96222cc7a7766810bb780) |

Overview
========

The away goals rule is a tie-breaker in 2-leg (home and away) soccer playoffs. We investigate how it's implementation in Major League Soccer (MLS) in 2014 has influenced its playoff series.

**The (non-technical) write-up with web visualizations using D3.js is provided** [**HERE**](http://bl.ocks.org/coop16/raw/651c862765c96222cc7a7766810bb780/).

The data
========

I scraped data from [Flashscore.com](https://www.flashscore.com/) using Python's *Selenium* library. I considered all MLS playoff games *from 2-leg series* (starting in 2003 when 2-leg series were introduced, and through 2017). From the team names, scores, and formatting/ordering, I was able to generate many other relevant variables from the basic score reports.

Visualization
=============

I created several interactive visualizations with D3.js to enhance the write-up. The code is provided on this [Gist](https://gist.github.com/coop16/651c862765c96222cc7a7766810bb780) which can also be viewed as a block [HERE](http://bl.ocks.org/coop16/651c862765c96222cc7a7766810bb780).

Steps for Replication
=====================

### Web Scraping, parsing and cleaning

1.  Clone this repo.
2.  Download [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) and place it in the same folder as 'playoffgamescraper.py'.
3.  Run 'playoffgamescraper.py' --- this will output the file 'playoff.csv'.

### Basic Analyses and production of datafiles for d3.js visualization

1.  Run 'awaygoalsbasicanalysis.R'
    -   This provides several descriptive statistics and plots and outputs a few csv files for use in the D3.js visualizations.

### Visualization

1.  All .html, .css, .js, and .csv files used to produce the write-up are provided in a sepparate Gist [HERE](https://gist.github.com/coop16/651c862765c96222cc7a7766810bb780).
2.  To see the write-up and visualizations, this repository may be viewed as a block [**HERE**](http://bl.ocks.org/coop16/651c862765c96222cc7a7766810bb780).
