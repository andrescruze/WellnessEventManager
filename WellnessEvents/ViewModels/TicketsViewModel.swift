import Foundation
import Observation

@Observable
class TicketsViewModel {
    var tickets: [Ticket] = []

    private let ticketsKey = "userTicketsStore"

    init() {
        loadTickets()
    }

    private func loadTickets() {
        if let data = UserDefaults.standard.data(forKey: ticketsKey),
           let saved = try? JSONDecoder().decode([Ticket].self, from: data) {
            tickets = saved
        }
    }

    func saveTickets() {
        if let data = try? JSONEncoder().encode(tickets) {
            UserDefaults.standard.set(data, forKey: ticketsKey)
        }
    }

    @discardableResult
    func purchaseTicket(event: WellnessEvent, userId: String, count: Int) -> Ticket {
        let qrData = "WE-\(event.id)-\(userId)-\(UUID().uuidString.prefix(8))"
        let ticket = Ticket(
            eventId: event.id,
            userId: userId,
            eventTitle: event.title,
            eventDate: event.date,
            eventLocation: event.location,
            eventCategory: event.category,
            organizerName: event.organizerName,
            ticketCount: count,
            totalPrice: Double(count) * event.ticketPrice,
            qrCodeData: qrData,
            eventImageName: event.imageName
        )
        tickets.append(ticket)
        saveTickets()
        return ticket
    }

    func tickets(for userId: String) -> [Ticket] {
        tickets.filter { $0.userId == userId }
            .sorted { $0.purchaseDate > $1.purchaseDate }
    }

    func upcomingTickets(for userId: String) -> [Ticket] {
        tickets(for: userId).filter { $0.isUpcoming }
    }

    func pastTickets(for userId: String) -> [Ticket] {
        tickets(for: userId).filter { !$0.isUpcoming }
    }
}
