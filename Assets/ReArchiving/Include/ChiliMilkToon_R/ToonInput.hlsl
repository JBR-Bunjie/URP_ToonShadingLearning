#ifndef REARCHIVING_TOONINPUT_INCLUDED
#define REARCHIVING_TOONINPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct appdata {
    float4 vertex: POSITION;
    float2 uv: TEXCOORD0;
};

struct v2f {
    float4 vertex: SV_POSITION;
    float2 uv: TEXCOORD0;
};

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

CBUFFER_START(UnityPerMaterial)
float4 _MainTex_ST;
half4 _MainColor;
CBUFFER_END



#endif
