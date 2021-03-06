extends Node

signal endBox(active)
signal nextPage(active)


#array containing all the text. Set up when a new Diobox is made
var text = ["Dang, daniel.","I've already got a basic text engine","adding choices is next!"]
onready var textBox = $textBox
onready var textBoxText = $text

#which text line from text array is being used
var active = 0

#if all avalible text has been printed 
var endOfLine = false

#how many characters a player can see. Makes the "scrolling text" effect 
var canSee = 0
onready var canSeeTimer = $canSeeTimer

#All lines of text that will terminate the box
var ends = []

#If active is a choice
var isAChoice = false

var choiceTriggers = []

#The actual Choice Text
#Choice Format When It Triggers:How Many there are:ChoiceText1-X:Corrisponding Choice Destination
var choices = ["0:2:Click Me: No, click me:1:2"]

func _ready():
	
	initChoices()
	checkIfChoice()
	
	textBoxText.text = text[active]
	canSeeTimer.start()
	
	
	
	
# warning-ignore:unused_argument
func _process(delta):
	textBoxText.visible_characters = canSee
	
	if canSee >= text[active].length():
		endOfLine = true
	else:
		endOfLine = false
		

	
func IsLastLine():
	if active + 1 < text.size() and !checkActiveAgainstEnd():
		nextPage()
	else:
		emit_signal("endBox", active)
		self.queue_free()

#loops through all the ends, and will return a True to isLastLine to terminate Text Box
func checkActiveAgainstEnd():
	if ends.size() != 0:
		for i in ends:
			if active == i:
				return true
			else:
				pass
		
	

func nextPage():
	
	canSee = 0
	endOfLine = false
	active += 1
	emit_signal("nextPage",active)
	textBoxText.text = text[active]
	canSeeTimer.start()
	
	checkIfChoice()

func _on_canSeeTimer_timeout():
	if !endOfLine:
		canSee += 1
		canSeeTimer.start()
		#print(canSee)

#Determines MouseClick in Box
func _on_clickableObject_clicked():
	
	if !endOfLine:
		canSee = text[active].length()
	if endOfLine and !isAChoice:
		IsLastLine()
		
func initChoices():
	for i in choices:
		print(i)
		var choiceStaging = i.split(":")
		print(choiceStaging[0])
		choiceTriggers.append(choiceStaging[0])
		
func checkIfChoice():
	for i in choiceTriggers:
		if active == int(i):
			isAChoice = true
			setupChoiceBoxes()
			
func setupChoiceBoxes():
	var choiceBox = "res://TextEngine/choice.tscn"
	
	var staticRank = int(choiceTriggers.find(str(active)))
	#Split Choice Zero is when it's active
	#Split Choice One is the number of Choices in the Choice Datapack
	
	var splitChoice = choices[staticRank].split(":")
	var numberOfChoices = int(splitChoice[1])
	
	var choiceText = []
	var choiceDes = []
	
	for i in numberOfChoices:
		choiceText.append(splitChoice[2+i])
		
		choiceDes.append(splitChoice[ 2 + numberOfChoices + i ])
		
#	print(choiceText)	
#	print(choiceDes)
	
	for i in numberOfChoices:
		var nBox = load("res://TextEngine/choice.tscn").instance()
		nBox.text = choiceText[i]
		nBox.des = choiceDes[i]
		
		nBox.connect("clicked",self, "FlipToPage")
		
		if i < 3:
			nBox.position = Vector2(600, 388 + (i * 75))
		else:
			nBox.position = Vector2(875, 388 +( abs(i/2) * 75 ))
		
		$Choices.add_child(nBox)
		
	
func FlipToPage(page):
	isAChoice = false
	canSee = 0
	endOfLine = false
	active = int(page)
	emit_signal("nextPage",active)
	textBoxText.text = text[active]
	canSeeTimer.start()
	
	checkIfChoice()
	
	for i in $Choices.get_child_count():
		$Choices.get_child(i).queue_free()
		
	
	
	
	
	
	

