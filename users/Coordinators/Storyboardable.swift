//
//  Storyboardable.swift
//  users
//
//  Created by User on 28.11.2022.
//

import Foundation
import UIKit

protocol Storyboardable {
    static var storyboardBundle: Bundle { get }
    static var viewControllerName: String { get }
    static func instantiate(storyBoardName: String) -> Self
}

extension Storyboardable where Self : UIViewController {
    static var storyboardBundle: Bundle {
        return .main
    }
    
    static var viewControllerName: String {
        return String(describing: self)
    }
    
    static func instantiate(storyBoardName: String) -> Self {
        return UIStoryboard(name: storyBoardName, bundle: storyboardBundle).instantiateViewController(withIdentifier: viewControllerName) as! Self
    }
}
