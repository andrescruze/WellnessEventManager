import SwiftUI

struct MyTicketsView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(TicketsViewModel.self) private var ticketsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                let userId = authViewModel.currentUser?.id ?? ""
                let upcoming = ticketsViewModel.upcomingTickets(for: userId)
                let past = ticketsViewModel.pastTickets(for: userId)

                if upcoming.isEmpty && past.isEmpty {
                    EmptyStateView(
                        icon: "ticket",
                        title: "No tickets yet",
                        subtitle: "Browse upcoming wellness events and book your first experience. Your tickets will appear here."
                    )
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if !upcoming.isEmpty {
                                TicketSection(title: "Upcoming", icon: "calendar.badge.clock", tickets: upcoming)
                            }
                            if !past.isEmpty {
                                TicketSection(title: "Past Events", icon: "clock.arrow.circlepath", tickets: past)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle("My Tickets")
        }
    }
}

private struct TicketSection: View {
    let title: String
    let icon: String
    let tickets: [Ticket]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(Color.appBlue)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.appBlue)
                Text("(\(tickets.count))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(tickets) { ticket in
                NavigationLink(destination: TicketDetailView(ticket: ticket)) {
                    TicketCardView(ticket: ticket)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct TicketCardView: View {
    let ticket: Ticket

    var body: some View {
        HStack(spacing: 0) {
            // Left accent bar
            Rectangle()
                .fill(ticket.isUpcoming ? Color.appMint : Color.appGray)
                .frame(width: 5)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 14, bottomLeadingRadius: 14,
                        bottomTrailingRadius: 0, topTrailingRadius: 0
                    )
                )

            HStack(spacing: 14) {
                // Event icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(ticket.eventCategory.badgeColor.opacity(0.2))
                        .frame(width: 52, height: 52)
                    Image(systemName: ticket.eventImageName)
                        .font(.title3)
                        .foregroundStyle(ticket.eventCategory.badgeColor)
                }

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(ticket.eventTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.appDarkText)
                        .lineLimit(2)
                    HStack(spacing: 8) {
                        Label(ticket.eventDate.formatted(.dateTime.month().day().year()), systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    HStack(spacing: 8) {
                        Label(ticket.eventLocation.components(separatedBy: ",").first ?? "", systemImage: "mappin")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(ticket.ticketCount) ticket\(ticket.ticketCount > 1 ? "s" : "")")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(ticket.isUpcoming ? Color.appMint : .secondary)
                    }
                }

                Spacer()

                // Mini QR code
                VStack(spacing: 4) {
                    QRCodeView(data: ticket.qrCodeData, size: 44)
                    Text("TAP")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .tracking(1)
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 14, topTrailingRadius: 14
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    MyTicketsView()
        .environment(AuthViewModel())
        .environment(TicketsViewModel())
}
