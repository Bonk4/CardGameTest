extends Node

var cardTemplate = load("res://CardBase.tscn")

var centerTextFormat = "[center]{text}"

# board Node Refs
var board: Node
var trash: Node
var field: Node
var playerScoreDisplay: Node
var cpuScoreDisplay: Node
var resultDisplay: Node

# meta variables
var fieldSelected: bool = false
var heldCard: Node = null

# GAME VARIABLES
var playerTurn = true
var playerScore = 0
var cpuScore = 0
var HAND_SIZE = 3

func load(
		boardRef: Node, 
		trashRef: Node, 
		fieldRef: Node, 
		playerScoreRef: Node, 
		cpuScoreRef: Node,
		resultRef: Node
	):
	board = boardRef
	trash = trashRef
	field = fieldRef
	playerScoreDisplay = playerScoreRef
	cpuScoreDisplay = cpuScoreRef
	resultDisplay = resultRef
	
	board.hand_size = HAND_SIZE
	
	for num in range(0, HAND_SIZE):
		board.drawPlayerCard()
	board.addCpuCard()
	setScore()
	resultDisplay.visible = false

func refreshHands():
	board.refreshHands()

func tryTakeTurn(node: Node):
	if(!playerTurn):
		unhover()
		return
	
	var cardsInField = field.get_child_count()
	
	if (fieldSelected):
		if (cardsInField == 0):
			playCard(node)
			playerTurn = false
			revealCpu()
	
	board.refreshHands()
	unhover()

func revealCpu():
	board.revealCpuCards()

func signalCardRevealed():
	if(playerTurn): return
	finishTurn()
	playerTurn = true

func finishTurn():
	var cpu = board.getCpuCards()
	var player = board.getPlayerCards()
	
	var cpuRoundScore = 0
	var playerRoundScore = 0
	
	for cpuCard in cpu:
		cpuRoundScore = cpuRoundScore + cpuCard.score
	for playerCard in player:
		playerRoundScore = playerRoundScore + playerCard.score
	
	if(cpuRoundScore > playerRoundScore):
		cpuScore = cpuScore + 1
		resultDisplay.text = centerText("Loss!")
	else: if(cpuRoundScore < playerRoundScore):
		playerScore = playerScore + 1
		resultDisplay.text = centerText("Win!")
	else:
		resultDisplay.text = centerText("Tie!")
	
	board.showResult()
		
	setScore()
	
	await get_tree().create_timer(1).timeout
	
	for card in cpu:
		card.despawn()
	
	for card in player:
		card.despawn()
		
	board.drawPlayerCard()
	board.addCpuCard()

func removeCard(node: Node):
	node.queue_free()

func holdCard(node: Node):
	heldCard = node

func dropCard():
	heldCard = null

func hoverField():
	Game.fieldSelected = true
	if heldCard != null:
		heldCard.hoverPlay()

func unhover():
	Game.fieldSelected = false
	if heldCard != null:
		heldCard.unhover()
		heldCard = null

func playCard(node: Node):
	node.reparent(field)
	node.onBoard = true
	board.refreshHands()
	playerTurn = false

func setScore():
	playerScoreDisplay.text = centerText(playerScore)
	cpuScoreDisplay.text = centerText(cpuScore)

func centerText(text):
	return centerTextFormat.format({"text": text})
