import Foundation
import Observation

@Observable
class EventsViewModel {
    var events: [WellnessEvent] = []
    var searchText: String = ""
    var selectedCategory: EventCategory? = nil
    var maxPrice: Double = 2000

    private let eventsKey = "wellnessEventsStore"

    init() {
        loadEvents()
    }

    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let saved = try? JSONDecoder().decode([WellnessEvent].self, from: data) {
            events = saved
        } else {
            events = MockData.sampleEvents
            saveEvents()
        }
    }

    func saveEvents() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: eventsKey)
        }
    }

    // MARK: - Filtered Events

    var filteredEvents: [WellnessEvent] {
        events.filter { event in
            let matchesSearch = searchText.isEmpty
                || event.title.localizedCaseInsensitiveContains(searchText)
                || event.location.localizedCaseInsensitiveContains(searchText)
                || event.organizerName.localizedCaseInsensitiveContains(searchText)
                || event.description.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || event.category == selectedCategory
            let matchesPrice = event.ticketPrice <= maxPrice
            return matchesSearch && matchesCategory && matchesPrice
        }
        .sorted { $0.date < $1.date }
    }

    func events(for organizerId: String) -> [WellnessEvent] {
        events.filter { $0.organizerId == organizerId }
            .sorted { $0.date < $1.date }
    }

    // MARK: - CRUD

    func addEvent(_ event: WellnessEvent) {
        events.append(event)
        saveEvents()
    }

    func updateEvent(_ event: WellnessEvent) {
        if let idx = events.firstIndex(where: { $0.id == event.id }) {
            events[idx] = event
            saveEvents()
        }
    }

    func deleteEvent(id: String) {
        events.removeAll { $0.id == id }
        saveEvents()
    }

    func incrementAttendee(eventId: String, by count: Int = 1) {
        if let idx = events.firstIndex(where: { $0.id == eventId }) {
            events[idx].attendeeCount = min(
                events[idx].attendeeCount + count,
                events[idx].maxCapacity
            )
            saveEvents()
        }
    }

    // MARK: - Stats for organizer

    func totalRevenue(for organizerId: String) -> Double {
        events(for: organizerId).reduce(0) { $0 + $1.revenue }
    }

    func totalAttendees(for organizerId: String) -> Int {
        events(for: organizerId).reduce(0) { $0 + $1.attendeeCount }
    }
}
