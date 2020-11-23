//
//  BadgedAppIcon.swift
//  Recency
//
//  Created by Joao Boavida on 23/11/2020.
//

import SwiftUI

/// This view builds a badged app icon from app's the appstore icon by overlaying a red circle and a number. Used in the notification authorisation request screen.
struct BadgedAppIcon: View {

    /// The outer frame length of the view, which is square, containing all the elements
    let frameLength: CGFloat

    /// The inner frame containing the app icon
    var innerFrameLength: CGFloat {
        frameLength*2/3
    }

    var body: some View {
        ZStack {
            Image("largeAppIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: innerFrameLength, height: innerFrameLength)
                .clipShape(RoundedRectangle(cornerRadius: innerFrameLength/4))
            ZStack {
                Group {
                    Circle()
                        .frame(width: innerFrameLength/2, height: innerFrameLength/2)
                        .foregroundColor(.red)
                    Text("1")
                        .foregroundColor(.white)
                        .font(.system(size: innerFrameLength/3))
                }
                .offset(x: innerFrameLength/2, y: -innerFrameLength/2)
            }

        }
        .frame(width: frameLength, height: frameLength)
    }

}

struct BadgedAppIcon_Previews: PreviewProvider {
    static var previews: some View {
            BadgedAppIcon(frameLength: 200)
                //.preferredColorScheme(.dark)
    }

}
