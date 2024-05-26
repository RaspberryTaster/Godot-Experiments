shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

uniform vec4 uv_tiling_offset_speed;

uniform sampler2D mask;

varying vec2 tiling;
varying vec2 offset_speed;

void vertex() {}


void fragment() {
	tiling = uv_tiling_offset_speed.xy;
	offset_speed = uv_tiling_offset_speed.zw;
	
	vec2 base_uv = UV;
	base_uv -= 0.5;
	base_uv *= 2.0;
	
	float angle = atan(base_uv.y, base_uv.x) / (2.0 * PI);
	float dist = length(vec2(
			base_uv.x, 
			base_uv.y
			));
			
	vec2 polar_uv = vec2(
			angle,
			dist
			);
	
	vec2 offset = offset_speed * TIME;
	
	polar_uv *= tiling;
	polar_uv += offset;
	
	vec4 albedo_tex = texture(
		texture_albedo, 
		polar_uv
		);
		
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
	
	ALPHA *= texture(mask, UV).r;
}
