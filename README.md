# MakeIcons

A macOS CLI utility to populate Xcode projects `AppIcon.appiconset` with icon images.

### Usage:

```
makeicons <image> <project> [-i <idiom>]
```

Where:
- image: path to a `.png` image file to use as the app icon.
- project: path to Xcode project; can be a project path or `AppIcon.appiconset` path.
- `-i <idiom>`: (optional) idiom to apply the icon file to. When provided, the image will be set for all images matching this idiom. For example, "-i mac" will update icons for macOS only.

