# Combine vs RxSwift Benchmarking Suite 📊
This project contains two simple test classes for comparing the performance of the most commonly used components and operators in RsSwift and Combine.

The RxSwift benchmarking tests are the original ones used in the RxSwift project without the two tests from RxCocoa testing Drivers, since there is no equivalent in Combine. The Combine tests are 1:1 translated tests from the Rx test-suite and should therefore be easily comparable. 

[image:76581B5C-6E7F-4032-A870-F5D03943976F-412-00001272010FDE92/Bildschirmfoto 2019-08-04 um 17.34.16.png]

As a summary Combine was faster in every test and on average 4,5x more performant than RxSwift. These statistics shows every test-method and it's result. Lower is better.

## Test example: PublishSubject pumping
### RxSwift
```swift
func testPublishSubjectPumping() {
    measure {
        var sum = 0
        let subject = PublishSubject<Int>()

        let subscription = subject
            .subscribe(onNext: { x in
                sum += x
            })

        for _ in 0 ..< iterations * 100 {
            subject.on(.next(1))
        }

        subscription.dispose()

        XCTAssertEqual(sum, iterations * 100)
    }
}
```

### Combine
```swift
func testPublishSubjectPumping() {
    measure {
        var sum = 0
        let subject = PassthroughSubject<Int, Never>()

        let subscription = subject
            .sink(receiveValue: { x in
                sum += x
            })

        for _ in 0 ..< iterations * 100 {
            subject.send(1)
        }
        
        subscription.cancel()
        
        XCTAssertEqual(sum, iterations * 100)
    }
}
```

## Test Results

*Test* | *RxSwift (ms)* | *Combine (ms)* | *Factor*
--- | --- | --- | ---
*PublishSubjectPumping* | 2.463 | 495 | 4,98x
*PublishSubjectPumpingTwoSubscriptions* | 4.182 | 618 | 6,77x
*PublishSubjectCreating* | 841 | 341 | 2,47x
*MapFilterPumping* | 1.321 | 181 | 7,30x
*MapFilterCreating* |512 | 160 | 3,20x
*FlatMapsPumping* | 2.444 | 419 | 5,83x
*FlatMapsCreating* | 673 | 149 | 4,52x
*FlatMapLatestPumping* | 1.873 | 766 | 2,45x
*FlatMapLatestCreating* | 551 | 208 | 2,65x
*CombineLatestPumping* | 1.284 | 313 | 4,10x
*CombineLatestCreating* | 1.743 | 400 | 4,36x


