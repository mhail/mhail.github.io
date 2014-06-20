---
layout: post
category : "Mobile"
title: "Xamarin Forms Fluent Bindings"
tags : [Xamarin, c#]
---
{% include JB/setup %}

Xamarin Forms are a big step in the right direction for creating cross platform mobile applications.

After working with Mvvmcross, the first thing that tripped me up in the transition is the binding syntax.

{% highlight c# %}

var title = new Label {  };
title.SetBinding<MainViewModel>(Label.TextProperty, vm=> vm.Title);

{% endhighlight %}

The very procedural nature of calling SetBinding for each property is very cumbersome.
The solution is a little fluent api magic.

{% highlight c# %}

var title = new Label {  }
  .Bind (Label.TextProperty).To (this.ViewModel, vm => vm.Title);

{% endhighlight %}

Much better. There is a clear binding between the instantiated label and the ViewModels Title property.
Also the To method returns the original label so that multiple binding statements can be chained.

With the two extension methods ```Bind``` and ```To```,
  I can inline all of the bindings allowing for full object initialization.

I am also using a base view class that handles creating my view model,
  and provides the strongly typed ViewModel property.

{% highlight c# %}

public class BaseView<T> : ContentPage where T : BaseViewModel
{
	public BaseView (T viewModel = null)
	{
		this.BindingContext = viewModel ?? Activator.CreateInstance<T> ();
	}

	public T ViewModel
	{
		get { return this.BindingContext as T; }
	}
}

public class MainView : BaseView<MainViewModel>
{
  ...
}

{% endhighlight %}

The handoff of Bind and To are done via a simple ```IBindableObjectFrom``` interface.

{% highlight c# %}

public interface IBindableObjectFrom<B> where B : BindableObject
{
  B Object { get; }
  BindableProperty TargetProperty { get; }
}

public static class BaseViewExtensions
{
	public static IBindableObjectFrom<B> Bind<B>(this B b, BindableProperty targetProperty) where B : BindableObject
	{
		return new BindableObjectFrom<B>(b, targetProperty);
	}

	public static B To<B, S>(this IBindableObjectFrom<B> f, S s, Expression<Func<S, object>> src, BindingMode mode = BindingMode.Default, IValueConverter converter = null, string stringFormat = null) where B : BindableObject where S : INotifyPropertyChanged
	{
		f.Object.BindingContext = s;
		f.Object.SetBinding(f.TargetProperty, src,mode, converter, stringFormat);
		return f.Object;
	}

	private class BindableObjectFrom<B> : IBindableObjectFrom<B> where B : BindableObject
	{
		public BindableObjectFrom(B obj, BindableProperty targetProperty)
		{
			this.Object = obj;
			this.TargetProperty = targetProperty;
		}

		#region IBindableObjectFrom implementation
		public B Object {
			get;
			private set;
		}
		public BindableProperty TargetProperty {
			get ;
			private set;
		}
		#endregion
	}
}

{% endhighlight %}

There is a [Beer Brewing Mash Calculator](https://github.com/mhail/MashCalc/)
  in the works using the base view model, fluent bindings as well as some other tricks.
  Check it out to see som of the other helpers and extensions for Xamrin Forms.
