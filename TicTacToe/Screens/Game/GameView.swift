//
//  GameView.swift
//  TicTacToe
//
//  Created by Алексей on 30.09.2024.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Constants.Colors.background
            VStack {
                HeaderView()
                .padding(.horizontal, 30)
                .padding(.top, 122)
                
                HStack {
                    PlayerIndicator(image: viewModel.currentPlayer == .human
                                    ? Constants.Skins.xSkin1
                                    : Constants.Skins.oSkin1)
                    Text(viewModel.currentPlayer == .human ? "Your turn" : "Player Two turn")
                        .font(.system(size: 20).bold())
                        .padding(.bottom, 44)
                        .padding(.top, 55)
                        .offset(y: -4)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                        .shadow(color: Constants.Colors.blue.opacity(0.3), radius: 15)
                    
                    GeometryReader { geometry in
                        ZStack {
                            LazyVGrid(columns: viewModel.columns, spacing: 20) {
                                ForEach(0..<9) { item in
                                    ZStack {
                                        GameSquareView(proxy: geometry)
                                        PlayerIndicator(image: viewModel.moves[item]?.indicator)
                                    }
                                    .onTapGesture {
                                        viewModel.processPlayerMove(for: item)
                                    }
                                }
                            }
                        }
                        .disabled(viewModel.isGameboardDisabled)
                    }
                    .padding(20)
                }
                .frame(width: UIScreen.main.bounds.width - 88, height: UIScreen.main.bounds.width - 88)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        didDismiss()
                    }
                }, label: {
                    Constants.Icons.back
                })
            }
        }
        .fullScreenCover(isPresented: $viewModel.isFinishedGame, onDismiss: didDismiss) {
            ResultView(
                text: viewModel.statusGame?.title ?? "",
                image: viewModel.statusGame?.image ?? Constants.Icons.win
            )
        }
    }
    
    private func didDismiss() {
        viewModel.resetGame()
    }
}

//#Preview {
//    GameView()
//}