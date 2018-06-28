using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeMeshRenderScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Mesh mesh = GetComponent<MeshFilter>().mesh;

        for(int i=0; i<mesh.subMeshCount; i++)
        {
            int[] indices = mesh.GetIndices(i);
            mesh.SetIndices(indices, MeshTopology.Points, i);


        }


	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
