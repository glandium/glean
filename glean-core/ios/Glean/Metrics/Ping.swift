/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

/// This implements the developer facing API for custom pings.
///
/// Instances of this class type are automatically generated by the parsers at build time.
///
/// The Ping API only exposes the `Ping.send()` method, which schedules a ping for sending.
public class Ping {
    var handle: UInt64
    let name: String
    let includeClientId: Bool

    /// The public constructor used by automatically generated metrics.
    public init(name: String, includeClientId: Bool, sendIfEmpty: Bool) {
        self.name = name
        self.includeClientId = includeClientId
        self.handle = glean_new_ping_type(name, includeClientId.toByte(), sendIfEmpty.toByte())
        NSLog("Registering this ping: \(name)")
        Glean.shared.registerPingType(self)
    }

    /// Destroy this ping type.
    deinit {
        if self.handle != 0 {
            glean_destroy_ping_type(self.handle)
        }
    }

    /// Send the ping.
    ///
    /// While the collection of metrics into pings happens synchronously, the
    /// ping queuing and ping uploading happens asyncronously.
    /// There are no guarantees that this will happen immediately.
    ///
    /// If the ping currently contains no content, it will not be queued.
    public func send() {
        Glean.shared.sendPings([self])
    }
}
