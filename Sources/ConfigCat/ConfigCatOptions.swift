import Foundation

/// Configuration options for `ConfigCatClient`.
public final class ConfigCatOptions {
    /**
     Default: `DataGovernance.global`. Set this parameter to be in sync with the
     Data Governance preference on the [Dashboard](https://app.configcat.com/organization/data-governance).
     (Only Organization Admins have access)
     */
    public var dataGovernance: DataGovernance = .global

    /// The cache implementation used to cache the downloaded config.json.
    public var configCache: ConfigCache? = UserDefaultsCache()

    /// The polling mode.
    public var pollingMode: PollingMode = PollingModes.autoPoll()

    /// Custom `URLSessionConfiguration` used by the HTTP calls.
    public var sessionConfiguration: URLSessionConfiguration = .default

    /// The base ConfigCat CDN url.
    public var baseUrl: String = ""

    /// Feature flag and setting overrides.
    public var flagOverrides: OverrideDataSource? = nil

    /// Default: `LogLevel.warning`. The internal log level.
    public var logLevel: ConfigCatLogLevel = .warning
    
    /// The logger used by the SDK.
    public var logger: ConfigCatLogger = NoLogger()

    /// The default user, used as fallback when there's no user parameter is passed to the getValue() method.
    public var defaultUser: ConfigCatUser? = nil

    /// Hooks for events sent by ConfigCatClient.
    public let hooks: Hooks = Hooks()

    /// Indicates whether the SDK should be initialized in offline mode or not.
    public var offline: Bool = false

    /// The default client configuration options.
    public static var `default`: ConfigCatOptions {
        get {
            ConfigCatOptions()
        }
    }
}

/// Describes the initialization state of the `ConfigCatClient`.
public enum ClientReadyState: Int {
    /// The SDK has no feature flag data neither from the cache nor from the ConfigCat CDN.
    case noFlagData
    /// The SDK runs with local only feature flag data.
    case hasLocalOverrideFlagDataOnly
    /// The SDK has feature flag data to work with only from the cache.
    case hasCachedFlagDataOnly
    /// The SDK works with the latest feature flag data received from the ConfigCat CDN.
    case hasUpToDateFlagData
}

/// Hooks for events sent by `ConfigCatClient`.
public final class Hooks {
    private let mutex: Mutex = Mutex(recursive: true);
    private var readyState: ClientReadyState?
    private var onReady: [(ClientReadyState) -> ()] = []
    private var onFlagEvaluated: [(EvaluationDetails) -> ()] = []
    private var onConfigChanged: [(Config) -> ()] = []
    private var onError: [(String) -> ()] = []

    /**
     Subscribes a handler to the `onReady` hook.
     - Parameter handler: The handler to subscribe.
     */
    public func addOnReady(handler: @escaping (ClientReadyState) -> ()) {
        mutex.lock()
        defer { mutex.unlock() }
        if let readyState = self.readyState {
            handler(readyState)
        } else {
            onReady.append(handler)
        }
    }

    /**
     Subscribes a handler to the `onFlagEvaluated` hook.
     - Parameter handler: The handler to subscribe.
     */
    public func addOnFlagEvaluated(handler: @escaping (EvaluationDetails) -> ()) {
        mutex.lock()
        defer { mutex.unlock() }
        onFlagEvaluated.append(handler)
    }

    /**
     Subscribes a handler to the `onConfigChanged` hook.
     - Parameter handler: The handler to subscribe.
     */
    public func addOnConfigChanged(handler: @escaping (Config) -> ()) {
        mutex.lock()
        defer { mutex.unlock() }
        onConfigChanged.append(handler)
    }

    /**
     Subscribes a handler to the `onError` hook.
     - Parameter handler: The handler to subscribe.
     */
    public func addOnError(handler: @escaping (String) -> ()) {
        mutex.lock()
        defer { mutex.unlock() }
        onError.append(handler)
    }

    func invokeOnReady(state: ClientReadyState) {
        mutex.lock()
        defer { mutex.unlock() }
        readyState = state
        for item in onReady {
            item(state);
        }
    }

    func invokeOnConfigChanged(config: Config) {
        mutex.lock()
        defer { mutex.unlock() }
        for item in onConfigChanged {
            item(config);
        }
    }

    func invokeOnFlagEvaluated(details: EvaluationDetails) {
        mutex.lock()
        defer { mutex.unlock() }
        for item in onFlagEvaluated {
            item(details);
        }
    }

    func invokeOnError(error: String) {
        mutex.lock()
        defer { mutex.unlock() }
        for item in onError {
            item(error);
        }
    }

    func clear() {
        mutex.lock()
        defer { mutex.unlock() }
        onError.removeAll()
        onFlagEvaluated.removeAll()
        onConfigChanged.removeAll()
        onReady.removeAll()
    }
}
