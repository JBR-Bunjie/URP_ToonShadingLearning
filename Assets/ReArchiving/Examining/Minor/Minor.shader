Shader "Examining/Minor" {
    Properties {
        [Tex(_MainColor)]_MainTex ("Main Tex", 2D) = "white" { }
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry"
        }
        LOD 100

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_ST;
        half4 _MainColor;
        CBUFFER_END
        ENDHLSL

        Pass {
            Name "ForwardLit"
            Tags {
                "LightMode" = "UniversalForward"
            }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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

            v2f vert(appdata v) {
                v2f o;
                VertexPositionInputs vertexPos = GetVertexPositionInputs(v.vertex.xyz);
                o.vertex = vertexPos.positionCS;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x = 1 - o.uv.x;
                return o;
            }

            half4 frag(v2f i): SV_Target {
                half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                return col;
            }
            ENDHLSL
        }
    }
}