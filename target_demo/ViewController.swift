//
//  ViewController.swift
//  target_demo
//
//  Created by Alex Murphy on 6/7/17.
//  Copyright © 2017 thexande. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let immutableButton: UIButton = {
        let button = UIButton()
        button.setTitle("immutable button".uppercased(), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(immutableTarget), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var mutableButton: UIButton = {
        let button = UIButton()
        button.setTitle("mutable button".uppercased(), for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(mutableTarget), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    let immutableClickableViewLabel: UILabel = {
        let label = UILabel()
        label.text = "immutable view".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mutableClickableViewLabel: UILabel = {
        let label = UILabel()
        label.text = "mutable view".uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var views_dict: [String:UIView] = ["mutable":self.mutableButton, "immutable":self.immutableButton, "immutable_view":self.immutableClickableView, "mutable_view":self.mutableClickableView]
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        for view in views_dict.values { self.view.addSubview(view) }
        
        immutableClickableView.addSubview(immutableClickableViewLabel)
        mutableClickableView.addSubview(mutableClickableViewLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: immutableClickableViewLabel, attribute: .centerX, relatedBy: .equal, toItem: immutableClickableView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: immutableClickableViewLabel, attribute: .centerY, relatedBy: .equal, toItem: immutableClickableView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mutableClickableViewLabel, attribute: .centerX, relatedBy: .equal, toItem: mutableClickableView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mutableClickableViewLabel, attribute: .centerY, relatedBy: .equal, toItem: mutableClickableView, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[immutable]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[mutable]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[immutable_view]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[mutable_view]-12-|", options: [], metrics: nil, views: views_dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-70-[immutable(30)]-24-[mutable(30)]-30-[immutable_view(50)]-30-[mutable_view(50)]", options: [], metrics: nil, views: views_dict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func immutableTarget() {
        print("this button was initialized with let")
    }
    
    @objc func mutableTarget() {
        print("this button was initialized with lazy var")
    }
}

