### Adding Targets to Immutable Instance Properties Bug
Consider a swift subclass of UIViewController with two instance properties of type UIButton. The first is initialized immutably using the `let` keyword. The second is initialized mutably using `lazy var`. We use a call to the method `addTarget()` to add a click listener from each button to a class method, `immutableTarget()` and `mutableTarget()` respectfully.


```swift
let immutableButton: UIButton = {
        let button = UIButton()
        button.setTitle("immutable button".uppercased(), for: .normal)
        button.addTarget(self, action: #selector(immutableTarget), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
}()

lazy var mutableButton: UIButton = {
    let button = UIButton()
    button.setTitle("mutable button".uppercased(), for: .normal)
    button.addTarget(self, action: #selector(mutableTarget), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

@objc func immutableTarget() {
    print("this button was initialized with let")
}

@objc func mutableTarget() {
    print("this button was initialized with lazy var")
}
```

This works great, and the result is both messages printing out to the console when each button is clicked. While this produces the desired functionality, the fact that `self` accessible within an immutable closure at the instance property level is somewhat confusing. `self` is not accessible in any other context here, for example adding another instance property of type `UIView` as a subview using a call to `addSubview()`:

```swift
let greenView: UIView = {
    let view = UIView()
    view.backgroundColor = .green
    view.translatesAutoResizingMaskIntoConstraints = false
    return view
}()

let immutableButton: UIButton = {
        let button = UIButton()
        button.setTitle("immutable button".uppercased(), for: .normal)
        button.addSubview(self.greenView)
        button.addTarget(self, action: #selector(immutableTarget), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
}()
```

This produces the following error at the `addSubview()` call:

`Value of type '(NSObject) -> () -> ViewController' has no member 'mutableClickableView'`

As expected, both contexts of self access are valid within a lazy initialized mutable instance property.

This is clear because the lazy keyword delays initialization until the instance property is accessed, typically by a calling addSubview() on a view controller superview within an overridden initializer or viewDidLoad(). Both of these are called after `super.init()`, and therefore instance properties are accessible for lazily initialized instance properties. Considering immutableButton is initialized before `super.init()` is called on UIViewController, self should not be accessible.

If `UIView` is used instead of `UIButton` in the last example, and we use a call to `addGestureRecognizer()` instead of `addTarget()`, the tap gesture for the immutable instance property simply does not work. Take the following two properties as an example:

```swift

let immutableClickableView: UIView = {
    let view = UIView()
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(immutableTarget)))
    view.isUserInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    return view
}()

lazy var mutableClickableView: UIView = {
    let view = UIView()
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mutableTarget)))
    view.isUserInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .green
    return view
}()
```

In this situation, the immutable view will never call the `immutableTarget()` method. This is the bug.
