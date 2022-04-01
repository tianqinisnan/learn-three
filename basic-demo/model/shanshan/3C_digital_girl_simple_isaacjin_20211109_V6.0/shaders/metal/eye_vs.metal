using namespace metal;
struct xlatMtlShaderInput {
  float3 inVertexPosition [[attribute(0)]];
  float2 inTexCoord0 [[attribute(3)]];
  float3 inVertexNormal [[attribute(1)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float2 v_UV0;
  float2 v_UV1;
  float3 v_wL;
  float3 v_wN;
  float3 v_wView;
  float rotate;
};
struct xlatMtlShaderUniform {
  float4x4 _MVP;
  float4x4 _MV;
  float4x4 _M;
  float4x4 _MIT;
  float3 _CameraPos;
  float3 lightdir;
  float scale;
};
vertex xlatMtlShaderOutput eye_vs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _mtl_i.inVertexPosition;
  _mtl_o.gl_Position = (_mtl_u._MVP * tmpvar_1);
  _mtl_o.v_UV0 = _mtl_i.inTexCoord0;
  _mtl_o.v_UV1 = ((_mtl_i.inTexCoord0 / _mtl_u.scale) - ((
    (1.0/(_mtl_u.scale))
   - 1.0) * 0.5));
  float4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = _mtl_i.inVertexNormal;
  _mtl_o.v_wN = normalize((_mtl_u._MIT * tmpvar_2).xyz);
  float4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = _mtl_i.inVertexPosition;
  _mtl_o.v_wL = normalize(_mtl_u.lightdir);
  _mtl_o.v_wView = normalize((_mtl_u._CameraPos - (_mtl_u._M * tmpvar_3).xyz));
  _mtl_o.rotate = normalize(_mtl_u._MV*float4(_mtl_i.inVertexNormal, 0.0)).x;
  _mtl_o.gl_Position.z = (_mtl_o.gl_Position.z + _mtl_o.gl_Position.w) / 2.0f;
  return _mtl_o;
}