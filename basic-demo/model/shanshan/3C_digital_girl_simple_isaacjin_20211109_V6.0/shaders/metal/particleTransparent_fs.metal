using namespace metal;
struct xlatMtlShaderInput {
  float2 v_UV0;
  float4 v_Col;
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  int albedousage;
  float4 color;
};
fragment xlatMtlShaderOutput particleTransparent_fs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]]
  ,   texture2d<float> albedo [[texture(0)]], sampler _mtlsmp_albedo [[sampler(0)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 albedoColor_1;
  albedoColor_1 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.albedousage)) {
    albedoColor_1 = albedo.sample(_mtlsmp_albedo, (float2)(_mtl_i.v_UV0));
  };
  _mtl_o.gl_FragColor = float4(((float4)((float4)((float4)((float4)albedoColor_1 * _mtl_u.color)) * _mtl_i.v_Col.zyxw)));
  return _mtl_o;
}

