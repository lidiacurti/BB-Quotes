//
//  QuoteView.swift
//  BB Quotes
//
//  Created by ulixe on 24/04/24.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    @State private var showCharacterInfo = false
    let show: String
    
    var body: some View {
        // per avere le proporzioni giuste
        GeometryReader {geo in
            ZStack {
                Image(show.lowerNoSpaces)
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                VStack {
                    VStack {
                        Spacer(minLength: 140)
                        
                        switch viewModel.status {
                            
                        case .fetching:
                            ProgressView()
                        case .success(let data):
                            Text("\"\(data.quote.quote)\"")
                            // per scalare il testo se diventa troppo lungo in modo che ci stia nella view
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .cornerRadius(25)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                
                                AsyncImage(url: data.character.images[0]) { image in
                                    image.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                .onTapGesture {
                                    showCharacterInfo.toggle()
                                }
                                .sheet(isPresented: $showCharacterInfo, content: {
                                    CharacterView(show: show, character: data.character)
                                })
                                
                                
                                Text(data.quote.character)
                                    .foregroundColor(.white)
                                    .padding(10)
                                
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .cornerRadius(80)
                        default:
                            EmptyView()
                            
                            
                        }
                        Spacer()
                    }
                    
                    Button {
                        // serve il task se no non posso chiamare una funzione asincrona
                        Task {
                            await viewModel.getData(for: show)
                        }
                    } label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("\(show.noSpaces)Button"))
                            .cornerRadius(10)
                            .shadow(color: Color("\(show.noSpaces)Shadow"),radius: 2)
                    }
                    
                    Spacer(minLength: 180)
                }
                .frame(width: geo.size.width)
                    
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    QuoteView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
