import SwiftUI

struct TicketDetailView: View {
    let ticket: Ticket

    var body: some View {
        ZStack {
            Color.appBeige.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Ticket card
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(ticket.eventCategory.badgeColor.opacity(0.2))
                                    .frame(width: 70, height: 70)
                                Image(systemName: ticket.eventImageName)
                                    .font(.largeTitle)
                                    .foregroundStyle(ticket.eventCategory.badgeColor)
                            }
                            CategoryBadge(category: ticket.eventCategory)
                            Text(ticket.eventTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.appDarkText)
                                .multilineTextAlignment(.center)
                            Text("by \(ticket.organizerName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)

                        // Dashed divider with circles
                        TicketDivider()

                        // QR code section
                        VStack(spacing: 16) {
                            Text("Scan at entry")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .tracking(1.5)
                                .textCase(.uppercase)

                            QRCodeView(data: ticket.qrCodeData, size: 200)
                                .padding(16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.appMint, lineWidth: 2)
                                )
                                .shadow(color: Color.appMint.opacity(0.2), radius: 8)

                            Text(ticket.qrCodeData)
                                .font(.caption2)
                                .fontDesign(.monospaced)
                                .foregroundStyle(Color.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)

                        // Dashed divider
                        TicketDivider()

                        // Details
                        VStack(spacing: 14) {
                            TicketDetailRow(icon: "calendar", label: "Date", value: ticket.eventDate.formatted(.dateTime.weekday().month().day().year()))
                            TicketDetailRow(icon: "clock", label: "Time", value: ticket.eventDate.formatted(.dateTime.hour().minute()))
                            TicketDetailRow(icon: "mappin.and.ellipse", label: "Location", value: ticket.eventLocation)
                            TicketDetailRow(icon: "ticket.fill", label: "Tickets", value: "\(ticket.ticketCount) × General Admission")
                            TicketDetailRow(icon: "creditcard", label: "Total Paid", value: String(format: "$%.2f", ticket.totalPrice))
                            TicketDetailRow(icon: "number", label: "Booking ID", value: "#\(ticket.id.prefix(8).uppercased())")
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0, bottomLeadingRadius: 16,
                                bottomTrailingRadius: 16, topTrailingRadius: 0
                            )
                        )
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appMint, lineWidth: 1.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 5)
                    .padding(.horizontal)

                    // Status badge
                    HStack(spacing: 6) {
                        Circle()
                            .fill(ticket.isUpcoming ? Color.appMint : Color.appGray)
                            .frame(width: 8, height: 8)
                        Text(ticket.isUpcoming ? "Upcoming Event" : "Past Event")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(ticket.isUpcoming ? Color(hex: "1E5631") : .secondary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(ticket.isUpcoming ? Color.appMint.opacity(0.15) : Color.appGray.opacity(0.2))
                    .clipShape(Capsule())

                    Text("Purchased on \(ticket.purchaseDate.formatted(.dateTime.month().day().year()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Your Ticket")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TicketDivider: View {
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.appBeige)
                .frame(width: 24, height: 24)
                .offset(x: -12)

            Rectangle()
                .fill(Color.appGray.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 8)

            Circle()
                .fill(Color.appBeige)
                .frame(width: 24, height: 24)
                .offset(x: 12)
        }
        .background(Color.white)
    }
}

private struct TicketDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.appBlue)
                .frame(width: 22)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.appDarkText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        TicketDetailView(ticket: Ticket(
            eventId: "evt1",
            userId: "att1",
            eventTitle: "Sunrise Yoga Retreat in Bali",
            eventDate: Date().addingTimeInterval(86400 * 14),
            eventLocation: "Ubud, Bali, Indonesia",
            eventCategory: .retreat,
            organizerName: "Maya Patel",
            ticketCount: 2,
            totalPrice: 2400,
            qrCodeData: "WE-evt1-att1-ABCDE123",
            eventImageName: "figure.yoga"
        ))
    }
}
