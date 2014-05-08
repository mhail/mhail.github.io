---
layout: post
title: "FontAwesome.Touch"
description: "New FontAwesome.Touch nuget package"
category: Mobile
tags: [Xamarin, iOS, c#]
---
{% include JB/setup %}

One of the first chalenges I face when creating a mobile app is creating image assets.
  The most notable is creating a custom button icon.
  On iOS this is done using custom PNG images.

  I personally coming from a web background the easiest solution for custom button images is to use font icon packs.
  It turns out the same can be done on iOS by including the custom true type font file with your app.

###FontAwesome.Touch

I have created a nuget package that can be referenced in a Xamarin iOS project.  
  It provides a strongly typed representation of all of the [FontAwesome](http://fontawesome.io/icons/) Icons, and provides methods for generating a UIImage at runtime of the desired size.
  This allows for custom buttons in navigation and tool bars.

{% highlight csharp %}

rightNavButton = new UIBarButtonItem (
  FontAwesome.Touch.Icon.CloudDownload.ToUIImage(30),
  UIBarButtonItemStyle.Bordered, (s,e) =>{
});

{% endhighlight %}

[See Here](https://raw.githubusercontent.com/mhail/FontAwesome.Touch/master/Art/sample-app.png)

### GitHub Project

https://github.com/mhail/FontAwesome.Touch

### Next Steps

The icon names are generated from a yaml file within the fontawesome repository.
  There is a code genration console app that uses the yaml file to generate the Icon enum.
  I plan on moving to reading the true type file to extract the glyph information directly.
  This should allow for incorporating new icon font packs.
