import SwiftUI

struct AttendeeListView: View {
    let event: WellnessEvent
    @State private var searchText = ""

    var attendees: [(name: String, ticketId: String, date: String)] {
        let total = event.attendeeCount
        return (0..<total).map { idx in
            let name = MockData.attendeeNames[idx % MockData.attendeeNames.count]
            let ticketId = "TK-\(String(format: "%04d", idx + 1001))"
            let daysAgo = Int.random(in: 1...14)
            let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
            return (
                name: name,
                ticketId: ticketId,
                date: date.formatted(.dateTime.month().day())
            )
        }
    }

    var filtered: [(name: String, ticketId: String, date: String)] {
        if searchText.isEmpty { return attendees }
        return attendees.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ZStack {
            Color.appBeige.ignoresSafeArea()

            VStack(spacing: 0) {
                // Stats banner
                HStack(spacing: 0) {
                    BannerStat(icon: "person.2.fill", value: "\(event.attendeeCount)", label: "Registered", color: Color.appMint)
                    Divider().frame(height: 40)
                    BannerStat(icon: "person.badge.clock", value: "\(event.availableSpots)", label: "Spots Left", color: Color.appBlue)
                    Divider().frame(height: 40)
                    BannerStat(
                        icon: "chart.pie.fill",
                        value: "\(Int(Double(event.attendeeCount) / Double(max(event.maxCapacity, 1)) * 100))%",
                        label: "Capacity",
                        color: Color.appLavender
                    )
                }
                .padding(.vertical, 14)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Search attendees", text: $searchText)
                }
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .padding(.top, 12)

                if event.attendeeCount == 0 {
                    Spacer()
                    EmptyStateView(
                        icon: "person.2",
                        title: "No attendees yet",
                        subtitle: "When people book this event, they'll appear here."
                    )
                    .padding(.horizontal)
                    Spacer()
                } else if filtered.isEmpty {
                    Spacer()
                    EmptyStateView(icon: "magnifyingglass", title: "No results", subtitle: "No attendees match your search.")
                        .padding(.horizontal)
                    Spacer()
                } else {
                    List(filtered, id: \.ticketId) { attendee in
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.appLavender.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                Text(String(attendee.name.prefix(1)))
                                    .font(.headline)
                                    .foregroundStyle(Color(hex: "4A148C"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(attendee.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.appDarkText)
                                Text("Booked \(attendee.date)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(attendee.ticketId)
                                    .font(.caption)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.appMint)
                                    .font(.caption)
                            }
                        }
                        .listRowBackground(Color.white)
                        .listRowSeparatorTint(Color.appGray)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.appBeige)
                }
            }
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct BannerStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.subheadline).foregroundStyle(color)
            Text(value).font(.headline).fontWeight(.bold).foregroundStyle(Color.appDarkText)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        AttendeeListView(event: MockData.sampleEvents[0])
    }
}
