precision highp float;
attribute vec3 inVertexPosition;
attribute vec2 inTexCoord0;
attribute vec3 inVertexNormal;

uniform mat4 _MVP;
uniform mat4 _MV;
uniform mat4 _M;
uniform mat4 _MIT;
uniform vec4 albedo_uv;
uniform vec3 _CameraPos;
uniform vec3 lightdir; 
uniform float scale;
varying vec2 v_UV0;
varying vec2 v_UV1;

varying vec3 v_wL;
varying vec3 v_wN;
varying vec3 v_wView;
varying float rotate;
void main(){
	gl_Position = _MVP * vec4(inVertexPosition, 1.0);
	v_UV0 = inTexCoord0;
	v_UV1 = inTexCoord0/scale-(1.0/scale-1.0)*0.5;
 	v_wN = normalize((_MIT * vec4(inVertexNormal, 0.0)).xyz);
    vec3 wPos = (_M * vec4(inVertexPosition, 1.0)).xyz;
	v_wL = normalize(lightdir);
	v_wView = normalize(_CameraPos-wPos);
    rotate = normalize(_MV*vec4(inVertexNormal, 0.0)).x;
}
