using namespace metal;
struct xlatMtlShaderInput {
  float3 inPos [[attribute(0)]];
  float2 inTexCoord0 [[attribute(3)]];
  uint   inVertexColor [[attribute(2)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float2 v_UV0;
  float4 v_Col;
};
struct xlatMtlShaderUniform {
  float4x4 _MVP;
  float4 albedo_uv;
};
vertex xlatMtlShaderOutput particleTransparent_vs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _mtl_i.inPos;
  _mtl_o.gl_Position = (_mtl_u._MVP * tmpvar_1);
  _mtl_o.v_UV0 = ((_mtl_i.inTexCoord0 * _mtl_u.albedo_uv.xy) + _mtl_u.albedo_uv.zw);
  _mtl_o.v_Col= unpack_unorm4x8_to_float(_mtl_i.inVertexColor);
  _mtl_o.gl_Position.z = (_mtl_o.gl_Position.z + _mtl_o.gl_Position.w) / 2.0f;
  return _mtl_o;
}
