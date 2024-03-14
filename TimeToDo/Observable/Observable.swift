//
//  Observable.swift
//  TimeToDo
//
//  Created by Minho on 3/8/24.
//

final class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    // MARK: bind를 하자마자 실행되는 현상을 방지하려고 closure 주석처리해 둠
    // MARK: MVVM 기준에서는 이것을 어떻게 처리하는지 알아보자.
    func bind(_ closure: @escaping (T) -> Void) {
        // closure(value)
        self.closure = closure
    }
}
