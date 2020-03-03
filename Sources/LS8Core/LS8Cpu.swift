//
//  File.swift
//  
//
//  Created by Michael Redig on 3/2/20.
//

import Foundation

public class LS8Cpu {

	var ir: UInt8 = 0
	var register: [UInt8] = {
		var register = (0..<8).map { _ in UInt8(0) }
		register[7] = 0xF4
		return register
	}()
	var ram = (0..<256).map { _ in UInt8(0) }
	var pc: UInt8 = 0


	public init() {}

	private func registerRead(address: UInt8) -> UInt8 {
		register[Int(address)]
	}

	private func registerWrite(data: UInt8, address: UInt8) {
		register[Int(address)] = data
	}

	private func ramRead(address: UInt8) -> UInt8 {
		ram[Int(address)]
	}

	private func ramWrite(data: UInt8, address: UInt8) {
		ram[Int(address)] = data
	}

	public func load(program: Data) {
		for (index, byte) in program.enumerated() {
			ram[index] = byte
		}
	}

	public func run() -> String {
		var running = true
		var output = ""

		while running {
			let ir = ramRead(address: pc)

			switch ir {
			case LS8.AND:
				let operandAIndex = ramRead(address: pc + 1)
				let operandBIndex = ramRead(address: pc + 2)
				let newValue = registerRead(address: operandAIndex) & registerRead(address: operandBIndex)
				registerWrite(data: newValue, address: operandAIndex)
			case LS8.XOR:
				let operandAIndex = ramRead(address: pc + 1)
				let operandBIndex = ramRead(address: pc + 2)
				let newValue = registerRead(address: operandAIndex) ^ registerRead(address: operandBIndex)
				registerWrite(data: newValue, address: operandAIndex)
			case LS8.PRA:
				let operand = ramRead(address: pc + 1)
				let value = registerRead(address: operand)
				let scalar = Unicode.Scalar(value)
				output += "\(scalar)"
			case LS8.LDI:
				let operandIndex = ramRead(address: pc + 1)
				let operand = ramRead(address: pc + 2)
				registerWrite(data: operand, address: operandIndex)
			case LS8.HLT:
				running = false
			default:
				print("Illegal instruction: \(String(ir, radix: 16))")
			}

			if ((ir >> 4) & 0b1) != 1 {
				pc += ((ir & 0xc0) >> 6) + 1
			}
		}
		return output
	}
}
