precision highp float;
attribute vec3 inPos;
attribute vec2 inTexCoord0;
attribute vec4 inVertexColor;

uniform mat4 _MVP;
uniform vec4 albedo_uv;

varying vec2 v_UV0;
varying vec4 v_Col;
                                                                  
void main(){
	gl_Position = _MVP * vec4(inPos, 1.0);
	v_UV0 = vec2(inTexCoord0*albedo_uv.xy+albedo_uv.zw);
	v_Col = inVertexColor;
}
