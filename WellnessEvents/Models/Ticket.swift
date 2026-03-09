import Foundation

struct Ticket: Identifiable, Codable {
    var id: String
    var eventId: String
    var userId: String
    var eventTitle: String
    var eventDate: Date
    var eventLocation: String
    var eventCategory: EventCategory
    var organizerName: String
    var purchaseDate: Date
    var ticketCount: Int
    var totalPrice: Double
    var qrCodeData: String
    var eventImageName: String

    init(
        id: String = UUID().uuidString,
        eventId: String,
        userId: String,
        eventTitle: String,
        eventDate: Date,
        eventLocation: String,
        eventCategory: EventCategory,
        organizerName: String,
        purchaseDate: Date = Date(),
        ticketCount: Int,
        totalPrice: Double,
        qrCodeData: String,
        eventImageName: String
    ) {
        self.id = id
        self.eventId = eventId
        self.userId = userId
        self.eventTitle = eventTitle
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventCategory = eventCategory
        self.organizerName = organizerName
        self.purchaseDate = purchaseDate
        self.ticketCount = ticketCount
        self.totalPrice = totalPrice
        self.qrCodeData = qrCodeData
        self.eventImageName = eventImageName
    }

    var isUpcoming: Bool {
        eventDate > Date()
    }
}
