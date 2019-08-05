# Combine vs RxSwift Benchmarking Suite 📊
This project contains a benchmarking test suite for comparing the performance of the most commonly used components and operators in RxSwift and Combine. For a detailed comparison of RxSwift with Combine have a look at [our blog post](https://quickbirdstudios.com/blog/?p=831).

The RxSwift benchmarking tests are [the original ones used in the RxSwift project](https://github.com/ReactiveX/RxSwift/blob/master/Tests/Benchmarks/Benchmarks.swift). We removed the two tests from RxCocoa testing Drivers, since there is no equivalent in Combine. The Combine tests are 1:1 translated tests from the Rx test-suite and should, therefore, be easily comparable. 

![](https://quickbirdstudios.com/files/benchmarks/all.png)

As a summary Combine was faster in every test and on average 4,5x more performant than RxSwift. These statistics show every test-method and its results. Lower is better.

## Test Results Summary

**Test** | **RxSwift (ms)** | **Combine (ms)** | **Factor**
--- | --- | --- | ---
**PublishSubjectPumping** | 2.463 | 495 | 4,98x
**PublishSubjectPumpingTwoSubscriptions** | 4.182 | 618 | 6,77x
**PublishSubjectCreating** | 841 | 341 | 2,47x
**MapFilterPumping** | 1.321 | 181 | 7,30x
**MapFilterCreating** |512 | 160 | 3,20x
**FlatMapsPumping** | 2.444 | 419 | 5,83x
**FlatMapsCreating** | 673 | 149 | 4,52x
**FlatMapLatestPumping** | 1.873 | 766 | 2,45x
**FlatMapLatestCreating** | 551 | 208 | 2,65x
**CombineLatestPumping** | 1.284 | 313 | 4,10x
**CombineLatestCreating** | 1.743 | 400 | 4,36x

## Test example: PublishSubject pumping

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

## Detailed Test Results

### PublishSubjectPumping 

![](https://quickbirdstudios.com/files/benchmarks/1.png)

### PublishSubjectPumpingTwoSubscriptions

![](https://quickbirdstudios.com/files/benchmarks/2.png)

### PublishSubjectCreating

![](https://quickbirdstudios.com/files/benchmarks/3.png)

### MapFilterPumping

![](https://quickbirdstudios.com/files/benchmarks/4.png)

### MapFilterCreating

![](https://quickbirdstudios.com/files/benchmarks/5.png)

### FlatMapsPumping

![](https://quickbirdstudios.com/files/benchmarks/6.png)

### FlatMapsCreating

![](https://quickbirdstudios.com/files/benchmarks/7.png)

### FlatMapLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/8.png)

### FlatMapLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/9.png)

### CombineLatestPumping

![](https://quickbirdstudios.com/files/benchmarks/10.png)

### CombineLatestCreating

![](https://quickbirdstudios.com/files/benchmarks/11.png)


