---
date: 2021-06-05 00:00
---

# Organize your dock using spacers

A simple way to organize the dock in groups of apps is using a white space as shown in the example below.

<img src="/images/articles/organize-your-dock-using-spacers/example.png" alt="Visual example of dock with space" width="100%"/> 

Run the following command:

```bash
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock
```

This will create a spacer at the end of your dock. This space can be dragged around like any other app icon in the dock.

Run the command once for every new desired spacer.
