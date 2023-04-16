using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ReArchiving.Editor {
    public class ReArchivingSimpleToonShaderGUI : ReArchiving_SimpleToonShaderPropertyData {
        #region GUI

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
            m_BaseFoldout = GetFoldoutState(FoldoutName.Base);
            m_AdvanceFoldout = GetFoldoutState(FoldoutName.Advance);

            // https://docs.unity.cn/cn/2021.3/ScriptReference/ShaderGUI.FindProperty.html
            // Base
            m_MainTex = FindProperty(InsideMaterialProperties.MainTex, properties, false);
            m_MainColor = FindProperty(InsideMaterialProperties.MainColor, properties, false);
            m_MainTexDark = FindProperty(InsideMaterialProperties.MainTexDark, properties, false);
            m_ReceiveShadowMappingColor = FindProperty(InsideMaterialProperties.ReceiveShadowMappingColor, properties, false);
            m_ReceiveShadowMappingAmount = FindProperty(InsideMaterialProperties.ReceiveShadowMappingAmount, properties, false);
            m_ReceiveShadowMappingOffset = FindProperty(InsideMaterialProperties.ReceiveShadowMappingOffset, properties, false);
            m_CelShadowMidPoint = FindProperty(InsideMaterialProperties.CelShadowMidPoint, properties, false);
            m_CelShadowWidth = FindProperty(InsideMaterialProperties.CelShadowWidth, properties, false);

            m_BumpMap = FindProperty(InsideMaterialProperties.BumpMap, properties, false);
            m_BumpMapStrength = FindProperty(InsideMaterialProperties.BumpMapStrength, properties, false);

            // Advance
            m_IsFace = FindProperty(InsideMaterialProperties.IsFace, properties, false);
            
            // Draw
            EditorGUI.BeginChangeCheck();
            DrawProperties(materialEditor);
            if (EditorGUI.EndChangeCheck()) SetMaterialKeywords(materialEditor.target as Material);
        }

        #endregion

        // 设定决定 Shader 变体的关键字

        #region Keywords

        private void SetKeyword(Material material, string keyword, bool value) {
            if (value) material.EnableKeyword(keyword);
            else material.DisableKeyword(keyword);
        }

        private void SetMaterialKeywords(Material material) {
            // https://docs.unity3d.com/ScriptReference/Material-shaderKeywords.html
            // material.shaderKeywords = null;
        }

        #endregion

        #region Properties

        private void DrawProperties(MaterialEditor materialEditor) {
            // Base
            // foreach (var foldout in MFoldouts) {
            //     var tempFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(foldout, );
            //     if (tempFoldout) {
            //         EditorGUILayout.Space();
            //         DrawBaseOption(materialEditor);
            //         EditorGUILayout.Space();
            //     }
            // }
            var baseFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_BaseFoldout, GUIContentStruct.BaseFoldout);
            if (baseFoldout) {
                EditorGUILayout.Space();
                DrawBaseOption(materialEditor);
                EditorGUILayout.Space();
            }
            SetFoldoutState(FoldoutName.Base, m_BaseFoldout, baseFoldout);
            EditorGUILayout.EndFoldoutHeaderGroup();
            
            // Advance
            var advanceFoldout = EditorGUILayout.BeginFoldoutHeaderGroup(m_AdvanceFoldout, GUIContentStruct.AdvanceFoldout);
            if (advanceFoldout) {
                EditorGUILayout.Space();
                DrawAdvanceOption(materialEditor);
                EditorGUILayout.Space();
            }
            SetFoldoutState(FoldoutName.Advance, m_AdvanceFoldout, advanceFoldout);
            EditorGUILayout.EndFoldoutHeaderGroup();
        }

        private void DrawBaseOption(MaterialEditor materialEditor) {
            Material material = materialEditor.target as Material;

            // Base Color
            // Texture
            materialEditor.TexturePropertySingleLine(GUIContentStruct.MainTex, m_MainTex, m_MainColor);
            materialEditor.TexturePropertySingleLine(GUIContentStruct.MainTexDark, m_MainTexDark,
                m_ReceiveShadowMappingColor);
            materialEditor.TexturePropertySingleLine(GUIContentStruct.BumpMap, m_BumpMap);
            materialEditor.FloatProperty(m_BumpMapStrength, InsideMaterialProperties.BumpMapStrength);
            
            if (material) {
                // Shadow Controller
                if (material.HasProperty(InsideMaterialProperties.ReceiveShadowMappingAmount)) {
                    EditorGUI.showMixedValue = m_ReceiveShadowMappingAmount.hasMixedValue;
                    var temp = EditorGUILayout.Slider(GUIContentStruct.ReceiveShadowMappingAmount, m_ReceiveShadowMappingAmount.floatValue, 0, 1);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.ReceiveShadowMappingAmount);
                        m_ReceiveShadowMappingAmount.floatValue = temp;
                    }
                    EditorGUI.showMixedValue = false;
                }

                if (material.HasProperty(InsideMaterialProperties.ReceiveShadowMappingOffset)) {
                    EditorGUI.showMixedValue = m_ReceiveShadowMappingOffset.hasMixedValue;
                    var temp = EditorGUILayout.Slider(GUIContentStruct.ReceiveShadowMappingOffset,
                        m_ReceiveShadowMappingOffset.floatValue, 0, 0.5f);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.ReceiveShadowMappingOffset);
                        m_ReceiveShadowMappingOffset.floatValue = temp;
                    }
                    EditorGUI.showMixedValue = false;
                }

                if (material.HasProperty(InsideMaterialProperties.CelShadowMidPoint)) {
                    EditorGUI.showMixedValue = m_CelShadowMidPoint.hasMixedValue;
                    var temp = EditorGUILayout.Slider(GUIContentStruct.CelShadowMidPoint, m_CelShadowMidPoint.floatValue, 0,
                        1);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.CelShadowMidPoint);
                        m_CelShadowMidPoint.floatValue = temp;
                    }
                    EditorGUI.showMixedValue = false;
                }

                if (material.HasProperty(InsideMaterialProperties.CelShadowWidth)) {
                    EditorGUI.showMixedValue = m_CelShadowWidth.hasMixedValue;
                    var temp = EditorGUILayout.Slider(GUIContentStruct.CelShadowWidth, m_CelShadowWidth.floatValue, 0, 0.2f);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.CelShadowWidth);
                        m_CelShadowWidth.floatValue = temp;
                    }
                    EditorGUI.showMixedValue = false;
                }
            }

            // if (material) {
            //     if (material.HasProperty(InsideMaterialProperties.MainTex) && material.HasProperty(InsideMaterialProperties.MainColor)) {
            // materialEditor.TexturePropertySingleLine(GUIContentStruct.MainColor, m_MainTex, m_MainColor);
            //
            //         
            //     }
            //     
            // }
        }
        
        private void DrawAdvanceOption(MaterialEditor materialEditor) {
            Material material = materialEditor.target as Material;
            
            if (material) {
                if (material.HasProperty(InsideMaterialProperties.IsFace)) {
                    EditorGUI.showMixedValue = m_IsFace.hasMixedValue;
                    // Debug.Log(m_IsFace.floatValue);
                    EditorGUI.BeginChangeCheck();
                    var isFace = EditorGUILayout.Toggle(GUIContentStruct.IsFace, m_IsFace.floatValue == 1.0f);
                    if (EditorGUI.EndChangeCheck()) {
                        materialEditor.RegisterPropertyChangeUndo(InsideMaterialProperties.IsFace);
                        m_IsFace.floatValue = isFace ? 1 : 0;
                    }
                    
                    EditorGUI.showMixedValue = false;
                }
            }
        }
        

        #endregion

        #region EditorPrefs

        private bool GetFoldoutState(string name) {
            return EditorPrefs.GetBool($"{EditorPreKey}.{name}");
        }

        private void SetFoldoutState(string name, bool field, bool value) {
            if (field == value) return;
            EditorPrefs.SetBool($"{EditorPreKey}.{name}", value);
        }

        #endregion
    }
}