using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class WallCollsionDetection : MonoBehaviour {

	public GameObject cube;
    private bool isCollided = false;
    private List<float> ttlList = new List<float> { 0 };
   private List<Vector4> impactPosList = new List<Vector4> { new Vector4(0, 0, 0, 0) };
// private Vector4 impactPos;
    public Text text;

    void OnCollisionEnter(Collision col)
    {
        foreach (ContactPoint colPoint in col.contacts)
        {
            Vector4 impactPos = new Vector4(colPoint.point.x, colPoint.point.y, colPoint.point.z, 1);
// text.text = impactPos.ToString();
            gameObject.GetComponent<MeshRenderer>().material.SetVector("_ImpactPosition", impactPos);
            gameObject.GetComponent<MeshRenderer>().material.SetFloat("_ImpactForce", 1f);
            gameObject.GetComponent<MeshRenderer>().material.SetVector("_CollisionDirection", col.impulse.normalized);
            impactPosList.Add(impactPos);
            ttlList.Add(10F);
        }
        }


    void Update()
    {
        //text.text = "bla";
        for (int i = 0; i < ttlList.Count; i++)
        {
            float f = ttlList.ElementAt<float>(i);
                f -= 0.1F;
            if (f <= 0)
            {
                ttlList.RemoveAt(i);
                impactPosList.RemoveAt(i);
            }
            else
            {
                ttlList[i] = f;
            }
        }
        
        if (ttlList.Count == 0)
        {
            ttlList.Add(0);
            impactPosList.Add(new Vector4(0, 0, 0, 0));
        }
        cube.GetComponent<MeshRenderer>().material.SetFloatArray("_TtlList", ttlList.ToArray());
        cube.GetComponent<MeshRenderer>().material.SetVectorArray("_ImpactPositionList", impactPosList.ToArray());
    }
}
