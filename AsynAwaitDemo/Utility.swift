//
//  Utility.swift
//  AsynAwaitDemo
//
//  Created by Michael Maguire on 3/22/23.
//

import Foundation
import Combine

@objc public class Utility: NSObject {
    
    // - verbose
    // - syntax ceremony
    // - relies on remembering to call the completionHandler in all closure completion routes
    // - returns information in buried callback
    // - no built-in guarantee around return value (can be none, 1, or both)
    // - verbose to involve helper functions due to completionHandler type
    @objc public static func performWithCallback(completionHandler: @escaping (Something?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completionHandler(Something(), nil)
        }
    }
    
    // - verbose
    // - relies on remembering to call the promise in all closure completion routes
    // - information buried in return type
    // - cannot expose to obj-c
    // + guarantees either Somthing or Error, not both
    //@objc public static func performAsFuture() -> Future<Something, NSError> {
    public static func performAsFuture() -> Future<Something, NSError> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(Result.success(Something()))
            }
        }
    }
    
    // - no built-in guarantee around return value (can be none, 1, or
    // - additional try/await/throws syntax
    // - adds additional do/catch syntax
    // + single path for returning value, easier to break out into helper functions
    @objc public static func performAsyncAwait() async -> (Something?, Error?) {
        do {
            try await Task.sleep(for: .seconds(1))
            return (Something(), nil)
        } catch {
            return (nil, NSError())
        }
    }
    
    // - additional try/await/throws syntax
    // + concise & intuitive ordering
    // + single path for returning value, easier to break out into helper functions
    // + gaurantees either value or error
    // + throwing errors in-line eliminates verbose return types
    @objc public static func performAsyncAwaitThrowing() async throws -> Something {
        try await Task.sleep(for: .seconds(1))
        return Something()
    }
}

@objc public class Something: NSObject {}
