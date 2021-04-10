//
//  fieldView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 09/04/2021.
//

import SwiftUI

struct field: View {
    var viewModel: gameViewController
    var grid: Array<Array<Cell>>
    var selectedCard: Card!
//    @State private var placeCard = false
    var body: some View {
        ForEach(grid, id: \.self) { row in
            HStack{
                ForEach(row) { cell in
                    CellView(cell: cell, selectedCard: selectedCard, viewModel: viewModel)
                    
                }
            }
        }
        
    }
}

struct placeCardView: View {
    var card: Card
    var cell: Cell
    var viewModel: gameViewController
    

    @State var showCard = false
    
    var body: some View {
        ZStack {
            Image(card.cardImage)
                .resizable()
                .blendMode(.multiply)
                .aspectRatio(contentMode: .fit)
                .onAppear {
                    withAnimation(Animation.easeIn(duration: 1)){
                        showCard = true

                    }
                }.opacity(showCard ? 1 : 0)
        }

    }
}

struct CellView: View {
    var cell: Cell
    var selectedCard: Card
    var viewModel: gameViewController
    @State var placeCard = false
    @State var invalidMoveText = "This is an invalid move"
    @State private var isInvalidPlay: Bool = false //
    
    var body: some View{
        let cardWidth: CGFloat = 82.0
        let cardHeight: CGFloat = 126.0
        ZStack {
            if cell.hasCard {
                if cell.card.isFaceUp {
                        Image(cell.card.cardImage)
                            .resizable()
                            .blendMode(.multiply)
                            .aspectRatio(contentMode: .fit)

                            
                } else {
                    Image("GC_Face_Down")
                        .resizable()
                        .blendMode(.multiply)
                        .aspectRatio(contentMode: .fit)
                }
            } else {
                RoundedRectangle(cornerRadius: 2).fill(Color.white).onTapGesture {
                    placeCard = true
                    let error = viewModel.placeCard(cell: cell)
                    if  error == .succes {
                        viewModel.endTurn()
                    } else {
                        isInvalidPlay = true
                        invalidMoveText = error.rawValue
                    }
                    
                }
                RoundedRectangle(cornerRadius: 2.0).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4])).frame(width: cardWidth, height: cardHeight)
            }
            if placeCard {
                placeCardView(card: selectedCard,cell: cell, viewModel: viewModel).onAppear(){
                    placeCard = false
                }
                
            }
            
        }.padding(0)
        .alert(isPresented: $isInvalidPlay){
            Alert(title: Text(invalidMoveText))
        }


    }
}
