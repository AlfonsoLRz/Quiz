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
    private var preguntasSinUtilizar = [Int]()
    private var tiempoTotal : Int
    
    
    init?(preguntas: [Pregunta]) {
        if preguntas.count == 0 {
            return nil
        }
        
        self.aciertos = 0
        self.preguntas = preguntas
        self.tiempoTotal = 0        // Tiempo empleado en responder todas las preguntas en segundos.
        
        // Inicializamos el vector de preguntas sin responder...
        for i in 0..<self.preguntas.count {
            self.preguntasSinUtilizar.append(i)
        }
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
    
    func getPreguntasUtilizadas() -> Int {
        return self.preguntas.count - self.preguntasSinUtilizar.count
    }
    
    func getPuntuación() -> Int {
        return self.aciertos * self.PUNTOS_POR_ACIERTO
    }
    
    func getSiguientePregunta() -> Pregunta? {
        let preguntasUtilizadas = self.getPreguntasUtilizadas()
        if preguntasUtilizadas == self.preguntas.count {
            return nil
        }
        
        // No tenemos operador unario ++...
        let randomIndex = self.getSiguienteÍndice()
        let index = self.preguntasSinUtilizar[randomIndex]
        self.preguntasSinUtilizar.remove(at: randomIndex)
        return self.preguntas[index]
    }
    
    func getTiempoMedio() -> Float {
        let preguntasUtilizadas = self.getPreguntasUtilizadas()
        if preguntasUtilizadas != 0 {
            return (Float(self.tiempoTotal / preguntasUtilizadas))
        }
        
        return 0
    }
    
    func getTotalPreguntas() -> Int {
        return self.preguntas.count
    }
    
    
    //MARK: Métodos privados
    
    private func getSiguienteÍndice() -> Int {
        return Int(arc4random_uniform(UInt32(self.preguntasSinUtilizar.count)))
    }
}
