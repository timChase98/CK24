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

def instructionToBin24(line):
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
    if opType == "1":
        if not op:
            raise Exception("Not Enough Arguments for " + instruction)
        if len(op.split(",")) > 1:
            raise Exception("Too Many Arguments for " + instruction)
        instructionString += decodeArgToAddrMode(op)
    elif opType == "1IM":
        if len(op.split(",")) != 2:
            raise Exception("Wrong number of Arguments for " + instruction)
        instructionString += decodeArgToAddrMode(op.split(",")[0])
        instructionString += "{0:014b}".format(int(op.split(",")[1]))
    elif opType == "2":
        if len(op.split(",")) != 2:
            raise Exception("Wrong number of Arguments for " + instruction)
        instructionString += decodeArgToAddrMode(op.split(",")[0])
        instructionString += decodeArgToAddrMode(op.split(",")[1])
    else:
        raise Exception("instruction not implemented yet")
    instructionString += "0" * (24 - len(instructionString))
    return int(instructionString, 2)

def decodeArgToAddrMode(op):
    return "00{0:03b}".format(int(op.strip()[1]))

instructionSet = readInstructonSetFile()

if __name__ == '__main__':

    labels = {}
    with open("main.asm") as f:
        # read in file convert to all caps and remove trailing newlines
        s = f.read().upper().strip("\n")
    lineCounter = 0
    for line in s.split("\n"):
        lineCounter += 1
        line = line.strip()

        if ":" in line: # check for labels
            label, line = line.split(":", 1)
            if not label:
                sys.exit(colored("Missing Label Text @line " + str(lineCounter), "red"))
            labels[label] = lineCounter

        if ";" in line: # remove comments
            line, comment = line.split(";", 1)

        line = line.strip() # remove any whitespace at either end

        if not line: # verify line has code on it
            continue

        # decode the instruction
        try:
            decoded = instructionToBin24(line)
        except Exception as e:
            sys.exit(colored(str(e) + " @line " + str(lineCounter), "red"))
        print("{0}:\t{1:15}\t0b{2:024b}\t0x{3:06X}".format(lineCounter, line, decoded, decoded))
