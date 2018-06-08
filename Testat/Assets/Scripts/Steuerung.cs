using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Steuerung : MonoBehaviour {

    // Use this for initialization
    void Start () {
	Cursor.lockState = CursorLockMode.Locked;

	// Make the rigid body not change rotation
        if (GetComponent<Rigidbody>()){
             GetComponent<Rigidbody>().freezeRotation = true;
	}
        originalRotation = transform.localRotation;
    }
	
    public float speed = 6.0F;
    public float jumpSpeed = 8.0F;
    public float gravity = 20.0F;
    private Vector3 moveDirection = Vector3.zero;

    public enum RotationAxes { MouseXAndY = 0, MouseX = 1, MouseY = 2 }
    public RotationAxes axes = RotationAxes.MouseXAndY;
    public float sensitivityX = 15F;
    public float sensitivityY = 15F;
    public float minimumX = -360F;
    public float maximumX = 360F;
    public float minimumY = -60F;
    public float maximumY = 60F;
    float rotationX = 0F;
    float rotationY = 0F;
    Quaternion originalRotation;

    void Update() {
        CharacterController controller = GetComponent<CharacterController>();
        if (controller.isGrounded) {
            moveDirection = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            moveDirection = transform.TransformDirection(moveDirection);
            moveDirection *= speed;
            if (Input.GetButton("Jump")){
                moveDirection.y = jumpSpeed;
	    }
        }
        moveDirection.y -= gravity * Time.deltaTime;
        controller.Move(moveDirection * Time.deltaTime);

	if (axes == RotationAxes.MouseXAndY)
        {
            // Read the mouse input axis
            rotationX += Input.GetAxis("Mouse X") * sensitivityX;
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationX = ClampAngle (rotationX, minimumX, maximumX);
            rotationY = ClampAngle (rotationY, minimumY, maximumY);
            Quaternion xQuaternion = Quaternion.AngleAxis (rotationX, Vector3.up);
            Quaternion yQuaternion = Quaternion.AngleAxis (rotationY, -Vector3.right);
            transform.localRotation = originalRotation * xQuaternion * yQuaternion;
        }
        else if (axes == RotationAxes.MouseX)
        {
            rotationX += Input.GetAxis("Mouse X") * sensitivityX;
            rotationX = ClampAngle (rotationX, minimumX, maximumX);
            Quaternion xQuaternion = Quaternion.AngleAxis (rotationX, Vector3.up);
            transform.localRotation = originalRotation * xQuaternion;
        }
        else
        {
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = ClampAngle (rotationY, minimumY, maximumY);
            Quaternion yQuaternion = Quaternion.AngleAxis (-rotationY, Vector3.right);
            transform.localRotation = originalRotation * yQuaternion;
        }
    }
    public static float ClampAngle (float angle, float min, float max)
    {
        if (angle <= -360F){
            angle += 360F;
	}
        if (angle >= 360F){
            angle -= 360F;
	}
        return Mathf.Clamp (angle, min, max);
    }
}
