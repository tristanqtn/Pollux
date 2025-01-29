# Pollux Report

At the end of a run, Pollux generates a report with every finding. The report is generated in [Markdown](https://en.wikipedia.org/wiki/Markdown) language.

## Markdown report generation

The markdown report takes each output file, generated from scripts, and appends them into the markdown "final" report. It summarizes every finding with the timestamp of the scan, and provides in the end of the report information written in the config file, to keep an exact trace of the configuration in place during the audit.

## PDF report generation

From the markdown report is generated a pdf one. Information are the same, but the display method is different and clearer.
