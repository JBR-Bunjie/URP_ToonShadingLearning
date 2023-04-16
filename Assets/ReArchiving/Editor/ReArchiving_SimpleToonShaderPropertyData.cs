using UnityEditor;
using UnityEngine;

namespace ReArchiving.Editor {
    public class ReArchiving_SimpleToonShaderPropertyData : ShaderGUI {
        protected const string EditorPreKey = "ReArchiving:ShaderGUI:";

        protected struct GUIContentStruct {
            // Fold
            public static readonly GUIContent BaseFoldout = new GUIContent("Base Foldout");
            public static readonly GUIContent AdvanceFoldout = new GUIContent("Advance");

            // Base Properties
            public static readonly GUIContent MainTex = new GUIContent("Main Texture");
            public static readonly GUIContent MainColor = new GUIContent("Main Color");
            public static readonly GUIContent MainTexDark = new GUIContent("Main Texture Dark");
            public static readonly GUIContent ReceiveShadowMappingColor = new GUIContent("Shadow Color");
            // public static readonly GUIContent MainColorDark = new GUIContent("Main Color Dark");
            public static readonly GUIContent ReceiveShadowMappingAmount = new GUIContent("Shadow Amount");
            public static readonly GUIContent ReceiveShadowMappingOffset = new GUIContent("Shadow Offset");
            
            public static readonly GUIContent CelShadowMidPoint = new GUIContent("Cel Shadow Mid Point");
            public static readonly GUIContent CelShadowWidth = new GUIContent("Cel Shadow Width");
            
            public static readonly GUIContent BumpMap = new GUIContent("Bump Map");
            public static readonly GUIContent BumpMapStrength = new GUIContent("Bump Strength");

            // Advance Properties
            public static readonly GUIContent IsFace = new GUIContent("Is Face");
        }

        protected struct InsideMaterialProperties {
            // Base Properties
            public static readonly string MainTex = "_MainTex";
            public static readonly string MainColor = "_MainColor";
            public static readonly string MainTexDark = "_MainTexDark";
            public static readonly string ReceiveShadowMappingColor = "_ReceiveShadowMappingColor";
            public static readonly string ReceiveShadowMappingAmount = "_ReceiveShadowMappingAmount";
            public static readonly string ReceiveShadowMappingOffset = "_ReceiveShadowMappingOffset";
            
            public static readonly string CelShadowMidPoint = "_CelShadowMidPoint";
            public static readonly string CelShadowWidth = "_CelShadowWidth";
            
            public static readonly string BumpMap = "_BumpMap";
            public static readonly string BumpMapStrength = "_BumpMapStrength";

            // Advance Properties
            public static readonly string RenderQueue = "_RenderQueue";
            public static readonly string IsFace = "_IsFace";
        }

        protected struct FoldoutName {
            public static readonly string Base = "Base";
            public static readonly string Advance = "Advance";
        }
        
        #region Data for OnGUI

        // Foldouts
        protected static bool m_BaseFoldout;
        protected static bool m_AdvanceFoldout;

        // Base
        protected MaterialProperty m_MainTex;
        protected MaterialProperty m_MainColor;
        protected MaterialProperty m_MainTexDark;
        protected MaterialProperty m_ReceiveShadowMappingColor;
        // protected MaterialProperty m_MainColorDark;
        protected MaterialProperty m_ReceiveShadowMappingAmount;
        protected MaterialProperty m_ReceiveShadowMappingOffset;

        protected MaterialProperty m_CelShadowMidPoint;
        protected MaterialProperty m_CelShadowWidth;
        
        protected MaterialProperty m_BumpMap;
        protected MaterialProperty m_BumpMapStrength;
        

        // Advance
        protected MaterialProperty m_IsFace;

        #endregion

        #region ENUM


        #endregion
    }
}