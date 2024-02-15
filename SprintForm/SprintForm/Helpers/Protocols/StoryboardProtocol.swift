//
//  StoryboardProtocol.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

protocol StoryboardProtocol {
    static var storyboardID: String { get }
    static func instantiateVC() -> Self?
}

extension StoryboardProtocol where Self: UIViewController {
    static func instantiateVC() -> Self? {
        let sb = UIStoryboard.main()
        return sb.instantiateViewController(withIdentifier: storyboardID) as? Self
    }
    
    static func instantiateVCNavigationController() -> UINavigationController? {
        let sb = UIStoryboard.main()
        return sb.instantiateViewController(withIdentifier: storyboardID) as? UINavigationController
    }
}
