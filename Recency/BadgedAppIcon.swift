//
//  BadgedAppIcon.swift
//  Recency
//
//  Created by Joao Boavida on 23/11/2020.
//

import SwiftUI

struct BadgedAppIcon: View {

    let frameLength: CGFloat

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
