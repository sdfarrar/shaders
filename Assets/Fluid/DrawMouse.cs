// Alan Zucconi: http://www.alanzucconi.com/?p=4643
using UnityEngine;

public class DrawMouse : MonoBehaviour {

    public RenderTexture renderTexture;

    public Texture brush0;
    public Texture brush1;
    public int size = 50;

    private Material _addBrushMaterial;

    void Start() {
        _addBrushMaterial = new Material(Shader.Find("Hidden/AddBrushShader"));
    }

	// Update is called once per frame
	void Update () {

        if (Input.GetMouseButton(0) || Input.GetMouseButton(1))
        {
            Texture brush = Input.GetMouseButton(0) ? brush0 : brush1;

            Vector3 mouse = Input.mousePosition;
            mouse.z = transform.position.z;
            Vector2 screen = -Camera.main.ScreenToWorldPoint(mouse);

            Debug.DrawLine(Vector3.zero, screen);

            Camera cam = Camera.main;
            RaycastHit hit;
            if (!Physics.Raycast(cam.ScreenPointToRay(Input.mousePosition), out hit)) return;

            Renderer rend = hit.transform.GetComponent<Renderer>();
            MeshCollider meshCollider = hit.collider as MeshCollider;

            float x = hit.textureCoord.x * renderTexture.width - size*0.5f;
            float y = (1-hit.textureCoord.y) * renderTexture.height - size*0.5f;

            RenderTexture.active = renderTexture; //the render texture to be drawn to
            GL.PushMatrix();
            GL.LoadPixelMatrix(0, renderTexture.width, renderTexture.height, 0);
            Graphics.DrawTexture(new Rect(x, y, size, size), brush);
            GL.PopMatrix();
            RenderTexture.active = null;
        }

    }

}
