//
//  ConfigHelper.swift
//  TripPlanner
//
//  Created by Victoria Belinschi on 07.10.2024.
//
import Foundation

// MARK: - Config Enum
public enum Config {

    // MARK: - Properties
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        return dict
    }()

    // MARK: - Base URL
    static let baseURL: URL = {
        guard let baseURL = Config.infoDictionary[Keys.baseURL.rawValue] as? String else {
            fatalError("Base URL not set in plist")
        }
        guard let url = URL(string: baseURL) else {
            fatalError("Base URL is invalid")
        }
        return url
    }()

    // MARK: - Keys Enum
    private enum Keys: String {
        case baseURL = "API_URL"
    }
}
