//
//  Extension+UIControl.swift
//  MoneyBox
//
//  Created by shafique dassu on 13/01/2024.
//

import Foundation
import UIKit
import Combine

extension UIControl {
    
    func publisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, controlEvent: event)
    }
    
    struct EventPublisher: Publisher {
        
        typealias Output = UIControl // we are passing in the data stream the uicontrol as value
        typealias Failure = Never
        
        let control: UIControl
        let controlEvent: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = EventSubscription(control: control, event: controlEvent, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }

    class EventSubscription<S: Subscriber>: Subscription
    where S.Input == UIControl, S.Failure == Never {
        
        let control: UIControl
        let event: UIControl.Event
        var subscriber: S?
        
        var currentDemand = Subscribers.Demand.none
        
        init(control: UIControl, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addTarget(self,
                              action: #selector(eventOccured),
                              for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self,
                                 action: #selector(eventOccured),
                                 for: event)
        }
        
        @objc func eventOccured() {
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(control) ?? .none
                currentDemand -= 1
            }
        }
    }
}
