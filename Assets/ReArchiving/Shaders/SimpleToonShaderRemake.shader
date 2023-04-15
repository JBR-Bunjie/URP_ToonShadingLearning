Shader "ReArchiving/SimpleToonShaderRemake" {
    Properties {
        [Tex(_MainColor)]_MainTex ("Main Tex", 2D) = "white" { }
        [HideInInspector]_MainColor ("Main Color", Color) = (1, 1, 1, 1)


        _OutlineWidth("Outline Width", Range(0, 0.5)) = 0.01
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)

        [ToggleOff]_UsingAlphaClipping("Using Alpha Clipping?", float) = 0
        _AlphaClipping("Alpha Clipping", Range(0, 1)) = 0.5
        
        _CelShadowMidPoint("Cel Shadow Mid Point", Range(0, 1)) = 0.5
        _CelShadowWidth("Cel Shadow Width", Range(0, 0.2)) = 0.05
        
        _ReceiveShadowMappingAmount("Receive Shadow Mapping Amount", Range(0, 1)) = 0.5
        _ReceiveShadowMappingOffset("Receive Shadow Mapping Offset", Range(0, 0.5)) = 0.01
        _ReceiveShadowMappingColor("Receive Shadow Mapping Color", Color) = (0, 0, 0, 1)

        //        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("Src Blend", float) = 1
        //        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("Dst Blend", float) = 0
        
        // Advance
        [ToggleOn]_IsFace("Is Face?", float) = 1
    }
    SubShader {
        Tags {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry"
        }
        LOD 100

        HLSLINCLUDE
        #include "Assets/ReArchiving/Include/SimpleToonShaderRemake_R/SharedFunctions_SimpleToonShaderRemake.hlsl"
        ENDHLSL
        
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

            ENDHLSL
        }
    }
    CustomEditor "ReArchiving.Editor.ReArchivingReArchivingToonShaderGUI"
}