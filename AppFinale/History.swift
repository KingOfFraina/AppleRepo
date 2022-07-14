/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

struct History: Identifiable, Codable {
    let id: UUID
    var transcript: String?

    init(id: UUID = UUID(), transcript: String? = nil){
        self.id = id
        self.transcript = transcript
    }
}
