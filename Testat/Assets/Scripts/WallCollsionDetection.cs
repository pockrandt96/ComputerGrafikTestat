using System.Collections.Generic;
using UnityEngine;

public class WallCollsionDetection : MonoBehaviour
{
    public int DeformationTimeToLive;
    public int MaxNumberOfDeformations;
    public float ForceMultiplier;
    private List<Vector4> posList;
    private List<float> ttlList;

    public void OnCollisionEnter(Collision collision)
    {
        Vector4 pos = new Vector4(collision.gameObject.transform.position.x,
            collision.gameObject.transform.position.y, collision.gameObject.transform.position.z, 1);

        ttlList.Insert(0, DeformationTimeToLive);
        posList.Insert(0, pos);

        ttlList.RemoveAt(ttlList.Count - 1);
        posList.RemoveAt(posList.Count - 1);

        GetComponent<MeshRenderer>().material.SetFloatArray("_timeToLiveList", ttlList.ToArray());
        GetComponent<MeshRenderer>().material.SetVectorArray("_collisionPositionList", posList.ToArray());
    }

    public void Start()
    {
        //100 is maxArraySize in Shader
        if (MaxNumberOfDeformations > 100 || MaxNumberOfDeformations <= 0)
        {
            MaxNumberOfDeformations = 100; 
        }

        if (DeformationTimeToLive == 0)
        {
            DeformationTimeToLive = 100;
        }
        
        if (ForceMultiplier < 0.1f)
        {
            ForceMultiplier = 1;
        }

        ttlList = new List<float>(MaxNumberOfDeformations);
        posList = new List<Vector4>(MaxNumberOfDeformations);

        for (int i = 0; i < MaxNumberOfDeformations; i++)
        {
            ttlList.Add(0F);
            posList.Add(new Vector4(0, 0, 0, 0));
        }

        GetComponent<MeshRenderer>().material.SetFloat("_timeToLive", DeformationTimeToLive);
        GetComponent<MeshRenderer>().material.SetFloat("_forceMultiplier", ForceMultiplier);
        GetComponent<MeshRenderer>().material.SetFloatArray("_timeToLiveList", ttlList.ToArray());
        GetComponent<MeshRenderer>().material.SetVectorArray("_collisionPositionList", posList.ToArray());
    }

    public void Update()
    {
        for (var i = 0; i < ttlList.Count; i++)
        {
            if ((ttlList[i] > 0))
            {
                float ttl = ttlList[i];
                ttl -= 1;
                ttlList[i] = ttl;
                GetComponent<MeshRenderer>().material.SetFloatArray("_timeToLiveList", ttlList.ToArray());
            }
        }
    }
}