using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallController : MonoBehaviour {

    public float thrust = 1;
    public Rigidbody rb;
    private bool oneTime = true;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.useGravity = false;
    }

    // Update is called once per frame
    void Update () {
		
	}

    private void FixedUpdate() {
        if (Input.anyKeyDown)
        {
            if (oneTime)
            {
                rb.useGravity = true;
                rb.AddForce(transform.forward * -700);
                oneTime = false;
            }
        }
    }
}
