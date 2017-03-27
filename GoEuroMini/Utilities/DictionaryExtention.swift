//
//  DictionaryExtention.swift
//  MovieWebService
//
//  Created by Sasha on 07/03/17.
//

import Foundation

extension Dictionary {
    
    //MARK: -- Function to return string Value --
    
    func stringForKey (_ aKey : String) -> String {
        
        if let value = self[aKey as! Key] as? String {
            var string = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if(string.characters.count == 0  || string.isEmpty) {
                return Constants.kEmptyString
            }
            return string
        }
        
        return Constants.kEmptyString
    }
    
    //MARK: -- Function to return double Value
    
    func doubleForKey (_ aKey : String) -> Double {
        if(self[aKey as! Key] == nil) {
            
            return Constants.kZeroDouble
        }
        
        let value = self[aKey as! Key] as? String
        if let _value = value {
            if (_value == ""){
                return Constants.kZeroDouble
            }else{
                return Double(_value)!
            }
        }else if let doubleValue = self[aKey as! Key] as? Double{
            return doubleValue
        }else if let doubleValue = self[aKey as! Key] as? Float{
            return Double(doubleValue)
        }else if let doubleValue = self[aKey as! Key] as? Int{
            return Double(doubleValue)
        }else{
            return Constants.kZeroDouble
        }
    }
    
    
    //MARK: Function to return Int Value
    
    func integerForKey (_ aKey : String) -> Int {
        
        if(self[aKey as! Key] == nil) {
            
            return Constants.kZeroInteger
        }
        
        let value = self[aKey as! Key] as? String
        if let _value = value {
            return Int(_value)!
        }else if let intValue = self[aKey as! Key] as? Int{
            return intValue
        }else{
            return Constants.kZeroInteger
        }
    }
    
    //MARK: Function to return bool Value
    
    func boolForKey (_ aKey : String) -> Bool {
        
        if(self[aKey as! Key] == nil) {
            
            return false
        }
        
        let value = (self[aKey as! Key] as? Bool)
        if let _value = value{
            return _value
            
        }else{
            return false
        }
    }

    //MARK: -- Function to return array Value
    
    func arrayForKey (_ aKey : String) -> Array<AnyObject>? {
        
        if(self[aKey as! Key] == nil) {
            return nil
        }
        //
        var array = self[aKey as! Key] as? [AnyObject]
        //
        if(self[aKey as! Key]  is [String:AnyObject]) {
            array = [self[aKey as! Key]  as! [String:AnyObject] as AnyObject]
        }
        
        return array
    }
    
    //MARK: -- Function to return dictionary Value
    
    func dictionaryForKey(_ aKey : String) -> [String : AnyObject]? {
        //MARK: --            return nil
        if(self[aKey as! Key] == nil) {
            return nil
        }
        return self[aKey as! Key] as? [String: AnyObject]
    }
}


