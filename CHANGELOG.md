## [2.3.0] - 2022-06-14
* BiomarkerString: added `maxOptimalValue` and `minOptimalValue`. 
* BioMarkerCard: Now showing optimal range text for BiomarkerStrings if they have a `maxOptimalValue` and/or `minOptimalValue`.

## [2.2.0] - 2022-06-08
* TrendLine: Moved the value text to be just above the dot (or just under it if there is no space above) rather than at the bottom.
* BioMarkerCard: Updated the font style for values text in TrendLine.

## [2.1.0] - 2022-06-07
* TrendLine: Now hiding the "More arrow" if there is nothing more.
* TrendLine: Now the "More arrow" text will draw under the arrow if there is not enough space above (i.e. if the dot is close to the top edge).
* TrendLine: made the value text look prettier.
* TrendLine and BiomarkerTrendLine: Added `dateFormat` to control the formatting of the date.
* TrendLine and BiomarkerTrendLine: Added `dotRadius` to control the size of the dots.
* TrendLine and BiomarkerTrendLine: Added `linesStrokeWidth` to control the width of the drawn links and more arrow. 

## [2.0.0] - 2022-06-06
* Added a lot of new element for displaying biomarker cards and doing data verification.
* *Breaking change:* Changed BiomarkerRangeIndicator to take a BiomarkerData as parameter.
* *Breaking change:* Changed BiomarkerTrendLine to take a list of BiomarkerData as parameter.
* Added BiomarkerCard widget.
* Added BiomarkerCardRangeIndicator widget.
* Added BiomarkerCardTrendLine widget.
* Added RangeIndicator widget (which is exactly the same as the former BiomarkerRangeIndicator).
* Added TrendLine widget (which is exactly the same as the former BiomarkerTrendLine).
* Added BiomarkerData model.
* BiomarkerValidator.
* Updated example app.

## [1.0.0] - 2022-05-18
* Initial Commit.
* Added BiomarkerRangeIndicator.
* Added BiomarkerTrendLine.
* Added example app.

