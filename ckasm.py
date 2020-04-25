#!/usr/bin/env python3
from termcolor import cprint, colored
import sys

def readInstructonSetFile():
	instructions = {}
	with open("instructionSet.txt") as f:
		s = f.read().upper().strip()
	for instruction in s.split("\n"):
		opcode, inst, opNum = instruction.split()
		instructions[inst] = (opcode, opNum)
	return instructions

def instructionToBin24(line, PC):
	if " " in line:
		instruction, op = line.split(None, 1)
	else:
		instruction, op = line, ""

	op = op.replace(" ", "")

	if not instruction in instructionSet.keys():
		raise Exception("Garbage at Begining of Line")

	# put opcode at begining of isntruction string
	instructionString = "{0:05b}".format(int(instructionSet[instruction][0]))

	opType = instructionSet[instruction][1]
	missingLabel = 0
	if opType == "0":
		pass # dont do anything
	elif opType == "1":
		if not op:
			raise Exception("Not Enough Arguments for " + instruction)
		if len(op.split(",")) > 1:
			raise Exception("Too Many Arguments for " + instruction)
		instructionString += decodeArgToAddrMode(op)
	elif opType == "1IM":
		if len(op.split(",")) != 2:
			raise Exception("Wrong number of Arguments for " + instruction)
		instructionString += decodeArgToAddrMode(op.split(",")[0])
		imm = op.split(',')[1]
		if "0X" in imm:
			imm = int(imm, 16)
		elif "0B" in imm:
			imm = int(imm, 2)
		else:
			imm = int(imm)
		instructionString += "{0:014b}".format(imm)
	elif opType == "2":
		if len(op.split(",")) != 2:
			raise Exception("Wrong number of Arguments for " + instruction)
		instructionString += decodeArgToAddrMode(op.split(",")[0])
		instructionString += decodeArgToAddrMode(op.split(",")[1])
	elif opType[0] == "B":
		instructionString += opType[1:]
		instructionString += labelToProgramCounterIMM(op, PC)
	elif opType == "J":
		instructionString += "0000" + labelToProgramCounterIMM(op, PC)
	else:
		raise Exception("instruction not implemented yet")
	instructionString += "0" * (24 - len(instructionString))
	return int(instructionString, 2)

def decodeArgToAddrMode(op):
	if "(" in op:
		return "01{0:03b}".format(int(op.strip()[2]))
	return "00{0:03b}".format(int(op.strip()[1]))

def labelToProgramCounterIMM(label, currentPC):
	if label in labels:
		return "{0:015b}".format(labels[label][0])
	else:
		labels[label] = [-1, [currentPC]]
		return "0" * 15

instructionSet = readInstructonSetFile()
labels = {}

if __name__ == '__main__':

	with open("main.asm") as f:
		# read in file convert to all caps and remove trailing newlines
		s = f.read().upper().strip("\n")
	lines = s.split("\n")
	lineCounter = 0
	programCounter = 0

	program = []
	out = []

	for line in s.split("\n"):
		lineCounter += 1
		line = line.strip()

		if ":" in line: # check for labels
			label, line = line.split(":", 1)
			if not label:
				sys.exit(colored("Missing Label Text @line " + str(lineCounter), "red"))
			if label in labels:
				labels[label][0] = lineCounter
			else:
				labels[label] = [programCounter, []]

		if ";" in line: # remove comments
			line, comment = line.split(";", 1)

		line = line.strip() # remove any whitespace at either end

		if not line: # verify line has code on it
			continue

		# decode the instruction
		try:
			decoded= instructionToBin24(line, programCounter)
			program.append(decoded)
		except Exception as e:
			sys.exit(colored(str(e) + " @line " + str(lineCounter), "red"))
		out.append("{0}:\t{1:15}\t0b{2:024b}\t0x{3:06X}".format(programCounter, line, decoded, decoded))
		programCounter += 1

	# go back and fix mixing labels
	for label in labels.keys():
		# handle labels that were never found
		if labels[label][0] == -1:
			sys.exit(colored("unresolved refrence to label: " + label, "red"))

		# loop through all the missing reffrences
		for instruction in labels[label][1]:
			oldInstruction = program[instruction]
			program[instruction] += labels[label][0]
			# fix the output window
			txt = out[instruction]
			oldOutString = "0b{0:024b}\t0x{0:06X}".format(oldInstruction)
			newOutString = "0b{0:024b}\t0x{0:06X}".format(program[instruction])
			out[instruction] = txt.replace(oldOutString, newOutString)

	for line in out:
		print(line)









#
