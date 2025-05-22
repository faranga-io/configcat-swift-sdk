import Foundation

public class OverrideDataSource {
    let behaviour: OverrideBehaviour

    init(behaviour: OverrideBehaviour) {
        self.behaviour = behaviour
    }

    public func getOverrides() -> [String: Setting] {
        [:]
    }
}
