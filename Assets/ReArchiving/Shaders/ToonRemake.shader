Shader "ReArchiving/ToonRemake" {
    Properties {
        // Surface Options
        _WorkflowMode ("Workflow Mode", Float) = 0
        _CullMode ("Cull Mode", Float) = 0
        
        // Base
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        [ToggleOff]_Test ("Test Float", Float) = 1
        
        
        // Advance
        _RenderQueue ("Render Queue", Float) = 2000
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True" "ShaderModel" = "4.5"
        }
        LOD 300

        Pass {
            Name "ForwardLit"
            Tags {
                "LightMode"="UniversalForward"
            }
            Cull Back

            //            ZTest Less
            //            ZWrite Off

            HLSLPROGRAM
            // #pragma exclude_renderers gles gles3 glcore
            #pragma target 3.0

            // #pragma multi_compile_instancing
            // #pragma multi_compile_fog

            #pragma vertex vert
            #pragma fragment frag

            #include "../Include/ChiliMilkToon_R/ToonInput.hlsl"
            // #include "../Include/ChiliMilkToon_R/ToonHairShadowMaskPass.hlsl"


            v2f vert(appdata v) {
                v2f o;
                VertexPositionInputs vertexPos = GetVertexPositionInputs(v.vertex.xyz);
                o.vertex = vertexPos.positionCS;

                return o;
            }


            half4 frag(v2f i): SV_Target {
                return half4(1, 1, 1, 1);
            }
            ENDHLSL
        }
    }
    CustomEditor "ReArchiving.Editor.ReArchivingReArchivingToonShaderGUI"
}