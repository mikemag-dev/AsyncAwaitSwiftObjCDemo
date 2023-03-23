//
//  ViewController.swift
//  AsynAwaitDemo
//
//  Created by Michael Maguire on 3/22/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - usually requires weak capture
        // - messy hierarchy
        Utility.performWithCallback { [weak self] something, error in
            guard let _ = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(something.debugDescription)
            }
        }
        
        
        
        
        
        
        // - verbose
        // - usually requires weak capture
        // - requires storage for callback
        // + breaks apart error vs value reception
        // + does not require
        // + enables combine operators such as mapping, filtering, aggregation, zipping
        Utility.performAsFuture()
            .eraseToAnyPublisher()
            //.map { .. } //example combine operator
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] something in
                guard let _ = self else { return }
                print(something.debugDescription)
            }
            .store(in: &cancellables)

        // try no try :)
        //Utility.performAsyncAwait()
        
        
        
        
        
        
        
        // When you create an instance of Task, you provide a closure that contains the work for that task to perform. Tasks can start running immediately after creation; you don’t explicitly start or schedule them.
        Task {
            // - must be called in a task closure
            // + more chronological
            // + less boilerplate
            // + no weak capture (Task will retain the view controller while it's running. The view controller will only be deallocated once the task finishes)
            let result = await Utility.performAsyncAwait()
            if let error = result.1 {
                print(error.localizedDescription)
            } else if let something = result.0 {
                print(something.debugDescription)
            } else {
                print("should not happen")
            }
        }
        
        
        
        
        
        
        Task {
            // - adds do/catch syntax
            // + more chronological
            // + less boilerplate
            // + no weak capture (Task will retain the view controller while it's running. The view controller will only be deallocated once the task finishes)
            do {
                let something = try await Utility.performAsyncAwaitThrowing()
                print(something.debugDescription)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
        
        
        
        Task {
            // - erases error
            // + most concise
            let something = try? await Utility.performAsyncAwaitThrowing()
            print(something.debugDescription)
        }
    }

    
}

