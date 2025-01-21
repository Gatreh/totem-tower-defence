extends Node

var story : Story = Story.new()

func _ready() -> void:
	story.Line1()
	story.Line2()
	story.Line3()
	Vector2

class Story:

	func Line2() -> void:
		print("was in a single function")


	func Line1() -> void:
		print("If these print statements")


	func Line3() -> void:
		print("They would be out of order!")
