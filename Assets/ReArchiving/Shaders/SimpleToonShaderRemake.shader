Shader "ReArchiving/SimpleToonShaderRemake" {
    Properties {
        // Base
        [Tex(_MainColor)]_MainTex ("Main Texture", 2D) = "white" { }
        [HideInInspector]_MainColor ("Main Color", Color) = (1, 1, 1, 1)
        _MainTexDark ("Dark Main Texture", 2D) = "white" { }
        _ReceiveShadowMappingColor("Receive Shadow Mapping Color", Color) = (1, 0.89, 0.78, 1)
        //       _ReceiveShadowMappingColor ==> _MainTexDarkColor ("Dark Main Color", Color) = (1, 1, 1, 1)
        _ReceiveShadowMappingAmount("Receive Shadow Mapping Amount", Range(0, 1)) = 0.5
        _ReceiveShadowMappingOffset("Receive Shadow Mapping Offset", Range(0, 0.5)) = 0.01

        _CelShadowMidPoint("Cel Shadow Mid Point", Range(0, 1)) = 0.5
        _CelShadowWidth("Cel Shadow Width", Range(0, 0.2)) = 0.05

        _BumpMap("Normal Map", 2D) = "bump" { }
        _BumpMapStrength("Normal Map Strength", Range(0, 1)) = 1

        _Occlusion("Occlusion", 2D) = "white" { }
        _OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1



        // Outline
        _OutlineWidth("Outline Width", Range(0, 0.5)) = 0.01
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)

        // 
        [ToggleOff]_UsingAlphaClipping("Using Alpha Clipping?", float) = 0
        _AlphaClipping("Alpha Clipping", Range(0, 1)) = 0.5

        // Advance
        [ToggleOn]_IsFace("Is Face?", float) = 1
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry"
        }
        LOD 100

        Pass {
            Name "ForwardLit"
            Tags {
                "LightMode" = "UniversalForward"
            }

            // They are default actually
            Cull Back
            ZWrite On
            ZTest LEqual
            Blend One Zero

            HLSLPROGRAM
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            // ---------------------------------------------------------------------------------------------
            // Unity defined keywords
            #pragma multi_compile_fog

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Assets/ReArchiving/Include/SimpleToonShaderRemake_R/MainFunctions_SimpleToonShaderRemake.hlsl"
            
            ENDHLSL
        }

        Pass {
            Name "Outline"
            Tags {}

            Cull Front

            HLSLPROGRAM

            // Direct copy all keywords from "ForwardLit" pass
            // ---------------------------------------------------------------------------------------------
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            // ---------------------------------------------------------------------------------------------
            #pragma multi_compile_fog
            // ---------------------------------------------------------------------------------------------

            #pragma vertex vert
            #pragma fragment frag

            // because this is an Outline pass, define "ToonShaderIsOutline" to inject outline related code into both VertexShaderWork() and ShadeFinalColor()
            #define OutlinePass

            #include "Assets/ReArchiving/Include/SimpleToonShaderRemake_R/MainFunctions_SimpleToonShaderRemake.hlsl"
            
            ENDHLSL
        }

        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode" = "ShadowCaster"
            }

            ZWrite On
            ZTest LEqual
            //            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment BaseColorAlphaClipTest

            #define ShadowCasterPass
            
            #include "Assets/ReArchiving/Include/SimpleToonShaderRemake_R/MainFunctions_SimpleToonShaderRemake.hlsl"
            
            ENDHLSL
        }

    }
    CustomEditor "ReArchiving.Editor.ReArchivingSimpleToonShaderGUI"
}