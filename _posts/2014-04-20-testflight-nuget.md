---
layout: post
category : Mobile
title: "Xamarin TestFlight Nuget"
tags : [Xamarin, iOS, c#]
---
{% include JB/setup %}

Using test flight for beta testing has been my de-facto standard for mobile apps.
  Integration with Xamarin is easy from a deployment standpoint, but setting up a project to use the TestFlight API requires clearing a few hoops.
  You would think that there is a component already built or a Nuget package already out there?
  The best option was the Testflight binding from the [monotouch-bindings](https://github.com/mono/monotouch-bindings/tree/master/TestFlight) github project.
  This is a great start but it required cloning a large repository and then dealing with a pre-built dll that I needed to check into my app's source code repository.

  Enter nuget, and a custom feed from myget.

### Process

The first step to building a nuget package, was to define a build script to do thy bidding.
  I have been using FAKE on a few projects and it has been really helpful for creating an automated repeatable process.
  The task hierarchy is as follows:

{% highlight fsharp %}
"Clean"
  ==> "ExtractSDK"
  ==> "BuildTouchBinding"
  ==> "CreateNugetPackage"
  ==> "Default"
{% endhighlight %}

The details of the tasks are available on the project [github repository](https://github.com/mhail/TestFlightPackage).
  In short the script extracts the libtestflight.a file from the SDK and then runs the mdtool on the bindings project file.
  The package is generated from a template using the FAKE NuGet method, and placed into ```build/package```

Next the Nuget package can be uploaded to your personal or company NuGet server.
  I created my own feed on [mygit](https://www.myget.org) .
  I don't plan on publishing my nuget package as it is very fuzzy around the licensing for the TestFlight SDK.

The final step is to add your new feed url to the NuGet package addin for Xamarin Studio or Visual Studio.
  The TestFlight Nuget is now ready to use and can be added to every project, and eliminated managing a pre-compiled dll.

{% highlight powershell %}  
PM> Install-Package TestFlight.Touch -Version 3.0.0
{% endhighlight %}

![Xamrin NuGet Addin]({{ site.url }}/downloads/xamarin-nuget-testflight-ios.png)

### Future Improvements

I really wish that the SDK could be downloaded from TestFlight directly.
  There is a commented out target ```DownloadSDK``` for when the SDK is available without a login.

Additionally there are constant updates to the original binding project and the TestFlight SDK, I hope to keep this up to date.
  It might be a good idea to add the binding code as a sub-project, if there is a way to add a sub folder of a larger project as a sub project?

### Next Steps

I am using FAKE for my mobile projects and have overloaded the standard RestorePackages method with my own, to support my custom feed.

{% highlight fsharp %}
let RestoreCustomPackages() =
    !! "./**/packages.config"
    |> Seq.iter (fun id ->
        RestorePackage (fun p ->
          { p with
              Sources = [
                         "https://go.microsoft.com/fwlink/?LinkID=206669"; // Main Nuget Feed url
                         "https://www.myget.org/F/<YOUR_USER_NAME>/" // Your custom Feed
              ]
          }) id)
{% endhighlight %}
