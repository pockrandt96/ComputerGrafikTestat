using UnityEngine;
using System.Collections;

public class CameraController2 : MonoBehaviour
{
    

    private Vector3 offset;
    public float intensity;
    public Material material;

    void Start()
    {
        
    }

    void Awake()
    {
        material = new Material(Shader.Find("Hidden/Sepia"));
    }


    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (intensity == 0)
        {
            Graphics.Blit(source, destination);
            return;
        }
        material.SetFloat("_sepiaBlend", intensity);
        Graphics.Blit(source, destination, material);
    }
}
