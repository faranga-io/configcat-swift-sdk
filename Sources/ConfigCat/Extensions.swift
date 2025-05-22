import Foundation

extension ConfigCatClient {
    public func getStringValue(for key: String, defaultValue: String, user: ConfigCatUser?, completion: @escaping (String) -> ()) {
        return getValue(for: key, defaultValue: defaultValue, user: user, completion: completion)
    }

    public func getIntValue(for key: String, defaultValue: Int, user: ConfigCatUser?, completion: @escaping (Int) -> ()) {
        return getValue(for: key, defaultValue: defaultValue, user: user, completion: completion)
    }

    public func getDoubleValue(for key: String, defaultValue: Double, user: ConfigCatUser?, completion: @escaping (Double) -> ()) {
        return getValue(for: key, defaultValue: defaultValue, user: user, completion: completion)
    }

    public func getBoolValue(for key: String, defaultValue: Bool, user: ConfigCatUser?, completion: @escaping (Bool) -> ()) {
        return getValue(for: key, defaultValue: defaultValue, user: user, completion: completion)
    }

    public func getAnyValue(for key: String, defaultValue: Any, user: ConfigCatUser?, completion: @escaping (Any) -> ()) {
        return getValue(for: key, defaultValue: defaultValue, user: user, completion: completion)
    }

    public func getAnyValueDetails(for key: String, defaultValue: Any, user: ConfigCatUser?, completion: @escaping (EvaluationDetails) -> ()) {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
            completion(EvaluationDetails(key: details.key,
                    value: details.value,
                    variationId: details.variationId,
                    fetchTime: details.fetchTime,
                    user: user,
                    isDefaultValue: details.isDefaultValue,
                    error: details.error,
                    matchedTargetingRule: details.matchedTargetingRule,
                    matchedPercentageOption: details.matchedPercentageOption))
        }
    }

    public func getStringValueDetails(for key: String, defaultValue: String, user: ConfigCatUser?, completion: @escaping (StringEvaluationDetails) -> ()) {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
            completion(details.toStringDetails())
        }
    }

    public func getBoolValueDetails(for key: String, defaultValue: Bool, user: ConfigCatUser?, completion: @escaping (BoolEvaluationDetails) -> ()) {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
            completion(details.toBoolDetails())
        }
    }

    public func getIntValueDetails(for key: String, defaultValue: Int, user: ConfigCatUser?, completion: @escaping (IntEvaluationDetails) -> ()) {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
            completion(details.toIntDetails())
        }
    }

    public func getDoubleValueDetails(for key: String, defaultValue: Double, user: ConfigCatUser?, completion: @escaping (DoubleEvaluationDetails) -> ()) {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
            completion(details.toDoubleDetails())
        }
    }

    #if compiler(>=5.5) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getValue<Value>(for key: String, defaultValue: Value, user: ConfigCatUser? = nil) async -> Value {
        await withUnsafeContinuation { continuation in
            getValue(for: key, defaultValue: defaultValue, user: user) { value in
                continuation.resume(returning: value)
            }
        }
    }
    
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAnyValue(for key: String, defaultValue: Any?, user: ConfigCatUser? = nil) async -> Any? {
        await withUnsafeContinuation { continuation in
            getValue(for: key, defaultValue: defaultValue, user: user) { value in
                continuation.resume(returning: value)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getValueDetails<Value>(for key: String, defaultValue: Value, user: ConfigCatUser? = nil) async -> TypedEvaluationDetails<Value> {
        await withUnsafeContinuation { continuation in
            getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
                continuation.resume(returning: details)
            }
        }
    }
    
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAnyValueDetails(for key: String, defaultValue: Any?, user: ConfigCatUser? = nil) async -> TypedEvaluationDetails<Any?> {
        await withUnsafeContinuation { continuation in
            getValueDetails(for: key, defaultValue: defaultValue, user: user) { details in
                continuation.resume(returning: details)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAllValueDetails(user: ConfigCatUser? = nil) async -> [EvaluationDetails] {
        await withUnsafeContinuation { continuation in
            getAllValueDetails(user: user) { details in
                continuation.resume(returning: details)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAllKeys() async -> [String] {
        await withUnsafeContinuation { continuation in
            getAllKeys { keys in
                continuation.resume(returning: keys)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getKeyAndValue(for variationId: String) async -> KeyValue? {
        await withUnsafeContinuation { continuation in
            getKeyAndValue(for: variationId) { value in
                continuation.resume(returning: value)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func getAllValues(user: ConfigCatUser? = nil) async -> [String: Any] {
        await withUnsafeContinuation { continuation in
            getAllValues(user: user) { values in
                continuation.resume(returning: values)
            }
        }
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    @discardableResult
    public func forceRefresh() async -> RefreshResult {
        await withUnsafeContinuation { continuation in
            forceRefresh { result in
                continuation.resume(returning: result)
            }
        }
    }
    #endif
}

extension ConfigCatSnapshot {
    public func getStringValue(for key: String, defaultValue: String, user: ConfigCatUser?) -> String {
        return getValue(for: key, defaultValue: defaultValue, user: user)
    }

    public func getIntValue(for key: String, defaultValue: Int, user: ConfigCatUser?) -> Int {
        return getValue(for: key, defaultValue: defaultValue, user: user)
    }

    public func getDoubleValue(for key: String, defaultValue: Double, user: ConfigCatUser?) -> Double {
        return getValue(for: key, defaultValue: defaultValue, user: user)
    }

    public func getBoolValue(for key: String, defaultValue: Bool, user: ConfigCatUser?) -> Bool {
        return getValue(for: key, defaultValue: defaultValue, user: user)
    }

    public func getAnyValue(for key: String, defaultValue: Any, user: ConfigCatUser?) -> Any {
        return getValue(for: key, defaultValue: defaultValue, user: user)
    }

    public func getAnyValueDetails(for key: String, defaultValue: Any, user: ConfigCatUser?) -> EvaluationDetails {
        let details = getValueDetails(for: key, defaultValue: defaultValue, user: user)
        return EvaluationDetails(key: details.key,
                                 value: details.value,
                                 variationId: details.variationId,
                                 fetchTime: details.fetchTime,
                                 user: user,
                                 isDefaultValue: details.isDefaultValue,
                                 error: details.error,
                                 matchedTargetingRule: details.matchedTargetingRule,
                                 matchedPercentageOption: details.matchedPercentageOption)
    }

    public func getStringValueDetails(for key: String, defaultValue: String, user: ConfigCatUser?) -> StringEvaluationDetails {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user).toStringDetails()
    }

    public func getBoolValueDetails(for key: String, defaultValue: Bool, user: ConfigCatUser?) -> BoolEvaluationDetails {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user).toBoolDetails()
    }

    public func getIntValueDetails(for key: String, defaultValue: Int, user: ConfigCatUser?) -> IntEvaluationDetails {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user).toIntDetails()
    }

    public func getDoubleValueDetails(for key: String, defaultValue: Double, user: ConfigCatUser?) -> DoubleEvaluationDetails {
        return getValueDetails(for: key, defaultValue: defaultValue, user: user).toDoubleDetails()
    }
}
