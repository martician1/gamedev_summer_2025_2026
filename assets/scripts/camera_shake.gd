extends ColorRect
class_name CameraShake

func set_shake_strength(strength: float):
	(material as ShaderMaterial).set_shader_parameter("shake_strength", strength)
