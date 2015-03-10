---
layout: post
category : "Mobile"
title: "Xamarin Forms - Strongly Typed Xaml Bindings"
tags : [Xamarin, c#, Xaml]
---
{% include JB/setup %}



  I was building some Xamarin Forms prototype applications focusing mostly on the Xaml and screen layouts, using a generated fake data source. I knew that the property names of the view model would most likely change.

  Using Xaml for defining view layout is an awesome productivity booster.
    There is just one drawback... refactoring.
    Because the xaml is parsed and verified at run time, you don't know if there will be binding errors with the view model.

  I wanted to be able to easily refactor the view model property names, and be notified by the compiler when binding properties that did not exist.
  One solution is to just define all of the views in code. Not as much fun, and much more verbose.

  After looking at the markup extension that is used internally for the ``` {Binding SomeViewModelProperty}``` I was surprised to see how simple it really is. See: ```BindingExtension.ProvideValue``` in Xamarin.Forms.Xaml.dll

  ```BindingExtension``` is just a wrapper around the ```Xamarin.Forms.Binding``` class.

  So with some experimentation I created my own Binding wrapper, but it looks for a field on the View in which it is defined to clone a Binding instance.

View Xaml:

{% highlight xml %}

<Button
  Text="Submit"
  Command="{local:BindingRef Submit}"
  Grid.Row="2" Grid.ColumnSpan="2"
  />  

{% endhighlight %}

View Code Behind:

{% highlight c# %}

public partial class EntryView : ContentPage
{
  public static readonly Binding Name = Binding.Create<EntryViewModel>(vm=>vm.Name);
  public static readonly Binding Email = Binding.Create<EntryViewModel>(vm=>vm.Email);
  public static readonly Binding Submit = Binding.Create<EntryViewModel>(vm=>vm.SubmitCommand);

  public EntryView ()
  {
    InitializeComponent ();
  }
}

{% endhighlight %}

From the code above, the Submit Button command is bound to the ViewModel SubmitCommand, via the Submit binding field.

The only trick I found was that Binding class instances can't be re-used so the binding definition in the field is a template that is cloned when the markup extension is processed.

BindingRefExtension.cs :

{% highlight c# %}

[ContentProperty ("Key")]
public class BindingRefExtension : IMarkupExtension
{
  public string Key { get; set; }

  #region IMarkupExtension implementation

  public object ProvideValue (IServiceProvider serviceProvider)
  {
    var provider = serviceProvider.GetService (typeof(IRootObjectProvider)) as IRootObjectProvider;
    if (null == provider)
      throw new InvalidOperationException ("IRootObjectProvider");

    var binding = GetBindingFromRootObjectField (provider.RootObject);

    if (null != binding) {
      // The binding needs to be cloned or it will throw an Instance Cannot Be Reused Exception
      return new Binding (binding.Path, binding.Mode, binding.Converter, binding.ConverterParameter, binding.StringFormat, binding.Source);
    }

    throw new InvalidOperationException (string.Format("Binding field '{0}' not found on object {1}", Key, provider.RootObject.GetType().Name));

  }

  #endregion

  Binding GetBindingFromRootObjectField (object rootObject)
  {
    var field = rootObject.GetType ().GetRuntimeField (Key);
    if (null != field) {
      return field.GetValue (rootObject) as Binding;
    }
    return null;
  }
}

{% endhighlight %}

Now I can use the re-factoring tools in Xamrin Studio, Visual Studio or ReSharper to modify my ViewModels but the view bindings will still be linked by the field names on the view. There are some added benefits of seeing additional usages of the view model properties when using source code analysis. The only drawback is the small overhead of doing the field lookup using reflection, although there is a lot more reflection logic executed by Xamrin Forms once the binding object is evaluated.

A small simple example project is [here](https://github.com/mhail/BindingExt).
