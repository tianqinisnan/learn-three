#version 300 es
precision highp float;
in vec3 inVertexPosition;
in vec2 inTexCoord0;
in vec4 inVertexColor;
in vec3 inVertexNormal;
in vec3 inVertexBinormal;
in vec3 inVertexTangent;

uniform mat4 _MVP;
uniform mat4 _MV;
uniform mat4 _M;
uniform mat4 _MIT;
uniform vec4 albedo_uv;
uniform vec4 bumptex_uv;
uniform vec4 masktex_uv;
uniform vec3 _CameraPos;
uniform vec3 lightdir; 

out vec2 v_UV0;
out vec2 v_UV2;
out vec2 v_UV3;
out vec3 v_wT;
out vec3 v_wB;
out vec3 v_wN;
out vec3 v_wL;
out vec3 v_vN; 
out vec3 v_wView;   

void main(){
	gl_Position = _MVP * vec4(inVertexPosition, 1.0);
	v_UV0 = vec2(inTexCoord0*albedo_uv.xy+albedo_uv.zw);
	v_UV2 = vec2(inTexCoord0*bumptex_uv.xy+bumptex_uv.zw);
	v_UV3 = vec2(inTexCoord0*masktex_uv.xy+masktex_uv.zw);
 	v_wN = normalize((_MIT * vec4(inVertexNormal, 0.0)).xyz);
    v_wT = normalize((_MIT * vec4(inVertexTangent, 0.0)).xyz);
    v_wB = normalize((_MIT * vec4(inVertexBinormal, 0.0)).xyz);
    vec3 v_wPos = (_M * vec4(inVertexPosition, 1.0)).xyz;
	v_wL = normalize(lightdir);
	v_wView = normalize(_CameraPos-v_wPos); 
}