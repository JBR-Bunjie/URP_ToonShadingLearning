#pragma once

#ifndef REARCHIVING_MainFunctions_SimpleToonShaderRemake_INCLUDED
#define REARCHIVING_MainFunctions_SimpleToonShaderRemake_INCLUDED

#include "SharedFunctions_SimpleToonShaderRemake.hlsl"
// #include "Input_SimpleToonShaderRemake.hlsl"


// See the Comment at line 7 of ShadowCasterPass.hlsl in URP
half3 _LightDirection;
// ------------------------------------------------------------
// Vertex-Fragment Functions
// ------------------------------------------------------------
v2f vert(appdata v) {
    v2f o;
    VertexPositionInputs vertexPos = GetVertexPositionInputs(v.vertex.xyz);
    // VertexNormalInputs vertexNormal = GetVertexNormalInputs(v.normal);
    VertexNormalInputs vertexNormal = GetVertexNormalInputs(v.normal, v.tangent);

    // general data
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.worldNormalDir = vertexNormal.normalWS;

    // To make the vert function compatible with shadow caster and other passes,
    // we need to do more calculations to get the correct world position in different situations.
    float3 worldPos = vertexPos.positionWS;
    // half fogFactor = ComputeFogFactor(vertexPos.positionCS.z);
    
    #ifdef OutlinePass
    
    #endif

    o.worldPosWithFog.xyz = worldPos;
    o.worldPosWithFog.w = 1;

    o.positionCS = TransformWorldToHClip(worldPos);
    
    #ifdef OutlinePass
    
    #endif
    
    // Shadow Caster Part
    #ifdef ShadowCasterPass
        // see GetShadowPositionHClip() in URP/Shaders/ShadowCasterPass.hlsl
        // https://github.com/Unity-Technologies/Graphics/blob/master/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl
        float4 positionCS = TransformWorldToHClip(ApplyShadowBias(worldPos, o.worldNormalDir, _LightDirection));
        
        #if UNITY_REVERSED_Z
        positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
        #else
        positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
        #endif
        o.positionCS = positionCS;
    #endif
    
    
    return o;
}

half4 frag(v2f i): SV_Target {
    SimpleToonObjectData simpleToonObjectData = InitSimpleToonObjectData(i);

    SimpleToonSurfaceData simpleToonSurfaceData = InitSimpleToonSurfaceData(i);


    // half3 averageSH = SampleSH(0);
    //
    // // can prevent result becomes completely black if lightprobe was not baked 
    // averageSH = max(_IndirectLightMinColor, averageSH);
    //
    // // occlusion (maximum 50% darken for indirect to prevent result becomes completely black)
    // half indirectOcclusion = lerp(1, simpleToonSurfaceData.occlusion, 0.5);
    // half3 indirectionalLight = averageSH * indirectOcclusion;


    half3 mainLightResult = 0;
    Light mainLight = GetMainLight();
    float3 shadowCoordWorldPos = i.worldPosWithFog.xyz + mainLight.direction * (_IsFace);

    #ifdef _MAIN_LIGHT_SHADOWS
        half4 shadowCoord = TransformWorldToShadowCoord(shadowCoordWorldPos);
        mainLight.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
    #endif
    mainLightResult = ShadeSingleLight(mainLight, simpleToonSurfaceData, simpleToonObjectData);

    half3 additionLightSumResult = 0;
    #ifdef _ADDITIONAL_LIGHTS
    half lightCount = GetAdditionalLightsCount();
    for (int it = 0; it < lightCount; it++) {
        int perObjectLightIndex = GetPerObjectLightIndex(it);
        Light additionalLight = GetAdditionalLight(perObjectLightIndex, simpleToonObjectData.worldPos);
        // attention here:
        // In `AdditionalLightRealtimeShadow` function, we use "shadowCoordWorldPos" rather than shadowCoord
        additionalLight.shadowAttenuation = AdditionalLightRealtimeShadow(perObjectLightIndex, shadowCoordWorldPos);
        
        additionLightSumResult += ShadeSingleLight(additionalLight, simpleToonSurfaceData, simpleToonObjectData, true);
    }
    #endif

    half3 color = mainLightResult + additionLightSumResult;

    // half fogFactor = i.worldPosWithFog.w;
    // Mix the pixel color with fogColor. You can optionaly use MixFogColor to override the fogColor
    // with a custom one.
    // color = MixFog(color, fogFactor);

    return half4(color, 1);
    // return half4(simpleToonObjectData.worldNormkalDir, 1);
}

half4 BaseColorAlphaClipTest(v2f i) : SV_TARGET {
    SimpleToonSurfaceData simpleToonSurfaceData = InitSimpleToonSurfaceData(i);
    DoClipTestToTargetAlphaTest(simpleToonSurfaceData.alpha);
    return 0;
}



#endif
