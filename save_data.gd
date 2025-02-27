extends Node

var level = 0
var upgrades = []
var health = Ship.MAX_HEALTH
var score = 0

func reset():
	level = 0
	upgrades = []
	health = Ship.MAX_HEALTH
	score = 0
