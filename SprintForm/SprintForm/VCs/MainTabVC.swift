//
//  MainTabVC.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class MainTabVC: UITabBarController, StoryboardProtocol {
    static var storyboardID: String {
        return "mainTabBarVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectTransactions() {
        selectedIndex = 1
    }
}
