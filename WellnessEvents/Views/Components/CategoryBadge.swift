import SwiftUI

struct CategoryBadge: View {
    let category: EventCategory
    var small: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(small ? .caption2 : .caption)
            Text(category.rawValue)
                .font(small ? .caption2 : .caption)
                .fontWeight(.semibold)
        }
        .foregroundStyle(category.badgeTextColor)
        .padding(.horizontal, small ? 8 : 10)
        .padding(.vertical, small ? 4 : 6)
        .background(category.badgeColor.opacity(0.2))
        .overlay(
            Capsule().stroke(category.badgeColor, lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        CategoryBadge(category: .yoga)
        CategoryBadge(category: .soundBath)
        CategoryBadge(category: .meditation, small: true)
    }
    .padding()
    .background(Color.appBeige)
}
