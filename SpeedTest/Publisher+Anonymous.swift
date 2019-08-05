//
//  Publisher+Anonymous.swift
//  SpeedTest
//
//  Created by Stefan Kofler on 05.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Combine

extension Publishers {

    public struct Anonymous<Output, Failure: Swift.Error>: Publisher {
        private var closure: (AnySubscriber<Output, Failure>) -> Void

        public init(closure: @escaping (AnySubscriber<Output, Failure>) -> Void) {
            self.closure = closure
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Anonymous.Failure == S.Failure, Anonymous.Output == S.Input {
            let subscription = Subscriptions.Anonymous(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.start(closure)
        }
    }

}

extension Subscriptions {

    final class Anonymous<SubscriberType: Subscriber, Output, Failure>: Subscription where SubscriberType.Input == Output, Failure == SubscriberType.Failure {

        private var subscriber: SubscriberType?

        init(subscriber: SubscriberType) {
            self.subscriber = subscriber
        }

        func start(_ closure: @escaping (AnySubscriber<Output, Failure>) -> Void) {
            if let subscriber = subscriber {
                closure(AnySubscriber(subscriber))
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // Irgnore demand
        }

        func cancel() {
            self.subscriber = nil
        }

    }

}

extension AnyPublisher {

    static func create(_ closure: @escaping (AnySubscriber<Output, Failure>) -> Void) -> AnyPublisher<Output, Failure> {
        return Publishers.Anonymous<Output, Failure>(closure: closure)
            .eraseToAnyPublisher()
    }

}
