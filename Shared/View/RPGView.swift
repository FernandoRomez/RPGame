//
//  RPGView.swift
//  RPG
//
//  Created by fernando meza on 20/04/22.
//

import SwiftUI

struct RPGView: View {
    
    @State var Partida = Game(player: Sujeto(id: 1, name: "Bueno"), enemy: Sujeto(id: 2, name: "Malo"), start: false, time: 20)
    
    var body: some View {
        VStack {
            ZStack {
                
                CounterView(Partida: $Partida)
                
                InfoView(Partida: $Partida)
                
            }
        }
    }
}
struct CounterView : View {
    @Binding var Partida : Game
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    HStack(alignment:.top) {
                        Score(Partida: $Partida)
                        
                        Text("Round \(Partida.round) : Time \(Partida.time)'s \n High Round \(Partida.highRound)  ")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding()
                            .foregroundColor(Color.yellow)
                    }
                    Spacer()
                }
                GameView(Partida: $Partida)
            }
            
        }.onReceive(timer) { time in
            if Partida.start {
                if Partida.time > 0 {
                    Partida.time -= 1
                } else {
                    Partida.start.toggle()
                }
            }
        }
    }
}

struct Score : View {
    @Binding var Partida : Game
    var body: some View {
        VStack(spacing:10) {
            Text(" LVL : \(Partida.player.level), life : \(Partida.player.life), DMG : \(Partida.player.damage) ").fontWeight(.bold)
            Text(" LVL : \(Partida.enemy.level), life : \(Partida.enemy.life), DMG : \(Partida.enemy.damage) ").fontWeight(.bold)
        }.foregroundColor(Color.yellow).padding().background(Color.red).cornerRadius(10).padding()
            
    }
}

struct GameView : View {
    @Binding var Partida : Game    //modificar la velocidad dependiendo el tamaño de la ventana
    @State var medida = 0.0
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let height = geometry.size.height
                let width = geometry.size.width
                let size: CGFloat = 100
                let heightMax = height - size
                let widthMax = width - size
                let xRandom: CGFloat = CGFloat(Int.random(in: 0..<Int(widthMax )))
                let yRandom: CGFloat = CGFloat(Int.random(in: 0..<Int(heightMax)))
                
                EnemyView(Partida: $Partida).position(x: xRandom , y: yRandom )
                
            }
        }.background(Color.white.opacity(0.2)).onTapGesture{
            Partida.Golpe(2)
        }
    }
}


struct EnemyView : View {
    @Binding var Partida : Game
    var body: some View {
        Text("😈").font(.largeTitle).padding().background(Color("Negro")).cornerRadius(10).onTapGesture{ Partida.Golpe(1) }
    }
}

struct InfoView : View {
    @Binding var Partida : Game
    
    var mensaje: String {
        var result = "Start"
        
        if Partida.winner.id == Partida.player.id {
            result = "YOU WIN!!! 👍🏽"
        }else if Partida.winner.id == Partida.enemy.id {
            result = "YOU LOST!! 👎🏽"
        }
        
        return result
    }
    var body: some View {
        if Partida.start == false {
            
            VStack {
                Text(mensaje).font(.title).fontWeight(.bold).foregroundColor(Color.yellow)
                HStack {
                    Button("reset") {  Partida.Reset() }
                    Partida.round == 0 ? Button("play") { Partida.Start() } : Button("next") { Partida.start = true }
                    
                }.padding().background(Color("Blanco")).cornerRadius(10)
            }.padding().background(Color.red).cornerRadius(20)
            
            
        }
            
    }
}

struct RPGView_Previews: PreviewProvider {
    static var previews: some View {
        RPGView()
    }
}
