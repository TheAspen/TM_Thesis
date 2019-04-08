extends Node2D

const IS_NPC = true
const DIALOGUE_PATH = "res://Assets/Dialogue/Dummy/"
const HAS_MISSION = true
const MISSION_DIALOGUE_PATH = "res://Assets/Dialogue/Mission1/"
const DEFAULT_DIALOGUE_PATH = "res://Assets/Dialogue/Default/"


var d_NPC_Self = {}
var d_Player_Self = {}
var d_NPC_DummysQuest = {}
var d_Player_DummysQuest = {}
var d_Player_DummyQuest_Bonus = {}
var d_Player_Intro_Answers = {}
var d_Player_Pass_Anwsers = {}
var d_Player_Failed_Answers = {}
var d_Player_Complete_Answers = {}

var d_Player_Bonus = {}
var d_Player_Bonus_Answers = {}

var _HP = 0
var _Armor = 0
var _Dialogue = null

export (bool)var isAggressive = 0
export (bool)var isEnemy = 0
export (bool)var isAlly = 0
export (bool)var isNeutral = 0

func _ready():
	get_parent().isAggressive = isAggressive
	get_parent().isEnemy = isEnemy
	get_parent().isAlly = isAlly
	get_parent().isNeutral = isNeutral
	_Armor = 10
	_HP = 100
	if(HAS_MISSION):
		_load_Personal_Dialogues()
		pass
	pass

func _load_Personal_Dialogues():
	d_NPC_Self = {
		"Personal" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(DIALOGUE_PATH + "Introduction.txt")}
	d_Player_Intro_Answers = {
		"Start Mission" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "Ask_Quest.txt"),
		"Quit" :  get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "Quit.txt")}
	d_Player_DummysQuest = {
	"Personal" : d_Player_Intro_Answers}
	_setup_Personal_Dialogues()
	pass
	
func _setup_Personal_Dialogues():
	get_parent().get_node("NPC_Dialogue")._setup_Dialog("NPC",d_NPC_Self)
	get_parent().get_node("NPC_Dialogue")._setup_Dialog("Player", d_Player_DummysQuest)
	
	pass
func _load_Mission_Dialogues():
	
	d_Player_Self = {}
	d_NPC_DummysQuest = {
		"Intro" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1.txt"), 
		"Complete" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1_Complete.txt"),
		"Pass" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1_Pass.txt"),
		"Failed" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1_Failed.txt"),
		"State 1" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1.txt"),
		"State 2" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1_Complete.txt")}
	d_Player_Intro_Answers = {
		"Pass" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "Player/Mission1_A1.txt"),
		"Failed" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "Player/Mission1_A2.txt"),
		"State 1" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "NPC/Mission1_Failed.txt")}
	d_Player_Pass_Anwsers = {
		"Complete" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "OK.txt")}
	d_Player_Failed_Answers = {
		"Complete" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "OK.txt")}
	d_Player_Complete_Answers = {
		"Quit" :  get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "Quit.txt")}
		#"0_Failed" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(DEFAULT_DIALOGUE_PATH + "OK.txt")}
	d_Player_DummysQuest = {
	"Intro" : d_Player_Intro_Answers, 
	"Pass" : d_Player_Pass_Anwsers,
	"Failed" : d_Player_Failed_Answers,
	"Complete" : d_Player_Complete_Answers,
	"State 1" : d_Player_Intro_Answers,
	"State 2" : d_Player_Bonus_Answers}
	
	d_Player_Bonus_Answers = {
		"Pass" : get_parent().get_node("NPC_Dialogue")._load_Dialogue(MISSION_DIALOGUE_PATH + "Player_Optionals/Mission1_Optional.txt")}
	d_Player_Bonus = {
		"Intro" : d_Player_Bonus_Answers}
	
	_setup_Mission_Dialogues()
	pass
	
	
func _setup_Mission_Dialogues():
	
	get_parent().get_node("NPC_Dialogue")._init_Mission_Data("Dummy's Quest", self, 10, false,null) 
	get_parent().get_node("NPC_Dialogue")._setup_Dialog("NPC",d_NPC_DummysQuest)
	get_parent().get_node("NPC_Dialogue")._setup_Dialog("Player", d_Player_DummysQuest)
	get_parent().get_node("NPC_Dialogue")._setup_Dialog("Bonus", d_Player_Bonus)
	pass
func _update_NPC_Behavior():
	
	
	pass

