precision highp float;
precision highp int;
attribute vec3 inVertexPosition;
attribute vec3 inVertexNormal;
attribute vec3 inVertexTangent;
attribute vec3 inVertexBinormal;
attribute vec4 inVertexColor;
attribute vec2 inTexCoord0;
attribute vec2 inTexCoord1;
 
/* Uniforms */
uniform mat4 _M;
uniform mat4 _MIT;
uniform mat4 _MVP;
uniform vec4 albedo_uv;
uniform vec4 metallictex_uv;
uniform vec4 aotex_uv;
uniform vec4 emissivetex_uv;
uniform vec4 bumptex_uv;
 
/* Varyings */
varying vec4 v_Col;
varying vec2 v_UV0;
varying vec2 v_UV1;
varying vec2 v_UV2;
varying vec2 v_UV3;
varying vec2 v_UV4;
varying vec3 v_wPos;
varying vec3 v_wT;
varying vec3 v_wB;
varying vec3 v_wN;

//#VSUniformInsert
void main()
{
    gl_Position = _MVP * vec4(inVertexPosition, 1.0);
    v_UV0 = vec2(inTexCoord0*albedo_uv.xy+albedo_uv.zw);
    v_UV1 = vec2(inTexCoord0*metallictex_uv.xy+metallictex_uv.zw);
    v_UV2 = vec2(inTexCoord1*aotex_uv.xy+aotex_uv.zw);
    v_UV3 = vec2(inTexCoord0*emissivetex_uv.xy+emissivetex_uv.zw);
    v_UV4 = vec2(inTexCoord0*bumptex_uv.xy+bumptex_uv.zw);
    v_wPos = (_M * vec4(inVertexPosition, 1.0)).xyz;
    v_wN = normalize((_MIT * vec4(inVertexNormal, 0.0)).xyz);
    v_wT = normalize((_MIT * vec4(inVertexTangent, 0.0)).xyz);
    v_wB = normalize((_MIT * vec4(inVertexBinormal, 0.0)).xyz);
    v_Col = inVertexColor;
//#VSMainInsert
}
