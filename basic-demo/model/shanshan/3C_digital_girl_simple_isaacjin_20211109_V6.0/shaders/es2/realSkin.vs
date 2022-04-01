precision highp float;
attribute vec3 inVertexPosition;
attribute vec2 inTexCoord0;
attribute vec4 inVertexColor;
attribute vec3 inVertexNormal;
attribute vec3 inVertexBinormal;
attribute vec3 inVertexTangent;

uniform mat4 _MVP;
uniform mat4 _MV;
uniform mat4 _M;
uniform mat4 _MIT;
uniform vec4 albedo_uv;
uniform vec4 bumptex_uv;
uniform vec4 paramtex_uv;
uniform vec3 _CameraPos;
uniform vec3 lightdir; 

varying vec2 v_UV;
varying vec3 v_wT;
varying vec3 v_wB;
varying vec3 v_wN;
varying vec3 v_wL;
varying vec3 v_wView;   

void main(){
	gl_Position = _MVP * vec4(inVertexPosition, 1.0);
	v_UV = inTexCoord0;
 	v_wN = normalize((_MIT * vec4(inVertexNormal, 0.0)).xyz);
    v_wT = normalize((_MIT * vec4(inVertexTangent, 0.0)).xyz);
    v_wB = normalize((_MIT * vec4(inVertexBinormal, 0.0)).xyz);
    vec3 v_wPos = (_M * vec4(inVertexPosition, 1.0)).xyz;
	v_wL = normalize(lightdir);
	v_wView = normalize(_CameraPos-v_wPos); 
}
