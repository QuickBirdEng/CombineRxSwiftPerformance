# Combine vs. RxSwift Performance Benchmark Test Suite 📊
This project contains a benchmarking test suite for comparing the performance of the most commonly used components and operators in RxSwift and Combine. For a detailed comparison of RxSwift with Combine have a look at [our blog post](https://quickbirdstudios.com/blog/?p=831).

The RxSwift performance benchmark tests are [the original ones used in the RxSwift project](https://github.com/ReactiveX/RxSwift/blob/master/Tests/Benchmarks/Benchmarks.swift). We removed the two tests from RxCocoa testing Drivers, since there is no equivalent in Combine. The Combine tests are 1:1 translated tests from the Rx test-suite and should, therefore, be easily comparable.

**Important update:** As mentioned correctly the old numbers were created with XCTests running in DEBUG mode. The differences seem not so critical in Release builds. We have updated all the numbers and graphs to use release builds.

![](https://quickbirdstudios.com/files/benchmarks/all_release.png)

As a summary Combine was faster in every test and on average 41% more performant than RxSwift. These statistics show every test-method and its results. Lower is better.

## Test Results Summary

### Testing Details #1

**Machine**: MacBook Pro 2018, 2,7 GHz Intel Core i7, 16 GB
**IDE**: Xcode 11.0 beta 5 (11M382q)
**Testing Device**: iPhone XR Simulator

**Test** | **RxSwift (ms)** | **Combine (ms)** | **Factor**
--- | --- | --- | ---
**PublishSubjectPumping** | 227 | 135 | 168%
**PublishSubjectPumpingTwoSubscriptions** | 400 | 246 | 163%
**PublishSubjectCreating** | 295 | 250 | 118%
**MapFilterPumping** | 123 | 132 | 93%
**MapFilterCreating** |168 | 114 | 147%
**FlatMapsPumping** | 646 | 367 | 176%
**FlatMapsCreating** | 214 | 121 | 177%
**FlatMapLatestPumping** | 810 | 696 | 116%
**FlatMapLatestCreating** | 263 | 180 | 146%
**CombineLatestPumping** | 298 | 282 | 106%
**CombineLatestCreating** | 644 | 467 | 138%

### Testing Details #2

**IDE**: Xcode 15.0 beta 8 (15A5229m)
**Testing Device**: iPhone 7 Plus, iOS 15.7.8
**RxSwift Version: 6.5.0**

**Test** | **RxSwift (ms)** | **Combine (ms)** | **Factor**
--- | --- | --- | ---
**PublishSubjectPumping** | 830 | 224 | 370%
**PublishSubjectPumpingTwoSubscriptions** | 1198 | 940 | 127%
**PublishSubjectCreating** | 428 | 386 | 11%
**MapFilterPumping** | 217 | 15 | 1446%
**MapFilterCreating** |223 | 165 | 135%
**FlatMapsPumping** | 983 | 718 | 137%
**FlatMapsCreating** | 290 | 233 | 124%
**FlatMapLatestPumping** | 1027 | 653 | 157%
**FlatMapLatestCreating** | 299 | 222 | 135%
**CombineLatestPumping** | 449 | 474 | 94%
**CombineLatestCreating** | 686 | 740 | 93%

## Performance Test Example: PublishSubject Pumping

For every test we replace the RxSwift component with the corresponding Combine component. In this case `PublishSubject` with `PassthroughSubject`.

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

## Detailed Performance Test Results: RxSwift vs. Combine

### PublishSubjectPumping 

![](https://quickbirdstudios.com/files/benchmarks/1_release.png)

### PublishSubjectPumpingTwoSubscriptions

![](https://quickbirdstudios.com/files/benchmarks/2_release.png)

### PublishSubjectCreating

![](https://quickbirdstudios.com/files/benchmarks/3_release.png)

### MapFilterPumping

![](https://quickbirdstudios.com/files/benchmarks/4_release.png)

### MapFilterCreating

![](https://quickbirdstudios.com/files/benchmarks/5_release.png)

### FlatMapsPumping

![](https://quickbirdstudios.com/files/benchmarks/6_release.png)

### FlatMapsCreating

![](https://quickbirdstudios.com/files/benchmarks/7_release.png)

### FlatMapLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/8_release.png)

### FlatMapLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/9_release.png)

### CombineLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/10_release.png)

### CombineLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/11_release.png)

