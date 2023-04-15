using UnityEditor;
using UnityEngine;

[ExecuteInEditMode]
public class CreateURPShader : CreateCustomItemInMenu {
    private const string TemplatePath = "Assets/ReArchiving/Editor/Template/URPShader.shader";

    [MenuItem("Assets/Create/Shader/URP Shader")]
    public static void CreateFileFromTemplate() {
        ProjectWindowUtil.StartNameEditingIfProjectWindowExists(
            0, 
            ScriptableObject.CreateInstance<EndAction>(),
            GetSelectedPathOrFallback() + "/URPShader.shader", 
            null, 
            TemplatePath
        );
    }
}

