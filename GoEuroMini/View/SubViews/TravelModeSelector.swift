//
//  TravelModeSelector.swift
//  GoEuroMini
//
//  Created by Sasha on 26/03/17.
//  Copyright © 2017 ShwtMhjn. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TravelModeSelectorDelegate
{
    func travelModeSelector(menuView: TravelModeSelector, didSelectItem item: TravelMode)
}

public class TravelModeSelector: UIView
{
    var delegate:TravelModeSelectorDelegate?
    var selectedTravelMode : TravelMode = .TRAIN
    
    @IBOutlet weak var sliderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var flightButton: UIButton!
    @IBOutlet weak var busButton: UIButton!
    @IBOutlet weak var trainTransparentView: UIView!
    @IBOutlet weak var busTransparentView: UIView!
    @IBOutlet weak var flightTransparentView: UIView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView()
    {
        let nibArray = Bundle.main.loadNibNamed("TravelModeSelector", owner: self, options: nil);
        let selectorView : UIView = nibArray?[0] as! UIView
        selectorView.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(selectorView)
        
        let viewsDictionary = ["selectorView":selectorView];
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[selectorView]-0-|", options: NSLayoutFormatOptions(rawValue: UInt(0)), metrics: nil, views: viewsDictionary);
        self.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[selectorView]-0-|", options: NSLayoutFormatOptions(rawValue: UInt(0)), metrics: nil, views: viewsDictionary);
        self.addConstraints(constraints);
    }
    
    func animateSelector(width:CGFloat, leadingConstraintValue:CGFloat)
    {
        self.sliderLeadingConstraint.constant = leadingConstraintValue;
        self.underlineViewWidthConstraint.constant = width;
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}

//MARK: IBActions
extension TravelModeSelector
{
    @IBAction func trainSelected(_ sender: AnyObject)
    {
        self.animateSelector(width: self.trainTransparentView.frame.size.width, leadingConstraintValue: self.trainTransparentView.frame.origin.x)
        selectedTravelMode = .TRAIN
        if let delegate = self.delegate
        {
            delegate.travelModeSelector(menuView: self, didSelectItem: .TRAIN)
        }
    }
    
    @IBAction func busSelected(_ sender: AnyObject)
    {
        self.animateSelector(width: self.busTransparentView.frame.size.width, leadingConstraintValue: busTransparentView.frame.origin.x)
        selectedTravelMode = .BUS
        if let delegate = self.delegate
        {
            delegate.travelModeSelector(menuView: self, didSelectItem: .BUS)
        }
    }
    
    @IBAction func flightSelected(_ sender: AnyObject)
    {
        self.animateSelector(width: self.flightTransparentView.frame.width, leadingConstraintValue: flightTransparentView.frame.origin.x)
        selectedTravelMode = .FLIGHT
        if let delegate = self.delegate
        {
            delegate.travelModeSelector(menuView: self, didSelectItem: .FLIGHT)
        }
    }
}
