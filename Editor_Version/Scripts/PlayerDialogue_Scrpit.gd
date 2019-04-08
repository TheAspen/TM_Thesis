extends Node2D

var CurrentNPC = null


func _ready():
	_set_Dialogue_Position()
	pass

func _set_Dialogue_Position():
	self.position.x = get_viewport().size.x / 2
	self.position.y = get_viewport().size.y / 2
	pass

func _set_NPC_Character(NPC):
	CurrentNPC = NPC
	pass

func _init_NPC_Text(text):
	get_node("Dialogue_BG/Text").text = text
	pass

func _init_Player_Text(answerOption):
	print(answerOption)
	get_node("Dialogue_BG/Answer_Options").add_item(answerOption,null,true)
	pass

func _clear_Player_Answers():
	get_node("Dialogue_BG/Answer_Options").clear()
	pass

func _on_Answer_Options_item_activated(index):
	var text = get_node("Dialogue_BG/Answer_Options").get_item_text(index)
	CurrentNPC.get_parent().get_node("NPC_Dialogue")._process_Player_Answer(text)
	pass

func _end_Player_Dialogue():
	CurrentNPC = null
	self.hide()
	pass

func _add_Quest_toPlayer(questName):
	get_parent()._add_Quest(questName)
	pass