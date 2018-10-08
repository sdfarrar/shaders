// Alan Zucconi: http://www.alanzucconi.com/?p=4643
using UnityEngine;

public class DrawMouse : MonoBehaviour {

    public RenderTexture RenderTexture;

    public Texture brush0;
    public Texture brush1;
    public int size = 50;

    private Material _addBrushMaterial;
    private RenderTexture initialTexture;

    void Awake() { 
        SetTextureRegion.OnRegionEntered += SetRenderTexture;
        SetTextureRegion.OnRegionExited += ResetRenderTexture;
    }

    void Start() {
        _addBrushMaterial = new Material(Shader.Find("Hidden/AddBrushShader"));
        initialTexture = RenderTexture;
    }

	void Update() {
        if(!Input.GetMouseButton(0) && !Input.GetMouseButton(1)){ return; }
        if(RenderTexture==null || brush0==null || brush1==null){ return; }
        DrawToTexture();
    }

    private void DrawToTexture(){
        Texture brush = Input.GetMouseButton(0) ? brush0 : brush1;

        Vector3 mouse = Input.mousePosition;
        mouse.z = transform.position.z;

        //Vector2 screen = -Camera.main.ScreenToWorldPoint(mouse);
        //Debug.DrawLine(Vector3.zero, screen);

        Camera cam = Camera.main;
        RaycastHit hit;
        if (!Physics.Raycast(cam.ScreenPointToRay(Input.mousePosition), out hit)) return;

        Renderer rend = hit.transform.GetComponent<Renderer>();
        MeshCollider meshCollider = hit.collider as MeshCollider;

        float x = hit.textureCoord.x * RenderTexture.width - size*0.5f;
        float y = (1-hit.textureCoord.y) * RenderTexture.height - size*0.5f;

        RenderTexture.active = RenderTexture; //the render texture to be drawn to
        GL.PushMatrix();
        GL.LoadPixelMatrix(0, RenderTexture.width, RenderTexture.height, 0);
        Graphics.DrawTexture(new Rect(x, y, size, size), brush);
        GL.PopMatrix();
        RenderTexture.active = null;
    }

    private void SetRenderTexture(SetTextureRegion region) {
        RenderTexture = region.TargetTexture;
    }

    private void ResetRenderTexture(SetTextureRegion region) {
        RenderTexture = initialTexture;
    }

}
