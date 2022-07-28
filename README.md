Flutter package containing shared UI components to display biomarkers values. Created for Android,
iOS and web.

## Getting started

The package contains the following UI components:

- BiomarkerRangeIndicator:
  Meant to display a biomarker with a single value on a given range. Optionally an 'Optimal'
  and/or 'Borderline' range can be added.
- BiomarkerTrendLine:
  Meant to display a biomarker with a several values over time.
- BiomarkerCard:
  Take a list of biomarkers and tries to display them (best effort). The card will decide if it should 
  display a BiomarkerRangeIndicator or a BiomarkerTrendLine. It will not display errors and try to handle 
  them gracefully.
- BiomarkerValidator: Contains tools to perform data validation before displaying BiomarkerCard (meant for the clinic portal).
  Will given details about the errors found in the data for debugging.
- BiomarkerLeanBodyMass:
  Meant to display a biomarker of type Lean Body Mass with a special UI.
- BiomarkerVisceralFatArea
  Meant to display a biomarker of type Visceral Fat Area with a special UI.

Figma design link: https://www.figma.com/file/Tfh5DGMt6ECmNQIKvfh2CE/Mobile?node-id=4959%3A29497

## Usage

An example project demonstrating the UI can be run from command line
with `cd example && flutter run`. Tap the floating button at the bottom right corner to cycle
between each different components.
