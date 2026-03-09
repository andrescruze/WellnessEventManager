import SwiftUI

@main
struct WellnessEventsApp: App {
    @State private var authViewModel = AuthViewModel()
    @State private var eventsViewModel = EventsViewModel()
    @State private var ticketsViewModel = TicketsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authViewModel)
                .environment(eventsViewModel)
                .environment(ticketsViewModel)
        }
    }
}
