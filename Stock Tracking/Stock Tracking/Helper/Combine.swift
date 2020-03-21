import Combine

extension Publisher where Self.Failure == Never {
    public func assignWeak<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Publisher {
    public func assignError<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Failure?>, on object: Root) -> AnyPublisher<Self.Output, Never> where Root: AnyObject {
        self.catch { [weak object] error -> Empty<Self.Output, Never> in
            object?[keyPath: keyPath] = error
            return Empty<Self.Output, Never>()
        }
        .eraseToAnyPublisher()
    }
    public func assignError<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Failure?>, on object: Root, replaceWith replacement: Self.Output) -> AnyPublisher<Self.Output, Never> where Root: AnyObject {
        return self.mapError { [weak object] error -> Self.Failure in
            object?[keyPath: keyPath] = error
            return error
        }
        .replaceError(with: replacement)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    public func filterNil<T>() -> AnyPublisher<T, Self.Failure> where Self.Output == T? {
        filter { $0 != nil }
            .map { $0! }
            .eraseToAnyPublisher()
    }
}
