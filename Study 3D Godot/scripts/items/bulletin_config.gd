class_name BulletinConfig

enum Keys {
	InteractionPrompt
}

const BULLETIN_PATHS := {
	Keys.InteractionPrompt : "res://scenes/interact_prompt.tscn"
}

static func get_bulletin(key : Key) -> Bulletin:
	return load(BULLETIN_PATHS.get(key)).instantiate()
