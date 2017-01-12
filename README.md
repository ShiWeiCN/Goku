# Goku

<p align="center">

<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>

<a href="http://cocoadocs.org/docsets/JESAlertView"><img src="https://img.shields.io/badge/pod-v1.0-blue.svg"></a>

<a href="https://raw.githubusercontent.com/ShiWeiCN/JESAlertView/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>

<a href="http://cocoadocs.org/docsets/JESAlertView"><img src="https://img.shields.io/badge/platform-ios 8.0+-lightgrey.svg"></a>

<a href="https://github.com/ShiWeiCN/JESAlertView"><img src="https://img.shields.io/badge/Xcode 8-Swift 3-red.svg"></a>

</p>

**Goku** is an alert view written by swift 3, support both action sheet and alert view style. And now provide 6 styles to show your alert. If you want to use the world of Swift 3, you need Xcode 8+.

## Screenshots

![GIF](Gif/alert.gif)
![GIF](Gif/actionsheet.gif)
![GIF](Gif/morealertstyle.gif)

## Easy to use

Provide a default theme of alert view. So you can use this default theme or create a theme you like.

```swift
import Goku

// 🌟 Usage 👇
	
self.goku.presentAlert(true, closure: { (make) in
	make.theme
		.actionSheet
		.title("Okay/Cancel")
		.message("A customizable action sheet message.")
		.cancel("Cancel")
		.destructive("OK")
		.normal(["Button1", "Button2"])
		.tapped({ (index) in
			print("Tapped index is \(index)")
		}
	)
})	

self.goku.presentAlert(true, closure: { (make) in
	make.theme
		.alert
		.success
		.title("Congratulations!")
		.message("You've just displayed this awesome Pop Up View.")
		.cancel("Cancel")
		.normal(["Default 1", "Default 2"])
		.tapped({ (index) in
			print("Index \(index)")
		}
	)
})
```
	
For more usage you can see [Example](https://github.com/ShiWeiCN/Goku)
    
> Icon image from [SCLAlertView](https://github.com/dogo/SCLAlertView)

## Installation

**Goku** is available through [Cocoapods](https://cocoapods.org/).

Add the following to you `Podfile`

```
pod 'Goku', '~> 1.0'
```

## TODO

- [ ] More animation
- [x] More beautiful syntax
- [x] Usage like `SnapKit`

## License

Goku is released under the MIT license. See LICENSE for details.

