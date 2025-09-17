//
//  ThemeManager.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//

import Foundation
import UIKit

enum AppColors {
    static let accent = UIColor.systemBlue
    static let background = UIColor.systemBackground
    static let cardBackground = UIColor.secondarySystemBackground
    
   
    static var navBarBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    static var navBarText: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
}

enum AppFonts {
    static let headline = UIFont.systemFont(ofSize: 22, weight: .bold)
    static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let caption = UIFont.systemFont(ofSize: 14, weight: .medium)
}

final class ThemeManager {
    static func applyGlobalTheme() {
       
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = AppColors.navBarBackground
        navAppearance.titleTextAttributes = [.foregroundColor: AppColors.navBarText]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: AppColors.navBarText]

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = AppColors.accent

     
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = AppColors.navBarBackground
        tabAppearance.stackedLayoutAppearance.selected.iconColor = AppColors.accent
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: AppColors.accent]
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: AppColors.navBarText]

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = AppColors.accent
    }
}
