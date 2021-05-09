---
date: 2021-05-09 00:00
description: In this article we explore a not-very-known feature of UIFont that allows enabling alternate versions of the font using its stylistic sets.
---

#  How to customize a font's stylistic set in your iOS app

Our design team recently decided to change the app's font to _Galano Grotesque Alt_. 
This sounded like a straightforward task:

- Remove the old font from the app
- Add the new font
- Update the `.plist` file
- Update the centralized font generating function

However, there was a twist, they wanted to use a variation of the font modifying some stylistic sets.
Stylistic sets are a feature available in some fonts that enables alternate versions of some characters. 
Below is an example of the letter K using _Galano Grotesque Alt_ font with its stylistic set turned off, then on.

<p style="text-align: center">
  <img src="/images/articles/customize-your-font/stylistic_set_off.png" alt="Stylistic set of the letter K turned off" height="60px"/>
  <img src="/images/articles/customize-your-font/stylistic_set_on.png" alt="Stylistic set of the letter K turned on" height="60px" style="margin-left: 10px"/>
</p>

\

## Step by step

For the purpose of this tutorial we will be using the default iOS font to make sure anyone can correctly follow along.
Remember however, not all fonts have custom stylistic set.

- Start off by printing the information of the font. To do so, add this somewhere in your code:

```
let font = UIFont.systemFont(ofSize: 12)
print(CTFontCopyFeatures(font))
```

This will print out a large array containing several information. 
The array element we are interested in is the feature type with an identifier value equal to 35 as shown below.

```
{
  CTFeatureTypeIdentifier = 35;
  CTFeatureTypeName = "Alternative Stylistic Sets";
  CTFeatureTypeSelectors = (
    {
      CTFeatureSelectorIdentifier = 2;
      CTFeatureSelectorName = "Straight-sided six and nine";
    },
    {
      CTFeatureSelectorIdentifier = 4;
      CTFeatureSelectorName = "Open four";
    },
    {
      CTFeatureSelectorIdentifier = 6;
      CTFeatureSelectorName = "Vertically centered colon";
    },
    {
      CTFeatureSelectorIdentifier = 8;
      CTFeatureSelectorName = "Open currencies";
    },
    {
      CTFeatureSelectorIdentifier = 12;
      CTFeatureSelectorName = "High legibility";
    },
    {
      CTFeatureSelectorIdentifier = 14;
      CTFeatureSelectorName = "One storey a";
    },
    {
      CTFeatureSelectorIdentifier = 18;
      CTFeatureSelectorName = Calculator;
    }
  );
},
```

The default system font has 7 custom stylistic sets that can be turned on. 
Each stylistic set has an identifier and a name. 
The name matches the values you would find if you try and edit your font using editing tools such as _Figma_ or _Sketch_ among others. 
The identifier on the other hand is used to reference these stylistic sets.

\

For the purpose of this tutorial, let's assume we want to activate the _High legibility_ and _Open four_ stylistic sets. 
The goal is to customize the font descriptor to use the stylistic sets we want.

- We start by creating a dictionary of type `[UIFontDescriptor.FeatureKey: Int]` for each stylistic set.

```
let openFourStylisticSet: [UIFontDescriptor.FeatureKey: Int] = [
  .featureIdentifier: kStylisticAlternativesType,
  .typeIdentifier: 4
]

let highLegibilityStylisticSet: [UIFontDescriptor.FeatureKey: Int] = [
  .featureIdentifier: kStylisticAlternativesType,
  .typeIdentifier: 12
]
```
- We then create a font descriptor by adding attributes to the font's existing descriptor.

```
let descriptor = UIFont.systemFont(ofSize: 12)
  .fontDescriptor
  .addingAttributes(
    [.featureSettings: [openFourStylisticSet, highLegibilityStylisticSet]]
  )
```

- Finally we create our new font using the `init(descriptor: UIFontDescriptor, size: CGFloat)`.

```
// By passing 0 as a size we fallback of the on the font's descriptor font size. 
let font = UIFont(descriptor: descriptor, size: 0)
```

\

## Full code example

Below is a full code example on how to apply all what we learned and put in an elegant way as a `UIFont` extension.

```
extension UIFont {
  static func alternateSystemFont(size: CGFloat, weight: Weight) -> UIFont {
    let openFourStylisticSet: [UIFontDescriptor.FeatureKey: Int] = [
      .featureIdentifier: kStylisticAlternativesType,
      .typeIdentifier: 4
    ]
  
    let highLegibilityStylisticSet: [UIFontDescriptor.FeatureKey: Int] = [
      .featureIdentifier: kStylisticAlternativesType,
      .typeIdentifier: 12
    ]
    
    let descriptor = UIFont.systemFont(ofSize: size, weight: weight)
      .fontDescriptor
      .addingAttributes(
        [.featureSettings: [openFourStylisticSet, highLegibilityStylisticSet]]
      )
    
    return UIFont(descriptor: descriptor, size: 0)
  }
}
```
