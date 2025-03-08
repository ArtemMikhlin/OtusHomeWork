import SwiftUI

struct MediaView: View {
    let media: Media
    
    var body: some View {
        if let url = URL(string: media.filePath) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
        }
    }
}
