import Foundation
//RPG #desafioHolaMundo

func IntC(_ Value: Substring) -> Int { Int(Value) ?? 0 }

struct Sujeto : Identifiable {
    var id: Int
    var name: String
    var level: Int = 0
    var life : Int = 0
    var damage : Int = 0
    
    mutating func Kill() {
        life = 0
    }
}

struct Game {
    var player : Sujeto
    var enemy : Sujeto
    var start : Bool
    var time : Int
    var round = 0
    var highRound = 0
    var winner : Sujeto = Sujeto(id: 0, name: "", level: 0)
    
    mutating func NextLevel() {
        round += 1
        if round > highRound {
            highRound = round
        }
        if winner.id == player.id {
            Mejorar(1)
        }else if winner.id == enemy.id {
            Mejorar(2)
        }
        
    }
    
    mutating func Win() {
        start = false
        if enemy.life < 1 {
            enemy.Kill()
            winner = player
            NextLevel()
        }else if player.life <  1 {
            player.Kill()
            winner = enemy
            NextLevel()
        }
    }
    
    mutating func Start() {
        player.level  = 0
        player.life   = 20
        player.damage = 2
        enemy.level = 0
        enemy.life = 20
        enemy.damage = 2
        start = true
        time = 20
        round = 0
        
    }
    
    
    mutating func Mejorar(_ value: Int) {
        
        time = 20
        if value == player.id {
            player.level +=  1
            player.damage += player.level
            player.life += 2 * player.level
            enemy.life = 20 + player.level
            enemy.damage = player.damage - player.level
            
        }else if value == enemy.id {
            enemy.level +=  1
            enemy.damage = player.damage + enemy.level
            enemy.life = 20 + player.level
            
        }
        //si quiero que se autoejecute cuanto gana quitamos el comentario 
        // start = true
    }
    
    mutating func Reset() {
        Start()
        start = false
    }
    
    mutating func Boost() { time += 1 }
        mutating func Golpe(_ from : Int) {
            
        if start == true && player.life > 0 && enemy.life > 0 {
            
            if from == 1 {
                enemy.life -= player.damage
                if enemy.life < 1 { enemy.Kill() ; Win()}
                
            }else if from == 2 {
                player.life -= enemy.damage
                if player.life < 1 { player.Kill() ; Win()}
            }
        }else {
            Win()
        }
            if enemy.level >= 3 {
                Reset()
            }
    }
}


//To save data


func EncodeString(_ value: Game) -> String { "\(value.player.id),\(value.player.name),\(value.player.level),\(value.player.life),\(value.player.damage),\(value.enemy.id),\(value.enemy.name),\(value.enemy.level),\(value.enemy.life),\(value.enemy.damage),\(value.start)" }

func DecodeGame(_ value : String) -> Game {
    
    let splitData = value.split(separator: ",")
    return Game(player: Sujeto(id: IntC(splitData[0]), name: String(splitData[1]), level: IntC(splitData[2]),life: IntC(splitData[3]),damage: IntC(splitData[4])), enemy: Sujeto(id: IntC(splitData[5]), name: String(splitData[6]),level: IntC(splitData[7]), life: IntC(splitData[8]), damage: IntC(splitData[9])), start: false, time: IntC(splitData[11]))
}

