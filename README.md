# BoulderLogbook

An unofficial boulder logbook for Dresden's boulder gym [Mandala](https://boulderhalle-dresden.de).

<img src="/Users/martinlist/Developer/BoulderLogbook/Resources/detail.png" alt="detail" style="zoom:20%;" /><img src="/Users/martinlist/Developer/BoulderLogbook/Resources/form.png" alt="form" style="zoom:20%;" /><img src="/Users/martinlist/Developer/BoulderLogbook/Resources/summary.png" alt="summary" style="zoom:20%;" />

## Features

When finished it should allow you to: 

* log all your tops for a session
* display a list of your past sessions
* show your number of tops for each grade in a line chart (over a time span of a week)  


Other possible features: 

* specify whether a top was a flash (or on sight)
* allow you to set the grading scale for your gym 

## Compatibility

* Runs and builds on iOS 15 and iOS 16 (without Charts though)
* Uses `#if canImport(Charts)` to build on Xcode 13