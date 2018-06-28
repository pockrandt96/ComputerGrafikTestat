using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Schießen : MonoBehaviour {

	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		

		if (Input.GetMouseButtonDown(0))
		{
			GameObject projectile = GameObject.CreatePrimitive(PrimitiveType.Sphere);
			projectile.name = "ball";
			projectile.transform.position = gameObject.transform.position + Camera.main.transform.forward * 2;
			projectile.AddComponent<Rigidbody>();
			projectile.GetComponent<Rigidbody>().velocity = Camera.main.transform.forward * 50;
		}
	}
}
