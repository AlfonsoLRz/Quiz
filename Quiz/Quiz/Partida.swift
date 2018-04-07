//
//  Partida.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation

class Partida {
    
    //MARK: Atributos
    
    private let PUNTOS_POR_ACIERTO = 150;
    
    private var aciertos : Int
    private var preguntas : [Pregunta]
    private var preguntasRespondidas : Int
    private var tiempoTotal : Int
    
    
    init?(preguntas: [Pregunta]) {
        if preguntas.count == 0 {
            return nil
        }
        
        self.aciertos = 0
        self.preguntas = preguntas
        self.preguntasRespondidas = 0
        self.tiempoTotal = 0        // Tiempo empleado en responder todas las preguntas en segundos.
    }
    
    //MARK: Métodos públicos
    
    func sumarAcierto() {
        self.aciertos += 1
    }
    
    func sumarTiempo(tiempo: Int) {
        self.tiempoTotal += tiempo
    }
    
    func getAciertos() -> Int {
        return self.aciertos
    }
    
    func getPuntuación() -> Int {
        return self.aciertos * self.PUNTOS_POR_ACIERTO
    }
    
    func getSiguientePregunta() -> Pregunta? {
        if self.preguntasRespondidas < self.preguntas.count {
            return nil
        }
        
        // No tenemos operador unario ++...
        self.preguntasRespondidas += 1
        return self.preguntas[self.preguntasRespondidas - 1]
    }
    
    func getTiempoMedio() -> Float {
        if self.preguntasRespondidas != 0 {
            return (Float(self.tiempoTotal / self.preguntasRespondidas))
        }
        
        return 0
    }
}
